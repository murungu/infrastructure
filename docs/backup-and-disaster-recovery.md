# nopCommerce Backup and Disaster Recovery

## Scope

This runbook protects the local nopCommerce PostgreSQL database:

```text
nopcommerce_local
```

The external `arity_store_db` database is intentionally excluded. SQL Server
and Redis are also excluded because the running store does not use SQL Server
and Redis currently contains no durable data.

## Off-machine destination decision

**Status:** Deferred on 2026-10-10.

The local backup and isolated restore workflow is operational. Selection and
configuration of an encrypted off-machine destination is intentionally
postponed. No storage provider, credentials, upload job, remote retention
policy, or remote-backup alerting is approved yet.

This is a conscious risk acceptance, not a claim that disaster recovery is
complete. Until this decision is revisited, the backup set protects against
logical database failures and supports container migration, but a failure that
destroys both the Docker host and its local backup files can still cause total
data loss.

Revisit this decision when any of these conditions occurs:

- Before the store is treated as production-critical.
- Before relying on the system for orders that cannot be reconstructed.
- Before moving the deployment to a new host.
- When a suitable S3, Backblaze B2, Azure Blob, MinIO, or managed PostgreSQL
  destination is approved.
- When recovery objectives become stricter than the local workflow can meet.

Candidate tooling remains `restic` with encrypted object storage. The choice is
not binding until the decision is explicitly reopened.

## Recovery objectives

Initial targets:

- Create a backup every 6 hours.
- Keep 30 daily backups, 8 weekly backups, and 12 monthly backups.
- Create an extra backup before deployments, imports, migrations, and plugin
  upgrades.
- Run an isolated restore test at least once per week.

These targets allow up to six hours of data loss. Use PostgreSQL point-in-time
recovery with WAL archiving if that recovery point is not acceptable for
production orders.

## What is protected

The database backup includes:

- Products and catalog configuration
- Customers and orders
- Store settings
- Plugins' database state
- Pictures stored in `PictureBinary`
- nopCommerce migration history

The current store has one `PictureBinary` row for every `Picture` row. The
backup verification checks that this remains true.

The following items are deliberately not database backups:

- Redis cache data
- Generated thumbnails
- Generated CSS and JavaScript bundles
- Docker images
- SQL Server's unused nopCommerce databases

The Compose files keep the nopCommerce connection configuration outside the
container writable layer and persist ASP.NET Core data-protection keys in the
`infrastructure_nopcommerce_keys` volume.

## Create a backup

Run:

```bash
make backup
```

The command creates three files under `backups/postgres/`:

```text
nopcommerce_local_YYYYMMDDTHHMMSSZ.dump
nopcommerce_local_YYYYMMDDTHHMMSSZ.sha256
nopcommerce_local_YYYYMMDDTHHMMSSZ.manifest.json
```

It also updates `backups/postgres/LATEST`.

The script:

1. Targets `NOPCOMMERCE_DB`, which defaults to `nopcommerce_local`.
2. Confirms that the database is reachable.
3. Creates a compressed PostgreSQL custom-format archive.
4. Confirms that `pg_restore` can read the archive.
5. Creates a SHA-256 checksum.
6. Records non-sensitive metadata and row-count fingerprints.

Backup files contain customer and order data. The directory and files are
created with restrictive permissions and are excluded from Git.

## Verify a backup

Verify the latest backup:

```bash
make verify-backup
```

Verify a specific backup:

```bash
make verify-backup \
  BACKUP=backups/postgres/nopcommerce_local_YYYYMMDDTHHMMSSZ.dump
```

Verification does not alter `nopcommerce_local`. It:

1. Checks the SHA-256 checksum.
2. Starts an isolated PostgreSQL 16 container on a temporary Docker network.
3. Restores the complete archive into temporary storage.
4. Checks required tables and record counts.
5. Checks that pictures and picture binaries are consistent.
6. Starts an isolated nopCommerce container against the restored database.
7. Requires an HTTP 200 response and rejects the installation wizard.
8. Deletes the temporary containers, network, and database storage.

Run database-only verification when the application image is unavailable:

```bash
VERIFY_APP=0 make verify-backup
```

Keep a failed verification environment temporarily for diagnosis:

```bash
KEEP_VERIFY_ENV=1 make verify-backup
```

Remove the retained temporary containers and network after diagnosis.

## Restore into a separate local database

A normal restore must use a separate target database:

```bash
make restore-backup \
  BACKUP=backups/postgres/nopcommerce_local_YYYYMMDDTHHMMSSZ.dump \
  TARGET_DB=nopcommerce_recovery
```

The restore script refuses to overwrite `nopcommerce_local`. If the recovery
database already exists, run the script directly with explicit replacement:

```bash
REPLACE_EXISTING=1 ./scripts/restore-postgres.sh \
  backups/postgres/nopcommerce_local_YYYYMMDDTHHMMSSZ.dump \
  nopcommerce_recovery
```

Validate the recovery database before changing the application connection.

## Recover on a new machine

### 1. Prepare the repository

```bash
git clone <infrastructure-repository-url> infrastructure
cd infrastructure
cp .env.example .env
```

Set strong passwords in `.env` and keep these values:

```dotenv
POSTGRES_DB=nopcommerce_local
NOPCOMMERCE_DB=nopcommerce_local
```

### 2. Start PostgreSQL only

```bash
docker compose up -d postgres
```

Wait until it is healthy:

```bash
docker compose ps postgres
```

### 3. Copy the backup set

Copy the `.dump`, `.sha256`, and `.manifest.json` files into
`backups/postgres/`.

Verify the backup before replacing anything:

```bash
VERIFY_APP=0 make verify-backup BACKUP=backups/postgres/<backup>.dump
```

### 4. Replace the new empty database

The new machine's application container must still be stopped. Then run:

```bash
ALLOW_ACTIVE_DATABASE_RESTORE=nopcommerce_local \
REPLACE_EXISTING=1 \
./scripts/restore-postgres.sh \
  backups/postgres/<backup>.dump \
  nopcommerce_local
```

The exact database name in `ALLOW_ACTIVE_DATABASE_RESTORE` is a deliberate
safety confirmation. The script refuses this operation if
`db-infra-nopcommerce` is running.

### 5. Start the store

```bash
docker compose up -d redis nopcommerce
```

Check:

```bash
docker compose ps
curl -I http://localhost:8080/
```

Confirm that the storefront loads and that the installation wizard does not
appear.

## Off-machine storage — deferred

A backup on the same Docker host is not complete disaster recovery. The
storage destination decision is currently deferred as recorded above. The
following options are retained for future evaluation; none is configured.

Recommended options:

- `restic` with S3, Backblaze B2, Azure Blob, or MinIO
- A managed PostgreSQL service with point-in-time recovery plus independent
  logical dumps
- An off-site NAS plus a second immutable object-storage copy

Recommended controls:

- Encrypt backups before upload.
- Use separate backup credentials with write-only or narrowly scoped access.
- Enable object versioning or object lock where available.
- Alert when a scheduled backup or restore verification fails.
- Test access to the storage account from a separate machine.
- Do not store backup encryption keys only on the protected server.

## Scheduling examples

A host cron entry can run backups every six hours:

```cron
0 */6 * * * cd /opt/nopcommerce/infrastructure && make backup >> /var/log/nopcommerce-backup.log 2>&1
```

Run an isolated restore test weekly:

```cron
30 3 * * 0 cd /opt/nopcommerce/infrastructure && make verify-backup >> /var/log/nopcommerce-restore-test.log 2>&1
```

Cron alone does not provide retention, encrypted off-site transfer, or alerts.
Use `restic forget --prune` or an equivalent storage lifecycle policy after an
off-machine destination is approved. The examples above are proposed
operations, not evidence that scheduling or remote retention is active.

## Operational rules

- Never treat a Docker volume as the only backup.
- Never use `make clean` unless a verified backup exists and data destruction
  is intentional.
- Never restore directly over the active database for a routine test.
- Always keep the archive, checksum, and manifest together.
- Always verify the newest backup after significant database changes.
- Always create a fresh backup before application or schema upgrades.
- Record the result and duration of production restore drills.

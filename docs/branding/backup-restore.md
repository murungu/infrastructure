# Arity nopCommerce Backup and Restore

The active backup scope is the local PostgreSQL database:

```text
nopcommerce_local
```

The external `arity_store_db` database, SQL Server, and Redis are excluded from
the current backup set.

Use the canonical runbook:

- [Backup and Disaster Recovery](../backup-and-disaster-recovery.md)

Quick commands:

```bash
make backup
make verify-backup
```

Do not put database passwords in this document. Keep credentials in the
Git-ignored `.env` file or in the production secret manager.

# Database Infrastructure + nopCommerce (Source Build)

Local PostgreSQL, SQL Server, Redis, and **[nopCommerce](https://www.nopcommerce.com) built from YOUR FORK** via Docker Compose.

> **Why source build?** So you can add your own plugins and themes, while still pulling updates from the main nopCommerce repo.
>
> **Not customizing?** Use the pre-built image instead: [`make use-prebuilt`](#quick-start-with-pre-built-image).

---

## Table of Contents

1. [Quick Start (Source Build)](#quick-start-source-build)
2. [Configuration (.env)](#configuration-env)
3. [Architecture](#architecture)
4. [The nopCommerce Fork Workflow](#the-nopcommerce-fork-workflow)
5. [Testing & Verification](#testing--verification)
6. [Adding Custom Plugins & Themes](#adding-custom-plugins--themes)
7. [Pulling Upstream Updates](#pulling-upstream-updates)
8. [Commands](#commands)
9. [Connecting Your Own Application](#connecting-your-own-application)
10. [Production Self-Hosting](#production-self-hosting)
11. [Troubleshooting](#troubleshooting)

---

## Quick Start (Source Build)

### Step 1 — Fork nopCommerce on GitHub

1. Go to [github.com/nopSolutions/nopCommerce](https://github.com/nopSolutions/nopCommerce)
2. Click **Fork** → creates `github.com/YOUR_USERNAME/nopCommerce`

### Step 2 — Clone Your Fork

```bash
# Edit Makefile: replace with YOUR fork URL
# Change line 10 from:
#   NOPCOMMERCE_REPO = https://github.com/nopSolutions/nopCommerce.git
# To:
#   NOPCOMMERCE_REPO = https://github.com/YOUR_USERNAME/nopCommerce.git

# Then clone
make clone-nopcommerce
```

This creates `nopcommerce-src/` — a full clone of nopCommerce ready for your customizations.

### Step 3 — Configure Environment Variables

```bash
cp .env.example .env
```

Edit `.env` to set your passwords. **Never commit `.env` to git** — it is already `.gitignore`d.

Key variables:

| Variable | Default | Used By |
|----------|---------|---------|
| `POSTGRES_USER` | `appuser` | PostgreSQL |
| `POSTGRES_PASSWORD` | `DevPassword123!` | PostgreSQL |
| `POSTGRES_DB` | `appdb` | PostgreSQL |
| `MSSQL_SA_PASSWORD` | `DevPassword123!` | SQL Server (nopCommerce DB) |
| `MSSQL_PID` | `Developer` | SQL Server edition |
| `REDIS_PASSWORD` | `DevRedis123!` | Redis |

### Step 4 — Start Everything

```bash
make up
```

This **builds nopCommerce from your source** (takes 5–10 minutes the first time), then starts all services.

### Step 5 — Complete Installation

Open `http://localhost:8080` and complete the [installation wizard](#step-3--complete-nopcommerce-installation-wizard).

---

## Configuration (.env)

All secrets and passwords live in `.env` (gitignored). Docker Compose loads it automatically.

### Setup

```bash
cp .env.example .env
# Edit .env with your passwords
```

### Variables

| Variable | Description | Where Used |
|----------|-------------|------------|
| `POSTGRES_USER` | PostgreSQL username | `docker-compose.yml`, `Makefile` (`make psql`) |
| `POSTGRES_PASSWORD` | PostgreSQL password | `docker-compose.yml`, `Makefile` |
| `POSTGRES_DB` | PostgreSQL database name | `docker-compose.yml`, `Makefile` |
| `MSSQL_SA_PASSWORD` | SQL Server `sa` password | `docker-compose.yml`, `Makefile` (`make sqlcmd`) |
| `MSSQL_PID` | SQL Server edition (`Developer`/`Express`) | `docker-compose.yml` |
| `REDIS_PASSWORD` | Redis AUTH password | `docker-compose.yml`, `Makefile` (`make redis-cli`) |
| `REDIS_CACHE_ENABLED` | Enable Redis distributed cache | `docker-compose.prebuilt.yml` |
| `REDIS_CACHE_TYPE` | Cache provider type | `docker-compose.prebuilt.yml` |
| `REDIS_CONNECTION_STRING` | Full Redis connection string | `docker-compose.prebuilt.yml` |

### Changing passwords

1. Edit `.env`
2. Run `make down && make up` (containers will restart with new env vars)
3. **Database volumes keep old data** — if you changed `MSSQL_SA_PASSWORD`, the existing `sqlserver_data` volume still has the old password. Either:
   - Use `make clean` to wipe and reinstall (destroys all data)
   - Or change the password inside SQL Server manually via `make sqlcmd`:
     ```sql
     ALTER LOGIN sa WITH PASSWORD = 'NewPassword123!';
     ```

---

## Architecture

```
infrastructure/                 ← This repo (Docker Compose, docs, automation)
├── docker-compose.yml         ← Builds from ./nopcommerce-src/
├── docker-compose.prebuilt.yml ← Uses official image (no source needed)
├── Makefile                    ← clone-nopcommerce, update-nopcommerce, up, down
└── README.md                   ← This file

nopcommerce-src/               ← YOUR FORK (gitignored, not in this repo)
├── src/
│   ├── Plugins/
│   │   └── YourCompany.YourPlugin/      ← Your custom plugin
│   └── Presentation/Nop.Web/Themes/
│       └── YourCompanyTheme/             ← Your custom theme
├── Dockerfile                  ← Official build file
└── ...
```

**Why two repos?**
- `infrastructure/` = deployment config. Small, focused, easy to review.
- `nopcommerce-src/` = application source. Large, forked, contains your custom code.

**Separation of concerns:** Your deployment setup doesn't change when you add a plugin. Your plugin code doesn't get mixed with Docker config.

---

## The nopCommerce Fork Workflow

### Daily Development Workflow

```bash
# Day 1: set up (one-time)
make clone-nopcommerce          # Clone your fork
cd nopcommerce-src
    git remote add upstream https://github.com/nopSolutions/nopCommerce.git
cd ..

# Day 2+: develop
make up                          # Build from source & start
# ... edit plugins in nopcommerce-src/src/Plugins/ ...
# ... edit themes in nopcommerce-src/src/Presentation/Nop.Web/Themes/ ...
cd nopcommerce-src && git add -A && git commit -m "feat: add my plugin"
cd nopcommerce-src && git push origin develop

# Pull latest upstream changes (weekly/monthly)
make update-nopcommerce          # Fetches upstream, merges into your fork
# Resolve any merge conflicts
cd nopcommerce-src && git push origin develop
make up                          # Rebuild with latest upstream + your changes
```

### What Goes Where

| File / Directory | Repo | Why |
|------------------|------|-----|
| `docker-compose.yml` | `infrastructure` | Deployment config doesn't belong in app source |
| `Makefile` | `infrastructure` | Automation scripts are infrastructure |
| `src/Plugins/YourPlugin/` | `nopcommerce-src` (your fork) | Plugin is application code |
| `src/Presentation/Nop.Web/Themes/YourTheme/` | `nopcommerce-src` (your fork) | Theme is application code |
| `src/NopCommerce.sln` | `nopcommerce-src` (your fork) | Modified to include your plugin |

---

## Testing & Verification

After running `make up`, confirm everything works before installing nopCommerce.

### 1. Check All Containers Are Healthy

```bash
make status
```

Expected output — all services show `(healthy)` or `Up`:

| Service | Status |
|---------|--------|
| `db-infra-postgres` | `Up (healthy)` |
| `db-infra-sqlserver` | `Up (healthy)` |
| `db-infra-redis` | `Up (healthy)` |
| `db-infra-nopcommerce` | `Up` or `Up (healthy)` |

### 2. Verify Databases Are Reachable

```bash
# PostgreSQL (primary database for nopCommerce)
docker exec db-infra-postgres psql -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -c "SELECT 'OK' as status;"
# → OK

# SQL Server (available for other applications)
docker exec db-infra-sqlserver sh -c '/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -Q "SELECT '\''OK'\''" -C'
# → OK

# Redis (password from .env)
docker exec db-infra-redis redis-cli -a "$REDIS_PASSWORD" ping
# → PONG

# nopCommerce web
curl -s -o /dev/null -w "HTTP %{http_code}\n" http://localhost:8080
# → HTTP 302
```

### 3. Complete nopCommerce Installation Wizard

Open your browser: **`http://localhost:8080`**

You should see **"nopCommerce installation"**. Fill in:

#### Store Information

| Field | Example Value |
|-------|---------------|
| **Admin email** | `admin@example.com` |
| **Admin password** | `Admin123!` |
| **Confirm password** | `Admin123!` |
| **Install sample data** | ✅ Checked (gives you demo products) |

#### Database Information — SQL Server (recommended)

| Field | Value |
|-------|-------|
| **Database** | PostgreSQL |
| **Server name** | `db-infra-postgres` |
| **Database name** | `nopcommerce` |
| **SQL Username** | `${POSTGRES_USER}` from `.env` |
| **SQL Password** | `${POSTGRES_PASSWORD}` from `.env` |
| **Create database if it doesn't exist** | ✅ Checked |

> **Why `db-infra-postgres`?** Inside the Docker network, containers reach each other by **container name**, not `localhost`.

#### Database Information — SQL Server (alternative)

| Field | Value |
|-------|-------|
| **Database** | Microsoft SQL Server |
| **Server name** | `db-infra-sqlserver` |
| **Database name** | `nopcommerce` |
| **SQL Username** | `sa` |
| **SQL Password** | `${MSSQL_SA_PASSWORD}` from `.env` |
| **Create database if it doesn't exist** | ✅ Checked |

Click **Install**. This takes **2–5 minutes**. You'll see a progress bar.

### 4. Post-Install Verification

After installation completes, verify:

```bash
# Storefront responds with 200 (not redirect)
curl -s -o /dev/null -w "Storefront: %{http_code}\n" http://localhost:8080
# → Storefront: 200

# Admin panel is reachable
curl -s -o /dev/null -w "Admin: %{http_code}\n" http://localhost:8080/admin
# → Admin: 200

# PostgreSQL created the nopcommerce database
docker exec db-infra-postgres psql -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -c "\l" | grep nopcommerce
# → nopcommerce

# Check nopCommerce logs for errors
make nop-logs
```

Then open your browser:

| URL | Expected |
|-----|----------|
| `http://localhost:8080` | **Storefront** with demo products |
| `http://localhost:8080/admin` | **Admin login** — use the credentials you set in the install wizard |

### 5. Re-enable Redis (optional)

After installation completes, Redis distributed caching can be enabled. Edit `docker-compose.yml` and uncomment the `environment` section under `nopcommerce:`:

```yaml
    environment:
      DistributedCacheConfig__Enabled: "true"
      DistributedCacheConfig__DistributedCacheType: "Redis"
      DistributedCacheConfig__ConnectionString: "db-infra-redis:6379,password=${REDIS_PASSWORD},ssl=False"
```

Then `make down && make up` to restart with caching enabled.

### 6. If Something Goes Wrong

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| `HTTP 000` or timeout | nopCommerce not ready yet | Wait 30s, retry |
| "FATAL: database 'nopcommerce' does not exist" | PostgreSQL not healthy or wrong db name | `make status`, check PostgreSQL logs |
| Installation wizard repeats | Volume was deleted | That's normal — completes once per volume |
| Red error in wizard | Wrong server name | Use container name (`db-infra-postgres`), not `localhost` |
| Build fails with .NET errors | Outdated fork | `make update-nopcommerce` then `make up` |

```bash
# Check logs for specific errors
docker compose logs nopcommerce --tail=50
docker compose logs postgres --tail=20
```

---

## Adding Custom Plugins & Themes

All customization happens in your fork at `nopcommerce-src/`.

### Add a Plugin

```bash
cd nopcommerce-src

# Create plugin directory
mkdir -p src/Plugins/YourCompany.YourPlugin

# Copy a built-in plugin as a template
cp -r src/Plugins/Nop.Plugin.Misc.News src/Plugins/YourCompany.YourPlugin

# Rename .csproj and update namespace
# Edit src/NopCommerce.sln to add your plugin project
# (Right-click in Visual Studio, or edit .sln file manually)

# Commit
git add -A
git commit -m "feat: add YourCompany.YourPlugin"
git push origin develop

# Rebuild
cd ..
make up
```

### Add a Theme

```bash
cd nopcommerce-src

# Create theme directory
mkdir -p src/Presentation/Nop.Web/Themes/YourCompanyTheme

# Copy the default theme as a template
cp -r src/Presentation/Nop.Web/Themes/DefaultClean/* src/Presentation/Nop.Web/Themes/YourCompanyTheme/

# Edit views, CSS, JS in YourCompanyTheme/
# No .sln changes needed for themes

# Commit
git add -A
git commit -m "feat: add YourCompanyTheme"
git push origin develop

# Rebuild
cd ..
make up
```

### Where Custom Files Live

| Type | Location in `nopcommerce-src/` | Needs `.sln` Update? |
|------|-------------------------------|---------------------|
| Plugin (C#) | `src/Plugins/YourCompany.PluginName/` | ✅ Yes |
| Theme (Razor/CSS/JS) | `src/Presentation/Nop.Web/Themes/YourThemeName/` | ❌ No |
| Static files (images, uploads) | `src/Presentation/Nop.Web/wwwroot/` | ❌ No |

---

## Pulling Upstream Updates

When nopCommerce releases a new version, pull it into your fork:

```bash
# Fetch and merge upstream changes
make update-nopcommerce

# If merge conflicts occur, resolve them in your IDE:
cd nopcommerce-src
# ... edit files to resolve conflicts ...
git add -A
git commit -m "merge: upstream release-4.90.5"
git push origin develop

# Rebuild with latest upstream + your customizations
cd ..
make up
```

**What conflicts to expect:**
- **None** if you only added new files (plugins/themes in new directories)
- **Minor** if you modified existing files (rare, document your changes)
- **None** if upstream didn't touch your files

**Best practice:** Don't modify core nopCommerce files. Add files, don't edit existing ones. This keeps merges conflict-free.

---

## Quick Start with Pre-built Image

If you don't need to customize plugins/themes, skip the source build:

```bash
# No fork needed. No build needed.
make use-prebuilt

# Complete the wizard at http://localhost:8080
# Uses the official nopCommerce image from Docker Hub
```

> **Note:** `make use-prebuilt` uses `docker-compose.prebuilt.yml` which pulls the official image. You cannot add custom plugins or themes with this method.

---

## Commands

| Command | What it does |
|---------|-------------|
| `make clone-nopcommerce` | Clone your fork to `./nopcommerce-src/` (run once) |
| `make up` | **Build from source** & start all services |
| `make use-prebuilt` | Start with official image (no source build) |
| `make down` | Stop all services (data preserved) |
| `make clean` | Stop and **delete all data** (volumes) |
| `make update-nopcommerce` | Pull upstream changes into your fork |
| `make status` | Show running containers |
| `make logs` | Follow all logs |
| `make nop-logs` | Follow nopCommerce logs only |
| `make psql` | Open PostgreSQL shell |
| `make sqlcmd` | Open SQL Server shell |
| `make redis-cli` | Open Redis shell |
| `make tag IMAGE_TAG=v1.0` | Tag current image for rollback |
| `make rollback IMAGE_TAG=v1.0` | Roll back to tagged image |
| `make list-tags` | Show all tagged images |

---

## Connecting Your Own Application

If you're building a separate app that needs to connect to these databases:

```bash
# Your app connects via localhost (if also running in Docker, use service names)
# PostgreSQL
psql postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost:5432/${POSTGRES_DB}

# SQL Server
sqlcmd -S localhost,1433 -U sa -P '${MSSQL_SA_PASSWORD}'

# Redis
redis-cli -a ${REDIS_PASSWORD} -p 6379
```

From inside Docker network (another container):
```bash
# Use Docker service names instead of localhost
postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db-infra-postgres:5432/${POSTGRES_DB}
sqlcmd -S db-infra-sqlserver,1433 -U sa -P '${MSSQL_SA_PASSWORD}'
redis-cli -h db-infra-redis -a ${REDIS_PASSWORD}
```

---

## Production Self-Hosting

### Recommended: VPS + Docker Compose + Nginx

For a real production store, rent a VPS and deploy with Docker Compose:

| Provider | Spec | Monthly Cost |
|----------|------|-------------|
| **Hetzner** | 4 vCPU / 8 GB / 80 GB | ~€6 |
| **DigitalOcean** | 2 vCPU / 4 GB / 80 GB | ~$24 |
| **Linode** | 2 vCPU / 4 GB / 80 GB | ~$24 |
| **Vultr** | 2 vCPU / 4 GB / 55 GB | ~$18 |

**Why VPS over managed/cloud?**
- You own the infrastructure
- No per-transaction fees from the platform
- Full control over backups, SSL, scaling
- Cheaper at low-to-medium scale

### Architecture

```
Internet
    │
    ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Nginx     │────▶│ nopCommerce │────▶│  SQL Server │
│ (reverse    │     │   (Docker)  │     │   (Docker)  │
│  proxy +    │     └─────────────┘     └─────────────┘
│  Let's      │             │
│  Encrypt)   │             ▼
└─────────────┘     ┌─────────────┐
                    │    Redis    │
                    │   (Docker)  │
                    └─────────────┘
```

### Setup Steps

```bash
# 1. Rent a VPS with Ubuntu 22.04/24.04
# 2. Install Docker
curl -fsSL https://get.docker.com | sh

# 3. Clone this repo
git clone <your-infrastructure-repo> /opt/nopcommerce
cd /opt/nopcommerce

# 4. Clone your nopCommerce fork
make clone-nopcommerce

# 5. Update passwords in .env (use strong passwords!)
cp .env.example .env
nano .env

# 6. Change port from 8080:80 to 80:80 (or keep 8080 and proxy via Nginx)

# 7. Start everything
make up

# 8. Install Nginx + Certbot for SSL
sudo apt install nginx certbot python3-certbot-nginx

# 9. Configure Nginx reverse proxy
# See: nginx/nopcommerce.conf example below

# 10. Get SSL certificate
sudo certbot --nginx -d yourdomain.com
```

### Sample Nginx Config

```nginx
server {
    listen 80;
    server_name yourdomain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### What About Kubernetes?

**Don't use Kubernetes for a single nopCommerce store.** It's overkill. Use Kubernetes only if:
- You have a team of 3+ DevOps engineers
- You're running 10+ microservices
- You need auto-scaling across multiple regions

For a single e-commerce store, Docker Compose on a VPS is simpler, cheaper, and easier to debug.

### Database Migration Path (Local → Production)

When you're ready to go live:

| Environment | Database Recommendation |
|-------------|--------------------------|
| **Local dev** | PostgreSQL in Docker (what you have now) |
| **Staging** | Same as local, but on a VPS |
| **Production** | **Managed database** — don't run PostgreSQL in Docker for production |

**Production database options:**
- **PostgreSQL**: AWS RDS, Azure Database for PostgreSQL, Google Cloud SQL (recommended — same engine as local)
- **SQL Server**: Azure SQL Database, AWS RDS for SQL Server
- **Redis**: AWS ElastiCache, Azure Cache for Redis

Your app only changes the connection string. Nothing else.

---

## Backups

### Docker Volumes (local dev)

```bash
# Backup all data (passwords read from .env automatically)
docker exec db-infra-postgres pg_dump -U "${POSTGRES_USER}" "${POSTGRES_DB}" > backup-postgres.sql
docker exec db-infra-sqlserver sh -c '/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -Q "BACKUP DATABASE [nopcommerce] TO DISK = N/var/opt/mssql/backup/nopcommerce.bak"' -C
docker exec db-infra-redis redis-cli -a "${REDIS_PASSWORD}" SAVE
```

### Production

Use your cloud provider's automated backup:
- Azure SQL: Point-in-time restore (built-in)
- AWS RDS: Automated daily backups + snapshots
- PostgreSQL: `pg_dump` via cron + object storage (S3)

---

## Persistent Data

Data survives `make down`. To wipe everything:

```bash
make clean        # removes containers + named volumes
make up           # fresh start
```

| Volume | What's stored |
|--------|--------------|
| `postgres_data` | PostgreSQL database files |
| `sqlserver_data` | SQL Server database files |
| `redis_data` | Redis RDB snapshots |

> **Note:** `App_Data` is **not** mounted as a volume. Mounting it causes a known nopCommerce bug where `ThemeProvider` crashes with `NullReferenceException` before the install wizard can load. The official nopCommerce Docker setup also does not mount `App_Data`.

---

## Image Versioning

Tag your nopCommerce image after every successful build so you can rollback instantly if something breaks.

### Tag the current image

```bash
# After a successful install, save this working state
make tag IMAGE_TAG=v1.0.0
```

This creates `infrastructure-nopcommerce:v1.0.0` from the current `latest`.

### List available tags

```bash
make list-tags
```

### Rollback to a previous tag

```bash
# If a new build breaks, revert in seconds
make rollback IMAGE_TAG=v1.0.0
```

This:
1. Stops the current container
2. Tags `infrastructure-nopcommerce:v1.0.0` back to `latest`
3. Restarts with the stable image

### Best practice workflow

```bash
# 1. Tag before any risky change (plugin install, theme update, upstream merge)
make tag IMAGE_TAG=before-theme-update

# 2. Make your changes, rebuild
make up

# 3. If it breaks, rollback instantly
make rollback IMAGE_TAG=before-theme-update
```

> **Note:** Image tags only snapshot the application code. Your **database data** lives in Docker volumes and survives rollbacks. If you need to wipe the database too, run `make clean` before `make up`.

---

## Fork Workflow

For a conflict-free workflow when pulling upstream nopCommerce updates, see [`docs/fork-workflow.md`](docs/fork-workflow.md).

**Quick version:**
- `develop` stays clean for upstream merges
- Custom work happens on `feature/*` branches
- Tag your image before risky merges: `make tag IMAGE_TAG=safe`

---

## Troubleshooting

### Redis causes SIGSEGV (exit code 139) during installation

**Symptom:** Container crashes during nopCommerce install with exit code 139.

**Cause:** The `StackExchange.Redis.FlushDatabaseAsync` call during installation crashes under Rosetta 2 on Apple Silicon.

**Fix:** Redis distributed caching is **disabled by default** in `docker-compose.yml`. After installation completes, uncomment the `environment` section under `nopcommerce` to enable it. See [Re-enable Redis](#5-re-enable-redis-optional).

### nopCommerce shows "Installation" page after restart

This only happens if the container was recreated (e.g., `make clean`). The wizard stores its config in `App_Data/dataSettings.json` inside the container. Since `App_Data` is not mounted as a volume, container recreation wipes the config and shows the wizard again.

To preserve your setup, **never** use `make clean` unless you want a complete reset. Use `make down` instead (stops containers but keeps volumes).

### SQL Server won't start on Apple Silicon

SQL Server is AMD64-only. Docker Desktop with Rosetta 2 handles this automatically. If it fails:

```bash
# Ensure Rosetta 2 is installed
softwareupdate --install-rosetta --agree-to-license
```

### `App_Data` volume causes `NullReferenceException`

**Symptom:** Container starts but web requests fail with HTTP 500 and this error:
```
System.NullReferenceException at Nop.Services.Themes.ThemeProvider.ThemeExistsAsync
```

**Cause:** Mounting `nopcommerce_data:/app/App_Data` as a Docker volume overwrites the image's built-in `App_Data` files. The `ThemeProvider` middleware crashes before the install wizard can load.

**Fix:** Remove the `App_Data` volume mount from `docker-compose.yml`. The official nopCommerce Docker setup does not mount `App_Data`.

**For production persistence:** After completing the install wizard, copy `App_Data` out of the container:
```bash
docker cp db-infra-nopcommerce:/app/App_Data ./nopcommerce-app-data
# Then mount the host directory instead:
# volumes:
#   - ./nopcommerce-app-data:/app/App_Data
```

### Port already in use

If 5432, 1433, 6379, or 8080 are taken:

```bash
# Find what's using port 8080
lsof -i :8080

# Change ports in docker-compose.yml
# Example: change "8080:80" to "8090:80"
```

### Build fails with .NET SDK errors

```bash
# Check that nopcommerce-src/ exists and has the Dockerfile
ls nopcommerce-src/Dockerfile

# If missing, re-clone
rm -rf nopcommerce-src
make clone-nopcommerce

# If the build fails due to plugin compilation errors,
# check your plugin code and fix any compilation issues
make nop-logs
```

---

## Project Layout

```
.
├── docker-compose.yml              # Builds from ./nopcommerce-src/
├── docker-compose.prebuilt.yml   # Uses official image (no source)
├── Makefile                        # clone, update, build, up, down
├── README.md                       # This file
└── .gitignore                      # Ignores nopcommerce-src/
```

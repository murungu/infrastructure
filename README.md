# Database Infrastructure + nopCommerce (Source Build)

Local PostgreSQL, SQL Server, Redis, and **[nopCommerce](https://www.nopcommerce.com) built from YOUR FORK** via Docker Compose.

> **Why source build?** So you can add your own plugins and themes, while still pulling updates from the main nopCommerce repo.
>
> **Not customizing?** Use the pre-built image instead: [`make use-prebuilt`](#quick-start-with-pre-built-image).

---

## Table of Contents

1. [Quick Start (Source Build)](#quick-start-source-build)
2. [Architecture](#architecture)
3. [The nopCommerce Fork Workflow](#the-nopcommerce-fork-workflow)
4. [Testing & Verification](#testing--verification)
5. [Adding Custom Plugins & Themes](#adding-custom-plugins--themes)
6. [Pulling Upstream Updates](#pulling-upstream-updates)
7. [Commands](#commands)
8. [Connecting Your Own Application](#connecting-your-own-application)
9. [Production Self-Hosting](#production-self-hosting)
10. [Troubleshooting](#troubleshooting)

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

### Step 3 — Start Everything

```bash
make up
```

This **builds nopCommerce from your source** (takes 5–10 minutes the first time), then starts all services.

### Step 4 — Complete Installation

Open `http://localhost:8080` and complete the [installation wizard](#step-3--complete-nopcommerce-installation-wizard).

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
| `db-infra-nopcommerce` | `Up` |

### 2. Verify Databases Are Reachable

```bash
# PostgreSQL
docker exec db-infra-postgres psql -U appuser -d appdb -c "SELECT 'OK' as status;"
# → OK

# SQL Server
docker exec db-infra-sqlserver sh -c '/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -Q "SELECT '\''OK'\''" -C'
# → OK

# Redis
docker exec db-infra-redis redis-cli -a DevRedis123! ping
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
| **Database** | Microsoft SQL Server |
| **Server name** | `db-infra-sqlserver` |
| **Database name** | `nopcommerce` |
| **SQL Username** | `sa` |
| **SQL Password** | `DevPassword123!` |
| **Create database if it doesn't exist** | ✅ Checked |

> **Why `db-infra-sqlserver`?** Inside the Docker network, containers reach each other by **container name**, not `localhost`.

#### Database Information — PostgreSQL (alternative)

| Field | Value |
|-------|-------|
| **Database** | PostgreSQL |
| **Server name** | `db-infra-postgres` |
| **Database name** | `nopcommerce` |
| **SQL Username** | `appuser` |
| **SQL Password** | `DevPassword123!` |
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

# SQL Server created the nopcommerce database
docker exec db-infra-sqlserver sh -c '/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -Q "SELECT name FROM sys.databases WHERE name = '\''nopcommerce'\''" -C'
# → nopcommerce

# Check nopCommerce logs for errors
make nop-logs
```

Then open your browser:

| URL | Expected |
|-----|----------|
| `http://localhost:8080` | **Storefront** with demo products |
| `http://localhost:8080/admin` | **Admin login** — use `admin@example.com` / `Admin123!` |

### 5. If Something Goes Wrong

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| `HTTP 000` or timeout | nopCommerce not ready yet | Wait 30s, retry |
| "Login failed for user 'sa'" | SQL Server not healthy | `make status`, check SQL Server logs |
| Installation wizard repeats | Volume was deleted | That's normal — completes once per volume |
| Red error in wizard | Wrong server name | Use container name (`db-infra-sqlserver`), not `localhost` |
| Build fails with .NET errors | Outdated fork | `make update-nopcommerce` then `make up` |

```bash
# Check logs for specific errors
docker compose logs nopcommerce --tail=50
docker compose logs sqlserver --tail=20
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

---

## Connecting Your Own Application

If you're building a separate app that needs to connect to these databases:

```bash
# Your app connects via localhost (if also running in Docker, use service names)
# PostgreSQL
psql postgresql://appuser:DevPassword123!@localhost:5432/appdb

# SQL Server
sqlcmd -S localhost,1433 -U sa -P 'DevPassword123!'

# Redis
redis-cli -a DevRedis123! -p 6379
```

From inside Docker network (another container):
```bash
# Use Docker service names instead of localhost
postgresql://appuser:DevPassword123!@db-infra-postgres:5432/appdb
sqlcmd -S db-infra-sqlserver,1433 -U sa -P 'DevPassword123!'
redis-cli -h db-infra-redis -a DevRedis123!
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

# 5. Update passwords in docker-compose.yml (use strong passwords!)
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
| **Local dev** | SQL Server in Docker (what you have now) |
| **Staging** | Same as local, but on a VPS |
| **Production** | **Managed database** — don't run SQL Server in Docker for production |

**Production database options:**
- **SQL Server**: Azure SQL Database, AWS RDS for SQL Server
- **PostgreSQL**: AWS RDS, Azure Database for PostgreSQL, Google Cloud SQL
- **Redis**: AWS ElastiCache, Azure Cache for Redis

Your app only changes the connection string. Nothing else.

---

## Backups

### Docker Volumes (local dev)

```bash
# Backup all data
docker exec db-infra-postgres pg_dump -U appuser appdb > backup-postgres.sql
docker exec db-infra-sqlserver sh -c '/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -Q "BACKUP DATABASE [nopcommerce] TO DISK = N/var/opt/mssql/backup/nopcommerce.bak"' -C
docker exec db-infra-redis redis-cli -a DevRedis123! SAVE
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
| `nopcommerce_data` | nopCommerce App_Data (plugins, uploads, settings) |
| `nopcommerce_wwwroot` | nopCommerce static files |

---

## Troubleshooting

### nopCommerce shows "Installation" page after restart

This only happens if the `nopcommerce_data` Docker volume was deleted (e.g., `make clean`). The wizard stores its config in `App_Data/dataSettings.json` inside that volume. If the volume exists, nopCommerce skips the wizard and goes straight to the store.

To preserve your setup, **never** use `make clean` unless you want a complete reset. Use `make down` instead (stops containers but keeps volumes).

### SQL Server won't start on Apple Silicon

SQL Server is AMD64-only. Docker Desktop with Rosetta 2 handles this automatically. If it fails:

```bash
# Ensure Rosetta 2 is installed
softwareupdate --install-rosetta --agree-to-license
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

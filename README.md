# Database Infrastructure + nopCommerce

Local PostgreSQL, SQL Server, Redis, and [nopCommerce](https://www.nopcommerce.com) via Docker Compose.

## Quick Start

```bash
# Start everything (databases + nopCommerce)
make up

# Check status
make status

# Open nopCommerce in browser
open http://localhost:8080
```

## What's Running

| Service | Image | Host Port | Purpose |
|---------|-------|-----------|---------|
| **nopCommerce** | `nopcommerceteam/nopcommerce:4.90.4` | `localhost:8080` | E-commerce platform |
| **PostgreSQL** | `postgres:16-alpine` | `localhost:5432` | Database option #1 |
| **SQL Server** | `mcr.microsoft.com/mssql/server:2022-latest` | `localhost:1433` | Database option #2 (default for nopCommerce) |
| **Redis** | `redis:7-alpine` | `localhost:6379` | Caching & session store |

## Database Connection Details

### PostgreSQL
- **Host:** `localhost:5432` (or `db-infra-postgres` from inside Docker network)
- **User:** `appuser`
- **Password:** `DevPassword123!`
- **Database:** `appdb`

### SQL Server
- **Host:** `localhost:1433` (or `db-infra-sqlserver` from inside Docker network)
- **User:** `sa`
- **Password:** `DevPassword123!`
- **Note:** nopCommerce uses this by default

### Redis
- **Host:** `localhost:6379` (or `db-infra-redis` from inside Docker network)
- **Password:** `DevRedis123!`

## nopCommerce Setup

### Option A: Auto-configured with SQL Server (default)

The `docker-compose.yml` already pre-configures nopCommerce to use SQL Server with Redis caching. On first run, nopCommerce will:

1. Create the `nopcommerce` database in SQL Server
2. Run migrations and seed data
3. Be ready at `http://localhost:8080`

**Admin credentials** (set during first-run installation wizard, or if skipped, default to):
- After the install wizard, create an admin account
- If auto-install is used, you may need to complete setup via the web UI

### Option B: Using PostgreSQL instead of SQL Server

If you prefer PostgreSQL over SQL Server for nopCommerce, edit `docker-compose.yml`:

```yaml
  nopcommerce:
    environment:
      DataConfig__ConnectionString: "Host=db-infra-postgres;Port=5432;Database=nopcommerce;Username=appuser;Password=DevPassword123!;"
      DataConfig__DataProvider: "PostgreSql"
```

Then restart:
```bash
docker compose down -v
docker compose up -d
```

### Option C: Manual Installation Wizard

If you remove the `DataConfig__` environment variables, nopCommerce will show the installation wizard on first visit. Use these settings:

| Field | Value |
|-------|-------|
| **Database** | SQL Server |
| **Server name** | `db-infra-sqlserver` |
| **Database name** | `nopcommerce` |
| **SQL Username** | `sa` |
| **SQL Password** | `DevPassword123!` |

Or for PostgreSQL:

| Field | Value |
|-------|-------|
| **Database** | PostgreSQL |
| **Server name** | `db-infra-postgres` |
| **Database name** | `nopcommerce` |
| **SQL Username** | `appuser` |
| **SQL Password** | `DevPassword123!` |

## Commands

| Command | What it does |
|---------|-------------|
| `make up` | Start all services |
| `make down` | Stop all services (data preserved) |
| `make clean` | Stop and **delete all data** |
| `make status` | Show running containers |
| `make logs` | Follow all logs |
| `make nop-logs` | Follow nopCommerce logs only |
| `make psql` | Open PostgreSQL shell |
| `make sqlcmd` | Open SQL Server shell |
| `make redis-cli` | Open Redis shell |

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

## Production Self-Hosting Recommendations

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
git clone <your-repo> /opt/nopcommerce
cd /opt/nopcommerce

# 4. Update passwords in docker-compose.yml (use strong passwords!)
# 5. Change port from 8080:80 to 80:80 (or keep 8080 and proxy via Nginx)

# 6. Start everything
docker compose up -d

# 7. Install Nginx + Certbot for SSL
sudo apt install nginx certbot python3-certbot-nginx

# 8. Configure Nginx reverse proxy
# See: nginx/nopcommerce.conf example below

# 9. Get SSL certificate
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

## Troubleshooting

### nopCommerce shows "Installation" page instead of store

The database wasn't pre-configured. Either:
1. Complete the installation wizard in your browser
2. Or set `DataConfig__ConnectionString` and `DataConfig__DataProvider` env vars

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

## Project Layout

```
.
├── docker-compose.yml    # All services (databases + nopCommerce)
├── Makefile              # Convenience commands
├── README.md             # This file
└── .gitignore
```

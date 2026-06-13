# Database Infrastructure

Local PostgreSQL, SQL Server, and Redis via Docker Compose.

## Quick Start

```bash
# Start all databases
make up

# Check status
make status
```

## Connection Details

| Database | Host | Port | User | Password | Database |
|----------|------|------|------|----------|----------|
| **PostgreSQL** | `localhost` | `5432` | `appuser` | `DevPassword123!` | `appdb` |
| **SQL Server** | `localhost` | `1433` | `sa` | `DevPassword123!` | `master` (create your own) |
| **Redis** | `localhost` | `6379` | — | `DevRedis123!` | `0` |

## Using the Databases

### PostgreSQL

```bash
# Interactive shell
make psql

# Or with any client
psql postgresql://appuser:DevPassword123!@localhost:5432/appdb
```

### SQL Server

```bash
# Interactive shell
make sqlcmd

# Or with any client
sqlcmd -S localhost,1433 -U sa -P 'DevPassword123!'
```

### Redis

```bash
# Interactive shell
make redis-cli

# Or with any client
redis-cli -a DevRedis123! -p 6379
```

## Commands

| Command | What it does |
|---------|-------------|
| `make up` | Start all databases |
| `make down` | Stop all databases (data preserved) |
| `make clean` | Stop and **delete all data** |
| `make status` | Show running containers |
| `make logs` | Follow container output |
| `make psql` | Open PostgreSQL shell |
| `make sqlcmd` | Open SQL Server shell |
| `make redis-cli` | Open Redis shell |

## Persistent Data

Data survives `make down`. To wipe everything and start fresh:

```bash
make clean
make up
```

## Production Path

When you're ready for production, **don't run databases in Docker**. Use managed services:

- **PostgreSQL**: Amazon RDS, Azure Database for PostgreSQL, Google Cloud SQL
- **SQL Server**: Azure SQL Database, Amazon RDS for SQL Server
- **Redis**: AWS ElastiCache, Azure Cache for Redis, Redis Cloud

Your application only needs to change the connection string — nothing else.

## Project Layout

```
.
├── docker-compose.yml    # Database definitions
├── Makefile              # Convenience commands
├── README.md             # This file
└── .gitignore
```

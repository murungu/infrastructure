.PHONY: up down status logs psql sqlcmd redis-cli clean help

## Start/Stop
up:
	@docker compose up -d
	@echo ""
	@echo "Waiting for databases to be healthy..."
	@docker compose ps

down:
	@docker compose down

clean:
	@docker compose down -v
	@echo "Removed containers and volumes."

## Status
status:
	@echo "╔══════════════════════════════════════════════════════════════╗"
	@echo "║              DATABASE CONTAINERS                             ║"
	@echo "╚══════════════════════════════════════════════════════════════╝"
	@docker compose ps

logs:
	@docker compose logs -f

## Quick Connect (no local clients needed)
psql:
	@docker exec -it db-infra-postgres psql -U appuser -d appdb

sqlcmd:
	@docker exec -it db-infra-sqlserver sh -c '/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$$MSSQL_SA_PASSWORD" -C || /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$$MSSQL_SA_PASSWORD"'

redis-cli:
	@docker exec -it db-infra-redis redis-cli -a DevRedis123!

## Help
help:
	@echo "Database Infrastructure — Docker Compose"
	@echo ""
	@echo "  make up         Start all databases"
	@echo "  make down       Stop all databases"
	@echo "  make clean      Stop and remove all data (volumes)"
	@echo "  make status     Show running containers"
	@echo "  make logs       Follow container logs"
	@echo "  make psql       Connect to PostgreSQL interactively"
	@echo "  make sqlcmd     Connect to SQL Server interactively"
	@echo "  make redis-cli  Connect to Redis interactively"

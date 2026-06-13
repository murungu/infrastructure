.PHONY: up down status logs psql sqlcmd redis-cli nop-logs clean help

## Start/Stop
up:
	@docker compose up -d
	@echo ""
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  All services starting..."
	@echo ""
	@echo "  nopCommerce:     http://localhost:8080"
	@echo "  PostgreSQL:      localhost:5432"
	@echo "  SQL Server:      localhost:1433"
	@echo "  Redis:           localhost:6379"
	@echo "═══════════════════════════════════════════════════════════════"

down:
	@docker compose down

clean:
	@docker compose down -v
	@echo "Removed containers and volumes."

## Status
status:
	@echo "╔══════════════════════════════════════════════════════════════╗"
	@echo "║              DATABASE & APPLICATION CONTAINERS               ║"
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

nop-logs:
	@docker compose logs -f nopcommerce

## Help
help:
	@echo "Database Infrastructure + nopCommerce — Docker Compose"
	@echo ""
	@echo "  make up           Start all services (databases + nopCommerce)"
	@echo "  make down         Stop all services"
	@echo "  make clean        Stop and remove all data (volumes)"
	@echo "  make status       Show running containers"
	@echo "  make logs         Follow all container logs"
	@echo "  make nop-logs     Follow nopCommerce logs only"
	@echo "  make psql         Connect to PostgreSQL interactively"
	@echo "  make sqlcmd       Connect to SQL Server interactively"
	@echo "  make redis-cli    Connect to Redis interactively"

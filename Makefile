.PHONY: up down status logs psql sqlcmd redis-cli nop-logs \
        clone-nopcommerce update-nopcommerce use-prebuilt clean help

# ════════════════════════════════════════════════════════
#  CONFIGURATION — change this to your fork URL
# ════════════════════════════════════════════════════════
# After forking nopCommerce on GitHub, replace this with your fork:
#   NOPCOMMERCE_REPO = https://github.com/YOUR_USERNAME/nopCommerce.git
#
# Default: official repo (read-only). You can still build, but you
# can't push your own plugins. Fork to customize.
# ════════════════════════════════════════════════════════
NOPCOMMERCE_REPO ?= https://github.com/Arity-Solutions/nopCommerce.shop.git

## Start/Stop (builds from source)
up:
	@echo "═══════════════════════════════════════════════════════════════"
	@if [ ! -d "nopcommerce-src" ]; then \
		echo "❌ nopcommerce-src/ not found. Run: make clone-nopcommerce"; \
		echo "═══════════════════════════════════════════════════════════════"; \
		exit 1; \
	fi
	@echo "Building nopCommerce from source (this takes 5–10 minutes)..."
	@echo "═══════════════════════════════════════════════════════════════"
	@docker compose up -d --build
	@echo ""
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  All services started."
	@echo ""
	@echo "  nopCommerce:     http://localhost:8080"
	@echo "  PostgreSQL:      localhost:5432"
	@echo "  SQL Server:      localhost:1433"
	@echo "  Redis:           localhost:6379"
	@echo "═══════════════════════════════════════════════════════════════"

## Quick start with pre-built image (no source needed)
use-prebuilt:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Starting with PRE-BUILD nopCommerce image..."
	@echo "  (No source build. Plugins/themes cannot be customized.)"
	@echo "═══════════════════════════════════════════════════════════════"
	@docker compose -f docker-compose.prebuilt.yml up -d

down:
	@docker compose down

clean:
	@docker compose down -v
	@echo "Removed containers and volumes."

## Clone your nopCommerce fork (run once)
clone-nopcommerce:
	@if [ -d "nopcommerce-src" ]; then \
		echo "✅ nopcommerce-src/ already exists."; \
		echo "   To update: make update-nopcommerce"; \
		echo "   To re-clone: rm -rf nopcommerce-src && make clone-nopcommerce"; \
		exit 0; \
	fi
	@echo "Cloning nopCommerce from: $(NOPCOMMERCE_REPO)"
	@git clone $(NOPCOMMERCE_REPO) nopcommerce-src
	@echo ""
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  ✅ nopCommerce cloned to ./nopcommerce-src/"
	@echo ""
	@echo "  Next steps:"
	@echo "    1. cd nopcommerce-src"
	@echo "    2. git remote add upstream https://github.com/nopSolutions/nopCommerce.git"
	@echo "    3. cd .."
	@echo "    4. make up"
	@echo ""
	@echo "  To add your own fork URL, edit Makefile:"
	@echo "    NOPCOMMERCE_REPO = https://github.com/YOUR_USERNAME/nopCommerce.git"
	@echo "═══════════════════════════════════════════════════════════════"

## Pull latest upstream changes into your fork
update-nopcommerce:
	@if [ ! -d "nopcommerce-src" ]; then \
		echo "❌ nopcommerce-src/ not found. Run: make clone-nopcommerce"; \
		exit 1; \
	fi
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Updating nopCommerce from upstream..."
	@echo "═══════════════════════════════════════════════════════════════"
	@cd nopcommerce-src && \
		git fetch upstream 2>/dev/null || \
		(echo "⚠️  'upstream' remote not found. Add it with:" && \
		 echo "   cd nopcommerce-src && git remote add upstream https://github.com/nopSolutions/nopCommerce.git" && \
		 exit 1)
	@echo ""
	@echo "Merging upstream/develop into your local branch..."
	@cd nopcommerce-src && git merge upstream/develop
	@echo ""
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  ✅ Update complete."
	@echo ""
	@echo "  If there were merge conflicts, resolve them in nopcommerce-src/"
	@echo "  Then rebuild: make up"
	@echo "═══════════════════════════════════════════════════════════════"

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
	@echo "Database Infrastructure + nopCommerce — Docker Compose (Source Build)"
	@echo ""
	@echo "SETUP (run once):"
	@echo "  make clone-nopcommerce   Clone nopCommerce source to ./nopcommerce-src/"
	@echo ""
	@echo "DAILY USE:"
	@echo "  make up                  Build from source & start all services"
	@echo "  make down                Stop all services (data preserved)"
	@echo "  make clean               Stop and delete all data (volumes)"
	@echo ""
	@echo "UPDATES:"
	@echo "  make update-nopcommerce  Pull upstream changes into your fork"
	@echo ""
	@echo "QUICK CONNECT:"
	@echo "  make psql                PostgreSQL interactive shell"
	@echo "  make sqlcmd              SQL Server interactive shell"
	@echo "  make redis-cli           Redis interactive shell"
	@echo ""
	@echo "DEBUGGING:"
	@echo "  make status              Show running containers"
	@echo "  make logs                Follow all container logs"
	@echo "  make nop-logs            Follow nopCommerce logs only"
	@echo ""
	@echo "ALTERNATIVE:"
	@echo "  make use-prebuilt        Skip source build, use pre-built image"

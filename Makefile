.PHONY: cluster-up cluster-down deploy-all deploy-postgres deploy-sqlserver deploy-redis \
        status clean port-forward-postgres port-forward-sqlserver port-forward-redis \
        help

CLUSTER_NAME ?= db-infra
KUBECTL := kubectl
KUSTOMIZE := $(KUBECTL) kustomize

## Local Cluster (kind)
cluster-up:
	@echo "Creating local kind cluster..."
	@kind create cluster --name $(CLUSTER_NAME) --config clusters/kind-config.yaml || true
	@echo "Waiting for nodes to be ready..."
	@kubectl wait --for=condition=Ready nodes --all --timeout=120s
	@echo "Cluster ready!"

cluster-down:
	@echo "Destroying local kind cluster..."
	@kind delete cluster --name $(CLUSTER_NAME) || true

## Deployments (Kustomize)
deploy-all: deploy-postgres deploy-sqlserver deploy-redis
	@echo "All databases deployed."

deploy-postgres:
	@echo "Deploying PostgreSQL..."
	@$(KUBECTL) apply -k databases/postgres/overlays/dev
	@echo "Waiting for PostgreSQL to be ready..."
	@$(KUBECTL) wait --for=condition=Ready pod -l app=postgres -n databases --timeout=120s || true

deploy-sqlserver:
	@echo "Deploying SQL Server..."
	@$(KUBECTL) apply -k databases/sqlserver/overlays/dev
	@echo "Waiting for SQL Server to be ready..."
	@$(KUBECTL) wait --for=condition=Ready pod -l app=sqlserver -n databases --timeout=180s || true

deploy-redis:
	@echo "Deploying Redis..."
	@$(KUBECTL) apply -k databases/redis/overlays/dev
	@echo "Waiting for Redis to be ready..."
	@$(KUBECTL) wait --for=condition=Ready pod -l app=redis -n databases --timeout=120s || true

## Status & Cleanup
status:
	@echo "=== Namespaces ==="
	@$(KUBECTL) get namespaces
	@echo ""
	@echo "=== Databases Namespace Pods ==="
	@$(KUBECTL) get pods -n databases -o wide
	@echo ""
	@echo "=== Services ==="
	@$(KUBECTL) get svc -n databases
	@echo ""
	@echo "=== PVCs ==="
	@$(KUBECTL) get pvc -n databases

clean:
	@echo "Removing all database deployments..."
	@$(KUBECTL) delete --ignore-not-found=true -k databases/postgres/overlays/dev || true
	@$(KUBECTL) delete -k databases/sqlserver/overlays/dev --ignore-not-found=true || true
	@$(KUBECTL) delete -k databases/redis/overlays/dev --ignore-not-found=true || true

## Port Forwarding (connect from your local machine)
port-forward-postgres:
	@echo "Forwarding PostgreSQL to localhost:5432..."
	@$(KUBECTL) port-forward svc/postgres -n databases 5432:5432

port-forward-sqlserver:
	@echo "Forwarding SQL Server to localhost:1433..."
	@$(KUBECTL) port-forward svc/sqlserver -n databases 1433:1433

port-forward-redis:
	@echo "Forwarding Redis to localhost:6379..."
	@$(KUBECTL) port-forward svc/redis -n databases 6379:6379

## Help
help:
	@echo "Database Infrastructure Platform"
	@echo ""
	@echo "Available targets:"
	@echo "  cluster-up              - Create local kind cluster"
	@echo "  cluster-down            - Destroy local kind cluster"
	@echo "  deploy-all              - Deploy all databases"
	@echo "  deploy-postgres         - Deploy PostgreSQL"
	@echo "  deploy-sqlserver        - Deploy SQL Server"
	@echo "  deploy-redis            - Deploy Redis"
	@echo "  status                  - Show cluster status"
	@echo "  clean                   - Remove all database deployments"
	@echo "  port-forward-postgres   - Forward PostgreSQL (5432)"
	@echo "  port-forward-sqlserver  - Forward SQL Server (1433)"
	@echo "  port-forward-redis      - Forward Redis (6379)"

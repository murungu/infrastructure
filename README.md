# Database Infrastructure Platform

A Kubernetes-native database infrastructure that runs identically on your laptop (via `kind`) and in production (EKS/AKS/GKE or on-prem).

## Philosophy

> **Same manifests, different clusters.**

We don't maintain two configs (docker-compose → prod). We deploy the same YAML to a local `kind` cluster and to a managed Kubernetes cluster in production.

## Supported Databases

| Database | Local Image | Production Notes |
|----------|-------------|------------------|
| **PostgreSQL** 16 | `postgres:16-alpine` | Use managed (RDS/Cloud SQL/Azure DB) or self-managed with operator |
| **SQL Server 2022** | `mcr.microsoft.com/mssql/server:2022-latest` | Azure SQL or self-managed on AKS/GKE with node selectors |
| **Redis** 7 | `redis:7-alpine` | Elasticache/Redis Cloud or self-managed with Redis Operator |

## Quick Start

```bash
# 1. Start local kind cluster with storage and ingress
make cluster-up

# 2. Deploy all databases to local cluster
make deploy-all

# 3. Verify everything is running
make status
```

## Project Layout

```
.
├── Makefile                    # Local orchestration commands
├── README.md                   # This file
├── clusters/
│   └── kind-config.yaml        # kind cluster config (local dev)
├── namespaces/
│   ├── databases.yaml            # Database namespace
│   └── monitoring.yaml         # Optional: monitoring namespace
├── databases/
│   ├── postgres/
│   │   ├── kustomization.yaml  # Kustomize overlay
│   │   ├── namespace.yaml      # Namespace reference
│   │   ├── deployment.yaml     # StatefulSet for data safety
│   │   ├── service.yaml        # ClusterIP service
│   │   ├── pvc.yaml            # Persistent volume claim
│   │   ├── configmap.yaml      # PostgreSQL configuration
│   │   └── secret.yaml         # Credentials (see README in folder)
│   ├── sqlserver/
│   │   ├── kustomization.yaml
│   │   ├── namespace.yaml
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── pvc.yaml
│   │   ├── configmap.yaml
│   │   └── secret.yaml
│   └── redis/
│       ├── kustomization.yaml
│       ├── namespace.yaml
│       ├── deployment.yaml
│       ├── service.yaml
│       ├── pvc.yaml
│       └── secret.yaml
├── infrastructure/
│   ├── storage/                # StorageClass definitions
│   ├── ingress/                # Ingress rules (if exposing externally)
│   └── monitoring/             # Optional: Prometheus/Grafana
└── docs/
    ├── scaling-to-production.md
    ├── backups.md
    └── security.md
```

## Environment Strategy

We use **namespaces** and **Kustomize overlays** for environment separation:

```
base/              # Common manifests (not environment-specific)
overlays/
  dev/             # Local development (kind)
  staging/         # Pre-production
  prod/            # Production (your cloud provider)
```

For now, we start simple with `dev` (local) and `prod` (cloud) overlays.

## Production Migration Path

1. **Local**: Run on `kind` cluster with hostPath storage
2. **Staging**: Deploy to managed K8s with standard SSD storage
3. **Production**: Either:
   - **Managed databases**: Use Kubernetes only for app workloads; point to RDS/Azure SQL/Cloud SQL
   - **Self-managed**: Use PostgreSQL Operator (Crunchy/Zalando) or SQL Server AGs on K8s

See `docs/scaling-to-production.md` for details.

## Prerequisites

- Docker Desktop (Mac/Windows) or Docker Engine (Linux)
- `kubectl` CLI
- `kind` (Kubernetes in Docker) — for local clusters
- `kustomize` (built into kubectl ≥ 1.14)
- `make` (optional, for convenience commands)

## Commands

| Command | Description |
|---------|-------------|
| `make cluster-up` | Create local kind cluster |
| `make cluster-down` | Destroy local kind cluster |
| `make deploy-all` | Deploy all databases |
| `make deploy-postgres` | Deploy only PostgreSQL |
| `make deploy-sqlserver` | Deploy only SQL Server |
| `make deploy-redis` | Deploy only Redis |
| `make status` | Check all pod/status |
| `make clean` | Remove all deployments |
| `make port-forward-postgres` | Forward PostgreSQL port locally |
| `make port-forward-sqlserver` | Forward SQL Server port locally |
| `make port-forward-redis` | Forward Redis port locally |

# Scaling to Production

This document outlines the migration path from local `kind` development to production-grade database infrastructure.

## Path 1: Managed Databases (Recommended)

For most applications, use managed database services and let Kubernetes handle only your applications.

### PostgreSQL
- **AWS**: Amazon RDS for PostgreSQL or Amazon Aurora PostgreSQL
- **Azure**: Azure Database for PostgreSQL Flexible Server
- **GCP**: Cloud SQL for PostgreSQL
- **On-prem**: CrunchyData PostgreSQL Operator or Zalando Postgres Operator

### SQL Server
- **Azure**: Azure SQL Database or Azure SQL Managed Instance
- **AWS/GCP**: Self-managed SQL Server on EC2/GCE (not ideal) or migrate to PostgreSQL
- **On-prem**: SQL Server Always On Availability Groups on VMs

### Redis
- **AWS**: ElastiCache for Redis
- **Azure**: Azure Cache for Redis
- **GCP**: Memorystore for Redis
- **On-prem**: Redis Enterprise Operator or KeyDB

### Implementation

Update your application connection strings to point to managed endpoints. Remove database StatefulSets from production overlays and only deploy:
- Connection secrets (via external secrets operator)
- Monitoring sidecars
- Backup validation jobs

## Path 2: Self-Managed on Kubernetes

Use this if you need maximum control or have regulatory constraints.

### PostgreSQL
Deploy the **Crunchy PostgreSQL Operator** or **CloudNativePG**:

```bash
# CloudNativePG (recommended)
kubectl apply -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/releases/cnpg-1.22.0.yaml
```

Benefits:
- Automated failover with streaming replication
- Point-in-time recovery (PITR)
- Built-in backups to S3/Azure Blob/GCS
- Connection pooling via PgBouncer

### SQL Server
Deploy SQL Server containers with **Always On Availability Groups**:
- Requires Kubernetes 1.24+
- Uses StatefulSet with anti-affinity rules
- Requires persistent volumes with ReadWriteMany or local SSDs

See: [SQL Server on Kubernetes deployment guide](https://learn.microsoft.com/en-us/sql/linux/tutorial-sql-server-containers-kubernetes)

### Redis
Deploy **Redis Cluster** or use the **Redis Operator**:

```bash
# Redis Operator
helm repo add ot-helm https://ot-container-kit.github.io/helm-charts/
helm install redis-operator ot-helm/redis-operator
helm install redis-cluster ot-helm/redis-cluster
```

## Storage Considerations

| Environment | Storage Class | Notes |
|-------------|-------------|-------|
| Local (kind) | `standard` | HostPath-based, ephemeral cluster |
| Staging | `managed-premium` or `gp3` | SSD-backed, single zone |
| Production | `managed-premium-rwo` or `io1/io2` | Replicated, multi-zone |

### Production Storage Requirements
- **PostgreSQL**: Use SSD-backed volumes with `ReadWriteOnce`. Size: start at 100GB with expansion enabled.
- **SQL Server**: Use premium SSD with at least 500 IOPS. Requires `ReadWriteOnce`.
- **Redis**: Can use ephemeral storage for cache-only workloads. Use SSD with persistence for session stores.

## Security Checklist

- [ ] **Secrets**: Use External Secrets Operator or Vault to inject credentials. Never commit secrets.
- [ ] **Network Policies**: Restrict database traffic to application namespaces only.
- [ ] **Encryption at Rest**: Enable storage-level encryption (managed by cloud provider).
- [ ] **Encryption in Transit**: Use TLS certificates for database connections. Add TLS sidecars or use managed endpoints.
- [ ] **RBAC**: Limit database pod access with specific ServiceAccounts.
- [ ] **Backups**: Automate daily backups to object storage (S3, GCS, Azure Blob).
- [ ] **Monitoring**: Deploy Prometheus + Grafana with database-specific dashboards and alerts.
- [ ] **Resource Limits**: Set proper CPU/memory limits to prevent noisy neighbor issues.

## Environment Promotion Flow

```
Developer Laptop (kind) → Git Push → CI/CD → Staging (EKS/AKS/GKE) → Production
         │                                                    │
         └─ Same Kustomize overlays, different cluster ───────┘
```

### Directory Structure for Multiple Environments

```
overlays/
  dev/         # Local kind cluster
    kustomization.yaml
    storage-class-patch.yaml
  staging/     # Pre-production
    kustomization.yaml
    replica-patch.yaml
    storage-class-patch.yaml
  prod/        # Production
    kustomization.yaml
    replica-patch.yaml
    storage-class-patch.yaml
    resource-limits-patch.yaml
    monitoring-patch.yaml
```

### Example: Production Kustomization

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: databases-prod

resources:
  - ../../base

commonLabels:
  environment: prod

patches:
  - target:
      kind: PersistentVolumeClaim
      name: postgres-pvc
    patch: |
      - op: replace
        path: /spec/resources/requests/storage
        value: "500Gi"
      - op: replace
        path: /spec/storageClassName
        value: "managed-premium"
```

## Cost Optimization

| Strategy | Savings |
|----------|---------|
| Use managed databases (no VM licensing) | 20-40% |
| Spot/preemptible instances for dev | 60-90% |
| Right-size requests/limits | 15-30% |
| Use connection pooling (PgBouncer) | Reduce connections by 80% |
| Schedule dev environments (start/stop) | 50-70% |

## Next Steps

1. Choose your path (managed vs. self-managed)
2. Create a staging cluster in your cloud provider
3. Add monitoring (Prometheus + Grafana + database exporters)
4. Configure automated backups
5. Document runbooks for failover and recovery

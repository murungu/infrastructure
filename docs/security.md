# Security Guide

## Secrets Management

### Local Development
Secrets in `base/secret.yaml` use `stringData` for convenience. For local dev, this is acceptable but should not be committed to version control with real passwords.

**Recommended approach:**
```bash
# 1. Never commit real secrets
# Add to .gitignore:
# databases/*/base/secret.yaml

# 2. Create secrets manually or via script
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
  namespace: databases
type: Opaque
stringData:
  POSTGRES_PASSWORD: "$(openssl rand -base64 32)"
EOF
```

### Production

Use one of these approaches:

1. **External Secrets Operator** (Recommended)
   Syncs secrets from AWS Secrets Manager, Azure Key Vault, or GCP Secret Manager.

2. **Sealed Secrets**
   Encrypt secrets with cluster-specific keys and commit encrypted versions safely.

3. **HashiCorp Vault**
   Full secrets lifecycle management with dynamic credentials.

## Network Security

### Network Policies

Restrict which pods can talk to databases:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: postgres-network-policy
  namespace: databases
spec:
  podSelector:
    matchLabels:
      app: postgres
  policyTypes:
    - Ingress
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              name: applications
      ports:
        - protocol: TCP
          port: 5432
```

### TLS in Transit

For production, add TLS to database connections:

- **PostgreSQL**: Use `sslmode=require` in connection strings. Mount TLS certificates via Secret.
- **SQL Server**: Enable TLS encryption in `mssql.conf`.
- **Redis**: Use TLS with `stunnel` sidecar or Redis 6+ native TLS.

## RBAC

Create a dedicated ServiceAccount for database workloads:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: postgres-sa
  namespace: databases
```

And apply least-privilege RBAC rules for any operators or backup jobs.

## Pod Security Standards

Apply restricted pod security standards:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: databases
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted
```

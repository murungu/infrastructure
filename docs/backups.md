# Backup and Recovery

## PostgreSQL Backups

### pg_dump (Manual)

```bash
# Create backup
kubectl exec -it postgres-0 -n databases -- pg_dump -U appuser -d appdb > backup.sql

# Restore
kubectl exec -i postgres-0 -n databases -- psql -U appuser -d appdb < backup.sql
```

### Automated with CronJob

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: postgres-backup
  namespace: databases
spec:
  schedule: "0 2 * * *"  # Daily at 2 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: pg-dump
              image: postgres:16-alpine
              command:
                - /bin/sh
                - -c
                - |
                  pg_dump -h postgres -U appuser -d appdb |
                  gzip > /backup/appdb-$(date +%Y%m%d-%H%M%S).sql.gz
              volumeMounts:
                - name: backup-volume
                  mountPath: /backup
          volumes:
            - name: backup-volume
              persistentVolumeClaim:
                claimName: backup-pvc
          restartPolicy: OnFailure
```

### Production: WAL Archiving (Point-in-Time Recovery)

Use CloudNativePG or Crunchy Operator for built-in PITR to S3/Azure Blob.

## SQL Server Backups

```bash
# Full backup
kubectl exec -it sqlserver-0 -n databases -- /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'DevPassword123!' \
  -Q "BACKUP DATABASE [appdb] TO DISK = '/var/opt/mssql/backup/appdb.bak'"

# Copy backup locally
kubectl cp databases/sqlserver-0:/var/opt/mssql/backup/appdb.bak ./appdb.bak
```

## Redis Backups

```bash
# Trigger BGSAVE
kubectl exec -it redis-0 -n databases -- redis-cli -a DevRedis123! BGSAVE

# Copy RDB file
kubectl cp databases/redis-0:/data/dump.rdb ./dump.rdb
```

## Backup Storage

For production, store backups in object storage:

- **AWS**: S3 with versioning and lifecycle policies
- **Azure**: Blob Storage with soft delete
- **GCP**: Cloud Storage with object versioning
- **On-prem**: MinIO or Ceph

## Disaster Recovery Checklist

- [ ] Daily automated backups
- [ ] Backup restoration tested monthly
- [ ] Off-site or cross-region backup copies
- [ ] Documented RTO (Recovery Time Objective) and RPO (Recovery Point Objective)
- [ ] Monitoring/alerting on backup job failures

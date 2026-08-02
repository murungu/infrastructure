# Arity nopCommerce — Backup & Restore Plan

## Why Reinstalls Happen

Each Docker deploy creates a new container. Without a persistent volume, nopCommerce loses these items:

- `App_Data/dataSettings.json` — database connection (mitigated by env vars).
- `App_Data/DataProtectionKeys/` — encryption keys (causes login failures).
- `App_Data/Installation/` — install state marker.
- `wwwroot/images/thumbs/` — generated product thumbnails.
- `wwwroot/bundles/` — CSS/JS bundles.

## Fix: Add a Named Volume

Add this to your Portainer compose to persist `App_Data` across deploys:

```yaml
services:
  shop-arity:
    image: registry.arity.co.za/nopcommerce:latest
    container_name: shop_arity
    restart: always
    ports:
      - "8086:80"
    environment:
      - ASPNETCORE_ENVIRONMENT=Production
      - ConnectionStrings__ConnectionString=Host=192.168.0.107;Port=5432;Database=arityshop_sampledb;Username=postgres;Password=postgres_arity_56523;Pooling=true;Trust Server Certificate=true;
      - ConnectionStrings__DataProvider=postgresql
    volumes:
      - shop_arity_data:/app/App_Data
      - shop_arity_thumbs:/app/wwwroot/images/thumbs
      - shop_arity_bundles:/app/wwwroot/bundles

volumes:
  shop_arity_data:
  shop_arity_thumbs:
  shop_arity_bundles:
```

Once added, redeploy. Future deploys will keep data intact — no more setup wizard.

---

## Database Backup (PostgreSQL)

### Full Backup

```bash
# On the PostgreSQL server (192.168.0.107)
pg_dump -U postgres -d arityshop_sampledb -F c -f /backups/arityshop_$(date +%Y%m%d_%H%M%S).dump
```

### Restore

```bash
# On the PostgreSQL server
pg_restore -U postgres -d arityshop_sampledb --clean /backups/arityshop_20260614_120000.dump
```

### Automated (cron on PostgreSQL server)

```bash
# Daily backup at 2am, keep last 30 days
0 2 * * * pg_dump -U postgres -d arityshop_sampledb -F c -f /backups/arityshop_$(date +\%Y\%m\%d).dump && find /backups -name 'arityshop_*.dump' -mtime +30 -delete
```

---

## Quick Recovery Steps

### If the store shows setup wizard

1. **Check connection** — is PostgreSQL at 192.168.0.107 reachable? Database `arityshop_sampledb` exists?

   ```bash
   psql -h 192.168.0.107 -U postgres -d arityshop_sampledb -c "SELECT name FROM store;"
   ```

2. **Verify env vars** — are `ConnectionStrings__ConnectionString` and `ConnectionStrings__DataProvider` set correctly in Portainer?

3. **Check volumes** — does `shop_arity_data` volume exist and is it mounted?

   ```bash
   docker volume ls | grep shop_arity
   ```

4. **If data is lost** — restore from latest backup:

   ```bash
   pg_restore -U postgres -d arityshop_sampledb --clean /backups/arityshop_LATEST.dump
   ```

---

## Pre-Deploy Checklist

Before each `registry.arity.co.za/nopcommerce:latest` update:

- [ ] Volume `shop_arity_data` exists and is mounted
- [ ] Latest database backup exists (< 24 hours old)
- [ ] Test connection: `psql -h 192.168.0.107 -U postgres -d arityshop_sampledb -c "SELECT 1"`
- [ ] Pull new image first: `docker pull registry.arity.co.za/nopcommerce:latest`
- [ ] Redeploy stack in Portainer (stop → pull → start)

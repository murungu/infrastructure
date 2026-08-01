#!/bin/bash
set -e

echo "=== Installing Arty Electra & Victoria Falls Themes ==="

# 1. Copy themes into container
docker cp tools/themes/arity-electra/. db-infra-nopcommerce:/app/Themes/ArtyElectra/
docker cp tools/themes/victoria-falls/. db-infra-nopcommerce:/app/Themes/VictoriaFalls/

# 2. Copy brand assets into theme image folders
docker cp tools/themes/assets/electra_logo.jpg db-infra-nopcommerce:/app/Themes/ArtyElectra/Content/images/
docker cp tools/themes/assets/electra_hero_banner.jpg db-infra-nopcommerce:/app/Themes/ArtyElectra/Content/images/
docker cp tools/themes/assets/electra_favicon.jpg db-infra-nopcommerce:/app/Themes/ArtyElectra/Content/images/

docker cp tools/themes/assets/victoria_logo.jpg db-infra-nopcommerce:/app/Themes/VictoriaFalls/Content/images/
docker cp tools/themes/assets/victoria_hero_banner.jpg db-infra-nopcommerce:/app/Themes/VictoriaFalls/Content/images/
docker cp tools/themes/assets/victoria_favicon.jpg db-infra-nopcommerce:/app/Themes/VictoriaFalls/Content/images/

echo "Themes copied to container"

# 3. Configure store-specific themes via SQL
docker exec db-infra-sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'DevPassword123!' -d nopcommerce -Q "
UPDATE Store SET DefaultTheme = 'ArtyElectra' WHERE Id = 1;
UPDATE Store SET DefaultTheme = 'VictoriaFalls' WHERE Id = 2;
SELECT Id, Name, DefaultTheme FROM Store ORDER BY Id;
" -C

echo "Store theme configuration updated"

# 4. Clear Redis cache
docker exec db-infra-redis redis-cli -a DevRedis123! FLUSHALL 2>/dev/null || echo "Redis flush skipped"

# 5. Restart nopCommerce
docker restart db-infra-nopcommerce

echo ""
echo "=== Installation Complete ==="
echo "Store 1 (Arty Electra):    http://localhost:8080/"
echo "Store 2 (Victoria Falls):  curl -H 'Host: store2.localhost' http://localhost:8080/"

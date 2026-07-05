# SQL Seed Script Generator

Generates a complete nopCommerce multi-store seed SQL script from `catalog.json`.

## Files

| File | Purpose |
|---|---|
| `generate_seed_sql.py` | Reads catalog.json and generates `seed-multistore-generated.sql` |
| `generate_picture_binary_sql.py` | Generates hex-encoded SQL to insert image binary data |
| `seed-multistore-generated.sql` | Auto-generated INSERT statements for all entities |

## Usage

```bash
cd tools/sql-seed

# Generate the SQL seed script
python3 generate_seed_sql.py

# Run it against the database
docker exec -i db-infra-sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'DevPassword123!' -d nopcommerce -C \
  < seed-multistore-generated.sql
```

## Note on image binaries

The generated SQL script inserts `Picture` rows but not `PictureBinary` rows. To make images render, either:

1. **Preferred**: Run the C# Console Data Importer (`../csharp-console/`), which inserts `PictureBinary` automatically.
2. **Alternative**: Generate and run the picture binary SQL:

   ```bash
   python3 generate_picture_binary_sql.py
   docker cp insert-picture-binary.sql db-infra-sqlserver:/tmp/
   docker exec db-infra-sqlserver /opt/mssql-tools18/bin/sqlcmd \
     -S localhost -U sa -P 'DevPassword123!' -d nopcommerce -C \
     -i /tmp/insert-picture-binary.sql
   ```

## What the seed script covers

- Store 2 creation (with IDENTITY_INSERT for explicit Id=2)
- 12 categories with StoreMapping
- 7 manufacturers with StoreMapping
- 50 products with all required columns (auto-generated from schema)
- Picture rows
- Product_Picture_Mapping, Product_Category_Mapping, Product_Manufacturer_Mapping
- StoreMapping for products
- UrlRecord for SEO slugs

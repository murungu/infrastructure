# C# Console Data Importer

Standalone .NET 10 console application that seeds nopCommerce directly via ADO.NET.

## What it does

1. Reads `catalog.json` (shared with the Python tool)
2. Connects to your local Docker SQL Server (`db-infra-sqlserver`)
3. Creates **Store 2** (`Victoria Falls Artisan Market`) if it doesn't exist
4. Inserts categories, manufacturers, products, pictures, and all mappings
5. Generates placeholder JPEG files named exactly as nopCommerce expects (`00000XX_0.jpg`)
6. Inserts `StoreMapping` and `UrlRecord` rows for SEO
7. Inserts `PictureBinary` rows so images render immediately (no manual copy needed)

## Prerequisites

- .NET 10 SDK (matches the nopCommerce Docker image)
- Docker containers running: `db-infra-sqlserver`, `db-infra-nopcommerce`

## Build & Run

```bash
cd tools/csharp-console
dotnet build -c Release
dotnet run -- ../python-data-generator/catalog.json ../output-images
```

The app will:

- Create Store 2 with explicit IDENTITY_INSERT (safe against previous failed runs)
- Insert 12 categories, 7 manufacturers, 50 products
- Generate 50 placeholder images via picsum.photos
- Insert all picture binary data into the database
- Commit everything in a single transaction

## Verify the stores

- Store 1 (Arty Shop): <http://localhost:8080/>
- Store 2 (Victoria Falls Artisan Market): `curl -H "Host: store2.localhost" http://localhost:8080/`

Both stores share the same nopCommerce instance; multi-store routing is done via the `Host` header.

## Database safety

- The importer reads current `MAX(Id)` from every table and starts above those values.
- Everything runs inside a SQL transaction; if anything fails, it rolls back.
- Store 2 creation uses `SET IDENTITY_INSERT Store ON` to guarantee Id=2, avoiding identity gaps from previous failed transactions.

## Architecture notes

- **Dynamic schema discovery**: `InsertProduct` reads `INFORMATION_SCHEMA.COLUMNS` at runtime and generates the INSERT with correct defaults for every column type. This makes the tool resilient to schema changes between nopCommerce versions.
- **C# overload gotcha fixed**: `new SqlParameter(name, 0)` resolves to the `SqlDbType` overload (because `0` matches enum value `BigInt = 0`), creating a parameter with **no value**. The fix is `new SqlParameter(name, (object)0)`.

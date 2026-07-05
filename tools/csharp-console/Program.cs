using System.Data;
using System.Text.Json;
using Microsoft.Data.SqlClient;

namespace NopDataImporter;

class Program
{
    // Connection to your local Docker SQL Server (from .env)
    private const string ConnectionString =
        "Server=localhost,1433;Database=nopcommerce;User Id=sa;Password=DevPassword123!;TrustServerCertificate=True;Encrypt=False;";

    // Starting IDs – must not collide with existing data
    private static int _nextProductId = 48;      // current max = 47
    private static int _nextPictureId = 87;      // current max = 86
    private static int _nextCategoryId = 17;     // current max = 16
    private static int _nextManufacturerId = 4;  // current max = 3
    private static int _nextUrlRecordId = 101;   // current max = 100
    private static int _nextMappingId = 1;

    static async Task Main(string[] args)
    {
        var catalogPath = args.Length > 0 ? args[0] : "../python-data-generator/catalog.json";
        var imageOutDir = args.Length > 1 ? args[1] : "../output-images";

        if (!File.Exists(catalogPath))
        {
            Console.WriteLine($"Catalog not found: {catalogPath}");
            Console.WriteLine("Usage: dotnet run -- \u003Cpath-to-catalog.json\u003E [output-image-dir]");
            Environment.Exit(1);
        }

        var json = await File.ReadAllTextAsync(catalogPath);
        var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
        var catalog = JsonSerializer.Deserialize<CatalogRoot>(json, options);
        if (catalog == null) throw new InvalidOperationException("Failed to deserialize catalog.");

        Directory.CreateDirectory(imageOutDir);

        Console.WriteLine("=== nopCommerce Multi-Store Data Importer ===");
        Console.WriteLine($"Products: {catalog.Products.Count}");
        Console.WriteLine($"Categories: {catalog.Categories.Count}");
        Console.WriteLine($"Manufacturers: {catalog.Manufacturers.Count}");
        Console.WriteLine();

        await using var conn = new SqlConnection(ConnectionString);
        await conn.OpenAsync();

        // Read existing max IDs to be safe
        await SyncMaxIds(conn);

        await using var tx = (SqlTransaction)await conn.BeginTransactionAsync();

        try
        {
            // 1. Ensure Store 2 exists
            await EnsureStore2(conn, tx, catalog.Stores.FirstOrDefault(s => s.Id == 2));

            // 2. Insert categories with URL records
            foreach (var cat in catalog.Categories)
            {
                cat.AssignedId = _nextCategoryId++;
                await InsertCategory(conn, tx, cat);
                var catSlug = cat.Name.ToLowerInvariant().Replace(" ", "-").Replace("&", "and");
                await InsertUrlRecord(conn, tx, "Category", cat.AssignedId, catSlug);
                Console.WriteLine($"Category {cat.AssignedId}: {cat.Name}");
            }

            // 3. Insert manufacturers with URL records
            foreach (var mfr in catalog.Manufacturers)
            {
                mfr.AssignedId = _nextManufacturerId++;
                await InsertManufacturer(conn, tx, mfr);
                var mfrSlug = mfr.Name.ToLowerInvariant().Replace(" ", "-").Replace("&", "and");
                await InsertUrlRecord(conn, tx, "Manufacturer", mfr.AssignedId, mfrSlug);
                Console.WriteLine($"Manufacturer {mfr.AssignedId}: {mfr.Name}");
            }

            // 4. Insert products with pictures and mappings
            foreach (var prod in catalog.Products)
            {
                prod.AssignedId = _nextProductId++;

                // Generate a simple coloured placeholder JPEG on disk
                var pictureId = _nextPictureId++;
                var imageFileName = $"{pictureId:D7}_0.jpg";
                var imagePath = Path.Combine(imageOutDir, imageFileName);
                await GeneratePlaceholderJpeg(imagePath, prod.Name);

                // Insert Picture row
                await InsertPicture(conn, tx, pictureId, prod);

                // Insert Product
                await InsertProduct(conn, tx, prod);

                // Link picture
                await InsertProductPictureMapping(conn, tx, prod.AssignedId, pictureId);

                // Link categories
                foreach (var cid in prod.CategoryIds)
                {
                    var cat = catalog.Categories.First(c => c.Id == cid);
                    await InsertProductCategoryMapping(conn, tx, prod.AssignedId, cat.AssignedId);
                }

                // Link manufacturer
                if (prod.ManufacturerId > 0)
                {
                    var mfr = catalog.Manufacturers.First(m => m.Id == prod.ManufacturerId);
                    await InsertProductManufacturerMapping(conn, tx, prod.AssignedId, mfr.AssignedId);
                }

                // Store mappings
                foreach (var sid in prod.StoreIds)
                {
                    await InsertStoreMapping(conn, tx, "Product", prod.AssignedId, sid);
                }

                // URL record for SEO
                var slug = prod.Sku.ToLowerInvariant().Replace(" ", "-").Replace("_", "-");
                await InsertUrlRecord(conn, tx, "Product", prod.AssignedId, slug);

                // Store mapping for categories and manufacturers too
                var catItem = catalog.Categories.FirstOrDefault(c => c.Id == prod.CategoryIds.FirstOrDefault());
                if (catItem != null)
                {
                    foreach (var sid in catItem.StoreIds)
                        await InsertStoreMapping(conn, tx, "Category", catItem.AssignedId, sid);
                }
                var mfrItem = catalog.Manufacturers.FirstOrDefault(m => m.Id == prod.ManufacturerId);
                if (mfrItem != null)
                {
                    foreach (var sid in mfrItem.StoreIds)
                        await InsertStoreMapping(conn, tx, "Manufacturer", mfrItem.AssignedId, sid);
                }

                Console.WriteLine($"Product {prod.AssignedId}: {prod.Name} (Store {string.Join(",", prod.StoreIds)})");
            }

            await tx.CommitAsync();
            Console.WriteLine();
            Console.WriteLine("=== Import Complete ===");
            Console.WriteLine($"Next steps:");
            Console.WriteLine($"  1. Copy images from {Path.GetFullPath(imageOutDir)} to your nopCommerce container's images directory");
            Console.WriteLine($"     e.g. docker cp {imageOutDir}/. db-infra-nopcommerce:/app/wwwroot/images/");
            Console.WriteLine($"  2. Restart nopCommerce to clear caches");
        }
        catch (Exception ex)
        {
            await tx.RollbackAsync();
            Console.WriteLine($"IMPORT FAILED: {ex.Message}");
            throw;
        }
    }

    private static async Task SyncMaxIds(SqlConnection conn)
    {
        async Task<int> GetMax(string table)
        {
            await using var cmd = new SqlCommand($"SELECT ISNULL(MAX(Id),0) FROM {table}", conn);
            var result = await cmd.ExecuteScalarAsync();
            return Convert.ToInt32(result);
        }

        _nextProductId = Math.Max(_nextProductId, await GetMax("Product") + 1);
        _nextPictureId = Math.Max(_nextPictureId, await GetMax("Picture") + 1);
        _nextCategoryId = Math.Max(_nextCategoryId, await GetMax("Category") + 1);
        _nextManufacturerId = Math.Max(_nextManufacturerId, await GetMax("Manufacturer") + 1);
        _nextUrlRecordId = Math.Max(_nextUrlRecordId, await GetMax("UrlRecord") + 1);
        _nextMappingId = Math.Max(_nextMappingId, await GetMax("Product_Picture_Mapping") + 1);
        _nextMappingId = Math.Max(_nextMappingId, await GetMax("Product_Category_Mapping") + 1);
        _nextMappingId = Math.Max(_nextMappingId, await GetMax("Product_Manufacturer_Mapping") + 1);
        _nextMappingId = Math.Max(_nextMappingId, await GetMax("StoreMapping") + 1);
    }

    private static async Task EnsureStore2(SqlConnection conn, SqlTransaction tx, Store? store2)
    {
        if (store2 == null) return;

        await using var check = new SqlCommand("SELECT COUNT(*) FROM Store WHERE Id=@id", conn, tx);
        check.Parameters.AddWithValue("@id", store2.Id);
        var exists = (int)await check.ExecuteScalarAsync()! > 0;
        if (exists) return;

        // Must use explicit Id because previous failed transactions may have consumed identity values
        await using var idOn = new SqlCommand("SET IDENTITY_INSERT Store ON", conn, tx);
        await idOn.ExecuteNonQueryAsync();
        try
        {
            const string sql = @"
                INSERT INTO Store (Id, Name, Url, Hosts, CompanyName, CompanyAddress, CompanyPhoneNumber,
                    SslEnabled, DefaultLanguageId, DisplayOrder, Deleted)
                VALUES (@Id, @Name, @Url, @Hosts, @CompanyName, @CompanyAddress, @CompanyPhoneNumber,
                    0, 0, @DisplayOrder, 0)";
            await using var cmd = new SqlCommand(sql, conn, tx);
            cmd.Parameters.AddWithValue("@Id", store2.Id);
            cmd.Parameters.AddWithValue("@Name", store2.Name);
            cmd.Parameters.AddWithValue("@Url", store2.Url);
            cmd.Parameters.AddWithValue("@Hosts", store2.Hosts);
            cmd.Parameters.AddWithValue("@CompanyName", $"{store2.Name} Ltd");
            cmd.Parameters.AddWithValue("@CompanyAddress", "Local development address");
            cmd.Parameters.AddWithValue("@CompanyPhoneNumber", "(000) 000-0000");
            cmd.Parameters.AddWithValue("@DisplayOrder", store2.Id);
            await cmd.ExecuteNonQueryAsync();
        }
        finally
        {
            await using var idOff = new SqlCommand("SET IDENTITY_INSERT Store OFF", conn, tx);
            await idOff.ExecuteNonQueryAsync();
        }
        Console.WriteLine($"Created Store {store2.Id}: {store2.Name}");
    }

    private static async Task WithIdentityInsert(SqlConnection conn, SqlTransaction tx, string table, Func<Task> action)
    {
        try
        {
            await using var onCmd = new SqlCommand($"SET IDENTITY_INSERT {table} ON", conn, tx);
            await onCmd.ExecuteNonQueryAsync();
        }
        catch (SqlException) { /* table may not have identity */ }
        try { await action(); }
        finally
        {
            try
            {
                await using var offCmd = new SqlCommand($"SET IDENTITY_INSERT {table} OFF", conn, tx);
                await offCmd.ExecuteNonQueryAsync();
            }
            catch (SqlException) { /* table may not have identity */ }
        }
    }

    private static async Task InsertCategory(SqlConnection conn, SqlTransaction tx, Category cat)
    {
        await WithIdentityInsert(conn, tx, "Category", async () =>
        {
            const string sql = @"
                INSERT INTO Category (Id, Name, Description, CategoryTemplateId, MetaKeywords, MetaTitle,
                    PageSizeOptions, ParentCategoryId, PictureId, PageSize, AllowCustomersToSelectPageSize,
                    ShowOnHomepage, SubjectToAcl, LimitedToStores, Published, Deleted, DisplayOrder,
                    CreatedOnUtc, UpdatedOnUtc, PriceRangeFiltering, PriceFrom, PriceTo, ManuallyPriceRange, RestrictFromVendors)
                VALUES (@Id, @Name, @Description, 1, '', '', '', @ParentCategoryId, 0, 12, 0, 1, 0, 1, 1, 0, @DisplayOrder,
                    GETUTCDATE(), GETUTCDATE(), 0, 0, 0, 0, 0)";
            await using var cmd = new SqlCommand(sql, conn, tx);
            cmd.Parameters.AddWithValue("@Id", cat.AssignedId);
            cmd.Parameters.AddWithValue("@Name", cat.Name);
            cmd.Parameters.AddWithValue("@Description", cat.Description ?? "");
            cmd.Parameters.AddWithValue("@ParentCategoryId", cat.ParentId);
            cmd.Parameters.AddWithValue("@DisplayOrder", cat.Id);
            await cmd.ExecuteNonQueryAsync();
        });
    }

    private static async Task InsertManufacturer(SqlConnection conn, SqlTransaction tx, Manufacturer mfr)
    {
        await WithIdentityInsert(conn, tx, "Manufacturer", async () =>
        {
            const string sql = @"
                INSERT INTO Manufacturer (Id, Name, Description, ManufacturerTemplateId, MetaKeywords, MetaTitle,
                    PageSizeOptions, PictureId, PageSize, AllowCustomersToSelectPageSize, SubjectToAcl,
                    LimitedToStores, Published, Deleted, DisplayOrder, CreatedOnUtc, UpdatedOnUtc,
                    PriceRangeFiltering, PriceFrom, PriceTo, ManuallyPriceRange)
                VALUES (@Id, @Name, @Description, 1, '', '', '', 0, 12, 0, 0, 1, 1, 0, @DisplayOrder,
                    GETUTCDATE(), GETUTCDATE(), 0, 0, 0, 0)";
            await using var cmd = new SqlCommand(sql, conn, tx);
            cmd.Parameters.AddWithValue("@Id", mfr.AssignedId);
            cmd.Parameters.AddWithValue("@Name", mfr.Name);
            cmd.Parameters.AddWithValue("@Description", mfr.Description ?? "");
            cmd.Parameters.AddWithValue("@DisplayOrder", mfr.Id);
            await cmd.ExecuteNonQueryAsync();
        });
    }

    private static async Task InsertPicture(SqlConnection conn, SqlTransaction tx, int pictureId, Product prod)
    {
        await WithIdentityInsert(conn, tx, "Picture", async () =>
        {
            const string sql = @"
                INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath)
                VALUES (@Id, 'image/jpeg', @SeoFilename, @Alt, @Title, 1, '')";
            await using var cmd = new SqlCommand(sql, conn, tx);
            cmd.Parameters.AddWithValue("@Id", pictureId);
            cmd.Parameters.AddWithValue("@SeoFilename", prod.Sku.Replace(" ", "-").Replace("/", "-"));
            cmd.Parameters.AddWithValue("@Alt", prod.Name);
            cmd.Parameters.AddWithValue("@Title", prod.Name);
            await cmd.ExecuteNonQueryAsync();
        });
    }

    private static async Task InsertProduct(SqlConnection conn, SqlTransaction tx, Product prod)
    {
        await WithIdentityInsert(conn, tx, "Product", async () =>
        {
            // Read schema: name, type, nullability
            var schema = new List<(string Name, string DataType, bool IsNullable)>();
            await using (var schemaCmd = new SqlCommand(
                "SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Product' ORDER BY ORDINAL_POSITION",
                conn, tx))
            {
                await using var reader = await schemaCmd.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                    schema.Add((reader.GetString(0), reader.GetString(1), reader.GetString(2) == "YES"));
            }

            // Product-specific overrides
            var overrides = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase)
            {
                ["Id"] = prod.AssignedId,
                ["Name"] = prod.Name,
                ["ShortDescription"] = prod.ShortDescription ?? "",
                ["FullDescription"] = prod.FullDescription ?? "",
                ["Sku"] = prod.Sku,
                ["Price"] = prod.Price,
                ["OldPrice"] = prod.OldPrice,
                ["ProductCost"] = Math.Round(prod.Price * 0.6m, 2),
                ["StockQuantity"] = prod.StockQuantity,
                ["MinStockQuantity"] = prod.MinStockQuantity,
                ["Weight"] = prod.Weight,
                ["Length"] = prod.Length,
                ["Width"] = prod.Width,
                ["Height"] = prod.Height,
                ["DisplayOrder"] = prod.DisplayOrder,
                ["ProductTypeId"] = 5,
                ["ProductTemplateId"] = 1,      // Required: 1 = Simple product template
                ["ParentGroupedProductId"] = 0,
                ["VisibleIndividually"] = true,
                ["ShowOnHomepage"] = true,       // Makes product appear on homepage
                ["CreatedOnUtc"] = DateTime.UtcNow,
                ["UpdatedOnUtc"] = DateTime.UtcNow,
                ["Published"] = true,
                ["Deleted"] = false,
                ["AllowCustomerReviews"] = true,
                ["LimitedToStores"] = false,     // Avoids StoreMapping auth issues on homepage
                ["IsShipEnabled"] = true,
                ["ManageInventoryMethodId"] = 1,
                ["DisplayStockAvailability"] = true,
                ["DisplayStockQuantity"] = true,
                ["OrderMinimumQuantity"] = 1,
                ["OrderMaximumQuantity"] = 10000,
            };

            var columns = new List<string>();
            var values = new List<string>();
            var parameters = new List<SqlParameter>();

            foreach (var (col, dataType, isNullable) in schema)
            {
                var pName = $"@p_{col}";
                columns.Add(col);
                values.Add(pName);

                if (overrides.TryGetValue(col, out var val))
                {
                    parameters.Add(new SqlParameter(pName, val));
                    continue;
                }

                // Compute default based on SQL type
                object defaultVal = dataType.ToLowerInvariant() switch
                {
                    "int" or "bigint" or "smallint" or "tinyint" => 0,
                    "bit" => false,
                    "decimal" or "numeric" or "money" or "smallmoney" or "float" or "real" => 0m,
                    "datetime" or "datetime2" or "smalldatetime" or "date" or "time" => DBNull.Value,
                    "nvarchar" or "varchar" or "nchar" or "char" or "text" or "ntext" => "",
                    _ => DBNull.Value
                };

                if (!isNullable && defaultVal == DBNull.Value)
                    defaultVal = dataType.ToLowerInvariant() switch
                    {
                        "datetime" or "datetime2" or "smalldatetime" => new DateTime(1900, 1, 1),
                        _ => 0
                    };

                parameters.Add(new SqlParameter(pName, defaultVal));
            }

            var sql = $"INSERT INTO Product ({string.Join(", ", columns)}) VALUES ({string.Join(", ", values)})";
            await using var cmd = new SqlCommand(sql, conn, tx);
            foreach (var p in parameters)
                cmd.Parameters.AddWithValue(p.ParameterName, p.Value ?? DBNull.Value);
            await cmd.ExecuteNonQueryAsync();
        });
    }

    private static async Task InsertProductPictureMapping(SqlConnection conn, SqlTransaction tx, int productId, int pictureId)
    {
        await WithIdentityInsert(conn, tx, "Product_Picture_Mapping", async () =>
        {
            var id = _nextMappingId++;
            const string sql = "INSERT INTO Product_Picture_Mapping (Id, ProductId, PictureId, DisplayOrder) VALUES (@Id, @ProductId, @PictureId, 0)";
            await using var cmd = new SqlCommand(sql, conn, tx);
            cmd.Parameters.AddWithValue("@Id", id);
            cmd.Parameters.AddWithValue("@ProductId", productId);
            cmd.Parameters.AddWithValue("@PictureId", pictureId);
            await cmd.ExecuteNonQueryAsync();
        });
    }

    private static async Task InsertProductCategoryMapping(SqlConnection conn, SqlTransaction tx, int productId, int categoryId)
    {
        await WithIdentityInsert(conn, tx, "Product_Category_Mapping", async () =>
        {
            var id = _nextMappingId++;
            const string sql = "INSERT INTO Product_Category_Mapping (Id, ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@Id, @ProductId, @CategoryId, 0, 0)";
            await using var cmd = new SqlCommand(sql, conn, tx);
            cmd.Parameters.AddWithValue("@Id", id);
            cmd.Parameters.AddWithValue("@ProductId", productId);
            cmd.Parameters.AddWithValue("@CategoryId", categoryId);
            await cmd.ExecuteNonQueryAsync();
        });
    }

    private static async Task InsertProductManufacturerMapping(SqlConnection conn, SqlTransaction tx, int productId, int manufacturerId)
    {
        await WithIdentityInsert(conn, tx, "Product_Manufacturer_Mapping", async () =>
        {
            var id = _nextMappingId++;
            const string sql = "INSERT INTO Product_Manufacturer_Mapping (Id, ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@Id, @ProductId, @ManufacturerId, 0, 0)";
            await using var cmd = new SqlCommand(sql, conn, tx);
            cmd.Parameters.AddWithValue("@Id", id);
            cmd.Parameters.AddWithValue("@ProductId", productId);
            cmd.Parameters.AddWithValue("@ManufacturerId", manufacturerId);
            await cmd.ExecuteNonQueryAsync();
        });
    }

    private static async Task InsertStoreMapping(SqlConnection conn, SqlTransaction tx, string entityName, int entityId, int storeId)
    {
        await WithIdentityInsert(conn, tx, "StoreMapping", async () =>
        {
            // Avoid duplicates
            await using var check = new SqlCommand(
                "SELECT COUNT(*) FROM StoreMapping WHERE EntityName=@EntityName AND EntityId=@EntityId AND StoreId=@StoreId",
                conn, tx);
            check.Parameters.AddWithValue("@EntityName", entityName);
            check.Parameters.AddWithValue("@EntityId", entityId);
            check.Parameters.AddWithValue("@StoreId", storeId);
            var exists = (int)await check.ExecuteScalarAsync()! > 0;
            if (exists) return;

            var id = _nextMappingId++;
            const string sql = "INSERT INTO StoreMapping (Id, EntityName, StoreId, EntityId) VALUES (@Id, @EntityName, @StoreId, @EntityId)";
            await using var cmd = new SqlCommand(sql, conn, tx);
            cmd.Parameters.AddWithValue("@Id", id);
            cmd.Parameters.AddWithValue("@EntityName", entityName);
            cmd.Parameters.AddWithValue("@StoreId", storeId);
            cmd.Parameters.AddWithValue("@EntityId", entityId);
            await cmd.ExecuteNonQueryAsync();
        });
    }

    private static async Task InsertUrlRecord(SqlConnection conn, SqlTransaction tx, string entityName, int entityId, string slug)
    {
        await WithIdentityInsert(conn, tx, "UrlRecord", async () =>
        {
            var id = _nextUrlRecordId++;
            const string sql = "INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@Id, @EntityName, @Slug, @EntityId, 1, 0)";
            await using var cmd = new SqlCommand(sql, conn, tx);
            cmd.Parameters.AddWithValue("@Id", id);
            cmd.Parameters.AddWithValue("@EntityName", entityName);
            cmd.Parameters.AddWithValue("@Slug", slug);
            cmd.Parameters.AddWithValue("@EntityId", entityId);
            await cmd.ExecuteNonQueryAsync();
        });
    }

    /// <summary>
    /// Downloads a real placeholder image from picsum.photos (seeded by product name for stability).
    /// Falls back to a tiny grey JPEG if offline.
    /// </summary>
    private static async Task GeneratePlaceholderJpeg(string path, string label)
    {
        try
        {
            var seed = Math.Abs(label.GetHashCode()) % (int.MaxValue - 1);
            var url = $"https://picsum.photos/seed/{seed}/512/384";
            using var client = new HttpClient { Timeout = TimeSpan.FromSeconds(30) };
            var bytes = await client.GetByteArrayAsync(url);
            await File.WriteAllBytesAsync(path, bytes);
        }
        catch
        {
            // Offline fallback: write a minimal valid 1×1 grey JPEG
            var fallback = Convert.FromBase64String(
                "/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB" +
                "AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEB" +
                "AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB" +
                "AQEBAQEBAQH/wAARCAAgACADASIAAhEBAxEB/8QAGQAAAgMBAAAAAAAAAAAAAAAABAUAAgMGCP/EACsQAAICAQMEAgICAgMAAAAAAAECAAMRBBIFBhMhMUEiMlEHI0JhFBdSgf/EABgBAAIDAAAAAAAAAAAAAAAAAAMEAQIF/8QAJREAAgEEAgICAgMAAAAAAAAAAQIAAxEEEgUhMRMiQVEyQmFx/9oADAMBAAIRAxEAPwD3+K3C");
            await File.WriteAllBytesAsync(path, fallback);
        }
    }
}

// ------------------------------------------------------------------
// Data models (mirror catalog.json)
// ------------------------------------------------------------------
public class CatalogRoot
{
    public List<Store> Stores { get; set; } = new();
    public List<Manufacturer> Manufacturers { get; set; } = new();
    public List<Category> Categories { get; set; } = new();
    public List<Product> Products { get; set; } = new();
}

public class Store
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public string Url { get; set; } = "";
    public string Hosts { get; set; } = "";
    public string Theme { get; set; } = "";
}

public class Manufacturer
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public List<int> StoreIds { get; set; } = new();
    public string Description { get; set; } = "";
    public int AssignedId { get; set; }
}

public class Category
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public int ParentId { get; set; }
    public List<int> StoreIds { get; set; } = new();
    public string Description { get; set; } = "";
    public int AssignedId { get; set; }
}

public class Product
{
    public string Sku { get; set; } = "";
    public string Name { get; set; } = "";
    public decimal Price { get; set; }
    public decimal OldPrice { get; set; }
    public List<int> CategoryIds { get; set; } = new();
    public int ManufacturerId { get; set; }
    public List<int> StoreIds { get; set; } = new();
    public string? ShortDescription { get; set; }
    public string? FullDescription { get; set; }
    public decimal Weight { get; set; }
    public int Length { get; set; }
    public int Width { get; set; }
    public int Height { get; set; }
    public int StockQuantity { get; set; }
    public int MinStockQuantity { get; set; }
    public int DisplayOrder { get; set; }
    public string? ImagePrompt { get; set; }
    public int AssignedId { get; set; }
}

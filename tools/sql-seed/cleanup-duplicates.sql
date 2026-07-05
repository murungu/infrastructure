SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

-- ================================================================
-- CLEANUP: Remove all data inserted by the SQL seed script
-- (keeps only C# app data: products 48-97, categories 17-28, manufacturers 4-10)
-- ================================================================

-- 1. Delete duplicate products (98-147) and their mappings
DELETE FROM Product_Picture_Mapping WHERE ProductId >= 98;
DELETE FROM Product_Category_Mapping WHERE ProductId >= 98;
DELETE FROM Product_Manufacturer_Mapping WHERE ProductId >= 98;
DELETE FROM StoreMapping WHERE EntityName = 'Product' AND EntityId >= 98;
DELETE FROM UrlRecord WHERE EntityName = 'Product' AND EntityId >= 98;
DELETE FROM Product WHERE Id >= 98;
PRINT 'Deleted duplicate products (98-147)';

-- 2. Delete duplicate pictures (137-186)
DELETE FROM PictureBinary WHERE PictureId >= 137;
DELETE FROM Picture WHERE Id >= 137;
PRINT 'Deleted duplicate pictures (137-186)';

-- 3. Delete duplicate categories (29-40) and their mappings
DELETE FROM StoreMapping WHERE EntityName = 'Category' AND EntityId BETWEEN 29 AND 40;
DELETE FROM UrlRecord WHERE EntityName = 'Category' AND EntityId BETWEEN 29 AND 40;
DELETE FROM Category WHERE Id BETWEEN 29 AND 40;
PRINT 'Deleted duplicate categories (29-40)';

-- 4. Delete duplicate manufacturers (11-17) and their mappings
DELETE FROM StoreMapping WHERE EntityName = 'Manufacturer' AND EntityId BETWEEN 11 AND 17;
DELETE FROM UrlRecord WHERE EntityName = 'Manufacturer' AND EntityId BETWEEN 11 AND 17;
DELETE FROM Manufacturer WHERE Id BETWEEN 11 AND 17;
PRINT 'Deleted duplicate manufacturers (11-17)';

-- 5. Remove any orphaned StoreMapping rows pointing to deleted entities
DELETE FROM StoreMapping WHERE EntityName = 'Category' AND EntityId > 40;
DELETE FROM StoreMapping WHERE EntityName = 'Manufacturer' AND EntityId > 17;
DELETE FROM StoreMapping WHERE EntityName = 'Product' AND EntityId > 97;
PRINT 'Cleaned orphaned StoreMapping rows';

COMMIT TRANSACTION;

-- Verify counts
SELECT 'Products' AS Entity, COUNT(*) AS Count FROM Product WHERE Deleted=0
UNION ALL
SELECT 'Categories', COUNT(*) FROM Category WHERE Deleted=0
UNION ALL
SELECT 'Manufacturers', COUNT(*) FROM Manufacturer WHERE Deleted=0
UNION ALL
SELECT 'Pictures', COUNT(*) FROM Picture
UNION ALL
SELECT 'UrlRecords', COUNT(*) FROM UrlRecord;

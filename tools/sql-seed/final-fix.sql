SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

-- Fix existing products: ProductTemplateId=1, ShowOnHomepage=1, LimitedToStores=0
UPDATE Product SET ProductTemplateId = 1, ShowOnHomepage = 1, LimitedToStores = 0 WHERE Id >= 48;
PRINT 'Fixed ProductTemplateId, ShowOnHomepage, LimitedToStores for products 48-97';

-- Fix existing categories: ShowOnHomepage=1
UPDATE Category SET ShowOnHomepage = 1 WHERE Id >= 17;
PRINT 'Fixed ShowOnHomepage for categories 17-28';

-- Add UrlRecord for categories if missing
INSERT INTO UrlRecord (EntityName, Slug, EntityId, IsActive, LanguageId)
SELECT 'Category', 
    LOWER(REPLACE(REPLACE(Name, ' ', '-'), '&', 'and')),
    Id, 1, 0
FROM Category
WHERE Id >= 17 AND NOT EXISTS (SELECT 1 FROM UrlRecord WHERE EntityName = 'Category' AND EntityId = Category.Id);
PRINT 'Added UrlRecord for categories';

-- Add UrlRecord for manufacturers if missing
INSERT INTO UrlRecord (EntityName, Slug, EntityId, IsActive, LanguageId)
SELECT 'Manufacturer', 
    LOWER(REPLACE(REPLACE(Name, ' ', '-'), '&', 'and')),
    Id, 1, 0
FROM Manufacturer
WHERE Id >= 4 AND NOT EXISTS (SELECT 1 FROM UrlRecord WHERE EntityName = 'Manufacturer' AND EntityId = Manufacturer.Id);
PRINT 'Added UrlRecord for manufacturers';

COMMIT TRANSACTION;
PRINT 'FINAL FIX COMPLETE';

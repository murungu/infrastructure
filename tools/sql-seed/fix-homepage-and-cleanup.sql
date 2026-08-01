SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

-- ================================================================
-- CLEANUP: Hide original sample data, make new data homepage-visible
-- ================================================================

-- 1. Unpublish original sample categories (keep them for reference but hide from menu)
UPDATE Category SET Published = 0, ShowOnHomepage = 0 WHERE Id BETWEEN 1 AND 16;
PRINT 'Unpublished original sample categories (1-16)';

-- 2. Unpublish original sample products
UPDATE Product SET Published = 0 WHERE Id BETWEEN 1 AND 47;
PRINT 'Unpublished original sample products (1-47)';

-- 3. Set ShowOnHomepage = 1 for new Store 1 products (electrical/solar)
UPDATE Product SET ShowOnHomepage = 1 WHERE Id BETWEEN 48 AND 67;
PRINT 'Set ShowOnHomepage=1 for Store 1 products (48-67)';

-- 4. Set ShowOnHomepage = 1 for new Store 2 products (artisan)
UPDATE Product SET ShowOnHomepage = 1 WHERE Id BETWEEN 68 AND 97;
PRINT 'Set ShowOnHomepage=1 for Store 2 products (68-97)';

COMMIT TRANSACTION;
PRINT 'HOMEPAGE FIX COMPLETE';

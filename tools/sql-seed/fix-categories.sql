SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

-- ================================================================
-- Fix 1: Add UrlRecord for every new category (required for links)
-- ================================================================
DECLARE @Now DATETIME2 = GETUTCDATE();

-- Store 1 categories (Electrical/Solar)
INSERT INTO UrlRecord (EntityName, Slug, EntityId, IsActive, LanguageId)
VALUES
('Category', 'solar-panels',     17, 1, 0),
('Category', 'batteries-storage',18, 1, 0),
('Category', 'inverters-controllers', 19, 1, 0),
('Category', 'led-lighting',     20, 1, 0),
('Category', 'cables-connectors',21, 1, 0),
('Category', 'smart-home',       22, 1, 0);

-- Store 2 categories (Artisan)
INSERT INTO UrlRecord (EntityName, Slug, EntityId, IsActive, LanguageId)
VALUES
('Category', 'hand-carved-wood',  23, 1, 0),
('Category', 'beaded-jewelry',    24, 1, 0),
('Category', 'woven-baskets',     25, 1, 0),
('Category', 'leather-goods',     26, 1, 0),
('Category', 'stone-carvings',    27, 1, 0),
('Category', 'painted-fabrics',   28, 1, 0);

PRINT 'UrlRecord entries created for 12 categories';

-- ================================================================
-- Fix 2: Set ShowOnHomepage = 1 for top-level menu visibility
-- ================================================================
UPDATE Category SET ShowOnHomepage = 1 WHERE Id IN (17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28);

PRINT 'ShowOnHomepage set to 1 for all new categories';

COMMIT TRANSACTION;
PRINT 'CATEGORY FIX COMPLETE';

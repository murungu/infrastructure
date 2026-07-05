SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

DECLARE @Now DATETIME2 = GETUTCDATE();
DECLARE @StartProductId INT = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
DECLARE @StartPictureId INT = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
DECLARE @StartCatId INT = (SELECT ISNULL(MAX(Id),0)+1 FROM Category);
DECLARE @StartMfrId INT = (SELECT ISNULL(MAX(Id),0)+1 FROM Manufacturer);
DECLARE @StartUrlId INT = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);

IF NOT EXISTS (SELECT 1 FROM Store WHERE Id=2)
BEGIN
SET IDENTITY_INSERT Store ON;
INSERT INTO Store (Id,Name,Url,Hosts,CompanyName,CompanyAddress,CompanyPhoneNumber,SslEnabled,DefaultLanguageId,DisplayOrder,Deleted)
VALUES (2,'Victoria Falls Artisan Market','http://store2.localhost:8080/','store2.localhost','Victoria Falls Artisan Market Ltd','Local dev address','(000) 000-0000',0,0,2,0);
SET IDENTITY_INSERT Store OFF;
END

SET @StartCatId = (SELECT ISNULL(MAX(Id),0)+1 FROM Category);
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (Id,Name,Description,CategoryTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,ParentCategoryId,PictureId,PageSize,AllowCustomersToSelectPageSize,ShowOnHomepage,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange,RestrictFromVendors)
VALUES (@StartCatId,'Solar Panels','Monocrystalline and polycrystalline panels for home and commercial use.',1,'','',',',0,0,12,0,1,0,1,1,0,11,@Now,@Now,0,0,0,0,0);
SET IDENTITY_INSERT Category OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Category',1,@StartCatId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Category', 'solar-panels', @StartCatId, 1, 0);

SET @StartCatId = (SELECT ISNULL(MAX(Id),0)+1 FROM Category);
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (Id,Name,Description,CategoryTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,ParentCategoryId,PictureId,PageSize,AllowCustomersToSelectPageSize,ShowOnHomepage,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange,RestrictFromVendors)
VALUES (@StartCatId,'Batteries & Storage','Lithium-ion and gel batteries for off-grid and backup systems.',1,'','',',',0,0,12,0,1,0,1,1,0,12,@Now,@Now,0,0,0,0,0);
SET IDENTITY_INSERT Category OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Category',1,@StartCatId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Category', 'batteries-and-storage', @StartCatId, 1, 0);

SET @StartCatId = (SELECT ISNULL(MAX(Id),0)+1 FROM Category);
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (Id,Name,Description,CategoryTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,ParentCategoryId,PictureId,PageSize,AllowCustomersToSelectPageSize,ShowOnHomepage,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange,RestrictFromVendors)
VALUES (@StartCatId,'Inverters & Controllers','MPPT charge controllers and pure-sine wave inverters.',1,'','',',',0,0,12,0,1,0,1,1,0,13,@Now,@Now,0,0,0,0,0);
SET IDENTITY_INSERT Category OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Category',1,@StartCatId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Category', 'inverters-and-controllers', @StartCatId, 1, 0);

SET @StartCatId = (SELECT ISNULL(MAX(Id),0)+1 FROM Category);
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (Id,Name,Description,CategoryTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,ParentCategoryId,PictureId,PageSize,AllowCustomersToSelectPageSize,ShowOnHomepage,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange,RestrictFromVendors)
VALUES (@StartCatId,'LED Lighting','Energy-efficient indoor, outdoor and security lighting.',1,'','',',',0,0,12,0,1,0,1,1,0,14,@Now,@Now,0,0,0,0,0);
SET IDENTITY_INSERT Category OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Category',1,@StartCatId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Category', 'led-lighting', @StartCatId, 1, 0);

SET @StartCatId = (SELECT ISNULL(MAX(Id),0)+1 FROM Category);
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (Id,Name,Description,CategoryTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,ParentCategoryId,PictureId,PageSize,AllowCustomersToSelectPageSize,ShowOnHomepage,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange,RestrictFromVendors)
VALUES (@StartCatId,'Cables & Connectors','Solar cable, MC4 connectors, trunking and conduit.',1,'','',',',0,0,12,0,1,0,1,1,0,15,@Now,@Now,0,0,0,0,0);
SET IDENTITY_INSERT Category OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Category',1,@StartCatId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Category', 'cables-and-connectors', @StartCatId, 1, 0);

SET @StartCatId = (SELECT ISNULL(MAX(Id),0)+1 FROM Category);
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (Id,Name,Description,CategoryTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,ParentCategoryId,PictureId,PageSize,AllowCustomersToSelectPageSize,ShowOnHomepage,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange,RestrictFromVendors)
VALUES (@StartCatId,'Smart Home','Wi-Fi switches, smart plugs and energy monitors.',1,'','',',',0,0,12,0,1,0,1,1,0,16,@Now,@Now,0,0,0,0,0);
SET IDENTITY_INSERT Category OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Category',1,@StartCatId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Category', 'smart-home', @StartCatId, 1, 0);

SET @StartCatId = (SELECT ISNULL(MAX(Id),0)+1 FROM Category);
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (Id,Name,Description,CategoryTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,ParentCategoryId,PictureId,PageSize,AllowCustomersToSelectPageSize,ShowOnHomepage,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange,RestrictFromVendors)
VALUES (@StartCatId,'Hand-carved Wood','Bowls, utensils, animals and decorative pieces carved from local hardwoods.',1,'','',',',0,0,12,0,1,0,1,1,0,21,@Now,@Now,0,0,0,0,0);
SET IDENTITY_INSERT Category OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Category',2,@StartCatId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Category', 'hand-carved-wood', @StartCatId, 1, 0);

SET @StartCatId = (SELECT ISNULL(MAX(Id),0)+1 FROM Category);
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (Id,Name,Description,CategoryTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,ParentCategoryId,PictureId,PageSize,AllowCustomersToSelectPageSize,ShowOnHomepage,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange,RestrictFromVendors)
VALUES (@StartCatId,'Beaded Jewelry','Necklaces, bracelets and earrings in traditional Zulu and Ndebele patterns.',1,'','',',',0,0,12,0,1,0,1,1,0,22,@Now,@Now,0,0,0,0,0);
SET IDENTITY_INSERT Category OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Category',2,@StartCatId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Category', 'beaded-jewelry', @StartCatId, 1, 0);

SET @StartCatId = (SELECT ISNULL(MAX(Id),0)+1 FROM Category);
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (Id,Name,Description,CategoryTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,ParentCategoryId,PictureId,PageSize,AllowCustomersToSelectPageSize,ShowOnHomepage,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange,RestrictFromVendors)
VALUES (@StartCatId,'Woven Baskets','Ilala palm and grass baskets in every size and colour.',1,'','',',',0,0,12,0,1,0,1,1,0,23,@Now,@Now,0,0,0,0,0);
SET IDENTITY_INSERT Category OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Category',2,@StartCatId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Category', 'woven-baskets', @StartCatId, 1, 0);

SET @StartCatId = (SELECT ISNULL(MAX(Id),0)+1 FROM Category);
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (Id,Name,Description,CategoryTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,ParentCategoryId,PictureId,PageSize,AllowCustomersToSelectPageSize,ShowOnHomepage,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange,RestrictFromVendors)
VALUES (@StartCatId,'Leather Goods','Wallets, belts, bags and sandals hand-stitched from locally sourced leather.',1,'','',',',0,0,12,0,1,0,1,1,0,24,@Now,@Now,0,0,0,0,0);
SET IDENTITY_INSERT Category OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Category',2,@StartCatId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Category', 'leather-goods', @StartCatId, 1, 0);

SET @StartCatId = (SELECT ISNULL(MAX(Id),0)+1 FROM Category);
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (Id,Name,Description,CategoryTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,ParentCategoryId,PictureId,PageSize,AllowCustomersToSelectPageSize,ShowOnHomepage,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange,RestrictFromVendors)
VALUES (@StartCatId,'Stone Carvings','Soapstone and serpentine sculptures of animals, people and abstract forms.',1,'','',',',0,0,12,0,1,0,1,1,0,25,@Now,@Now,0,0,0,0,0);
SET IDENTITY_INSERT Category OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Category',2,@StartCatId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Category', 'stone-carvings', @StartCatId, 1, 0);

SET @StartCatId = (SELECT ISNULL(MAX(Id),0)+1 FROM Category);
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (Id,Name,Description,CategoryTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,ParentCategoryId,PictureId,PageSize,AllowCustomersToSelectPageSize,ShowOnHomepage,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange,RestrictFromVendors)
VALUES (@StartCatId,'Painted Fabrics','Wall hangings, table runners and clothing hand-painted with natural dyes.',1,'','',',',0,0,12,0,1,0,1,1,0,26,@Now,@Now,0,0,0,0,0);
SET IDENTITY_INSERT Category OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Category',2,@StartCatId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Category', 'painted-fabrics', @StartCatId, 1, 0);

SET @StartMfrId = (SELECT ISNULL(MAX(Id),0)+1 FROM Manufacturer);
SET IDENTITY_INSERT Manufacturer ON;
INSERT INTO Manufacturer (Id,Name,Description,ManufacturerTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,PictureId,PageSize,AllowCustomersToSelectPageSize,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange)
VALUES (@StartMfrId,'SunPower Africa','Leading solar panel manufacturer across Southern Africa.',1,'','',',',0,12,0,0,1,1,0,101,@Now,@Now,0,0,0,0);
SET IDENTITY_INSERT Manufacturer OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Manufacturer',1,@StartMfrId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Manufacturer', 'sunpower-africa', @StartMfrId, 1, 0);

SET @StartMfrId = (SELECT ISNULL(MAX(Id),0)+1 FROM Manufacturer);
SET IDENTITY_INSERT Manufacturer ON;
INSERT INTO Manufacturer (Id,Name,Description,ManufacturerTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,PictureId,PageSize,AllowCustomersToSelectPageSize,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange)
VALUES (@StartMfrId,'Victron Energy','Premium inverters and battery management systems.',1,'','',',',0,12,0,0,1,1,0,102,@Now,@Now,0,0,0,0);
SET IDENTITY_INSERT Manufacturer OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Manufacturer',1,@StartMfrId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Manufacturer', 'victron-energy', @StartMfrId, 1, 0);

SET @StartMfrId = (SELECT ISNULL(MAX(Id),0)+1 FROM Manufacturer);
SET IDENTITY_INSERT Manufacturer ON;
INSERT INTO Manufacturer (Id,Name,Description,ManufacturerTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,PictureId,PageSize,AllowCustomersToSelectPageSize,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange)
VALUES (@StartMfrId,'Philips Lighting','Global leader in LED and smart lighting solutions.',1,'','',',',0,12,0,0,1,1,0,103,@Now,@Now,0,0,0,0);
SET IDENTITY_INSERT Manufacturer OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Manufacturer',1,@StartMfrId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Manufacturer', 'philips-lighting', @StartMfrId, 1, 0);

SET @StartMfrId = (SELECT ISNULL(MAX(Id),0)+1 FROM Manufacturer);
SET IDENTITY_INSERT Manufacturer ON;
INSERT INTO Manufacturer (Id,Name,Description,ManufacturerTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,PictureId,PageSize,AllowCustomersToSelectPageSize,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange)
VALUES (@StartMfrId,'Arity Electric','Local supplier of quality electrical components and cables.',1,'','',',',0,12,0,0,1,1,0,104,@Now,@Now,0,0,0,0);
SET IDENTITY_INSERT Manufacturer OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Manufacturer',1,@StartMfrId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Manufacturer', 'arity-electric', @StartMfrId, 1, 0);

SET @StartMfrId = (SELECT ISNULL(MAX(Id),0)+1 FROM Manufacturer);
SET IDENTITY_INSERT Manufacturer ON;
INSERT INTO Manufacturer (Id,Name,Description,ManufacturerTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,PictureId,PageSize,AllowCustomersToSelectPageSize,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange)
VALUES (@StartMfrId,'Victoria Crafts Collective','A cooperative of artisans based near the mighty Victoria Falls.',1,'','',',',0,12,0,0,1,1,0,201,@Now,@Now,0,0,0,0);
SET IDENTITY_INSERT Manufacturer OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Manufacturer',2,@StartMfrId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Manufacturer', 'victoria-crafts-collective', @StartMfrId, 1, 0);

SET @StartMfrId = (SELECT ISNULL(MAX(Id),0)+1 FROM Manufacturer);
SET IDENTITY_INSERT Manufacturer ON;
INSERT INTO Manufacturer (Id,Name,Description,ManufacturerTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,PictureId,PageSize,AllowCustomersToSelectPageSize,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange)
VALUES (@StartMfrId,'Zambezi Artisans','Traditional crafts inspired by the river and the spray.',1,'','',',',0,12,0,0,1,1,0,202,@Now,@Now,0,0,0,0);
SET IDENTITY_INSERT Manufacturer OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Manufacturer',2,@StartMfrId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Manufacturer', 'zambezi-artisans', @StartMfrId, 1, 0);

SET @StartMfrId = (SELECT ISNULL(MAX(Id),0)+1 FROM Manufacturer);
SET IDENTITY_INSERT Manufacturer ON;
INSERT INTO Manufacturer (Id,Name,Description,ManufacturerTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,PictureId,PageSize,AllowCustomersToSelectPageSize,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange)
VALUES (@StartMfrId,'Local Hands Co-op','Community-run workshop supporting rural craft makers.',1,'','',',',0,12,0,0,1,1,0,203,@Now,@Now,0,0,0,0);
SET IDENTITY_INSERT Manufacturer OFF;
INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Manufacturer',2,@StartMfrId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Manufacturer', 'local-hands-co-op', @StartMfrId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'SunPower 300W Monocrystalline Panel', 'High-efficiency 300W panel with 21% conversion rate.', 'Built for African conditions, this panel features tempered glass, anodized aluminium frame and bypass diodes to minimise shade loss. Ideal for residential rooftops and small commercial installations.', 'SOL-300W-001', 1, 0, 85, 1, 1, 10, 1, 10000, 189.99, 229.99, 113.99, 18.5, 1640, 992, 35, 1, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'SOL-300W-001', 'SunPower 300W Monocrystalline Panel', 'SunPower 300W Monocrystalline Panel', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'sol-300w-001', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'SunPower 450W Bifacial Panel', 'Double-sided bifacial panel capturing reflected light.', 'With transparent back-sheet technology, this 450W panel harvests energy from both sides. Perfect for ground-mount arrays and elevated carports where reflected light is abundant.', 'SOL-450W-002', 1, 0, 42, 1, 1, 8, 1, 10000, 289.99, 349.99, 173.99, 22.0, 2094, 1038, 35, 2, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'SOL-450W-002', 'SunPower 450W Bifacial Panel', 'SunPower 450W Bifacial Panel', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'sol-450w-002', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Portable 200W Folding Solar Kit', 'Foldable panel kit for camping and remote power needs.', 'This lightweight folding kit includes a built-in kickstand, carry case and MC4 cables. Charge your batteries anywhere the sun shines – perfect for camping trips and remote monitoring stations.', 'SOL-200W-003', 1, 0, 120, 1, 1, 15, 1, 10000, 149.5, 0, 89.7, 6.2, 580, 420, 45, 3, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'SOL-200W-003', 'Portable 200W Folding Solar Kit', 'Portable 200W Folding Solar Kit', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'sol-200w-003', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, '100W Flexible Solar Panel', 'Thin, bendable panel for boats and curved surfaces.', 'At just 2 mm thick, this ETFE-coated panel can be bonded to curved roofs, boat decks and vehicle canopies. Generates reliable 100W in full sun while weighing only 1.8 kg.', 'SOL-100W-004', 1, 0, 200, 1, 1, 20, 1, 10000, 89.99, 109.99, 53.99, 1.8, 1050, 540, 2, 4, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'SOL-100W-004', '100W Flexible Solar Panel', '100W Flexible Solar Panel', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'sol-100w-004', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Victron 100Ah LiFePO4 Battery', 'Deep-cycle lithium battery with built-in BMS.', 'This 100Ah LiFePO4 battery delivers over 2,500 cycles at 80% depth of discharge. The integrated Battery Management System protects against overcharge, under-voltage and thermal runaway.', 'BAT-LI-100AH-005', 1, 0, 60, 1, 1, 10, 1, 10000, 349.0, 399.0, 209.4, 12.5, 330, 172, 220, 1, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'BAT-LI-100AH-005', 'Victron 100Ah LiFePO4 Battery', 'Victron 100Ah LiFePO4 Battery', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'bat-li-100ah-005', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Victron 150Ah Gel Deep-Cycle Battery', 'Maintenance-free gel battery for backup power.', 'Designed for standby and cyclic applications, this 150Ah gel battery offers excellent performance in high temperatures. Completely sealed and safe for indoor installation.', 'BAT-GEL-150AH-006', 1, 0, 38, 1, 1, 6, 1, 10000, 275.0, 0, 165.0, 42.0, 483, 170, 240, 2, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'BAT-GEL-150AH-006', 'Victron 150Ah Gel Deep-Cycle Battery', 'Victron 150Ah Gel Deep-Cycle Battery', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'bat-gel-150ah-006', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, '5kW Modular Battery Rack', 'Stackable lithium modules for whole-home storage.', 'Start with 5 kWh and expand to 20 kWh by stacking up to four modules. Each module slides into a wall-mounted rack with integrated cooling fan and LCD status display.', 'BAT-RACK-5KW-007', 1, 0, 15, 1, 1, 3, 1, 10000, 1899.0, 2199.0, 1139.4, 58.0, 600, 180, 850, 3, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'BAT-RACK-5KW-007', '5kW Modular Battery Rack', '5kW Modular Battery Rack', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'bat-rack-5kw-007', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, '300Wh Portable Power Station', 'Compact power station with USB-C PD and AC outlet.', 'Take 300Wh of energy anywhere. Powers laptops, phones, LED lights and small fans. Recharges from solar, car socket or wall plug in under 4 hours.', 'BAT-PORT-300WH-008', 1, 0, 95, 1, 1, 12, 1, 10000, 129.99, 159.99, 77.99, 3.4, 210, 130, 180, 4, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'BAT-PORT-300WH-008', '300Wh Portable Power Station', '300Wh Portable Power Station', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'bat-port-300wh-008', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, '3kW Pure Sine Wave Inverter', 'Reliable inverter for home solar systems.', 'Converts 24V DC battery power to clean 230V AC output. Features overload protection, temperature-controlled fan and LCD remote monitoring panel. Safe for sensitive electronics.', 'INV-3KW-009', 1, 0, 55, 1, 1, 8, 1, 10000, 459.0, 529.0, 275.4, 8.9, 420, 220, 110, 1, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'INV-3KW-009', '3kW Pure Sine Wave Inverter', '3kW Pure Sine Wave Inverter', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'inv-3kw-009', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, '5kW Hybrid Solar Inverter', 'Grid-tie and off-grid hybrid inverter with MPPT.', 'This intelligent inverter blends solar, battery and grid power seamlessly. Two MPPT inputs maximise array output while the built-in Wi-Fi dongle sends real-time data to your phone.', 'INV-5KW-HYBRID-010', 1, 0, 28, 1, 1, 5, 1, 10000, 899.0, 0, 539.4, 14.2, 480, 360, 160, 2, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'INV-5KW-HYBRID-010', '5kW Hybrid Solar Inverter', '5kW Hybrid Solar Inverter', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'inv-5kw-hybrid-010', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, '60A MPPT Solar Charge Controller', 'Maximum Power Point Tracking for 12/24/48V systems.', 'Extract up to 30% more energy from your panels with this 60A MPPT controller. Large backlit LCD shows volts, amps and daily yield. RS-485 port enables remote monitoring.', 'INV-MPPT-60A-011', 1, 0, 72, 1, 1, 10, 1, 10000, 179.0, 209.0, 107.4, 1.5, 220, 150, 55, 3, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'INV-MPPT-60A-011', '60A MPPT Solar Charge Controller', '60A MPPT Solar Charge Controller', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'inv-mppt-60a-011', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Philips 12W Warm White LED Bulb', 'A60 bulb, 1055 lumens, 2700K, E27 base.', 'Replace your old 75W incandescent with this 12W LED and save up to 85% on lighting bills. Instant-on, flicker-free and rated for 15,000 hours of warm white comfort.', 'LED-BULB-12W-012', 1, 0, 500, 1, 1, 50, 1, 10000, 4.99, 6.49, 2.99, 0.08, 110, 60, 60, 1, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'LED-BULB-12W-012', 'Philips 12W Warm White LED Bulb', 'Philips 12W Warm White LED Bulb', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'led-bulb-12w-012', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, '5m RGB LED Strip Kit with Remote', 'Colour-changing strip with adhesive backing and IR remote.', 'Transform any room with 5 metres of vibrant RGB LEDs. Includes 44-key remote, power adapter and mounting clips. Cuttable every 3 LEDs for custom lengths.', 'LED-STRIP-5M-013', 1, 0, 180, 1, 1, 25, 1, 10000, 24.99, 29.99, 14.99, 0.35, 5000, 10, 2, 2, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'LED-STRIP-5M-013', '5m RGB LED Strip Kit with Remote', '5m RGB LED Strip Kit with Remote', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'led-strip-5m-013', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, '50W LED Floodlight with PIR Sensor', 'Daylight white floodlight with adjustable motion sensor.', 'Illuminate driveways, workshops and yards with this robust aluminium floodlight. The integrated PIR sensor detects movement up to 12 metres and switches the light on automatically.', 'LED-FLOOD-50W-014', 1, 0, 110, 1, 1, 15, 1, 10000, 34.5, 0, 20.7, 1.2, 185, 155, 45, 3, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'LED-FLOOD-50W-014', '50W LED Floodlight with PIR Sensor', '50W LED Floodlight with PIR Sensor', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'led-flood-50w-014', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, '9W Recessed LED Downlight', 'Slim-profile ceiling downlight, 90mm cut-out.', 'This slim recessed downlight fits into standard 90 mm ceiling holes. The die-cast aluminium body dissipates heat efficiently for a 25,000-hour lifespan. Dimmable driver included.', 'LED-DOWN-9W-015', 1, 0, 300, 1, 1, 40, 1, 10000, 7.99, 9.99, 4.79, 0.18, 90, 90, 35, 4, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'LED-DOWN-9W-015', '9W Recessed LED Downlight', '9W Recessed LED Downlight', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'led-down-9w-015', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'MC4 Solar Connector Pair', 'Male and female MC4 connectors for 4-6mm² cable.', 'These weatherproof MC4 connectors ensure reliable panel-to-panel and panel-to-controller connections. Rated IP67 and designed for field assembly without crimping tools.', 'CAB-MC4-PAIR-016', 1, 0, 800, 1, 1, 100, 1, 10000, 3.49, 0, 2.09, 0.04, 55, 22, 22, 1, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'CAB-MC4-PAIR-016', 'MC4 Solar Connector Pair', 'MC4 Solar Connector Pair', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'cab-mc4-pair-016', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, '25m Solar Cable 4mm² Twin Core', 'Double-insulated solar DC cable on a handy drum.', 'TUV-certified 4mm² twin-core cable with UV-resistant XLPE insulation. The compact drum makes it easy to pull exact lengths without tangles. Rated for 600V DC and 90°C operation.', 'CAB-TRUNK-25M-017', 1, 0, 65, 1, 1, 10, 1, 10000, 28.0, 34.0, 16.8, 3.8, 25000, 6, 6, 2, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'CAB-TRUNK-25M-017', '25m Solar Cable 4mm² Twin Core', '25m Solar Cable 4mm² Twin Core', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'cab-trunk-25m-017', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Weatherproof Junction Box IP65', 'Outdoor cable junction box with cable glands.', 'Protect your outdoor connections with this IP65-rated ABS enclosure. Includes four M20 cable glands, DIN rail mounting clips and a transparent lid for visual inspection.', 'CAB-CON-018', 1, 0, 140, 1, 1, 20, 1, 10000, 12.99, 15.99, 7.79, 0.45, 150, 110, 70, 3, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'CAB-CON-018', 'Weatherproof Junction Box IP65', 'Weatherproof Junction Box IP65', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'cab-con-018', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Wi-Fi Smart Plug with Energy Monitor', 'Control appliances from your phone and track consumption.', 'This compact smart plug works with Alexa and Google Assistant. Set timers, monitor real-time wattage and get alerts when devices are left on. No hub required.', 'SMART-PLUG-WIFI-019', 1, 0, 250, 1, 1, 30, 1, 10000, 14.99, 19.99, 8.99, 0.09, 65, 45, 35, 1, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'SMART-PLUG-WIFI-019', 'Wi-Fi Smart Plug with Energy Monitor', 'Wi-Fi Smart Plug with Energy Monitor', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'smart-plug-wifi-019', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Touch Glass Smart Light Switch', 'Tempered glass touch panel with dimmer and timer.', 'Replace any standard wall switch with this elegant tempered glass panel. Capacitive touch controls, built-in dimmer and programmable scenes via the free companion app. Fits standard 86 mm back boxes.', 'SMART-SWITCH-020', 1, 0, 175, 1, 1, 20, 1, 10000, 22.5, 0, 13.5, 0.15, 86, 86, 36, 2, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'SMART-SWITCH-020', 'Touch Glass Smart Light Switch', 'Touch Glass Smart Light Switch', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 1, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'smart-switch-020', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Hand-carved Mopane Bowl', 'Small serving bowl carved from sustainably sourced mopane wood.', 'Each bowl is hand-turned on a traditional lathe and finished with beeswax and linseed oil. The rich red-brown grain of mopane makes every piece unique. Food-safe and perfect for salads or trinkets.', 'WOOD-BOWL-001', 1, 0, 40, 1, 1, 5, 1, 10000, 18.0, 0, 10.8, 0.35, 180, 180, 70, 1, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'WOOD-BOWL-001', 'Hand-carved Mopane Bowl', 'Hand-carved Mopane Bowl', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'wood-bowl-001', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Set of 3 Olive Wood Spoons', 'Long-handled cooking spoons with smooth natural finish.', 'Crafted from fallen olive branches, these spoons are sanded silky-smooth and oiled to bring out the beautiful grain. The set includes a stirring spoon, slotted spoon and tasting spoon.', 'WOOD-SPOON-002', 1, 0, 65, 1, 1, 8, 1, 10000, 12.5, 15.0, 7.5, 0.18, 280, 55, 15, 2, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'WOOD-SPOON-002', 'Set of 3 Olive Wood Spoons', 'Set of 3 Olive Wood Spoons', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'wood-spoon-002', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Carved Wooden Warthog', 'Whimsical warthog sculpture carved from jacaranda wood.', 'Local carvers bring personality to every warthog with exaggerated tusks and a comical stance. Jacaranda wood is lightweight yet durable, making this an ideal shelf ornament or gift.', 'WOOD-ANIMAL-003', 1, 0, 30, 1, 1, 4, 1, 10000, 24.0, 0, 14.4, 0.42, 160, 70, 95, 3, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'WOOD-ANIMAL-003', 'Carved Wooden Warthog', 'Carved Wooden Warthog', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'wood-animal-003', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Interlocking Wooden Heart Puzzle', 'Two-piece interlocking heart carved from a single block.', 'A classic test of patience and love – two hearts carved from one solid piece of teak that slide together perfectly. Each set comes in a handmade drawstring pouch with a tag explaining the symbolism.', 'WOOD-HEART-004', 1, 0, 55, 1, 1, 7, 1, 10000, 9.0, 0, 5.4, 0.12, 90, 80, 25, 4, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'WOOD-HEART-004', 'Interlocking Wooden Heart Puzzle', 'Interlocking Wooden Heart Puzzle', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'wood-heart-004', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Live-edge Acacia Chopping Board', 'Thick chopping board with natural live edge and handle.', 'Cut, chop and serve on this stunning slab of acacia. The natural live edge is preserved and sealed, while the flat face is sanded smooth and finished with food-grade mineral oil. Includes a leather hanging strap.', 'WOOD-BOARD-005', 1, 0, 22, 1, 1, 3, 1, 10000, 32.0, 38.0, 19.2, 1.2, 380, 220, 25, 5, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'WOOD-BOARD-005', 'Live-edge Acacia Chopping Board', 'Live-edge Acacia Chopping Board', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'wood-board-005', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Zulu Beaded Necklace – Sunrise', 'Vibrant collar necklace in sunrise orange and gold.', 'Hand-strung by Zulu artisans using tiny Czech glass seed beads. The geometric sunrise pattern symbolises new beginnings. Finished with a traditional barrel clasp. Each necklace takes two days to complete.', 'BEAD-NECK-001', 1, 0, 18, 1, 1, 3, 1, 10000, 28.0, 0, 16.8, 0.08, 220, 180, 10, 1, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'BEAD-NECK-001', 'Zulu Beaded Necklace – Sunrise', 'Zulu Beaded Necklace – Sunrise', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'bead-neck-001', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Ndebele Pattern Bracelet', 'Wide cuff bracelet with bold black, white and red triangles.', 'Inspired by the traditional house-painting motifs of the Ndebele people, this bracelet is woven on a loom and backed with soft leather for comfort. The elastic cord ensures a snug fit on most wrists.', 'BEAD-BRAC-002', 1, 0, 35, 1, 1, 5, 1, 10000, 14.0, 0, 8.4, 0.05, 180, 45, 8, 2, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'BEAD-BRAC-002', 'Ndebele Pattern Bracelet', 'Ndebele Pattern Bracelet', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'bead-brac-002', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Maasai-inspired Bead Earrings', 'Long drop earrings with red, blue and green beads.', 'These lightweight drop earrings swing gently with every step. Handmade by a women''s cooperative, each pair supports fair wages and community education programmes in rural Zimbabwe.', 'BEAD-EARR-003', 1, 0, 48, 1, 1, 6, 1, 10000, 10.0, 0, 6.0, 0.02, 80, 15, 8, 3, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'BEAD-EARR-003', 'Maasai-inspired Bead Earrings', 'Maasai-inspired Bead Earrings', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'bead-earr-003', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Seed-bead Anklet with Cowrie Shells', 'Adjustable anklet with tiny cowrie shells and brass beads.', 'Cowrie shells have been used as currency and adornment across Africa for millennia. This delicate anklet combines them with gold-plated brass beads on a durable nylon cord with sliding knot.', 'BEAD-ANKL-004', 1, 0, 60, 1, 1, 8, 1, 10000, 8.5, 0, 5.1, 0.03, 250, 8, 5, 4, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'BEAD-ANKL-004', 'Seed-bead Anklet with Cowrie Shells', 'Seed-bead Anklet with Cowrie Shells', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'bead-ankl-004', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Wire-wrapped Bead Ring', 'Adjustable copper wire ring with glass bead centre.', 'Simple, elegant and affordable. The copper wire is hammered and shaped by hand, then wrapped around a colourful glass bead. The open-back design fits most finger sizes.', 'BEAD-RING-005', 1, 0, 80, 1, 1, 10, 1, 10000, 6.0, 0, 3.6, 0.015, 20, 20, 8, 5, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'BEAD-RING-005', 'Wire-wrapped Bead Ring', 'Wire-wrapped Bead Ring', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'bead-ring-005', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Large Ilala Palm Laundry Basket', 'Generous woven basket with fitted lid, natural and brown.', 'Woven from sustainably harvested ilala palm in the classic ''ukhamba'' shape. The fitted lid keeps laundry or toys neatly hidden. Sturdy enough to double as a side table when flipped over.', 'BASK-LARGE-001', 1, 0, 25, 1, 1, 4, 1, 10000, 35.0, 42.0, 21.0, 1.4, 400, 400, 500, 1, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'BASK-LARGE-001', 'Large Ilala Palm Laundry Basket', 'Large Ilala Palm Laundry Basket', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'bask-large-001', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Flat Woven Placemat Set of 4', 'Round grass placemats in earth tones.', 'These flat-weave placemats add warmth to any dining table. Each set includes four mats in complementary earth tones – ochre, sage, sand and rust. Woven from river grass and finished with a simple whipstitch edge.', 'BASK-FLAT-002', 1, 0, 32, 1, 1, 5, 1, 10000, 22.0, 0, 13.2, 0.4, 350, 350, 5, 2, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'BASK-FLAT-002', 'Flat Woven Placemat Set of 4', 'Flat Woven Placemat Set of 4', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'bask-flat-002', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Oval Serving Tray with Handles', 'Sturdy woven tray for bread, fruit or display.', 'This oval tray is woven around a wire frame for extra rigidity. The wrapped handles make it easy to carry from kitchen to table. Finished with a light coat of clear varnish for wipe-clean care.', 'BASK-TRAY-003', 1, 0, 28, 1, 1, 4, 1, 10000, 16.0, 0, 9.6, 0.55, 380, 260, 60, 3, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'BASK-TRAY-003', 'Oval Serving Tray with Handles', 'Oval Serving Tray with Handles', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'bask-tray-003', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Clutch Purse Woven from Phone Wire', 'Colourful geometric phone-wire clutch with zip closure.', 'A modern twist on a traditional craft – telephone wire is coiled and woven into vibrant geometric patterns. The clutch is fully lined with cotton and closes with a sturdy YKK zip.', 'BASK-CLUTCH-004', 1, 0, 38, 1, 1, 5, 1, 10000, 19.0, 0, 11.4, 0.2, 250, 150, 30, 4, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'BASK-CLUTCH-004', 'Clutch Purse Woven from Phone Wire', 'Clutch Purse Woven from Phone Wire', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'bask-clutch-004', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Miniature Woven Animal Set', 'Set of 3 tiny woven animals – elephant, giraffe and hippo.', 'These adorable miniature animals are woven from dyed palm fibre around a wire armature. Each set is slightly different, reflecting the individual style of the weaver. Popular with children and collectors alike.', 'BASK-TOY-005', 1, 0, 50, 1, 1, 7, 1, 10000, 8.0, 0, 4.8, 0.06, 80, 40, 60, 5, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'BASK-TOY-005', 'Miniature Woven Animal Set', 'Miniature Woven Animal Set', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'bask-toy-005', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Hand-stitched Leather Wallet', 'Bifold wallet with coin pocket and 6 card slots.', 'Cut from full-grain cowhide and hand-stitched with waxed nylon thread. The interior is lined with traditional Shweshwe cotton fabric. Ages beautifully, developing a rich patina over time.', 'LEATH-WALL-001', 1, 0, 45, 1, 1, 6, 1, 10000, 22.0, 0, 13.2, 0.09, 110, 90, 20, 1, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'LEATH-WALL-001', 'Hand-stitched Leather Wallet', 'Hand-stitched Leather Wallet', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'leath-wall-001', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Brass-buckle Leather Belt', '3.5cm wide belt in rich tan leather.', 'A classic belt that gets better with age. The solid brass buckle is cast locally and the leather is vegetable-tanned for durability. Available in waist sizes 80 cm to 110 cm.', 'LEATH-BELT-002', 1, 0, 30, 1, 1, 4, 1, 10000, 18.0, 0, 10.8, 0.25, 1100, 35, 4, 2, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'LEATH-BELT-002', 'Brass-buckle Leather Belt', 'Brass-buckle Leather Belt', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'leath-belt-002', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Leather Tote Bag with Beaded Strap', 'Generous tote with hand-beaded shoulder strap.', 'This unstructured tote is soft yet strong. The main body is hand-cut leather and the shoulder strap is woven with glass beads in a subtle stripe pattern. Unlined, with an interior key loop.', 'LEATH-TOTE-003', 1, 0, 20, 1, 1, 3, 1, 10000, 45.0, 55.0, 27.0, 0.55, 380, 100, 320, 3, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'LEATH-TOTE-003', 'Leather Tote Bag with Beaded Strap', 'Leather Tote Bag with Beaded Strap', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'leath-tote-003', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Leather Sandals with Carved Sole', 'Flat sandals with hand-carved rubber sole.', 'The leather straps are cut, dyed and riveted by hand. The rubber sole is carved with a traditional geometric pattern for grip and style. Sizes 36 to 44 available. Made to order in 3 days.', 'LEATH-SAND-004', 1, 0, 15, 1, 1, 2, 1, 10000, 28.0, 0, 16.8, 0.4, 260, 100, 30, 4, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'LEATH-SAND-004', 'Leather Sandals with Carved Sole', 'Leather Sandals with Carved Sole', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'leath-sand-004', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Leather Cuff Bracelet with Brass Studs', 'Wide leather cuff with hand-set brass studs.', 'A bold statement piece cut from thick buffalo leather. The brass studs are hammered in by hand and the edges are burnished to a smooth finish. Snap closure. One size fits most wrists.', 'LEATH-BRAC-005', 1, 0, 40, 1, 1, 5, 1, 10000, 14.0, 0, 8.4, 0.06, 220, 45, 5, 5, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'LEATH-BRAC-005', 'Leather Cuff Bracelet with Brass Studs', 'Leather Cuff Bracelet with Brass Studs', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'leath-brac-005', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Soapstone Elephant Family', 'Three elephants carved from a single soapstone block.', 'Master carver Tendai sculpts these gentle giants from soft grey-green soapstone quarried near Mutoko. The family grouping – mother, father and calf – fits in the palm of your hand.', 'STONE-ELE-001', 1, 0, 18, 1, 1, 3, 1, 10000, 30.0, 0, 18.0, 0.8, 150, 80, 100, 1, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'STONE-ELE-001', 'Soapstone Elephant Family', 'Soapstone Elephant Family', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'stone-ele-001', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Serpentine Fish Eagle', 'Perched fish eagle carved from dark green serpentine.', 'The African fish eagle is Zambia''s national bird. This sculpture captures the moment before flight – wings half-spread, talons gripping a carved stump. Polished to a soft sheen with beeswax.', 'STONE-BIRD-002', 1, 0, 22, 1, 1, 3, 1, 10000, 22.0, 0, 13.2, 0.55, 120, 90, 140, 2, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'STONE-BIRD-002', 'Serpentine Fish Eagle', 'Serpentine Fish Eagle', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'stone-bird-002', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Polished Soapstone Bowl', 'Small bowl with abstract carved exterior.', 'The exterior is carved with flowing abstract lines inspired by river currents. The interior is sanded smooth and polished with natural oil. Perfect for jewellery, keys or potpourri.', 'STONE-BOWL-003', 1, 0, 28, 1, 1, 4, 1, 10000, 16.0, 0, 9.6, 0.45, 120, 120, 55, 3, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'STONE-BOWL-003', 'Polished Soapstone Bowl', 'Polished Soapstone Bowl', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'stone-bowl-003', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Abstract Stone Face Sculpture', 'Minimalist face carved from cream dolomite.', 'In the Shona tradition, the head represents wisdom and the source of life. This modern abstract interpretation is carved from creamy white dolomite with just enough detail to suggest a gaze. A contemplative desk piece.', 'STONE-FACE-004', 1, 0, 12, 1, 1, 2, 1, 10000, 35.0, 42.0, 21.0, 1.1, 90, 70, 180, 4, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'STONE-FACE-004', 'Abstract Stone Face Sculpture', 'Abstract Stone Face Sculpture', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'stone-face-004', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Stone Bookends – Rhino Pair', 'Matching rhino bookends carved from dark soapstone.', 'These solid bookends keep your shelves tidy while celebrating African wildlife. Each rhino is hand-carved from a single block of dark soapstone and polished to a satin finish. Felt pads protect your surfaces.', 'STONE-BOOK-005', 1, 0, 16, 1, 1, 2, 1, 10000, 38.0, 0, 22.8, 1.6, 140, 80, 130, 5, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'STONE-BOOK-005', 'Stone Bookends – Rhino Pair', 'Stone Bookends – Rhino Pair', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'stone-book-005', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Hand-painted Cotton Wall Hanging', 'Large cotton panel with baobab tree scene.', 'Painted with natural ochre, charcoal and plant dyes on heavy unbleached cotton. The baobab tree is a symbol of endurance and community. Wooden dowel and twine included for easy hanging.', 'FABRIC-WALL-001', 1, 0, 20, 1, 1, 3, 1, 10000, 26.0, 0, 15.6, 0.45, 900, 600, 5, 1, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'FABRIC-WALL-001', 'Hand-painted Cotton Wall Hanging', 'Hand-painted Cotton Wall Hanging', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'fabric-wall-001', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Batik Table Runner – Geometric', '2-metre batik runner in indigo and cream.', 'Traditional batik wax-resist dyeing creates the crisp geometric pattern. The cotton is pre-washed for a soft drape. Machine washable on gentle cycle. Dimensions: 200 x 35 cm.', 'FABRIC-RUN-002', 1, 0, 30, 1, 1, 4, 1, 10000, 18.0, 0, 10.8, 0.2, 2000, 350, 2, 2, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'FABRIC-RUN-002', 'Batik Table Runner – Geometric', 'Batik Table Runner – Geometric', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'fabric-run-002', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Hand-painted Silk Scarf', 'Lightweight silk scarf with wildflower design.', 'Each scarf is hand-painted on Habotai silk using reactive dyes that bond permanently with the fibres. The wildflower design is unique – no two scarves are exactly alike. Finished with hand-rolled hem.', 'FABRIC-SCARF-003', 1, 0, 24, 1, 1, 3, 1, 10000, 32.0, 38.0, 19.2, 0.04, 1600, 400, 1, 3, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'FABRIC-SCARF-003', 'Hand-painted Silk Scarf', 'Hand-painted Silk Scarf', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'fabric-scarf-003', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Shweshwe Print Cushion Cover', '45cm cushion cover in traditional indigo Shweshwe.', 'Shweshwe is the iconic printed cotton fabric of Southern Africa. This cushion cover features the classic small geometric motifs in deep indigo on white. Concealed zip closure. Fits standard 45 cm inserts.', 'FABRIC-CUSH-004', 1, 0, 40, 1, 1, 5, 1, 10000, 14.0, 0, 8.4, 0.12, 450, 450, 2, 4, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'FABRIC-CUSH-004', 'Shweshwe Print Cushion Cover', 'Shweshwe Print Cushion Cover', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'fabric-cush-004', @StartProductId, 1, 0);

SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);
SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (Id, ProductTypeId, ParentGroupedProductId, VisibleIndividually, ProductTemplateId, VendorId, Name, ShortDescription, FullDescription, Sku, ShowOnHomepage, LimitedToStores, StockQuantity, DisplayStockAvailability, DisplayStockQuantity, MinStockQuantity, OrderMinimumQuantity, OrderMaximumQuantity, Price, OldPrice, ProductCost, Weight, Length, Width, Height, DisplayOrder, Published, Deleted, CreatedOnUtc, UpdatedOnUtc, AgeVerification, MinimumAgeToPurchase, AllowCustomerReviews, IsShipEnabled, ManageInventoryMethodId) VALUES (@StartProductId, 5, 0, 1, 1, 0, 'Hand-painted Kitchen Apron', 'Heavy cotton apron with adjustable neck strap.', 'Protect your clothes in style. This apron is hand-painted with a playful chilli-pepper border design on heavy unbleached cotton. Adjustable D-ring neck strap and long waist ties fit most body sizes.', 'FABRIC-APR-005', 1, 0, 35, 1, 1, 5, 1, 10000, 20.0, 0, 12.0, 0.25, 700, 600, 2, 5, 1, 0, @Now, @Now, 0, 0, 1, 1, 1);
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', 'FABRIC-APR-005', 'Hand-painted Kitchen Apron', 'Hand-painted Kitchen Apron', 1, '');
SET IDENTITY_INSERT Picture OFF;
INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);
INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartCatId, 0, 0);
INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, @StartMfrId, 0, 0);
INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', 2, @StartProductId);
SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);
INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', 'fabric-apr-005', @StartProductId, 1, 0);

COMMIT TRANSACTION;
PRINT 'SEED COMPLETE — restart nopCommerce to clear caches.';
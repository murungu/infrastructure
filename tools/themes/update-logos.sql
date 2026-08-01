SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

-- ================================================================
-- Insert new logo images into Picture/PictureBinary
-- and update store logo picture IDs
-- ================================================================

DECLARE @NextPictureId INT = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);

-- Store 1 Logo (Arty Electra)
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath)
VALUES (@NextPictureId, 'image/jpeg', 'arty-electra-logo', 'Arty Electra', 'Arty Electra', 0, '');
SET IDENTITY_INSERT Picture OFF;

-- Store 2 Logo (Victoria Falls)
SET IDENTITY_INSERT Picture ON;
INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath)
VALUES (@NextPictureId + 1, 'image/jpeg', 'victoria-falls-logo', 'Victoria Falls Artisan Market', 'Victoria Falls Artisan Market', 0, '');
SET IDENTITY_INSERT Picture OFF;

-- Update logo picture IDs in settings (global setting for Store 1, per-store for Store 2)
UPDATE Setting SET Value = CAST(@NextPictureId AS NVARCHAR(20)) WHERE Name = 'storeinformationsettings.logopictureid' AND StoreId = 0;

IF NOT EXISTS (SELECT 1 FROM Setting WHERE Name = 'storeinformationsettings.logopictureid' AND StoreId = 2)
    INSERT INTO Setting (Name, Value, StoreId) VALUES ('storeinformationsettings.logopictureid', CAST(@NextPictureId + 1 AS NVARCHAR(20)), 2);
ELSE
    UPDATE Setting SET Value = CAST(@NextPictureId + 1 AS NVARCHAR(20)) WHERE Name = 'storeinformationsettings.logopictureid' AND StoreId = 2;

COMMIT TRANSACTION;

-- Verify
SELECT Id, SeoFilename, AltAttribute FROM Picture WHERE Id >= @NextPictureId ORDER BY Id;
SELECT Name, Value, StoreId FROM Setting WHERE Name = 'storeinformationsettings.logopictureid';

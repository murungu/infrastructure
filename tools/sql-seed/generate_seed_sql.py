#!/usr/bin/env python3
"""Generate a complete nopCommerce multi-store seed SQL script from catalog.json."""

import json
from pathlib import Path


def quote(s):
    return "'" + str(s).replace("'", "''") + "'"


def main():
    catalog = json.loads(Path("../python-data-generator/catalog.json").read_text())
    out = []
    emit = out.append

    emit("SET NOCOUNT ON;")
    emit("SET XACT_ABORT ON;")
    emit("BEGIN TRANSACTION;")
    emit("")

    # Safe starting IDs
    emit("DECLARE @Now DATETIME2 = GETUTCDATE();")
    emit("DECLARE @StartProductId INT = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);")
    emit("DECLARE @StartPictureId INT = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);")
    emit("DECLARE @StartCatId INT = (SELECT ISNULL(MAX(Id),0)+1 FROM Category);")
    emit("DECLARE @StartMfrId INT = (SELECT ISNULL(MAX(Id),0)+1 FROM Manufacturer);")
    emit("DECLARE @StartUrlId INT = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);")
    emit("")

    # Store 2
    store2 = next(s for s in catalog["stores"] if s["id"] == 2)
    emit("IF NOT EXISTS (SELECT 1 FROM Store WHERE Id=2)")
    emit("BEGIN")
    emit("SET IDENTITY_INSERT Store ON;")
    emit(
        "INSERT INTO Store (Id,Name,Url,Hosts,CompanyName,CompanyAddress,CompanyPhoneNumber,SslEnabled,DefaultLanguageId,DisplayOrder,Deleted)"
    )
    emit(
        f"VALUES (2,{quote(store2['name'])},{quote(store2['url'])},{quote(store2['hosts'])},{quote(store2['name'] + ' Ltd')},'Local dev address','(000) 000-0000',0,0,2,0);"
    )
    emit("SET IDENTITY_INSERT Store OFF;")
    emit("END")
    emit("")

    cat_ids = {}
    mfr_ids = {}

    # Categories
    for c in catalog["categories"]:
        cid = c["id"]
        emit("SET @StartCatId = (SELECT ISNULL(MAX(Id),0)+1 FROM Category);")
        emit("SET IDENTITY_INSERT Category ON;")
        emit(
            "INSERT INTO Category (Id,Name,Description,CategoryTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,ParentCategoryId,PictureId,PageSize,AllowCustomersToSelectPageSize,ShowOnHomepage,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange,RestrictFromVendors)"
        )
        emit(
            f"VALUES (@StartCatId,{quote(c['name'])},{quote(c.get('description', ''))},1,'','',',',0,0,12,0,1,0,1,1,0,{c['id']},@Now,@Now,0,0,0,0,0);"
        )
        emit("SET IDENTITY_INSERT Category OFF;")
        cat_ids[cid] = "@StartCatId"
        for sid in c.get("storeIds", []):
            emit(
                f"INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Category',{sid},@StartCatId);"
            )
        # Category URL record
        cat_slug = c["name"].lower().replace(" ", "-").replace("&", "and")
        emit("SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);")
        emit(
            f"INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Category', {quote(cat_slug)}, @StartCatId, 1, 0);"
        )
        emit("")

    # Manufacturers
    for m in catalog["manufacturers"]:
        mid = m["id"]
        emit("SET @StartMfrId = (SELECT ISNULL(MAX(Id),0)+1 FROM Manufacturer);")
        emit("SET IDENTITY_INSERT Manufacturer ON;")
        emit(
            "INSERT INTO Manufacturer (Id,Name,Description,ManufacturerTemplateId,MetaKeywords,MetaTitle,PageSizeOptions,PictureId,PageSize,AllowCustomersToSelectPageSize,SubjectToAcl,LimitedToStores,Published,Deleted,DisplayOrder,CreatedOnUtc,UpdatedOnUtc,PriceRangeFiltering,PriceFrom,PriceTo,ManuallyPriceRange)"
        )
        emit(
            f"VALUES (@StartMfrId,{quote(m['name'])},{quote(m.get('description', ''))},1,'','',',',0,12,0,0,1,1,0,{m['id']},@Now,@Now,0,0,0,0);"
        )
        emit("SET IDENTITY_INSERT Manufacturer OFF;")
        mfr_ids[mid] = "@StartMfrId"
        for sid in m.get("storeIds", []):
            emit(
                f"INSERT INTO StoreMapping (EntityName,StoreId,EntityId) VALUES ('Manufacturer',{sid},@StartMfrId);"
            )
        # Manufacturer URL record
        mfr_slug = m["name"].lower().replace(" ", "-").replace("&", "and")
        emit("SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);")
        emit(
            f"INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Manufacturer', {quote(mfr_slug)}, @StartMfrId, 1, 0);"
        )
        emit("")

    # Products
    for p in catalog["products"]:
        emit("SET @StartProductId = (SELECT ISNULL(MAX(Id),0)+1 FROM Product);")
        emit("SET @StartPictureId = (SELECT ISNULL(MAX(Id),0)+1 FROM Picture);")
        emit("SET IDENTITY_INSERT Product ON;")

        # Build a compact Product INSERT with only non-default columns
        cols = []
        vals = []

        def add(col, val):
            cols.append(col)
            vals.append(val)

        add("Id", "@StartProductId")
        add("ProductTypeId", "5")
        add("ParentGroupedProductId", "0")
        add("VisibleIndividually", "1")
        add("ProductTemplateId", "1")  # Required: 1 = Simple product template
        add("VendorId", "0")
        add("Name", quote(p["name"]))
        add("ShortDescription", quote(p.get("shortDescription", "")))
        add("FullDescription", quote(p.get("fullDescription", "")))
        add("Sku", quote(p["sku"]))
        add("ShowOnHomepage", "1")
        add("LimitedToStores", "0")  # Avoids StoreMapping auth issues on homepage
        add("StockQuantity", str(p.get("stockQuantity", 100)))
        add("DisplayStockAvailability", "1")
        add("DisplayStockQuantity", "1")
        add("MinStockQuantity", str(p.get("minStockQuantity", 10)))
        add("OrderMinimumQuantity", "1")
        add("OrderMaximumQuantity", "10000")
        add("Price", str(p["price"]))
        add("OldPrice", str(p.get("oldPrice", 0) or 0))
        add("ProductCost", str(round(p["price"] * 0.6, 2)))
        add("Weight", str(p.get("weight", 1)))
        add("Length", str(p.get("length", 100)))
        add("Width", str(p.get("width", 100)))
        add("Height", str(p.get("height", 50)))
        add("DisplayOrder", str(p.get("displayOrder", 1)))
        add("Published", "1")
        add("Deleted", "0")
        add("CreatedOnUtc", "@Now")
        add("UpdatedOnUtc", "@Now")
        add("AgeVerification", "0")
        add("MinimumAgeToPurchase", "0")
        add("AllowCustomerReviews", "1")
        add("IsShipEnabled", "1")
        add("ManageInventoryMethodId", "1")

        col_sql = ", ".join(cols)
        val_sql = ", ".join(vals)
        emit(f"INSERT INTO Product ({col_sql}) VALUES ({val_sql});")
        emit("SET IDENTITY_INSERT Product OFF;")

        # Picture
        emit("SET IDENTITY_INSERT Picture ON;")
        safe_seo = p["sku"].replace(" ", "-").replace("/", "-")
        emit(
            f"INSERT INTO Picture (Id, MimeType, SeoFilename, AltAttribute, TitleAttribute, IsNew, VirtualPath) VALUES (@StartPictureId, 'image/jpeg', {quote(safe_seo)}, {quote(p['name'])}, {quote(p['name'])}, 1, '');"
        )
        emit("SET IDENTITY_INSERT Picture OFF;")

        # Product_Picture_Mapping
        emit(
            "INSERT INTO Product_Picture_Mapping (ProductId, PictureId, DisplayOrder) VALUES (@StartProductId, @StartPictureId, 0);"
        )

        # Product_Category_Mapping
        for cid in p.get("categoryIds", []):
            emit(
                f"INSERT INTO Product_Category_Mapping (ProductId, CategoryId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, {cat_ids[cid]}, 0, 0);"
            )

        # Product_Manufacturer_Mapping
        if p.get("manufacturerId"):
            emit(
                f"INSERT INTO Product_Manufacturer_Mapping (ProductId, ManufacturerId, IsFeaturedProduct, DisplayOrder) VALUES (@StartProductId, {mfr_ids[p['manufacturerId']]}, 0, 0);"
            )

        # StoreMapping for product
        for sid in p.get("storeIds", []):
            emit(
                f"INSERT INTO StoreMapping (EntityName, StoreId, EntityId) VALUES ('Product', {sid}, @StartProductId);"
            )

        # UrlRecord
        slug = p["sku"].lower().replace(" ", "-").replace("_", "-")
        emit("SET @StartUrlId = (SELECT ISNULL(MAX(Id),0)+1 FROM UrlRecord);")
        emit(
            f"INSERT INTO UrlRecord (Id, EntityName, Slug, EntityId, IsActive, LanguageId) VALUES (@StartUrlId, 'Product', {quote(slug)}, @StartProductId, 1, 0);"
        )
        emit("")

    emit("COMMIT TRANSACTION;")
    emit("PRINT 'SEED COMPLETE — restart nopCommerce to clear caches.';")

    out_path = Path("seed-multistore-generated.sql")
    out_path.write_text("\n".join(out))
    print(f"Generated: {out_path.absolute()}")
    print(f"  Lines: {len(out)}")
    print(f"  Products: {len(catalog['products'])}")
    print("Run with:")
    print(
        f'  docker exec -i db-infra-sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "DevPassword123!" -d nopcommerce -C < {out_path.name}'
    )


if __name__ == "__main__":
    main()

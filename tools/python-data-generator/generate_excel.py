#!/usr/bin/env python3
"""
generate_excel.py
=================
Builds a nopCommerce-ready Excel import file from catalog.json.
Uses external image URLs so nopCommerce downloads them during import.

Before importing:
  1. Host the generated images on a temporary local HTTP server or public URL
  2. In nopCommerce Admin, enable:
     Configuration → Settings → Catalog settings →
     "Export/import products. Allow download images"

Usage:
  python generate_excel.py --catalog catalog.json --image-base-url http://localhost:8000 --out nop-import.xlsx
"""

import argparse
import json
import sys
from pathlib import Path

try:
    import openpyxl
    from openpyxl.styles import Font  # noqa: F401
except ImportError as exc:
    raise ImportError("openpyxl is required. Install: pip install openpyxl") from exc


# nopCommerce Excel column headers (exact order from export template)
HEADERS = [
    "ProductTypeId",
    "ParentGroupedProductId",
    "VisibleIndividually",
    "Name",
    "ShortDescription",
    "FullDescription",
    "VendorId",
    "ProductTemplateId",
    "ShowOnHomepage",
    "AllowCustomerReviews",
    "ApprovedRatingSum",
    "NotApprovedRatingSum",
    "ApprovedTotalReviews",
    "NotApprovedTotalReviews",
    "SubjectToAcl",
    "LimitedToStores",
    "SKU",
    "ManufacturerPartNumber",
    "Gtin",
    "IsGiftCard",
    "GiftCardTypeId",
    "OverriddenGiftCardAmount",
    "RequireOtherProducts",
    "AutomaticallyAddRequiredProducts",
    "IsDownload",
    "UnlimitedDownloads",
    "MaxNumberOfDownloads",
    "DownloadExpirationDays",
    "DownloadActivationTypeId",
    "HasSampleDownload",
    "SampleDownloadId",
    "HasUserAgreement",
    "UserAgreementText",
    "IsRecurring",
    "RecurringCycleLength",
    "RecurringCyclePeriodId",
    "RecurringTotalCycles",
    "IsRental",
    "RentalPriceLength",
    "RentalPricePeriodId",
    "IsShipEnabled",
    "IsFreeShipping",
    "ShipSeparately",
    "AdditionalShippingCharge",
    "DeliveryDateId",
    "IsTaxExempt",
    "TaxCategoryId",
    "ManageInventoryMethodId",
    "ProductAvailabilityRangeId",
    "UseMultipleWarehouses",
    "WarehouseId",
    "StockQuantity",
    "DisplayStockAvailability",
    "DisplayStockQuantity",
    "MinStockQuantity",
    "LowStockActivityId",
    "NotifyAdminForQuantityBelow",
    "BackorderModeId",
    "AllowBackInStockSubscriptions",
    "OrderMinimumQuantity",
    "OrderMaximumQuantity",
    "AllowedQuantities",
    "AllowAddingOnlyExistingAttributeCombinations",
    "DisplayAttributeCombinationImagesOnly",
    "NotReturnable",
    "DisableBuyButton",
    "DisableWishlistButton",
    "AvailableForPreOrder",
    "PreOrderAvailabilityStartDateTimeUtc",
    "CallForPrice",
    "Price",
    "OldPrice",
    "ProductCost",
    "CustomerEntersPrice",
    "MinimumCustomerEnteredPrice",
    "MaximumCustomerEnteredPrice",
    "BasepriceEnabled",
    "BasepriceAmount",
    "BasepriceUnitId",
    "BasepriceBaseAmount",
    "BasepriceBaseUnitId",
    "MarkAsNew",
    "MarkAsNewStartDateTimeUtc",
    "MarkAsNewEndDateTimeUtc",
    "Weight",
    "Length",
    "Width",
    "Height",
    "AvailableStartDateTimeUtc",
    "AvailableEndDateTimeUtc",
    "DisplayOrder",
    "Published",
    "Deleted",
    "CreatedOnUtc",
    "UpdatedOnUtc",
    "Categories",
    "Manufacturers",
    "ProductTags",
    "PictureUrl",
    "SeName",
]


def build_row(
    product: dict, category_name: str, manufacturer_name: str, image_base_url: str
) -> list:
    """Map a product dict to the nopCommerce Excel column order."""
    safe_name = product["sku"].replace(" ", "_").replace("/", "-")
    image_url = f"{image_base_url.rstrip('/')}/{safe_name}.jpg"

    row = [""] * len(HEADERS)

    def set_val(col_name, value):
        if col_name in HEADERS:
            row[HEADERS.index(col_name)] = value

    set_val("ProductTypeId", 5)  # SimpleProduct
    set_val("ParentGroupedProductId", 0)
    set_val("VisibleIndividually", True)
    set_val("Name", product["name"])
    set_val("ShortDescription", product.get("shortDescription", ""))
    set_val("FullDescription", product.get("fullDescription", ""))
    set_val("VendorId", 0)
    set_val("ProductTemplateId", 0)
    set_val("ShowOnHomepage", False)
    set_val("AllowCustomerReviews", True)
    set_val("ApprovedRatingSum", 0)
    set_val("NotApprovedRatingSum", 0)
    set_val("ApprovedTotalReviews", 0)
    set_val("NotApprovedTotalReviews", 0)
    set_val("SubjectToAcl", False)
    set_val("LimitedToStores", True)
    set_val("SKU", product["sku"])
    set_val("ManufacturerPartNumber", "")
    set_val("Gtin", "")
    set_val("IsGiftCard", False)
    set_val("GiftCardTypeId", 0)
    set_val("OverriddenGiftCardAmount", "")
    set_val("RequireOtherProducts", False)
    set_val("AutomaticallyAddRequiredProducts", False)
    set_val("IsDownload", False)
    set_val("UnlimitedDownloads", True)
    set_val("MaxNumberOfDownloads", 0)
    set_val("DownloadExpirationDays", "")
    set_val("DownloadActivationTypeId", 0)
    set_val("HasSampleDownload", False)
    set_val("SampleDownloadId", 0)
    set_val("HasUserAgreement", False)
    set_val("UserAgreementText", "")
    set_val("IsRecurring", False)
    set_val("RecurringCycleLength", 0)
    set_val("RecurringCyclePeriodId", 0)
    set_val("RecurringTotalCycles", 0)
    set_val("IsRental", False)
    set_val("RentalPriceLength", 0)
    set_val("RentalPricePeriodId", 0)
    set_val("IsShipEnabled", True)
    set_val("IsFreeShipping", False)
    set_val("ShipSeparately", False)
    set_val("AdditionalShippingCharge", 0)
    set_val("DeliveryDateId", 0)
    set_val("IsTaxExempt", False)
    set_val("TaxCategoryId", 0)
    set_val("ManageInventoryMethodId", 1)  # ManageStock
    set_val("ProductAvailabilityRangeId", 0)
    set_val("UseMultipleWarehouses", False)
    set_val("WarehouseId", 0)
    set_val("StockQuantity", product.get("stockQuantity", 100))
    set_val("DisplayStockAvailability", True)
    set_val("DisplayStockQuantity", True)
    set_val("MinStockQuantity", product.get("minStockQuantity", 10))
    set_val("LowStockActivityId", 0)
    set_val("NotifyAdminForQuantityBelow", 1)
    set_val("BackorderModeId", 0)
    set_val("AllowBackInStockSubscriptions", False)
    set_val("OrderMinimumQuantity", 1)
    set_val("OrderMaximumQuantity", 10000)
    set_val("AllowedQuantities", "")
    set_val("AllowAddingOnlyExistingAttributeCombinations", False)
    set_val("DisplayAttributeCombinationImagesOnly", False)
    set_val("NotReturnable", False)
    set_val("DisableBuyButton", False)
    set_val("DisableWishlistButton", False)
    set_val("AvailableForPreOrder", False)
    set_val("PreOrderAvailabilityStartDateTimeUtc", "")
    set_val("CallForPrice", False)
    set_val("Price", product["price"])
    set_val("OldPrice", product.get("oldPrice", 0) or 0)
    set_val("ProductCost", round(product["price"] * 0.6, 2))
    set_val("CustomerEntersPrice", False)
    set_val("MinimumCustomerEnteredPrice", 0)
    set_val("MaximumCustomerEnteredPrice", 0)
    set_val("BasepriceEnabled", False)
    set_val("BasepriceAmount", 0)
    set_val("BasepriceUnitId", 0)
    set_val("BasepriceBaseAmount", 0)
    set_val("BasepriceBaseUnitId", 0)
    set_val("MarkAsNew", False)
    set_val("MarkAsNewStartDateTimeUtc", "")
    set_val("MarkAsNewEndDateTimeUtc", "")
    set_val("Weight", product.get("weight", 1))
    set_val("Length", product.get("length", 100))
    set_val("Width", product.get("width", 100))
    set_val("Height", product.get("height", 50))
    set_val("AvailableStartDateTimeUtc", "")
    set_val("AvailableEndDateTimeUtc", "")
    set_val("DisplayOrder", product.get("displayOrder", 1))
    set_val("Published", True)
    set_val("Deleted", False)
    set_val("CreatedOnUtc", "2026-07-01T00:00:00Z")
    set_val("UpdatedOnUtc", "2026-07-01T00:00:00Z")
    set_val("Categories", category_name)
    set_val("Manufacturers", manufacturer_name)
    set_val("ProductTags", "")
    set_val("PictureUrl", image_url)
    set_val("SeName", product["sku"].lower().replace(" ", "-").replace("_", "-"))

    return row


def main():
    parser = argparse.ArgumentParser(
        description="Generate nopCommerce Excel import file"
    )
    parser.add_argument(
        "--catalog", default="catalog.json", help="Path to catalog JSON"
    )
    parser.add_argument(
        "--image-base-url",
        default="http://localhost:8000",
        help="Base URL where images will be hosted",
    )
    parser.add_argument(
        "--out", default="../output-images/nop-import.xlsx", help="Output Excel path"
    )
    args = parser.parse_args()

    catalog_path = Path(args.catalog)
    if not catalog_path.exists():
        print(f"Catalog not found: {catalog_path}")
        sys.exit(1)

    try:
        with open(catalog_path, "r", encoding="utf-8") as f:
            catalog = json.load(f)
    except (OSError, json.JSONDecodeError) as exc:
        print(f"Failed to load catalog: {exc}")
        sys.exit(1)

    # Build lookup maps
    cat_map = {c["id"]: c["name"] for c in catalog.get("categories", [])}
    mfr_map = {m["id"]: m["name"] for m in catalog.get("manufacturers", [])}

    wb = openpyxl.Workbook()
    ws = wb.active
    if ws is None:
        ws = wb.create_sheet(title="Products")
    else:
        ws.title = "Products"
    ws.append(HEADERS)

    for product in catalog.get("products", []):
        cat_names = ";".join(
            cat_map.get(cid, "") for cid in product.get("categoryIds", [])
        )
        mfr_name = mfr_map.get(product.get("manufacturerId"), "")
        row = build_row(product, cat_names, mfr_name, args.image_base_url)
        ws.append(row)

    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    wb.save(out_path)
    print(f"Excel import file written: {out_path.absolute()}")
    print(f"  Rows: {len(catalog.get('products', []))}")
    print(f"  Image base URL: {args.image_base_url}")
    print("\nNext steps:")
    print(
        "  1. Host images at the base URL above (e.g. python -m http.server 8000 -d ../output-images)"
    )
    print(
        "  2. In nopCommerce Admin, enable 'Export/import products. Allow download images'"
    )
    print("  3. Go to Catalog → Products → Import and select this Excel file")


if __name__ == "__main__":
    main()

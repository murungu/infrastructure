# Python Data Generator

Isolated from `nopcommerce-src/`. Generates the master catalog and product images.

## Files

| File | Purpose |
|---|---|
| `catalog.json` | Master catalog with 50 products across 2 stores, 12 categories, 7 manufacturers |
| `generate_images.py` | Generate images via Gemini API, local FLUX, or placeholder download |
| `generate_images_fast.py` | **Recommended** — generates real-looking placeholders via picsum.photos (no API keys) |
| `generate_excel.py` | Build a nopCommerce-ready Excel import file with external image URLs |
| `requirements.txt` | Python dependencies |

## Quick Start (No API keys)

```bash
cd tools/python-data-generator
python -m venv .venv
source .venv/bin/activate
pip install openpyxl pillow requests

# Generate placeholder images (fast, real-looking)
python generate_images_fast.py --out ../output-images

# Optional: generate Excel import file
python generate_excel.py --image-base-url http://localhost:8000 --out ../output-images/nop-import.xlsx
```

## Image Generation Options

### Option A – picsum.photos (Recommended, zero setup)

```bash
python generate_images_fast.py --out ../output-images
```

Generates stable, seeded placeholder images from picsum.photos. Each product gets a unique image based on its SKU hash. No API keys, no GPU, works offline after first download.

### Option B – Google Gemini / Nano Banana

```bash
export GEMINI_API_KEY="your_api_key_here"
python generate_images.py --backend gemini --out ../output-images
```

### Option C – Local FLUX.1-schnell

```bash
pip install torch diffusers accelerate
python generate_images.py --backend flux --out ../output-images
```

## Importing into nopCommerce

The recommended import path is the **C# Console Data Importer** (`../csharp-console/`). It reads `catalog.json`, inserts all data directly into SQL Server, and handles StoreMapping/UrlRecord automatically.

If you prefer Excel import:

1. Start a local HTTP server: `cd ../output-images && python -m http.server 8000`
2. Generate Excel: `python generate_excel.py --image-base-url http://localhost:8000`
3. In nopCommerce Admin: Catalog → Products → Import → Select `nop-import.xlsx`
4. Enable **"Export/import products. Allow download images"** in Catalog settings

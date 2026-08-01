#!/usr/bin/env python3
"""
generate_images_fast.py
=======================
Fast image generation using picsum.photos (seeded by product name).
Falls back to placehold.co if offline.
Produces real-looking placeholder images instantly — no API keys needed.
"""

import json
import sys
import urllib.request
from pathlib import Path


def generate(path: Path, prompt: str):
    seed = abs(hash(prompt)) % (2**31 - 1)
    url = f"https://picsum.photos/seed/{seed}/1024/768"
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = resp.read()
        path.write_bytes(data)
        print(f"  OK {path.name} ({len(data)} bytes)")
        return True
    except Exception as e:
        print(f"  FAIL {path.name}: {e}")
        return False


def main():
    catalog_path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("catalog.json")
    out_dir = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("../output-images")
    out_dir.mkdir(parents=True, exist_ok=True)

    catalog = json.loads(catalog_path.read_text())
    products = catalog.get("products", [])
    print(f"Generating {len(products)} images into {out_dir.resolve()}")

    ok = 0
    for i, p in enumerate(products, 1):
        safe = p["sku"].replace(" ", "_").replace("/", "-")
        dest = out_dir / f"{safe}.jpg"
        if dest.exists():
            print(f"[{i}/{len(products)}] SKIP {dest.name}")
            ok += 1
            continue
        print(f"[{i}/{len(products)}] {p['name'][:50]}...")
        if generate(dest, p.get("imagePrompt", p["name"])):
            ok += 1

    print(f"\nDone: {ok}/{len(products)} images ready.")
    print(f"Directory: {out_dir.resolve()}")


if __name__ == "__main__":
    main()

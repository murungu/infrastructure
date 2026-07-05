#!/usr/bin/env python3
"""
generate_images.py
==================
Generate product images for nopCommerce using one of three backends:
  1) Google Gemini API (Nano Banana 2 / Nano Banana 2 Lite)  – best quality
  2) Local FLUX.1-schnell via HuggingFace diffusers            – free, local GPU
  3) picsum.photos / placehold.co placeholder download       – zero setup fallback

Usage:
  export GEMINI_API_KEY=your_key_here
  python generate_images.py --backend gemini --catalog catalog.json --out ../output-images
  python generate_images.py --backend flux     --catalog catalog.json --out ../output-images
  python generate_images.py --backend placeholder --catalog catalog.json --out ../output-images
"""

import argparse
import base64
import json
import os
import sys
import time
import urllib.request
from pathlib import Path


def ensure_dir(path: Path):
    path.mkdir(parents=True, exist_ok=True)


def save_bytes(data: bytes, path: Path):
    with open(path, "wb") as f:
        f.write(data)
    print(f"  Saved {path.name} ({len(data)} bytes)")


def save_b64(b64_string: str, path: Path):
    data = base64.b64decode(b64_string)
    save_bytes(data, path)


def gemini_generate(
    prompt: str, api_key: str, model: str = "gemini-3.1-flash-lite-image"
) -> bytes:
    """Generate an image using Google Gemini (Nano Banana family)."""
    import urllib.request
    import json as _json

    url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={api_key}"
    payload = {
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {
            "responseModalities": ["Text", "Image"],
            "responseMimeType": "text/plain",
        },
    }
    req = urllib.request.Request(
        url,
        data=_json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            result = _json.loads(resp.read().decode("utf-8"))
    except Exception as exc:
        raise RuntimeError(f"Gemini API request failed: {exc}") from exc

    # Extract inline image data from parts
    for part in result.get("candidates", [{}])[0].get("content", {}).get("parts", []):
        if "inlineData" in part:
            return base64.b64decode(part["inlineData"]["data"])

    raise RuntimeError(f"No image returned by Gemini. Response: {result}")


def flux_generate(prompt: str) -> bytes:
    """Generate an image using local FLUX.1-schnell via diffusers."""
    try:
        import torch
        from diffusers import FluxPipeline  # type: ignore[import-untyped]
    except ImportError as exc:
        raise RuntimeError(
            "diffusers and torch are required for local FLUX. "
            "Install: pip install torch diffusers accelerate"
        ) from exc

    try:
        pipe = FluxPipeline.from_pretrained(
            "black-forest-labs/FLUX.1-schnell",
            torch_dtype=torch.bfloat16,
        )
        pipe.enable_model_cpu_offload()

        image = pipe(
            prompt,
            guidance_scale=0.0,
            num_inference_steps=4,
            max_sequence_length=256,
            generator=torch.Generator("cpu").manual_seed(int(time.time())),
        ).images[0]
    except Exception as exc:
        raise RuntimeError(f"FLUX generation failed: {exc}") from exc

    import io

    buf = io.BytesIO()
    image.save(buf, format="JPEG", quality=90)
    return buf.getvalue()


def placeholder_download(prompt: str, size: str = "1024/768") -> bytes:
    """Download a random placeholder image (ignores prompt)."""
    # Use picsum for realistic-ish photos; seed by hash of prompt for stability
    seed = abs(hash(prompt)) % (2**31)
    url = f"https://picsum.photos/seed/{seed}/{size}"
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        return resp.read()


def generate_for_product(
    product: dict, backend: str, api_key: str, out_dir: Path, size: str
):
    prompt = product.get("imagePrompt", f"product photo of {product['name']}")
    safe_name = product["sku"].replace(" ", "_").replace("/", "-")
    out_path = out_dir / f"{safe_name}.jpg"

    if out_path.exists():
        print(f"  [skip] {out_path.name} already exists")
        return out_path

    print(f"Generating: {product['name']} [{backend}]")
    print(f"  Prompt: {prompt[:100]}...")

    for attempt in range(3):
        try:
            if backend == "gemini":
                data = gemini_generate(prompt, api_key)
            elif backend == "flux":
                data = flux_generate(prompt)
            else:
                data = placeholder_download(prompt, size)
            save_bytes(data, out_path)
            return out_path
        except Exception as exc:
            print(f"  Attempt {attempt + 1} failed: {exc}")
            time.sleep(2**attempt)

    # Ultimate fallback
    print("  Falling back to placehold.co")
    w, h = size.split("/")
    data = urllib.request.urlopen(
        f"https://placehold.co/{w}x{h}?text={product['sku']}"
    ).read()
    save_bytes(data, out_path)
    return out_path


def main():
    parser = argparse.ArgumentParser(
        description="Generate product images for nopCommerce"
    )
    parser.add_argument(
        "--catalog", default="catalog.json", help="Path to catalog JSON"
    )
    parser.add_argument(
        "--out", default="../output-images", help="Output directory for images"
    )
    parser.add_argument(
        "--backend",
        choices=["gemini", "flux", "placeholder"],
        default="placeholder",
        help="Image generation backend",
    )
    parser.add_argument(
        "--gemini-model",
        default="gemini-3.1-flash-lite-image",
        help="Gemini model ID (Nano Banana 2 Lite or Nano Banana 2)",
    )
    parser.add_argument("--size", default="1024/768", help="Image size, e.g. 1024/768")
    args = parser.parse_args()

    catalog_path = Path(args.catalog)
    out_dir = Path(args.out)
    ensure_dir(out_dir)

    if not catalog_path.exists():
        print(f"Catalog not found: {catalog_path}")
        sys.exit(1)

    try:
        with open(catalog_path, "r", encoding="utf-8") as f:
            catalog = json.load(f)
    except (OSError, json.JSONDecodeError) as exc:
        print(f"Failed to load catalog: {exc}")
        sys.exit(1)

    api_key = os.environ.get("GEMINI_API_KEY", "")
    if args.backend == "gemini" and not api_key:
        print(
            "Error: GEMINI_API_KEY environment variable is required for --backend gemini"
        )
        sys.exit(1)

    products = catalog.get("products", [])
    print(f"Generating {len(products)} images via '{args.backend}' backend...")
    print(f"Output: {out_dir.absolute()}")
    print("-" * 60)

    for idx, product in enumerate(products, 1):
        print(f"[{idx}/{len(products)}] ", end="")
        generate_for_product(product, args.backend, api_key, out_dir, args.size)
        # Be polite to APIs
        if args.backend == "gemini":
            time.sleep(1.5)

    print("-" * 60)
    print("Done.")


if __name__ == "__main__":
    main()

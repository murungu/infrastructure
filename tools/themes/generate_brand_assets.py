#!/usr/bin/env python3
"""Generate brand assets for both stores using Gemini API or fallback to picsum."""

import os
import json
import base64
import urllib.request
import urllib.error
from pathlib import Path

GEMINI_KEY = os.environ.get("GEMINI_API_KEY", "")
OUTDIR = Path(__file__).parent / "assets"


def gemini_generate(
    prompt, filename, size="1024x1024", model="gemini-3.1-flash-lite-image"
):
    """Generate image via Gemini API. Returns True on success."""
    if not GEMINI_KEY:
        return False
    try:
        url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={GEMINI_KEY}"
        data = json.dumps(
            {
                "contents": [{"parts": [{"text": prompt}]}],
                "generationConfig": {"responseModalities": ["Text", "Image"]},
            }
        ).encode()
        req = urllib.request.Request(
            url, data=data, headers={"Content-Type": "application/json"}, method="POST"
        )
        with urllib.request.urlopen(req, timeout=60) as resp:
            result = json.loads(resp.read().decode())
        # Extract inline image data
        parts = result.get("candidates", [{}])[0].get("content", {}).get("parts", [])
        for part in parts:
            if "inlineData" in part:
                img_b64 = part["inlineData"]["data"]
                img_bytes = base64.b64decode(img_b64)
                path = OUTDIR / filename
                path.write_bytes(img_bytes)
                print(f"  Generated {filename} ({len(img_bytes)} bytes)")
                return True
        return False
    except Exception as e:
        print(f"  Gemini failed for {filename}: {e}")
        return False


def placeholder_image(prompt_seed, filename, w=1024, h=768):
    """Download a stable placeholder from picsum.photos."""
    try:
        url = f"https://picsum.photos/seed/{prompt_seed}/{w}/{h}"
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = resp.read()
        path = OUTDIR / filename
        path.write_bytes(data)
        print(f"  Generated placeholder {filename} ({len(data)} bytes)")
        return True
    except Exception as e:
        print(f"  Placeholder failed for {filename}: {e}")
        return False


def generate_store_assets(store_name, store_key, prompts):
    print(f"\n=== Generating assets for {store_name} ===")
    for asset_name, prompt in prompts.items():
        filename = f"{store_key}_{asset_name}.jpg"
        print(f"  {asset_name}...")
        if not gemini_generate(prompt, filename):
            seed = f"{store_key}_{asset_name}"
            placeholder_image(seed, filename)


def main():
    OUTDIR.mkdir(parents=True, exist_ok=True)

    # Store 1: Arty Electra — minimalist, solar, clean, Arity-branded
    generate_store_assets(
        "Arty Electra",
        "electra",
        {
            "logo": "Minimalist logo design on white background. A stylized lightning bolt integrated with the letter 'A'. Black ink only, geometric, clean lines, modern sans-serif typography. No text, pure icon mark.",
            "hero_banner": "Wide landscape banner. African rooftop with modern solar panels under bright sun. Clean blue sky, warm golden light. Minimal, editorial photography style. High-end renewable energy campaign aesthetic.",
            "favicon": "Simple black lightning bolt icon on white background, 32x32 pixel art style, crisp edges, minimal",
            "category_solar": "Close-up of gleaming monocrystalline solar panels with blue sky reflection. Clean, technical, high-contrast photography.",
            "category_battery": "Modern lithium battery pack in clean white studio lighting. Sleek industrial design, minimal background.",
            "category_led": "Warm white LED strip lighting glowing in darkness. Clean product photography, minimal.",
        },
    )

    # Store 2: Victoria Falls Artisan Market — warm, earthy, traditional African
    generate_store_assets(
        "Victoria Falls Artisan Market",
        "victoria",
        {
            "logo": "Hand-drawn logo on cream paper texture. Silhouette of Victoria Falls waterfall with traditional African geometric patterns. Warm terracotta and olive green ink. Artisanal, organic, hand-crafted feel. No text.",
            "hero_banner": "Wide landscape banner. Traditional African open-air market at golden hour. Handwoven baskets, beaded jewelry, carved wooden sculptures displayed on rustic tables. Warm terracotta tones, dust motes in sunlight, authentic documentary photography style.",
            "favicon": "Hand-drawn Victoria Falls waterfall silhouette in terracotta color on cream background, simple, iconic",
            "category_wood": "Hand-carved wooden bowl with natural grain patterns. Warm sidelighting, earthy tones, artisan workshop background.",
            "category_beads": "Traditional Zulu beaded necklace in vibrant colors laid on natural linen. Close-up detail photography, warm tones.",
            "category_baskets": "Woven ilala palm basket with intricate pattern. Natural daylight, earthy background, artisan craft photography.",
            "category_leather": "Hand-stitched leather goods with brass buckles. Warm brown tones, rustic wooden surface, artisan craft photography.",
            "category_stone": "Soapstone elephant carving with smooth polished surface. Warm directional light, dark background, gallery-quality product photography.",
            "category_fabrics": "Hand-painted Shweshwe fabric with geometric indigo patterns. Natural light, draped over wooden rail, artisan textile photography.",
        },
    )

    print(f"\n=== Done. Assets in {OUTDIR.absolute()} ===")
    for f in sorted(OUTDIR.iterdir()):
        print(f"  {f.name} ({f.stat().st_size} bytes)")


if __name__ == "__main__":
    main()

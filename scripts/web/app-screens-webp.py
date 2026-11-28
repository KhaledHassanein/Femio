"""Turns the app renders in testing-results/2026-11-28-web-screens into the website's WebP screens.

Why it exists: the site's app tour (apps/web/public/app-screens) must show the app as it is. The
renders come from apps/mobile/test/store_plain_screenshots_test.dart (run with --update-goldens);
this copies them to the file names apps/web/src/lib/demos/samples.ts expects
(`<screen>-<lang>-<light|dark>.webp`). Run from the repository root: python scripts/web/app-screens-webp.py
Fails if a render is missing.
"""
from pathlib import Path

from PIL import Image

SRC = Path("testing-results/2026-11-28-web-screens")
DST = Path("apps/web/public/app-screens")
NAMES = [f"{s}-{v}" for s in ("today", "calendar", "pregnancy") for v in ("en-light", "ar-light", "ar-dark")]

for name in NAMES:
    src = SRC / f"{name}.png"
    if not src.exists():
        raise SystemExit(f"missing render: {src}")
    Image.open(src).convert("RGB").save(DST / f"{name}.webp", "WEBP", quality=85, method=6)
    print("wrote", DST / f"{name}.webp")

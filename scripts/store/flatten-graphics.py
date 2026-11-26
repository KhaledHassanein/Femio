"""Removes the alpha channel from the Play feature graphics and screenshots (Play refuses alpha).

Why it exists: Flutter golden files are RGBA PNGs; Google Play wants a 24-bit PNG or JPEG
for the feature graphic (docs/store/graphics-brief.md). Run after
`flutter test --update-goldens test/store_feature_graphic_test.dart` or
`test/store_screenshots_test.dart` (screenshots must be 1080x1920, R8.30).
Usage: python scripts/store/flatten-graphics.py
"""
import pathlib
import sys

from PIL import Image

STORE = pathlib.Path(__file__).resolve().parents[2] / "docs" / "store"
GRAPHICS = STORE / "graphics"
SCREENSHOTS = STORE / "screenshots"


def main() -> int:
    """Rewrites each feature graphic and screenshot PNG as RGB and checks its size; returns 1 on a bad size."""
    bad = 0
    jobs = [(p, (1024, 500)) for p in sorted(GRAPHICS.glob("feature-graphic-*.png"))]
    jobs += [(p, (1080, 1920)) for p in sorted(SCREENSHOTS.glob("*/*.png"))]
    for path, size in jobs:
        img = Image.open(path).convert("RGB")
        if img.size != size:
            print(f"{path.name}: {img.size}, expected {size}")
            bad = 1
        img.save(path, optimize=True)
        print(f"{path.name}: RGB {img.size}")
    return bad


if __name__ == "__main__":
    sys.exit(main())

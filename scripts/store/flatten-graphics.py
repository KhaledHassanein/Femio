"""Removes the alpha channel from the Play feature graphics (Play refuses alpha).

Why it exists: Flutter golden files are RGBA PNGs; Google Play wants a 24-bit PNG or JPEG
for the feature graphic (docs/store/graphics-brief.md). Run after
`flutter test --update-goldens test/store_feature_graphic_test.dart`.
Usage: python scripts/store/flatten-graphics.py
"""
import pathlib
import sys

from PIL import Image

GRAPHICS = pathlib.Path(__file__).resolve().parents[2] / "docs" / "store" / "graphics"


def main() -> int:
    """Rewrites each feature-graphic PNG as RGB and checks its size; returns 1 on a bad size."""
    bad = 0
    for path in sorted(GRAPHICS.glob("feature-graphic-*.png")):
        img = Image.open(path).convert("RGB")
        if img.size != (1024, 500):
            print(f"{path.name}: {img.size}, expected (1024, 500)")
            bad = 1
        img.save(path, optimize=True)
        print(f"{path.name}: RGB {img.size}")
    return bad


if __name__ == "__main__":
    sys.exit(main())

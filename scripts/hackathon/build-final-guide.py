"""Builds docs/hackathon/FINAL_GUIDE.html, the owner's one-page launch guide (2026-11-28).

Why it exists: the owner reads HTML, not Markdown. The page pulls the store listings (AR/FR/ES)
and the Devpost answers straight from their source files, so it never drifts from them:
docs/store/play-listing.{ar,fr,es}.md and docs/hackathon/DEVPOST_SUBMISSION.md.
Hand-written parts (verdict, GitHub steps, privacy advice) live in the template below.
Run from the repository root: python scripts/hackathon/build-final-guide.py
Fails if a listing or Devpost section it expects is missing.
"""
import html
import re
from pathlib import Path

ROOT = Path(".")
OUT = ROOT / "docs/hackathon/FINAL_GUIDE.html"
TEMPLATE = ROOT / "scripts/hackathon/final-guide.template.html"


def code_blocks(md: str) -> list[str]:
    """Returns the fenced code blocks of a listing file, in order (title, short, full)."""
    return re.findall(r"```\n(.*?)\n```", md, flags=re.S)


def copy_block(label: str, text: str, rtl: bool = False) -> str:
    """One labelled, copyable text box."""
    d = ' dir="rtl" lang="ar"' if rtl else ""
    n = len(text)
    return (
        f'<div class="copy"><div class="copy-head"><span>{html.escape(label)}</span>'
        f'<span class="count">{n} chars</span><button type="button" class="btn-copy">Copy</button></div>'
        f"<pre{d}>{html.escape(text)}</pre></div>"
    )


def listings() -> str:
    names = {"ar": "Arabic", "fr": "French", "es": "Spanish"}
    out = []
    for lang, name in names.items():
        blocks = code_blocks((ROOT / f"docs/store/play-listing.{lang}.md").read_text(encoding="utf-8"))
        if len(blocks) < 3:
            raise SystemExit(f"listing {lang}: expected 3 code blocks, found {len(blocks)}")
        rtl = lang == "ar"
        out.append(
            f'<details class="lang"><summary>{name}</summary>'
            + copy_block("App name (max 30)", blocks[0], rtl)
            + copy_block("Short description (max 80)", blocks[1], rtl)
            + copy_block("Full description (max 4,000)", blocks[2], rtl)
            + "</details>"
        )
    return "\n".join(out)


def section(md: str, start: str, end: str | None) -> str:
    """Text between two '## ' headings (start included as content only)."""
    a = md.index(f"\n## {start}")
    i = md.index("\n", a + 1) + 1
    j = md.index(f"\n## {end}", i) if end else len(md)
    return md[i:j].strip()


def devpost() -> str:
    md = (ROOT / "docs/hackathon/DEVPOST_SUBMISSION.md").read_text(encoding="utf-8")
    about = "## The problem\n" + section(md, "The problem", "Built with")
    fields = [
        ("Project name", section(md, "Project name", "Elevator pitch")),
        ("Elevator pitch (200 max)", section(md, "Elevator pitch", "About the project")),
        ("About the project (paste as Markdown)", about),
        ("Built with", section(md, "Built with", "Other fields")),
        ("Try it out, video, submitter", section(md, "Other fields", "What existed vs what I built")),
        ("What existed before vs what you built", section(md, "What existed vs what I built", "Main technology requirement")),
        ("Main technology requirement", section(md, "Main technology requirement", "Testing instructions")),
        ("Testing instructions", section(md, "Testing instructions", "License")),
        ("License", section(md, "License", None)),
    ]
    return "\n".join(copy_block(k, v) for k, v in fields)


page = TEMPLATE.read_text(encoding="utf-8")
page = page.replace("<!--LISTINGS-->", listings()).replace("<!--DEVPOST-->", devpost())
OUT.write_text(page, encoding="utf-8")
print("wrote", OUT, len(page), "bytes")

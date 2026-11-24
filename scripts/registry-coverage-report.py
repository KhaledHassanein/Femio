"""Summarise Ask femio's registry coverage by group and by language.

Why it exists: `apps/mobile/test/registry_coverage_test.dart` grades every synthetic question
and writes `apps/mobile/build/registry_coverage.json`. This script turns that file into the
Markdown tables used in docs/33_REBUILD_V3/research/REGISTRY_COVERAGE_2026-11.md, and lists
the questions still without a strong answer. The numbers come from a synthetic question set,
not from real use.

Usage: python scripts/registry-coverage-report.py [path/to/registry_coverage.json] [--json out.json]
"""

from __future__ import annotations

import json
import sys
from collections import defaultdict
from pathlib import Path

DEFAULT_INPUT = Path("apps/mobile/build/registry_coverage.json")
GROUP_LABELS = {
    "ttc": "Trying to conceive and PCOS",
    "pregnancy": "Pregnancy, week by week",
    "postpartum": "After birth and feeding",
    "periods": "Periods and cycle tracking",
    "firstPeriods": "First periods",
    "menopause": "Perimenopause and menopause",
    "wellness": "General wellness",
}
LANGS = ["en", "ar", "fr", "es"]


def tally(rows: list[dict]) -> dict:
    """Count grades in rows. Returns {'n', 'strong', 'weak', 'none', 'rule'}."""
    out = {"n": len(rows), "strong": 0, "weak": 0, "none": 0, "rule": 0}
    for r in rows:
        g = r["grade"]
        out["rule" if g.startswith("rule:") else g] += 1
    return out


def pct(part: int, whole: int) -> str:
    """Percentage with no decimals, or a dash for an empty set."""
    return f"{round(100 * part / whole)}%" if whole else "-"


def summarise(data: dict) -> dict:
    """Build the by-group, by-language and rules summaries from the test's output."""
    rows = [r for r in data["rows"] if r["group"] != "rules"]
    by_group = defaultdict(list)
    by_lang = defaultdict(list)
    for r in rows:
        by_group[r["group"]].append(r)
        by_lang[r["lang"]].append(r)
    return {
        "registry": data["registry"],
        "total": tally(rows),
        "groups": {g: tally(by_group[g]) for g in GROUP_LABELS},
        "langs": {lang: tally(by_lang[lang]) for lang in LANGS},
        "rules": [r for r in data["rows"] if r["group"] == "rules"],
        "open": [r for r in rows if r["grade"] != "strong"],
    }


def table(title: str, items: dict, labels: dict) -> str:
    """One Markdown table of strong/weak/none per item."""
    lines = [f"| {title} | Asked | Strong | Weak | None | Stopped by a rule |", "|---|---|---|---|---|---|"]
    for key, t in items.items():
        lines.append(
            f"| {labels.get(key, key)} | {t['n']} | {t['strong']} ({pct(t['strong'], t['n'])}) | "
            f"{t['weak']} | {t['none']} | {t['rule']} |"
        )
    return "\n".join(lines)


def main() -> None:
    sys.stdout.reconfigure(encoding="utf-8")
    args = sys.argv[1:]
    out_json = None
    if "--json" in args:
        i = args.index("--json")
        out_json = Path(args[i + 1])
        del args[i : i + 2]
    path = Path(args[0]) if args else DEFAULT_INPUT
    s = summarise(json.loads(path.read_text(encoding="utf-8")))
    if out_json:
        out_json.write_text(json.dumps(s, ensure_ascii=False, indent=1), encoding="utf-8")
    t = s["total"]
    print(f"Registry {s['registry']}: {t['n']} asked, strong {t['strong']} ({pct(t['strong'], t['n'])}), "
          f"weak {t['weak']}, none {t['none']}, rule {t['rule']}\n")
    print(table("Group", s["groups"], GROUP_LABELS) + "\n")
    print(table("Language", s["langs"], {"en": "English", "ar": "Arabic", "fr": "French", "es": "Spanish"}) + "\n")
    print("Rules group:")
    for r in s["rules"]:
        notice = " +clinician notice" if r.get("diagnosisNotice") else ""
        print(f"  {r['id']} {r['lang']} [{r['rule']}] -> {r['grade']}{notice} {r['passages']}")
    print("\nNot strong:")
    for r in s["open"]:
        print(f"  {r['id']} {r['lang']} {r['grade']:6} {r['question']}  -> {r['passages']}")


if __name__ == "__main__":
    main()

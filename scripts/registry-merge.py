"""Merge reviewed additions into Ask femio's bundled trusted-source registry.

Why it exists: new registry entries are drafted as separate JSON files (one per subject
cluster), reviewed, then merged into apps/mobile/assets/trusted_sources/registry.json. This
script applies the same licence rule the app enforces at load time (ADR-079), plus checks the
app cannot make: passage length, https links, no contraception wording, no repeated id, url+text
or text. It refuses the whole merge on any error, so a bad draft never half-lands.

Usage: python scripts/registry-merge.py VERSION draft1.json [draft2.json ...]
Writes the registry in place, sorted as before (existing entries first, new ones appended).
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

REGISTRY = Path("apps/mobile/assets/trusted_sources/registry.json")
PUBLIC_DOMAIN = {
    "CDC", "MedlinePlus (NLM)", "Office on Women's Health (womenshealth.gov)", "NICHD (NIH)",
    "NIDDK (NIH)", "NCI (NIH)", "NIA (NIH)", "NIMH (NIH)", "NHLBI (NIH)", "NIH ODS", "NIAMS (NIH)",
}
LINK_ONLY = {"WHO", "NHS", "ACOG", "RCOG", "NICE", "Saudi MOH"}
LANGS = {"en", "ar", "fr", "es"}
GOALS = {"period", "ttc", "pregnant", "menopause"}
LICENCE = "US federal government work, public domain (17 U.S.C. §105)"
# Words that mean a passage is about avoiding pregnancy (product rule 1): never bundled.
CONTRACEPTION = re.compile(r"birth control|contracepti|prevent pregnancy|avoid pregnancy|condom|\biud\b", re.I)
MIN_WORDS, MAX_WORDS = 12, 90
KEY_ORDER = ["id", "kind", "publisher", "title", "url", "retrieved", "reviewed", "lang", "licence",
             "topics", "goals", "personas", "text", "summaryEn"]


def check(e: dict) -> list[str]:
    """Problems with one entry; empty when it may be merged."""
    errs = []
    for k in ("id", "kind", "publisher", "title", "url", "retrieved"):
        if not isinstance(e.get(k), str) or not e[k].strip():
            errs.append(f"missing {k}")
    if errs:
        return errs
    if not e["url"].startswith("https://"):
        errs.append("url not https")
    if "medlineplus.gov/ency/" in e["url"]:
        errs.append("MedlinePlus encyclopedia is A.D.A.M. copyright, not public domain")
    if e.get("lang", "en") not in LANGS:
        errs.append("bad lang")
    if not set(e.get("goals", [])) <= GOALS:
        errs.append("bad goal")
    if e["kind"] == "passage":
        if e["publisher"] not in PUBLIC_DOMAIN:
            errs.append(f"{e['publisher']} may not supply a passage")
        text = e.get("text", "")
        n = len(text.split())
        if not MIN_WORDS <= n <= MAX_WORDS:
            errs.append(f"passage has {n} words")
        if CONTRACEPTION.search(text):
            errs.append("contraception wording")
    elif e["kind"] == "link":
        if e["publisher"] not in LINK_ONLY:
            errs.append(f"{e['publisher']} is not a link-only publisher")
        if not e.get("summaryEn"):
            errs.append("link without summaryEn")
        if "text" in e:
            errs.append("link carries copied text")
    else:
        errs.append("unknown kind")
    if e.get("reviewed") is not None and not re.fullmatch(r"\d{4}-\d{2}-\d{2}", e["reviewed"]):
        errs.append("reviewed is not yyyy-mm-dd")
    return errs


def tidy(e: dict) -> dict:
    """Keeps only registry keys, in a stable order, with the default language and licence."""
    e = {k: v for k, v in e.items() if k in KEY_ORDER and v not in (None, "")}
    e.setdefault("lang", "en")
    if e["kind"] == "passage":
        e["licence"] = LICENCE
    return {k: e[k] for k in KEY_ORDER if k in e}


def main() -> None:
    sys.stdout.reconfigure(encoding="utf-8")
    version, drafts = sys.argv[1], sys.argv[2:]
    reg = json.loads(REGISTRY.read_text(encoding="utf-8"))
    entries = [tidy(e) for e in reg["entries"]]
    ids = {e["id"] for e in entries}
    texts = {e.get("text") for e in entries if e.get("text")}
    problems = []
    added = 0
    for path in drafts:
        for e in json.loads(Path(path).read_text(encoding="utf-8"))["entries"]:
            errs = check(e)
            if e.get("id") in ids:
                errs.append("id repeated")
            if e.get("text") and e["text"] in texts:
                errs.append("text repeated")
            if errs:
                problems.append(f"{path}: {e.get('id')}: {'; '.join(errs)}")
                continue
            entries.append(tidy(e))
            ids.add(e["id"])
            texts.add(e.get("text"))
            added += 1
    if problems:
        print("Refused; fix these and run again:\n  " + "\n  ".join(problems))
        sys.exit(1)
    reg["version"] = version
    reg["note"] = ("Merged by scripts/registry-merge.py; passages verbatim from US federal public-domain pages "
                   "(CDC, MedlinePlus, OWH, NIH institutes and offices); links are WHO/NHS/ACOG/RCOG/NICE/Saudi MOH "
                   "pages Femio does not copy, described in Femio's own words.")
    reg["entries"] = entries
    REGISTRY.write_text(json.dumps(reg, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(f"registry {version}: {len(entries)} entries ({added} added)")


if __name__ == "__main__":
    main()

"""Add the app's Tools strings (R13.1-R13.3, R13.5) to the four ARB files.

Why it exists: the website calculators already carry reviewed EN/AR/FR/ES wording for
the same three tools, so the app reuses that text instead of a second translation.
Each ARB key maps to a key path in `apps/web/messages/<locale>.json`; the few
app-only strings are written here in all four languages. `#` in a web plural becomes
`{count}`, which Flutter's gen-l10n reads. Running it twice changes nothing.

Usage: python scripts/i18n/r11-app-arb.py
Then, as after any ARB edit: node scripts/mobile/sync-log-vocabulary.mjs, then
flutter gen-l10n in apps/mobile (the JSON rewrite here can drift the vocabulary block).
"""

from __future__ import annotations

import json
from collections import OrderedDict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
WEB = ROOT / "apps" / "web" / "messages"
ARB = ROOT / "apps" / "mobile" / "lib" / "l10n"
LOCALES = ("en", "ar", "fr", "es")

# ARB key -> dotted path under the web catalogue's "calculators" namespace.
FROM_WEB: dict[str, str] = {
    "toolsTitle": "title",
    "toolsSub": "disclaimer",
    "toolDueTitle": "list.dueDate.name",
    "toolDueDesc": "list.dueDate.desc",
    "toolCalTitle": "list.pregnancyCalendar.name",
    "toolCalDesc": "list.pregnancyCalendar.desc",
    "toolGainTitle": "list.weightGain.name",
    "toolGainDesc": "list.weightGain.desc",
    "toolDueMethodLabel": "dueDate.methodLabel",
    "toolDueMethodLmp": "dueDate.method.lmp",
    "toolDueMethodConception": "dueDate.method.conception",
    "toolDueMethodTransfer": "dueDate.method.transfer",
    "toolDueMethodScan": "dueDate.method.scan",
    "toolEmbryoLabel": "dueDate.embryoLabel",
    "toolEmbryo3": "dueDate.embryo.day3",
    "toolEmbryo5": "dueDate.embryo.day5",
    "toolPromptLmp": "calendar.prompt",
    "toolPromptConception": "dueDate.prompt.conception",
    "toolPromptTransfer": "dueDate.prompt.transfer",
    "toolPromptScan": "dueDate.prompt.scan",
    "toolCycleLabel": "stepper.cycleLabel",
    "toolDays": "stepper.days",
    "toolScanWeeksLabel": "dueDate.scanWeeksLabel",
    "toolScanDaysLabel": "dueDate.scanDaysLabel",
    "toolWeeks": "dueDate.weeks",
    "toolTermWindow": "dueDate.termWindowLabel",
    "toolScanNote": "dueDate.scanNote",
    "toolEstimateNote": "rules.estimateNote",
    "toolClinicianAdjust": "rules.clinicianAdjust",
    "toolCalMethodLabel": "pregnancyCalendar.methodLabel",
    "toolCalMethodEdd": "pregnancyCalendar.method.edd",
    "toolCalMethodLmp": "pregnancyCalendar.method.lmp",
    "toolCalPromptEdd": "pregnancyCalendar.promptEdd",
    "toolCalEyebrow": "pregnancyCalendar.eyebrow",
    "toolCalTrimesterLine": "pregnancyCalendar.trimesterLine",
    "toolCalWeek": "pregnancyCalendar.week",
    "toolCalCurrent": "pregnancyCalendar.current",
    "toolCalReadGuide": "pregnancyCalendar.readGuide",
    "toolGainIntro": "weightGain.intro",
    "toolGainWeight": "weightGain.weightMetric",
    "toolGainHeight": "bmi.heightMetric",
    "toolGainBabiesLabel": "weightGain.babiesLabel",
    "toolGainBabiesOne": "weightGain.babies.one",
    "toolGainBabiesTwo": "weightGain.babies.two",
    "toolGainBabiesMore": "weightGain.babies.more",
    "toolGainBmiLine": "weightGain.bmiLine",
    "toolBandUnderweight": "bmi.categories.underweight",
    "toolBandNormal": "bmi.categories.normal",
    "toolBandOverweight": "bmi.categories.overweight",
    "toolBandObese": "bmi.categories.obese",
    "toolGainEyebrow": "weightGain.eyebrow",
    "toolGainRangeKg": "weightGain.rangeKg",
    "toolGainRangeLb": "weightGain.rangeLb",
    "toolGainOtherUnit": "weightGain.otherUnit",
    "toolGainNoRangeTwins": "weightGain.noRangeTwinsUnderweight",
    "toolGainNoRangeMultiples": "weightGain.noRangeMultiples",
    "toolGainNote": "weightGain.note",
    "toolGainSource": "weightGain.source",
    "toolGainOutOfRange": "weightGain.outOfRange",
}

# App-only strings, written here in all four languages.
APP_ONLY: dict[str, dict[str, str]] = {
    "toolNothingSaved": {
        "en": "Nothing you enter here is saved.",
        "ar": "لا يُحفظ شيء مما تُدخلينه هنا.",
        "fr": "Rien de ce que vous saisissez ici n'est enregistré.",
        "es": "No se guarda nada de lo que introduces aquí.",
    },
}

# Placeholder types for the template ARB; anything not listed is a String.
INT_PLACEHOLDERS = {"count"}


def lookup(catalogue: dict, dotted: str) -> str:
    node = catalogue["calculators"]
    for part in dotted.split("."):
        node = node[part]
    if not isinstance(node, str):
        raise TypeError(f"calculators.{dotted} is not a string")
    return node.replace("#", "{count}")


def placeholders(text: str) -> list[str]:
    """Top-level ICU argument names in [text] ("{start}", "{count, plural, ...}")."""
    names: list[str] = []
    depth = 0
    i = 0
    while i < len(text):
        ch = text[i]
        if ch == "{":
            if depth == 0:
                j = i + 1
                while j < len(text) and (text[j].isalnum() or text[j] == "_"):
                    j += 1
                name = text[i + 1 : j]
                if name and name not in names:
                    names.append(name)
            depth += 1
        elif ch == "}":
            depth -= 1
        i += 1
    return names


def main() -> None:
    web = {loc: json.loads((WEB / f"{loc}.json").read_text(encoding="utf-8")) for loc in LOCALES}
    for loc in LOCALES:
        path = ARB / f"app_{loc}.arb"
        arb = json.loads(path.read_text(encoding="utf-8"), object_pairs_hook=OrderedDict)
        for key, dotted in FROM_WEB.items():
            arb[key] = lookup(web[loc], dotted)
            if loc == "en":
                names = placeholders(arb[key])
                if names:
                    arb[f"@{key}"] = {
                        "placeholders": {n: {"type": "int" if n in INT_PLACEHOLDERS else "String"} for n in names}
                    }
        for key, texts in APP_ONLY.items():
            arb[key] = texts[loc]
        path.write_text(json.dumps(arb, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
        print(f"{path.name}: {len(FROM_WEB) + len(APP_ONLY)} keys set")


if __name__ == "__main__":
    main()

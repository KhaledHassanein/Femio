"""Generate the golden fixtures for the R13 calculators, independently of the clients.

Why it exists: a fixture produced by running the TypeScript or Dart code would only
prove that the code agrees with itself. These expected values come from Python's own
calendar arithmetic and the numbers in the medical rules register
(docs/33_REBUILD_V3/01_PRODUCT_SCOPE.md §4: MR-23, MR-24, MR-25, MR-53, MR-54, MR-55),
so the website and the app must each reproduce them.

Writes:
  fixtures/domain/pregnancy-calendar.json  (MR-54)
  fixtures/domain/weight-gain.json         (MR-55)
  fixtures/domain/edd-from.json            (adds the "scan" cases, MR-53; other cases kept)

Run from the repo root:  python scripts/domain/gen_tool_fixtures.py
Re-running is safe: the output is deterministic. A change to the output is a change to
a medical rule and must be read in review, never accepted blindly.
"""

from __future__ import annotations

import json
import math
from datetime import date, timedelta
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
FIXTURES = ROOT / "fixtures" / "domain"

# MR-23: pregnancy length from the last period.
GESTATION_DAYS = 280
# MR-53: accepted gestation on a scan report, 4w0d to 41w6d.
SCAN_MIN_DAYS = 28
SCAN_MAX_DAYS = 293
# MR-54: calendar rows and the weeks that have a guide.
FIRST_ROW_WEEK = 4
LAST_ROW_WEEK = 41
FIRST_GUIDE_WEEK = 4
LAST_GUIDE_WEEK = 40
# MR-24 / MR-25.
TERM_START_DAYS = 259
TERM_END_DAYS = 294
SECOND_TRIMESTER_DAYS = 98
THIRD_TRIMESTER_DAYS = 196
# MR-55 / MR-28: accepted inputs.
MIN_WEIGHT_KG = 25
MAX_WEIGHT_KG = 300
MIN_HEIGHT_CM = 120
MAX_HEIGHT_CM = 220

# MR-55, IOM 2009 (report brief; kg from PMC4340812 Table 1 and the MSD Manual table).
SINGLETON = {
    "underweight": (12.5, 18, 28, 40),
    "normal": (11.5, 16, 25, 35),
    "overweight": (7, 11.5, 15, 25),
    "obese": (5, 9, 11, 20),
}
TWINS = {
    "underweight": None,  # IOM gives no range
    "normal": (16.8, 24.5, 37, 54),
    "overweight": (14.1, 22.7, 31, 50),
    "obese": (11.5, 19.1, 25, 42),
}


def iso(d: date) -> str:
    return d.isoformat()


def parse(s: str) -> date | None:
    try:
        return date.fromisoformat(s) if len(s) == 10 else None
    except ValueError:
        return None


def edd_from_scan(scan: str, weeks: int, days: int) -> str | None:
    d = parse(scan)
    if d is None or not (0 <= days <= 6) or weeks < 0:
        return None
    total = weeks * 7 + days
    if total < SCAN_MIN_DAYS or total > SCAN_MAX_DAYS:
        return None
    return iso(d + timedelta(days=GESTATION_DAYS - total))


def trimester(total_days: int) -> int:
    if total_days < SECOND_TRIMESTER_DAYS:
        return 1
    if total_days < THIRD_TRIMESTER_DAYS:
        return 2
    return 3


def pregnancy_calendar(edd: str, today: str) -> dict | None:
    e = parse(edd)
    t = parse(today)
    if e is None or t is None:
        return None
    lmp = e - timedelta(days=GESTATION_DAYS)
    weeks = []
    for w in range(FIRST_ROW_WEEK, LAST_ROW_WEEK + 1):
        start = lmp + timedelta(days=7 * w)
        weeks.append(
            {
                "week": w,
                "start": iso(start),
                "end": iso(start + timedelta(days=6)),
                "trimester": trimester(7 * w),
                "guide": f"pregnancy-week-{w}" if FIRST_GUIDE_WEEK <= w <= LAST_GUIDE_WEEK else None,
            }
        )
    since = (t - lmp).days
    current = since // 7 if since >= 0 else None
    if current is not None and not (FIRST_ROW_WEEK <= current <= LAST_ROW_WEEK):
        current = None
    return {
        "lmp": iso(lmp),
        "edd": iso(e),
        "secondTrimester": iso(lmp + timedelta(days=SECOND_TRIMESTER_DAYS)),
        "thirdTrimester": iso(lmp + timedelta(days=THIRD_TRIMESTER_DAYS)),
        "termStart": iso(lmp + timedelta(days=TERM_START_DAYS)),
        "termEnd": iso(lmp + timedelta(days=TERM_END_DAYS)),
        "currentWeek": current,
        "weeks": weeks,
    }


def round_half_up_1(x: float) -> float:
    """One decimal, halves away from zero for positives, as the clients' BMI does."""
    return math.floor(x * 10 + 0.5) / 10


def weight_gain(weight_kg: float, height_cm: float, babies: int) -> dict | None:
    if not (MIN_WEIGHT_KG <= weight_kg <= MAX_WEIGHT_KG) or not (MIN_HEIGHT_CM <= height_cm <= MAX_HEIGHT_CM):
        return None
    if babies not in (1, 2, 3):
        return None
    meters = height_cm / 100
    bmi = round_half_up_1(weight_kg / (meters * meters))
    if bmi < 18.5:
        band = "underweight"
    elif bmi < 25:
        band = "normal"
    elif bmi < 30:
        band = "overweight"
    else:
        band = "obese"
    if babies >= 3:
        return {"bmi": bmi, "band": band, "babies": babies, "range": None, "noRangeReason": "multiples"}
    table = SINGLETON if babies == 1 else TWINS
    row = table[band]
    if row is None:
        return {"bmi": bmi, "band": band, "babies": babies, "range": None, "noRangeReason": "twinsUnderweight"}
    low_kg, high_kg, low_lb, high_lb = row
    return {
        "bmi": bmi,
        "band": band,
        "babies": babies,
        "range": {"lowKg": low_kg, "highKg": high_kg, "lowLb": low_lb, "highLb": high_lb},
        "noRangeReason": None,
    }


def write(name: str, comment: str, cases: list[dict]) -> None:
    out = {"$comment": comment, "cases": cases}
    (FIXTURES / f"{name}.json").write_text(json.dumps(out, indent=2, ensure_ascii=False) + "\n", encoding="utf-8", newline="\n")


def main() -> None:
    # --- MR-54 pregnancy calendar -------------------------------------------------
    cal_inputs = [
        {"edd": "2027-03-01", "today": "2026-09-14"},  # mid second trimester
        {"edd": "2027-03-01", "today": "2026-06-08"},  # 2w0d: before the first row, no current week
        {"edd": "2026-12-25", "today": "2026-11-24"},  # late third trimester
        {"edd": "2027-07-10", "today": "2026-11-24"},  # before week 4: no current row
        {"edd": "2026-11-01", "today": "2026-11-24"},  # past the due date, inside week 43? -> null
        {"edd": "2026-11-20", "today": "2026-11-24"},  # 40w4d
        {"edd": "2028-02-29", "today": "2027-08-01"},  # leap day due date
        {"edd": "2026-02-30", "today": "2026-01-01"},  # invalid date
    ]
    write(
        "pregnancy-calendar",
        "MR-54 pregnancy week-by-week calendar: rows 4-41 from Nw0d to Nw6d counted from due date - 280 (MR-23); "
        "trimester per MR-25; term 37w0d-42w0d (MR-24); guide slug for weeks 4-40; currentWeek only inside a row. "
        "Generated by scripts/domain/gen_tool_fixtures.py from Python date arithmetic, not from either client.",
        [{"input": i, "expected": pregnancy_calendar(i["edd"], i["today"])} for i in cal_inputs],
    )

    # --- MR-55 weight gain ---------------------------------------------------------
    wg_inputs = [
        {"weightKg": 50, "heightCm": 170, "babies": 1},  # 17.3 underweight
        {"weightKg": 62, "heightCm": 165, "babies": 1},  # 22.8 normal
        {"weightKg": 72, "heightCm": 160, "babies": 1},  # 28.1 overweight
        {"weightKg": 95, "heightCm": 158, "babies": 1},  # 38.1 obese
        {"weightKg": 130, "heightCm": 160, "babies": 1},  # 50.8 obese, all classes
        {"weightKg": 62, "heightCm": 165, "babies": 2},  # twins normal
        {"weightKg": 72, "heightCm": 160, "babies": 2},  # twins overweight
        {"weightKg": 95, "heightCm": 158, "babies": 2},  # twins obese
        {"weightKg": 50, "heightCm": 170, "babies": 2},  # twins underweight: no range
        {"weightKg": 62, "heightCm": 165, "babies": 3},  # three or more: no range
        {"weightKg": 53.4, "heightCm": 170, "babies": 1},  # 18.477 -> 18.5 normal (rounding at the cut)
        {"weightKg": 72.2, "heightCm": 170, "babies": 1},  # 24.98 -> 25.0 overweight
        {"weightKg": 86.6, "heightCm": 170, "babies": 1},  # 29.965 -> 30.0 obese
        {"weightKg": 24, "heightCm": 160, "babies": 1},  # weight below 25 kg: refused
        {"weightKg": 60, "heightCm": 230, "babies": 1},  # height above 220: refused
        {"weightKg": 60, "heightCm": 160, "babies": 0},  # no babies: refused
    ]
    write(
        "weight-gain",
        "MR-55 pregnancy weight-gain range (IOM 2009): total gain by pre-pregnancy BMI (rounded to 0.1, WHO bands); "
        "twins provisional; no range for twins with BMI under 18.5 or for three or more babies. Inputs 25-300 kg, "
        "120-220 cm, babies 1-3. Generated by scripts/domain/gen_tool_fixtures.py, not from either client.",
        [{"input": i, "expected": weight_gain(i["weightKg"], i["heightCm"], i["babies"])} for i in wg_inputs],
    )

    # --- MR-53 scan dating (appended to edd-from.json) ------------------------------
    edd_path = FIXTURES / "edd-from.json"
    edd = json.loads(edd_path.read_text(encoding="utf-8"))
    kept = [c for c in edd["cases"] if c["input"].get("method") != "scan"]
    scan_inputs = [
        {"method": "scan", "date": "2026-03-10", "gaWeeks": 12, "gaDays": 3},
        {"method": "scan", "date": "2026-03-10", "gaWeeks": 8, "gaDays": 0},
        {"method": "scan", "date": "2026-06-30", "gaWeeks": 20, "gaDays": 6},
        {"method": "scan", "date": "2026-02-26", "gaWeeks": 4, "gaDays": 0},  # lowest accepted
        {"method": "scan", "date": "2026-02-26", "gaWeeks": 41, "gaDays": 6},  # highest accepted
        {"method": "scan", "date": "2026-02-26", "gaWeeks": 3, "gaDays": 6},  # too early: refused
        {"method": "scan", "date": "2026-02-26", "gaWeeks": 42, "gaDays": 0},  # too late: refused
        {"method": "scan", "date": "2026-02-26", "gaWeeks": 10, "gaDays": 7},  # days out of range
        {"method": "scan", "date": "2027-02-28", "gaWeeks": 10, "gaDays": 1},  # crosses Feb in a non-leap year
        {"method": "scan", "date": "2026-13-01", "gaWeeks": 10, "gaDays": 1},  # invalid date
    ]
    scan_cases = [
        {"input": i, "expected": edd_from_scan(i["date"], i["gaWeeks"], i["gaDays"])} for i in scan_inputs
    ]
    edd["$comment"] = (
        "Due date from what she knows (onboarding, 04_ANDROID_APP_SPEC §3). LMP +280; conception +266; IVF "
        "transfer +266 minus the embryo's age (ACOG Committee Opinion 700); scan date + 280 - the scan's gestation, "
        "accepted 4w0d-41w6d (MR-53; scan cases generated by scripts/domain/gen_tool_fixtures.py)."
    )
    edd["cases"] = kept + scan_cases
    edd_path.write_text(json.dumps(edd, indent=2, ensure_ascii=False) + "\n", encoding="utf-8", newline="\n")

    # --- R13.1 due date by method, with the window (MR-23, MR-24, MR-53) ---------------
    due_inputs = [
        {"method": "lmp", "date": "2026-01-01"},
        {"method": "lmp", "date": "2026-01-01", "cycleLength": 35},  # +7 days
        {"method": "lmp", "date": "2026-01-01", "cycleLength": 21},  # -7 days
        {"method": "lmp", "date": "2026-01-01", "cycleLength": 46},  # outside 21-45: refused
        {"method": "conception", "date": "2026-01-15"},
        {"method": "transfer3", "date": "2026-01-18"},
        {"method": "transfer5", "date": "2026-01-20"},
        {"method": "scan", "date": "2026-03-26", "scanWeeks": 12, "scanDays": 0},
        {"method": "scan", "date": "2026-03-26", "scanWeeks": 3, "scanDays": 6},  # refused
        {"method": "transfer5", "date": "not-a-date"},
    ]
    write(
        "due-date",
        "R13.1 due date by method with the term window: last period +280 shifted by (cycle length - 28) for a "
        "cycle of 21-45 days (MR-23); conception +266; IVF transfer +266 - embryo age; scan + 280 - gestation "
        "(MR-53); window 37w0d-42w0d (MR-24); lmp = due date - 280. Generated by scripts/domain/gen_tool_fixtures.py.",
        [{"input": i, "expected": due_date(i)} for i in due_inputs],
    )
    print("wrote pregnancy-calendar.json, weight-gain.json, due-date.json, edd-from.json (+%d scan cases)" % len(scan_cases))


# MR-23 cycle adjustment bounds (the website calculator's stepper).
MIN_CYCLE = 21
MAX_CYCLE = 45
TYPICAL_CYCLE = 28


def due_date(i: dict) -> dict | None:
    method = i["method"]
    d = parse(i["date"])
    if d is None:
        return None
    if method == "lmp":
        cycle = i.get("cycleLength", TYPICAL_CYCLE)
        if not (MIN_CYCLE <= cycle <= MAX_CYCLE):
            return None
        edd = d + timedelta(days=GESTATION_DAYS + cycle - TYPICAL_CYCLE)
    elif method == "conception":
        edd = d + timedelta(days=GESTATION_DAYS - 14)
    elif method in ("transfer3", "transfer5"):
        edd = d + timedelta(days=GESTATION_DAYS - 14 - (3 if method == "transfer3" else 5))
    elif method == "scan":
        s = edd_from_scan(i["date"], i.get("scanWeeks", -1), i.get("scanDays", -1))
        if s is None:
            return None
        edd = date.fromisoformat(s)
    else:
        return None
    return {
        "edd": iso(edd),
        "termStart": iso(edd - timedelta(days=GESTATION_DAYS - TERM_START_DAYS)),
        "termEnd": iso(edd + timedelta(days=TERM_END_DAYS - GESTATION_DAYS)),
        "lmp": iso(edd - timedelta(days=GESTATION_DAYS)),
    }


if __name__ == "__main__":
    main()

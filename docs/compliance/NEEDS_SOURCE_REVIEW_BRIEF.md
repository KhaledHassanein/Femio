# [NEEDS SOURCE] Review — Reviewer Brief (P0.22)
For: medical reviewer + researcher/compliance · Tool: `NEEDS_SOURCE_TRACKER.xlsx` (this folder) · Full context: `docs/11_NEEDS_SOURCE_CHECKLIST.md`

**Goal.** Clear the **432 verification flags** raised across the 73 persona specs so their content is safe to publish. Hard gate before the Phase-1 content freeze (P1.9). Does **not** block app scaffolding.

**Split the work (see the "Owner" column).**
- **Medical reviewer (OB-GYN / women's-health clinician):** thresholds & dosing (65), claims/scope language (69), clinical statistics (26), guideline positions/wording, and crisis directories (with local partners). ~160 clinician + 137 clinician/research + 46 crisis.
- **Researcher / compliance:** privacy/FTC facts (59) and competitor/market claims (30), plus guideline permalink-only lookups. ~89 pure non-clinical.

**Priority order.** SAFETY-CRITICAL (180) → ACCURACY (163) → INTEGRITY-LEGAL (89). Start with the safety-critical group.

**Per-flag loop.** Verify against a **primary Tier-1/2 source** (MedlinePlus/NIH/CDC/WHO/NHS > ACOG/RCOG/NICE/ATA/ESHRE/NAMS/ASRM); record URL + guideline + version/date in the `Source` column; correct the number/wording in the persona `.md` to match the source (or cut/rephrase if unsourceable); replace the inline `[NEEDS SOURCE]` with the citation; set `Status`, `Reviewer`, `Date`.

**Clear by category, not file-by-file.** Biggest lever: build **one localized `crisis_resources` source of truth** (esp. Arabic/MENA — the largest real gap; needs local clinical partners) to resolve all 46 crisis flags at once; pin all guideline permalinks in one pass.

**Sign-off & cadence.** Each cleared claim gets a named reviewer + date and a **+12-month** re-review (`femio-medical-content` SLA). Track progress on the workbook's **Summary** tab (live counts by status/priority/owner/category).

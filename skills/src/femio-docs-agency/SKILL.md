---
name: femio-docs-agency
description: Femio agency-grade documentation standard - decision logs, phase reports, runbooks, changelogs, and the master TODO governance (no-skip rule). Use at the start and end of ANY Femio work session, phase, feature, or when documenting decisions, and whenever a new task is discovered.
---

# Femio Documentation & Governance Standard

We operate as an agency delivering to a client (Khaled). Every piece of work is documented as if handing off to another team tomorrow.

## The Master TODO covenant (highest rule)
- `archive/2026-11/07_MASTER_TODO.md` is the single source of truth. The moment ANY task/need/requirement is identified — current or future phase — it gets a line with an ID (P#.#, C.#).
- **Nothing is ever skipped or deleted.** Reordering/reprioritizing allowed; removal only with Khaled's explicit approval, then marked `[DEPRECATED — approved YYYY-MM-DD, reason]` and kept in place.
- Statuses: `[ ]` pending · `[~]` in progress · `[x] done (→ doc link, date)` · `[BLOCKED: reason]` · `[DEPRECATED …]`.
- Phase gates (Khaled sign-off) are explicit line items; work past a gate requires the gate marked done.

## Repository documentation structure
```
docs/
  DECISIONS.md          # ADR log: one entry per architectural/product decision
  CHANGELOG.md          # keep-a-changelog format, per release
  phases/PHASE-<n>-REPORT.md   # written at phase close
  runbooks/             # deploy, rollback, incident, backup-restore, translation-release
  compliance/           # DPIA, data map, consent records design
```

## Session protocol (every working session)
1. **Open:** read master TODO → state which item(s) this session targets → mark `[~]`.
2. **During:** new discoveries → add TODO lines immediately (not at the end); decisions → one-paragraph ADR in DECISIONS.md (Context / Decision / Alternatives / Consequences).
3. **Close:** mark items done with doc links; write a session summary (what changed, files touched, follow-ups created); update CHANGELOG if user-visible.

## Phase report template
Objectives vs delivered · evidence (links, screenshots, test output) · metrics · deviations + approvals · lessons learned · carry-over items (added to TODO) · sign-off line for Khaled.

## Writing standards
- Documents are numbered, dated, and state their status (draft/final/living).
- Prose over bullets for reasoning; bullets for checklists only.
- Every claim of "done" links to evidence (commit, test run, deployed URL, screenshot).
- No document says "TODO" without a matching master-TODO line ID.

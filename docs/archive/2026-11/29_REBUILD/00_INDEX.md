# 29 — The rebuild plan (2026-08-23)

The plan that answers `docs/28_TEARDOWN`. It runs bottom-up — infrastructure, data
model, experience engine, content, design system, screens — because the teardown
found the surface thin *and* the layers beneath it thinner than the docs suggested,
and because building the surface first is how we got here.

## What this supersedes

**`docs/27_REVAMP_PLAN_2026-08.md` is superseded by this document.** Its phases 0–6
are absorbed below and its analysis stands; it stays in place per the MASTER_TODO
covenant, marked superseded, and should not be worked from.

**`docs/24_REVAMP_PLAN.md` is *not* superseded.** It is the architecture reference —
ADR-060 and ADR-061 still hold, the backend still owns decisions and the clients
still render them. This plan implements that architecture; it does not relitigate it.

`docs/25_DESIGN_DIRECTION_BRIEF.md` step 1 (an honest competitor teardown) is closed
by `docs/28`. Its remaining steps feed chapter 05 here.

## The rule this plan serves

> Femio must be at least as good as Flo, the pregnancy tracker and Petal **combined**,
> and then carry multiple features none of them have. — OD-14

Sixteen owner directions (OD-1…OD-16) constrain how. They are recorded in
`docs/28_TEARDOWN/11_FINDINGS_LEDGER.md` §1 and restated where they bind, in
chapter 01.

## Chapters

| # | Chapter | Layer |
|---|---|---|
| 01 | [Principles and constraints](01_PRINCIPLES.md) | The decisions everything below inherits |
| 02 | [Data model](02_DATA_MODEL.md) | Schema changes, table by table, with migration order |
| 03 | [The experience engine](03_EXPERIENCE_ENGINE.md) | The versioned module contract, the registry, onboarding as data |
| 04 | [Content and the Learn surface](04_CONTENT.md) | CMS model, locales, review metadata, search |
| 05 | [Design system](05_DESIGN_SYSTEM.md) | Tokens, motion, the chart foundation |
| 06 | [The screens](06_SCREENS.md) | Dashboard, calendar, logging, Learn, tools, visit pack |
| 07 | [Sequence](07_SEQUENCE.md) | Phases, dependencies, definition of done, what we retire |

## How to work from it

Chapters 02–06 are specifications: they say what to build, in enough detail to build
it without another design pass. Chapter 07 says in what order and what "done" means.

**Do not start in chapter 06.** The screens depend on the contract in 03, which
depends on the schema in 02. Building the surface against the current three-field
module contract is building work that gets rewritten — which is the specific trap
`CLAUDE.md` names about pre-R2 screens, and the reason `docs/26` had anything to
audit.

## Status

Written 2026-08-23 from the teardown. **Not yet reflected in
`docs/07_MASTER_TODO.md`** — per OD-1 the gap register and this plan stay
reference-only until Khaled approves them, after which one pass converts the accepted
work into queue lines and phase documents.

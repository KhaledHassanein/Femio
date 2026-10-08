---
name: femio-delegation
description: How Femio work is split between models — cheap, fast subagents (Haiku) for translation QA and content enrichment, a mid-tier subagent (Sonnet) for competitor benchmarking and research, and the lead session reviewing every output before anything lands in the repo. Use when a task is bulk text work across the four locales, content drafting or enrichment, or a comparison of Femio's knowledge base, tools and functions against competitors.
---

# Supervised delegation

The owner's direction (2026-10-08): content and translation work goes to a cheaper model,
other tasks go to whichever model does them well for the least cost, and **the lead session
reviews every output before accepting it**. A subagent proposes; the lead disposes. Nothing
a subagent writes reaches `main` without the lead reading it, checking it against the
product rules, and running the gate.

## Who does what

| Work | Agent (`.claude/agents/`) | Model | Why that model |
|---|---|---|---|
| Translation QA and fill-in for AR/FR/ES (app ARB files, web `messages/*.json`) | `femio-translator` | Haiku | Bounded, string-by-string work with a clear source of truth (English) and a checklist |
| Content enrichment: article outlines, glossary entries, FAQ drafts, alt text, store-listing copy | `femio-content-drafter` | Haiku | Drafting from sources we supply; every medical claim is flagged, never invented |
| Competitor benchmarking: our knowledge base, calculators and app functions against women's-health apps and sites, with ranked enhancements | `femio-competitor-analyst` | Sonnet | Needs web research and judgement across many sources; Haiku misses nuance here |
| Architecture, medical logic, anything touching the six product rules, merges, releases | the lead session | — | Never delegated |

If an agent definition is not loaded in the session (they load at session start), call
the Agent tool with `model: "haiku"` or `model: "sonnet"` and paste the definition's body
as the prompt preamble. Run independent agents in the background and in parallel.

## The contract every brief carries

1. **Read-only by default.** The agent writes its proposal to
   `docs/30_REVAMP/delegated/<date>-<task>.md` (or returns it), never edits product files
   directly unless the brief says so, and never commits, pushes or opens PRs.
2. **Sources or flags.** Every medical or statistical claim carries a Tier-1/2 citation
   (WHO, NHS, ACOG, NICE, RCOG, CDC, Cochrane, a peer-reviewed paper) or `[NEEDS SOURCE]`.
   An invented fact is a rejected output, not a fixable one.
3. **Product rules in the brief.** Wellness only, never diagnosis or contraception;
   ranges, never certain dates; personalise, never restrict; the wordmark is always
   "femio"; Arabic is first-class (Modern Standard Arabic, Western digits per ADR-069).
4. **A structured return.** Tables with a column the lead can tick: `accept / fix / reject`.

## The lead's review (do every step; record the verdict)

1. **Spot-check, don't skim.** For translations, read every changed Arabic string and a
   sample of at least 20% of FR/ES, more if the first sample has errors. For content,
   open every cited source the claim depends on. For benchmarking, verify each competitor
   claim that would change our plan against a primary source (store listing, help centre,
   the product itself), and every "competitor has X" that drives a P0/P1 recommendation.
2. **Run the guards.** `pnpm gate` (claims lint, untranslated lint, i18n parity,
   vocabulary sync) and, for the app, `flutter analyze` and `flutter test`.
3. **Judge against the rules.** Reject anything that diagnoses, implies contraception,
   gives a single certain date, gates knowledge by persona, or transliterates the logo.
4. **Record the verdict** at the top of the delegated file: accepted / accepted with fixes
   (list them) / rejected (why). Rejections are kept: they show what the agent gets wrong
   and sharpen the next brief.
5. **Only then** apply the accepted parts, in the lead's own commit, through the normal
   generators (for example, app strings shared with the website change in
   `apps/web/messages/*.json` and flow through `scripts/mobile/sync-log-vocabulary.mjs`,
   never by editing generated files).

## Known failure modes (add to this list as they appear)

- Cheap models "fix" Arabic medical terms into colloquial dialect, or translate brand
  and product names. Keep MSA; keep "femio", "Flo", "Clue" as written.
- Competitor feature lists go stale fast and marketing pages overclaim. A feature counts
  only if it is visible in the shipped product or its help centre, with a date checked.
- Benchmarking agents recommend copying everything. The lead filters every
  recommendation through the wedge (Arabic-first TTC → pregnancy with PCOS depth, D1) and
  the deferred list (AI chat, community, billing).

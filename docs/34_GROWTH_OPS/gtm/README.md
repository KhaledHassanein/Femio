# Tag Manager container export (owner guide part D, step 6)

`femio-container.json` is a Google Tag Manager **container export** that holds everything
the measurement design needs (`../01_ANALYTICS_AND_PIXELS.md` §4): the GA4 configuration
tag, seven GA4 event tags, their custom-event triggers, the data-layer variables, and the
consent settings that make every tag wait for the visitor's Allow. It carries **no ids of
yours**: the GA4 Measurement ID is a constant variable you fill in once.

## How to import (10 minutes)

1. Create the container first (guide D1) and enable the consent overview (D2).
2. Tag Manager → **Admin** → **Import Container** → choose `femio-container.json` →
   workspace: **Existing → Default Workspace** → **Merge** → **Rename conflicting** → Confirm.
3. **Variables → User-Defined → `const · GA4 measurement id`** → replace `G-REPLACE-ME` with
   your `G-…` id from guide C4 → Save.
4. **Preview** (guide D9): on load every consent type reads *Denied* and the GA4 tag sits
   under "Tags not fired"; after Allow it fires; a calculator tap shows `calculator_open`
   then `calculator_used` with only `calculator_slug`.
5. **Submit → Publish** as `v1 consent + GA4`.

## What is inside

| Kind | Name | Notes |
|---|---|---|
| Variable (constant) | `const · GA4 measurement id` | the one value you edit |
| Variables (data layer) | `dl · page_type`, `dl · page_language`, `dl · article_slug`, `dl · article_locale`, `dl · calculator_slug`, `dl · placement`, `dl · country`, `dl · from_locale`, `dl · to_locale`, `dl · source_host` | read from the site's pushes; nothing else is read |
| Trigger | `ev · femio_page` and one per event | Custom Event triggers named exactly as the site's events |
| Tag | `GA4 · configuration` | Google tag; fires on Initialization; requires `analytics_storage` |
| Tags | `GA4 · article_read`, `GA4 · calculator_open`, `GA4 · calculator_used`, `GA4 · get_app_click`, `GA4 · help_now_open`, `GA4 · language_switch`, `GA4 · outbound_source_click` | GA4 Event tags with only the allow-listed parameters; each requires `analytics_storage` |

Not included (added by you in the console, guide E6): the Meta Pixel tags, because the
template comes from the gallery and carries your Pixel ID. The `femio_page` event is
consumed by the configuration tag through `page_type` and `page_language` as user-visible
event parameters on `page_view`; no separate tag is needed.

**2026-10-30:** the first import failed with "File format is invalid": the event tags referenced the
configuration tag the retired way (`TAG_REFERENCE` on `measurementIdOverride`) and `consentSettings`
was shaped like a parameter. Both are fixed; `scripts/gtm-container-lint.mjs` (in `pnpm gate`) now
checks the shapes Tag Manager accepts. Re-download the file before importing again.

If the import reports a validation error, the export format changed since 2026-10-30: tell a
session the exact message.

# 01 · Analytics and pixels: measuring visits without touching her records

**Status: design, gated by ADR-075 (proposed).** This document is the specification a session
builds from once the owner accepts the ADR. The owner's clicks are in
`04_OWNER_GUIDE_GROWTH_A_TO_Z.md` parts C, D and E. Everything here is the website only;
the app keeps no analytics (rule 4, ADR-072).

## 1 · What is measured, in one table

| Question | Source | Needs code in the site? | Needs consent? |
|---|---|---|---|
| How many people visit, from where, in which language, on which device | GA4 through GTM | one component | yes |
| Which pages and calculators are opened; how far people scroll | GA4 (enhanced measurement + 9 custom events) | the same component | yes |
| How many click "Get the app" and from which page | GA4 event `get_app_click` | the same component | yes |
| How many of those installed | Play Console → Store performance → acquisition, by UTM | none (links already carry `utm_*`, `04_GROWTH_PACK.md` §3.5) | no |
| Which Google queries show the site, at what position | Google Search Console | none (meta tag already supported: `NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION`) | no |
| Who installed, kept, uninstalled; crashes; ratings | Play Console | none | no |
| How visitors from Facebook/Instagram behave; a Meta audience of site visitors for later organic reach | Meta Pixel through GTM (PageView + ViewContent + Lead on "Get the app") | the same component | yes |
| Aggregate page views without consent (fallback for the "declined" majority) | Vercel Web Analytics (cookieless) **or** GA4 cookieless pings under Consent Mode (modelled) | one line in the layout (Vercel) or nothing (Consent Mode pings) | no (cookieless) |

**What is never measured:** anything a woman types or taps inside a calculator (dates, cycle
length, symptoms), any result shown to her, any free text, any identifier of hers. The app
sends nothing. The feedback form warns against health details and is read by hand.

## 2 · Architecture

```
browser ──► femioapp.com (static)  ─ no server of ours
   │
   ├─ consent banner (AdSense Privacy & messaging, certified; TCF v2.3 string)
   │      └─ writes Consent Mode v2 state: analytics_storage, ad_storage,
   │         ad_user_data, ad_personalization  (default: denied)
   ├─ Google Tag Manager container  GTM-XXXXXXX   (the only script we add)
   │      ├─ GA4 configuration tag   (fires on consent: analytics_storage)
   │      ├─ GA4 event tags          (9 named events, allow-listed parameters)
   │      ├─ Meta Pixel base + events (fires on consent: ad_storage)
   │      └─ (later) AdSense page-level tag on article template only
   └─ Play link with utm_source=femioapp.com&utm_medium=web&utm_campaign=<page>
                     └─ Play Console acquisition report (no SDK)
```

One container means one script in the site and every later tag is a click in GTM, not a
deploy. That is the "least coding" the owner asked for.

## 3 · Consent (Consent Mode v2, default denied)

The site sets the default **before** the GTM script loads:

```html
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('consent', 'default', {
    ad_storage: 'denied', ad_user_data: 'denied', ad_personalization: 'denied',
    analytics_storage: 'denied', functionality_storage: 'denied',
    personalization_storage: 'denied', security_storage: 'granted',
    wait_for_update: 500
  });
</script>
```

Source: Google Tag Platform, "Manage consent settings" (developers.google.com/tag-platform/
security/guides/consent). The certified banner updates the state; tags configured with
built-in consent checks fire only after the update. One banner for every visitor, not only the
EEA: simpler to reason about, and Saudi PDPL and Egypt PDPL both expect consent for
non-essential cookies (**[NEEDS SOURCE]** for the exact cookie reading of each law; the legal
pack §6 tracks it).

Banner copy (four locales, through the normal message catalogue; the AdSense banner lets us
edit text): *"femio measures visits to improve the site. Nothing you enter in a calculator is
ever sent. Allow measurement?"* with **Allow** / **Only necessary** / **Settings**. The decline
button is as prominent as the accept button (the gate's crisis-lint style check already
enforces equal buttons on legal pages; extend it to the banner).

## 4 · The event list (closed allow-list)

| Event | When | Parameters (only these) | Meta mirror |
|---|---|---|---|
| `page_view` | every page (GA4 automatic) | `page_location`, `page_language`, `page_type` ∈ {home, learn, article, hub, calculator, help, legal, app} | PageView |
| `scroll` | 90 % (GA4 enhanced measurement) | — | — |
| `article_read` | article visible ≥ 45 s | `article_slug`, `article_locale` | ViewContent |
| `calculator_open` | a calculator page shown | `calculator_slug` | ViewContent |
| `calculator_used` | the first tap on the calendar | `calculator_slug` | — |
| `get_app_click` | any "Get the app" / Play link | `page_type`, `placement` ∈ {header, hero, inline, footer, calculator_result} | Lead |
| `help_now_open` | help-now page shown | `country` (the country *selected on the page*, not geolocation) | — |
| `language_switch` | locale switcher used | `from_locale`, `to_locale` | — |
| `outbound_source_click` | a citation link clicked | `source_host` | — |
| `ad_blocked` (later) | AdSense reports no fill because of a blocker | — | — |

**Forbidden by test:** any parameter whose name or value matches a date, a count of days, a
symptom key, a result label, or free text. `apps/web/src/lib/consent/events.ts` exports the
allow-list; `events.test.ts` fails on any other key, and `analytics-lint.mjs` fails if
`dataLayer.push` appears outside that module.

## 5 · Meta Pixel on a health domain: what to expect

Meta classifies data sources by domain. A women's-health site is likely to be placed under
**Core Setup** (standard events only, no custom events, no custom parameters, no URL
parameters) or a stricter tier (Meta Business Help 1402913027039332; secondary summaries by
Sagapixel and Aixel, 2025–2026). The design above already uses only PageView, ViewContent
and Lead with no parameters, so a restriction changes nothing. Meta's Business Tools Terms
forbid sending health information; we send none. Use: a custom audience of site visitors for
organic lookalike reach later; **no paid ads in the plan** (G7 in the growth pack).

## 6 · Implementation spec for the session (after ADR-075 is accepted)

Files (all under `apps/web/`):

| File | Purpose |
|---|---|
| `src/lib/consent/consent-default.ts` | the default-denied snippet as a string, rendered inline in `<head>` before GTM |
| `src/lib/consent/gtm.tsx` | the GTM loader component; reads `NEXT_PUBLIC_GTM_ID`; renders nothing when unset (so preview and tests stay clean) |
| `src/lib/consent/events.ts` | `track(event, params)` with the allow-list; the only `dataLayer.push` in the codebase |
| `src/lib/consent/events.test.ts` | rejects unknown events and parameters; asserts the default state is denied |
| `src/lib/consent/gtm.test.tsx` | renders nothing without the id; renders one script with it; the consent default precedes it |
| `e2e/consent.spec.ts` | no request to `google-analytics.com`, `googletagmanager.com/gtag`, or `facebook.com/tr` before the banner is answered; one after "Allow" |
| `scripts/analytics-lint.mjs` | keep forbidding every analytics/ads package; allow `googletagmanager.com` only from `gtm.tsx`; keep the app rules untouched |
| `messages/{en,ar,fr,es}.json` | `consent.*` strings if a custom banner is ever needed (the AdSense banner carries its own text) |
| `src/app/[locale]/layout.tsx` | mounts the default snippet then `<Gtm/>` |
| `docs/33_REBUILD_V3/03_LEGAL_PACK.md` | privacy notice: website section rewritten (what is measured, by whom, how to withdraw: the banner's Settings link); cookie table |

Order: write the tests first (they fail), the component, the lint change, the legal text, then
the owner creates the container (guide part D) and a session pastes the id into Vercel as
`NEXT_PUBLIC_GTM_ID`. Verification: GTM Preview mode shows no tag firing before consent;
GA4 DebugView shows the nine events with only their listed parameters; the e2e test passes
against the deployed preview; Lighthouse best-practices stays ≥ 95 on an article.

## 7 · The weekly measurement page (routine R7)

One Markdown page a week in `reports/weekly/YYYY-WW-measurement.md` with: sessions by
country and language; top 10 pages; calculator opens and uses; `get_app_click` count and
rate per page type; Play installs by UTM campaign (from the CSV the owner uploads); retained
installers; Search Console clicks, impressions, average position for the Arabic wedge queries;
a three-line "what changed and what we do about it". No raw exports are committed, only the
summary table.

## 8 · What the owner sees without opening any console

The R7 page, the interactive checklist's "Measurement" tile (green when Search Console,
GA4 and Play Console each reported in the last 7 days; the owner ticks it), and one sentence
in `docs/STATE.md`.

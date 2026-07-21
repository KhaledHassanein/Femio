# Femio V2 — Tech Stack, Skills, Tools, Accounts & Checklist

## 1. Verdict on your web-first question
**Yes — web-first is the right call.** One responsive Next.js PWA gives you: SEO (the competitors' weakest flank), lowest cost/credits, one codebase, installable app-like experience on phones, and a clean later path to stores via **Capacitor** (wraps the same code into Android/iOS binaries; update web = update everywhere). The backend is shared from day one, so a future native rebuild (if ever needed) changes nothing server-side.

## 2. Recommended stack (lean, low-code-volume, store-compliant)
| Layer | Choice | Why |
|---|---|---|
| Frontend | **Next.js 15 (App Router) + TypeScript + Tailwind CSS + shadcn/ui** | SSR/SSG for SEO, PWA-capable, huge ecosystem, minimal boilerplate |
| i18n | **next-intl** + ICU messages; `dir=rtl` native | 4 locales + RTL from scratch; strings live in DB via translation portal |
| Backend | **Supabase** (Postgres + Auth + RLS + Storage + Edge Functions) | One managed service replaces auth server, DB, file storage, realtime; row-level security fits health data; cheapest path |
| API style | Postgres RLS + thin Edge Functions; REST/RPC | Least code; mobile apps reuse identically |
| CMS | **Payload CMS** (self-hosted, same Postgres) — or Strapi | Admin UI out-of-the-box: articles, blog, review workflow, localization fields → your translation portal builds on it instead of from scratch |
| Admin portal | Payload admin + custom Next.js admin routes (analytics, CS inbox, moderation, string-translation editor) | Buy-don't-build for 70% of it |
| Analytics | **PostHog** (EU cloud) product analytics + **Plausible/GA4** web | Anonymized member analytics dashboard requirement; PostHog embeds/queries into admin |
| Email/notifications | Resend or Brevo (email), Web Push; FCM/APNs later via Capacitor | |
| Payments | **Stripe** (global) + **Paddle or LemonSqueezy** (merchant-of-record alternative, easier tax) + regional (Paymob/Tap for Egypt/MENA) | App-store IAP only needed at Phase 4 (RevenueCat then) |
| Search | Postgres full-text + Meilisearch (later) | Library/article search in 4 languages |
| Hosting | **Vercel** (frontend) + Supabase cloud; EU region for GDPR | Free tiers to start |
| Repo/CI | GitHub + GitHub Actions (lint, typecheck, tests, preview deploys) | Documentation & quality gates |
| Errors/monitoring | Sentry | |
| Mobile (Phase 4) | **Capacitor 8** + RevenueCat + FCM/APNs | Same codebase to both stores |

**Why not Flutter again:** Flutter Web is poor for SEO and page weight; the V1 codebase stays archived. If native-feel becomes critical later, a Flutter/native client can consume the same Supabase backend.

## 3. E-commerce advice (your Shopify question)
**Recommendation: do NOT build commerce into Femio's backend.** Use **Shopify Basic** with:
- **Shopify Storefront API (headless)** → store pages render inside the Femio site/app with our design; cart/checkout handled by Shopify (PCI, taxes, shipping).
- **Shopify Markets** for country-based catalogs/currencies/pricing — solves your "country-based stores" need in one dashboard.
- Admin: Shopify admin manages products/orders; deep-link it from the Femio admin portal.
This saves months of work (payments, inventory, fraud, shipping) and stays swappable. Build native commerce only if/when volume justifies it. For Egypt-local selling, Paymob-based checkout or Shopify with local gateway can be phase-decided.

## 4. Claude skills to create (I can draft these; you generate/approve)
1. **femio-engineering-standards** — enforce lean code rules: no dead code, no unused deps, server components by default, zero hardcoded strings (all via i18n keys), zero magic numbers, accessibility (WCAG 2.2 AA), conventional commits, file-size ceilings — the "not-vibe-coded" skill.
2. **femio-design-system** — brand tokens (palette, typography incl. Arabic font pairing e.g. Inter + IBM Plex Sans Arabic, spacing, radii), component patterns, empty/loading/error state standards, RTL rules, "screenshot-worthy" checklist.
3. **femio-medical-content** — article template (author/reviewer/sources/review-date), tone, reading level (grade 6–8), disclaimer blocks, citation rules per doc 04, per-locale medical terminology glossary.
4. **femio-seo-aso** — YMYL/E-E-A-T checklist, metadata/schema.org (MedicalWebPage, FAQPage), hreflang for 4 locales, internal-linking rules; ASO (title/subtitle/keywords per store per locale) for Phase 4.
5. **femio-i18n-workflow** — string-key naming, ICU plural rules, AR/FR/ES style guides, RTL QA checklist, translation-portal workflow (machine draft → human review → publish).
6. **femio-docs-agency** — documentation standard: every phase produces a numbered doc (decision log, changelog, runbooks) — your agency-grade output requirement.
7. **femio-compliance-privacy** — GDPR/PDPL rules, consent patterns, data-retention map, health-data handling do's/don'ts, disclaimer placement.
(You already have docx/pptx/pdf/xlsx + theme-factory + web-artifacts-builder here; the SEMrush/Ahrefs-style MCP connectors already connected to this session will power SEO research.)

## 5. Accounts / access checklist
**Now (Phase 0–1):**
- [ ] GitHub org (femio) + repo
- [ ] Vercel account (hobby → Pro)
- [ ] Supabase project (EU region)
- [ ] Domain: femio.app / femio.health + Cloudflare DNS
- [ ] Google Workspace or Zoho (support@, hello@)
- [ ] PostHog (EU) + Google Search Console + Bing Webmaster
- [ ] Sentry
- [ ] Resend/Brevo (email)
- [ ] Figma (design) — you have a Figma MCP connected already
- [ ] DeepL API (machine-translation drafts for the portal)
**Phase 2–3:**
- [ ] Stripe (or Paddle/LemonSqueezy) + regional gateway (Paymob/Tap)
- [ ] Shopify Basic + Storefront API token
- [ ] Affiliate networks (Amazon Associates, iHerb, relevant device makers)
- [ ] Medical reviewer contract (MD/OBGYN sign-off) — you (Dr. Khaled) may cover part of this
**Phase 4:**
- [ ] Apple Developer ($99/yr) + Google Play ($25) + RevenueCat
- [ ] App Store Connect / Play Console health-app declarations
**Legal (Phase 1):**
- [ ] Privacy policy + terms (health-data-specific), cookie consent (EU), DPIA document, company entity + trademark check on "Femio"

## 6. Languages/tools summary (one line)
TypeScript everywhere (Next.js + Supabase Edge Functions), Postgres SQL, Tailwind, ICU MessageFormat, GitHub Actions YAML — deliberately one language across the stack to minimize code and context-switching.

## 7. Cost envelope (start)
~$0–50/mo until traffic (Vercel free/Pro $20, Supabase free→$25, PostHog free tier, domain ~$30/yr); Shopify $39/mo when store launches; Apple/Google fees at Phase 4.

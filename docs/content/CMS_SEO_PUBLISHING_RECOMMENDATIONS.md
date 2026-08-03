# Femio CMS and SEO publishing recommendations

Updated: 2026-08-03

## Audit result

The current Payload article form is a safe minimum for drafting and medical approval, but it is not yet a complete publishing and SEO model. It stores a localized title, slug, excerpt, rich-text body, review status, an internal reviewer account, review dates, reading-level confirmation, disclaimer type, and sources.

The public site already supplies canonical links, `hreflang`, a sitemap, breadcrumbs, `MedicalWebPage` structured data, and basic title/description metadata. The highest-priority gaps are public authorship, dedicated SEO and social fields, complete `Article` structured data, representative images, visible article dates, and locale-aware publishing.

## Priority 0: add before publishing health articles

### Public author and reviewer profiles

Add these relationships to Articles:

- `authors`: relationship to `people`, supports one or more authors.
- `medicalReviewerProfile`: relationship to `people`, required for approved health content.

Keep the existing `medicalReviewer` relationship to `users` for workflow authorization and audit history. Do not expose staff email addresses as public bylines. The public article should show the named author and clinician reviewer, their credentials, and links to their People pages.

### Dedicated SEO group

Add a sidebar group named `seo` with:

- `seoTitle`: localized text. Recommended editorial target: concise and usually about 30–60 characters. It must remain editable separately from the H1.
- `metaDescription`: localized textarea. Recommended editorial target: a unique, useful summary, usually about 120–160 characters.
- `canonicalOverride`: optional URL for exceptional cases only. Generate the canonical from locale and slug by default.
- `noIndex`: checkbox, default false for publishable content and true for preview-only or intentionally excluded pages.
- `socialTitle`: localized text with fallback to `seoTitle`, then title.
- `socialDescription`: localized textarea with fallback to `metaDescription`, then excerpt.
- `socialImage`: upload relationship to Media. Require useful localized alt text in the Media record.

Do not add a meta-keywords field. Search engines do not need it, and it encourages keyword stuffing.

### Publishing and freshness

Add:

- `firstPublishedAt`: date set when the article is first published and retained on later edits.
- `contentUpdatedAt`: optional editorial date for a meaningful content update; do not use a date bump for trivial changes.
- Continue using `lastReviewed` and `nextReviewDue` for medical review.
- `changeSummary`: optional short note for material corrections or major updates.

Show the published, updated, and medically reviewed dates where they are relevant. Send `datePublished` and `dateModified` in `Article` JSON-LD.

### Article structured data

The public article page should emit `Article` or `BlogPosting` JSON-LD in addition to the existing `MedicalWebPage` and `BreadcrumbList`. Include:

- `headline`
- `description`
- `mainEntityOfPage`
- `inLanguage`
- `author` with each author's name and profile URL
- `reviewedBy` for the clinician reviewer
- `publisher` and logo
- `datePublished`
- `dateModified`
- representative `image`

Structured data must describe content that is visible on the page. Validate it with Google's Rich Results Test before launch.

### Publication gate improvements

Extend the existing review hook so publishing also requires:

- At least one public author profile
- A public medical reviewer profile for health content
- `lastReviewed` and `nextReviewDue`
- Reading-level confirmation
- The correct disclaimer type
- Required sources when the content makes medical or health claims
- SEO title and meta description
- Social image with alt text
- Completion of the current locale's review

Marketing-only articles can use a separate content category with an editorial/legal approval rule instead of forcing medical citations where no medical claim is made.

## Priority 1: strongly recommended

### Structured summary and FAQs

Add:

- `summary`: localized rich text or textarea for the answer-first summary shown above the article body.
- `relatedFAQs`: relationship to the existing FAQ collection, or a localized FAQ array if questions are article-specific.

Render selected FAQs visibly on the article page before emitting `FAQPage` structured data. FAQ markup may help machines understand the page, but Google limits FAQ rich-result visibility mainly to established health and government sites, so it should not be treated as a guaranteed traffic feature.

### Taxonomy and internal linking

Add:

- `category`: controlled relationship, such as Cycle Health, Trying to Conceive, Pregnancy, or Menopause.
- `topics`: controlled tags rather than free-form keyword stuffing.
- `relatedArticles`: curated article relationships.
- `relatedTools`: curated links or relationships to matching calculators and trackers.

Generate a table of contents from body headings instead of asking editors to maintain one manually. Add stable heading IDs so search results and users can link to specific sections.

### Slugs, translations, and redirects

The current slug is shared across locales, while the SEO plan calls for localized slugs. Choose and enforce one approach:

1. Localize slugs and maintain a translation group that connects the EN/AR/FR/ES versions; or
2. Keep the same slug in every locale and revise the SEO documentation to match.

Only output `hreflang` for locale versions that are actually published and medically approved. Add redirect history so a changed slug automatically creates a permanent redirect from the old URL.

### Preview and scheduling

Add:

- Draft preview from Payload to the web app
- Scheduled publish and unpublish times
- A search-result preview showing final title, URL, and description
- A social-card preview
- Character guidance in the admin UI as advice, not hard SEO law

## Priority 2: quality and operations

- Add a content owner and review reminders.
- Add a correction-reporting link and correction log.
- Add link validation for internal and external links.
- Add checks for missing image alt text, broken heading order, duplicate H1s, and empty excerpts.
- Add a reading-time display calculated from the final body.
- Add Search Console verification and submit the production sitemap after `femioapp.com` is connected.
- Run Lighthouse, accessibility, and structured-data checks in CI.
- Track search performance by page in Search Console without sending health logs or sensitive user data to analytics tools.

## Fields for the first Femio article

Use these values for `meet-femio`:

| CMS field | Value |
|---|---|
| Title / H1 | Meet Femio: Your Women's Health Tracking Companion |
| Slug | meet-femio |
| Excerpt | Meet Femio, a women's health app for cycle and symptom tracking, free calculators, private health logs, and better-prepared clinician visits. |
| SEO title | Femio App: Women's Health Tracking Features & Guide |
| Meta description | Discover how the Femio women's health app helps you track periods and symptoms, use free calculators, protect your privacy, and prepare for care. |
| Canonical | https://femioapp.com/en/learn/meet-femio |
| Disclaimer | General wellness |
| Robots while draft | noindex, nofollow |
| Robots after approval and publication | index, follow, max-image-preview:large |
| Social image | 1200 x 630 px branded product image; do not use a generic medical stock photo |
| Social image alt | Femio dashboard showing private cycle and symptom tracking tools |

The Markdown source contains one H1 so it reads correctly as a standalone document. When entering it in Payload, put the H1 in the Title field and start the rich-text Body with the introductory paragraph. Do not paste the H1 into Body, because the public page already renders the Title as its H1.


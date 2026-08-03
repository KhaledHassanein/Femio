# Femio global crisis-resource routing

Status: medically reviewed  
Reviewer: Mohamed K.  
Review date: 2026-07-23  
Next review due: 2027-07-23  
Owner: `femio-medical-content`

This is the single source of truth for crisis-resource wording in all Femio
personas. Persona specifications should reference this document rather than
copying telephone numbers or maintaining country lists.

## User-facing global fallback

> If you may act on thoughts of harming yourself or someone else, or you are in
> immediate danger, contact the emergency services available where you are now
> or go to the nearest emergency department. You can also use
> [Find A Helpline](https://findahelpline.com/) to find a crisis service for
> your country. If you can, stay with someone you trust while you get help.

For a user worried about another person:

> If you think the person is in immediate danger, do not leave them alone if it
> is safe for you to stay. Contact the emergency services available where they
> are, a crisis service, a health worker, or a trusted family member.

Do not promise that a helpline is confidential, anonymous, free, continuously
open, multilingual, or able to dispatch emergency help unless that exact
service attribute has been re-verified. Do not infer a user's location from
language. Let the user select or change their country and provide the global
fallback even when location is unavailable.

## Directory policy

- Link to a maintained country selector instead of copying a static global
  telephone-number list. Find A Helpline states that participating services
  verify their information directly and that it covers 175+ countries.
- Femio must confirm commercial-use/linking or integration terms with
  ThroughLine before production release. Until then, this is an external-link
  specification, not authorization to ingest, reproduce, or embed its dataset.
  **Terms reviewed 2026-08-03 (Claude Code — engineering analysis, not legal
  advice; DPO to countersign).** ThroughLine's Terms of Service
  (<https://www.throughlinecare.com/terms-of-service>) were read against what
  Femio actually does. Findings:
  - The terms **place no restriction on third parties linking in**. They address
    ThroughLine's own outbound links ("we do not control… not responsible nor
    liable") and say nothing about inbound hyperlinks, which is the ordinary
    position for a public website.
  - What *does* need prior written permission is using **the Services** for a
    commercial purpose, commercially exploiting/selling/licensing/distributing
    them, scraping, reverse engineering, the **API or widgets**, and
    **partner-branded** subdomains (`[company].findahelpline.com`).
  - Femio does none of those. The implementation is a single plain outbound
    `<a href="https://findahelpline.com">`: canonical host only, **no query
    string or fragment** (build-fails otherwise — `lib/crisis/directory.ts`), no
    embedding, no API call, no copy of their dataset, `referrerPolicy="no-referrer"`.
    The user's own visit to a free public service is theirs, not a Femio
    integration.
  - **Residual question for the DPO:** the "commercial purpose" clause is written
    around use *of the Services*, not around being linked to. A one-line written
    confirmation from ThroughLine removes the ambiguity for the cost of an email;
    a draft is in `docs/compliance/THROUGHLINE_LINK_CONFIRMATION.md`. Until it is
    answered, the assessment above is the record, and the link may stay: it is a
    safety feature, and removing it would leave people with fewer routes to help.
  - Re-check on the 12-month cadence below, or sooner if ThroughLine changes terms.
- A failed lookup must fall back to local emergency services or the nearest
  emergency department; it must never return an empty crisis screen.
- Numbers for named national services may appear only in country-specific
  content after re-verification. Never present a US or UK number as a global
  fallback.
- Support organizations that explicitly say they are not crisis services
  (including general peer-support, maternal-health, eating-disorder, or
  bereavement services) must remain visually separate from the urgent route.
- When a user seeks non-emergency topic-specific support, the maintained
  directory may be opened with a topic filter (for example, eating and body
  image or abuse and domestic violence). A topic result is support routing, not
  a diagnosis, treatment recommendation, or substitute for urgent routing.
- Re-check the directory, link, wording, accessibility, and commercial terms
  at least every 12 months and before each affected market launch.

## Implementation acceptance criteria

1. “Need help now?” is persistently reachable and not gated by a questionnaire
   total.
2. Any affirmative self-harm response uses the urgent route independently of
   the total score. A questionnaire without a self-harm item must not be
   described as detecting self-harm.
3. Country selection is explicit and changeable. Language and country are
   independent settings.
4. The interface clearly distinguishes emergency/crisis services from
   non-emergency support services.
5. If a third-party directory is unavailable, the WHO-aligned global fallback
   remains visible.
6. Translations, including Arabic and right-to-left layouts, receive human
   linguistic review before release.

## Primary/current sources

- [WHO — Suicide: questions and answers (18 September 2024)](https://www.who.int/news-room/questions-and-answers/item/suicide):
  immediate danger warrants contacting emergency services or a crisis line;
  when another person is in immediate danger, do not leave them alone and
  contact emergency services, a crisis line, a health worker, or family.
- [WHO — Preventing suicide: a resource for establishing a crisis line
  (2 September 2018; WHO-MSD-MER-18.4)](https://www.who.int/publications/i/item/WHO_MSD_MER_18.4):
  crisis lines are a complementary component of suicide-prevention services.
- [Find A Helpline — About (accessed 23 July 2026)](https://findahelpline.com/about):
  country-based directory whose participating helplines verify information
  directly; commercial users are directed to contact ThroughLine.
- [Find A Helpline — Eating & body image (accessed 23 July
  2026)](https://findahelpline.com/topics/eating-body-image): country-selectable
  topic directory, including listings across the Americas, Asia, Europe,
  Oceania, and Africa; availability differs by country.
- [Find A Helpline — Grief & loss (accessed 23 July
  2026)](https://findahelpline.com/topics/grief-loss): maintained
  country-selectable support route for grief and loss.
- [Find A Helpline — Abuse & domestic violence (accessed 23 July
  2026)](https://findahelpline.com/topics/abuse-domestic-violence): maintained
  country-selectable support route for abuse and domestic violence. Use the
  urgent emergency fallback whenever immediate danger is present.

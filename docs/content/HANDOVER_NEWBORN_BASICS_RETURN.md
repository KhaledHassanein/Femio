# Return handover — newborn basics seed set (drafted 2026-08-17)

Written against `docs/content/HANDOVER_NEWBORN_BASICS.md` §5. Eight drafts are in
`docs/content/articles/`. `pnpm content-lint` and `pnpm content-lint:urls` are both clean.

---

## Part 1 — Batch note

### What was written

Eight English drafts, `status: "draft"`, `disclaimer_type: "emergency"`, every byline and date
left `PENDING` / `null`.

| Slug | Words | Sources | Internal links |
|---|---|---|---|
| `newborn-first-two-weeks` (pillar) | ~1,430 | 4 | 6 |
| `feeding-your-newborn` | ~1,020 | 4 | 5 |
| `newborn-warning-signs` | ~1,160 | 4 | 5 |
| `newborn-crying` | ~1,105 | 3 | 5 |
| `safer-sleep-for-your-baby` | ~1,125 | 4 | 5 |
| `newborn-nappies-skin-and-cord` | ~1,115 | 5 | 4 |
| `bottle-and-formula-feeding` | ~1,115 | 4 | 4 |
| `newborn-checks-and-vaccinations` | ~1,055 | 6 | 4 |

Every article carries the same red-flag box, worded from the newborn set in the prompt §4.5, with
one addition on `newborn-crying` (a weak, high-pitched or continuous cry that is not the baby's
usual cry — NHS lists it, and it is the cry article). The box always closes with "Femio cannot
assess a baby". Emergency routing is global and number-free everywhere: "contact your local
emergency services or go to your nearest emergency department".

The boundary sentence sits in the answer-first opening of all eight, naming a midwife, health
visitor, paediatrician or emergency service as the place an individual baby's question goes.

### What was deliberately cut for lack of a source

- **Any "how many wet nappies per day" number.** The commonly circulated day-by-day counts could
  not be traced to a Tier-1 document. The articles describe a clear drop from the baby's own
  pattern, plus the NHS threshold of no wet nappy in 12 hours as urgent, and route the judgement
  to a clinician.
- **Newborn sleep totals** ("newborns sleep 16–17 hours"). No Tier-1 citation found that states
  it in a form worth quoting, and it invites a sleep verdict. Replaced with "short blocks, day
  and night, and adds up differently for every baby".
- **A crying-hours figure** (the "peaks at ~2–3 hours a day at 6 weeks" style claim). NHS and CDC
  describe the *shape* of the curve without a number, so only the shape is stated.
- **Cord separation timing as a range** ("5–15 days"). AAP's checkable statement is that a stump
  still attached at three weeks needs a check, so that is what is written.
- **SIDS incidence statistics.** AAP's parent page carries a US figure, but a single-country
  number in a four-locale product reads as a global one. Cut; the risk-reduction advice stands
  without it. Same reasoning for the CDC abusive-head-trauma mortality statistics — the safety
  behaviour is the message, not the death rate.
- **Colic prevalence and any colic remedy** (drops, probiotics, formula changes). No Tier-1
  support that survives the no-regimen rule.
- **Jaundice prevalence** ("around 6 in 10 newborns"). The NHS page describes the pattern rather
  than the rate in the section consulted, so only the pattern and the escalation routes are used.

### Where guidance differs between countries, and how it was handled

Three genuine splits, each stated plainly with both sides cited:

1. **Bed sharing** (`safer-sleep-for-your-baby`). AAP does not recommend bed sharing at all and
   advises room sharing without it. NHS also names a separate cot as safest, then publishes
   "co-sleeping more safely" advice because families do it anyway. The article gives the shared
   core first (back, firm flat clear surface, room sharing, never a sofa or armchair, the
   absolute contraindications both bodies agree on), then names the split and tells her to follow
   the guidance published where she lives and to tell her health visitor how the baby actually
   sleeps.
2. **Formula water temperature** (`bottle-and-formula-feeding`). NHS applies the ≥70°C water
   method to every feed for every baby. CDC says following label instructions with safe tap water
   is usually fine, and reserves boiled water for babies under two months, babies born before 37
   weeks, immunocompromised babies, emergencies, and unsafe water. Both are stated, both cited,
   with "follow the advice published where you live".
3. **Vaccination and screening schedules** (`newborn-checks-and-vaccinations`). WHO's summary
   tables as the base; NHS first routine vaccines at eight weeks with BCG and hepatitis B for
   babies at higher risk; CDC's US schedule starting at birth with a hepatitis B dose. Newborn
   blood-spot panels differ too (UK national panel vs per-state US programmes). No schedule is
   presented as Femio's recommendation.

A fourth, smaller one: **cord care**. WHO's postnatal-care recommendations describe clean dry
cord care as standard and chlorhexidine application in settings where newborn deaths at home are
common. Named, because Femio serves countries on both sides of that line.

### What a clinician must decide

1. **The 38°C threshold.** `newborn-warning-signs` states it in the opening paragraph and every
   red-flag box carries it. It is the single most valuable fact in the set and the most exposed —
   NICE NG143 and NHS both support it, but it is a number in the mouth of a wellness product.
   Keep, soften to "a fever", or keep with different framing is a reviewer's call.
2. **Temperatures, times and water temperature in the formula article** (≥70°C water, CDC's
   two-hour / one-hour / 24-hour storage limits). These are hygiene and safety parameters, not
   doses, and were read as outside the no-dose rule — but they are numbers attached to feeding, so
   they should be looked at with that rule in hand.
3. **The "put the baby down and step away" passage** in `newborn-crying`. Written from NHS and
   CDC wording, including "never shake a baby" and a ten-minute time limit, and routed to
   `/en/help-now`. It is the highest-value passage in the set and the one most sensitive to tone;
   please read it as a whole.
4. **Vitamin K** (`newborn-checks-and-vaccinations`). Cited to NICE NG194, which recommends
   offering it. Written as "offered … to protect against vitamin K deficiency bleeding" to keep
   the actor a guideline body. Confirm the framing is right for a global audience where the route
   of administration differs.
5. **Reviewer posture.** These eight pages are about a second person who is not the account
   holder. Doc 15 §8's reviewer statement is written for adult content. Raised in the source
   handover §6.5; repeated here because it should be settled before publication, not after.

---

## Part 2 — Handover prompt, to paste whole into a fresh chat

> You are the Femio project agent. Eight newborn drafts have come back from the content pass and
> need consolidating. Assume you have `docs/content/HANDOVER_NEWBORN_BASICS.md` and this file, and
> none of the drafting conversation.
>
> **The files** are in `docs/content/articles/`, all `status: "draft"`, all bylines `PENDING`:
> `newborn-first-two-weeks.md` (pillar) · `feeding-your-newborn.md` · `newborn-warning-signs.md` ·
> `newborn-crying.md` · `safer-sleep-for-your-baby.md` · `newborn-nappies-skin-and-cord.md` ·
> `bottle-and-formula-feeding.md` · `newborn-checks-and-vaccinations.md`.
>
> `pnpm content-lint` and `pnpm content-lint:urls` were clean on 2026-08-17 (64 drafts scanned).
> Re-run both before anything else; the URL check is the one that can rot.
>
> **Every source used, with tier.** All were fetched and read, not recalled, and each URL is the
> final address after redirects — NHS moved its baby content from `/conditions/baby/…` to
> `/baby/…`, so older NHS links in the repo may now be one redirect away from where they resolve.
>
> Tier 1:
> - NHS: Breastfeeding — the first few days · `https://www.nhs.uk/baby/breastfeeding-and-bottle-feeding/breastfeeding/the-first-few-days/`
> - NHS: Your baby's weight and height · `https://www.nhs.uk/baby/babys-development/height-weight-and-reviews/baby-height-and-weight/`
> - NHS: Jaundice in babies · `https://www.nhs.uk/conditions/jaundice-in-babies/`
> - NHS: When to get urgent medical help for babies and children under 5 · `https://www.nhs.uk/baby/health/when-to-get-urgent-medical-help-for-babies-and-children-under-5/`
> - NHS: Soothing a crying baby · `https://www.nhs.uk/baby/caring-for-a-newborn/soothing-a-crying-baby/`
> - NHS: Sudden infant death syndrome (SIDS) · `https://www.nhs.uk/baby/caring-for-a-newborn/sudden-infant-death-syndrome-sids/`
> - NHS: How to change your baby's nappy · `https://www.nhs.uk/baby/caring-for-a-newborn/how-to-change-your-babys-nappy/`
> - NHS: Nappy rash · `https://www.nhs.uk/baby/caring-for-a-newborn/nappy-rash/`
> - NHS: Washing and bathing your baby · `https://www.nhs.uk/baby/caring-for-a-newborn/washing-and-bathing-your-baby/`
> - NHS: How to make up baby formula · `https://www.nhs.uk/baby/breastfeeding-and-bottle-feeding/bottle-feeding/making-up-baby-formula/`
> - NHS: Sterilising baby bottles · `https://www.nhs.uk/baby/breastfeeding-and-bottle-feeding/bottle-feeding/sterilising-baby-bottles/`
> - NHS: Newborn physical examination · `https://www.nhs.uk/baby/newborn-screening/physical-examination/`
> - NHS: Newborn blood spot test · `https://www.nhs.uk/baby/newborn-screening/blood-spot-test/`
> - NHS: NHS vaccinations and when to have them · `https://www.nhs.uk/vaccinations/nhs-vaccinations-and-when-to-have-them/`
> - NICE NG143: Fever in under 5s · `https://www.nice.org.uk/guidance/ng143`
> - NICE NG194: Postnatal care · `https://www.nice.org.uk/guidance/ng194`
> - WHO: recommendations on maternal and newborn care for a positive postnatal experience · `https://www.who.int/publications/i/item/9789240045989`
> - WHO: recommendations on postnatal care of the mother and newborn · `https://www.who.int/publications/i/item/9789241506649`
> - WHO: Infant and young child feeding fact sheet · `https://www.who.int/news-room/fact-sheets/detail/infant-and-young-child-feeding`
> - WHO: Safe preparation, storage and handling of powdered infant formula · `https://www.who.int/publications/i/item/9789241595414`
> - WHO: recommendations for routine immunization — summary tables · `https://www.who.int/teams/immunization-vaccines-and-biologicals/policies/who-recommendations-for-routine-immunization---summary-tables`
> - CDC: About Abusive Head Trauma · `https://www.cdc.gov/child-abuse-neglect/about/about-abusive-head-trauma.html`
> - CDC: About SUID and SIDS · `https://www.cdc.gov/sudden-infant-death/about/index.html`
> - CDC: Infant Formula Preparation and Storage · `https://www.cdc.gov/infant-toddler-nutrition/formula-feeding/preparation-and-storage.html`
> - CDC: Vaccine Schedules for children · `https://www.cdc.gov/vaccines-children/schedules/index.html`
> - AAP: Safe Sleep · `https://www.aap.org/en/patient-care/safe-sleep/`
>
> Tier 2 (AAP's parent-facing site — tiered conservatively, and never the only source on a page):
> - AAP HealthyChildren: How Often and How Much Should Your Baby Eat? · `https://www.healthychildren.org/English/ages-stages/baby/feeding-nutrition/Pages/How-Often-and-How-Much-Should-Your-Baby-Eat.aspx`
> - AAP HealthyChildren: Responding to Your Baby's Cries · `https://www.healthychildren.org/English/ages-stages/baby/crying-colic/Pages/Responding-to-Your-Babys-Cries.aspx`
> - AAP HealthyChildren: How to Keep Your Sleeping Baby Safe · `https://www.healthychildren.org/English/ages-stages/baby/sleep/Pages/A-Parents-Guide-to-Safe-Sleep.aspx`
> - AAP HealthyChildren: Umbilical Cord Care in Newborns · `https://www.healthychildren.org/English/ages-stages/baby/bathing-skin-care/Pages/Umbilical-Cord-Care.aspx`
>
> Two Tier-1 bodies were wanted but could not be cited because their servers reject automated
> requests and `content-lint:urls` would fail on them: `publications.aap.org` (the 2022 AAP
> sleep-related infant deaths policy statement, HTTP 403), NICE CKS topics on infantile colic and
> nappy rash (HTTP 403), and the Cochrane Library (HTTP 412). Their content is covered by the
> NHS/AAP pages above. If a source URL must be added later, check the status code first.
>
> **Points to re-check, in order:**
> 1. The `38C` threshold and every red-flag box, against the newborn set in
>    `HANDOVER_NEWBORN_BASICS.md` §5.4–5.5. The boxes are near-identical by design; `newborn-crying`
>    adds the abnormal-cry line.
> 2. `newborn-crying`, the section "When you have had enough", end to end — the step-away message,
>    "never shake a baby", and the `/en/help-now` route. No phone number appears anywhere in the
>    set, including in the CDC-derived passages, which is deliberate.
> 3. The three country splits — bed sharing, formula water temperature, vaccination and screening
>    schedules — for whether "follow the guidance where you live" is doing enough work, or whether
>    a locale-aware note is needed later.
> 4. Numbers that survive: `38C` and `36C`, "no wet nappy for 12 hours", "at least 8 to 12 feeds in
>    24 hours", "around six to eight nappy changes a day", "≥70°C water", CDC's 2 h / 1 h / 24 h
>    formula storage limits, "16C to 20C" room temperature, "before 37 weeks or under 2.5kg" for
>    bed sharing, "three weeks" for cord separation and birthweight regain. Each is attributed to a
>    named body in the prose. No dose, volume or regimen appears anywhere.
>
> **Sentences to read specifically for the "no assessment of a baby" line** — these are the ones
> the drafting pass was least certain about:
> - `newborn-nappies-skin-and-cord`: "A few drops of blood around the time the stump comes away are
>   expected. Active bleeding is not." Population-level and paired with an escalation, but it is
>   the closest the set comes to telling her that something she is looking at right now is fine.
> - `newborn-first-two-weeks`, the weight section. It says babies commonly lose weight and are
>   weighed in the first two weeks, then explicitly hands the judgement to a midwife or health
>   visitor. Confirm the handoff sentence is doing enough.
> - `newborn-checks-and-vaccinations`, hearing screening: "Being asked back for a second attempt is
>   common, and the audiology team explains what the next step is." An earlier draft said a repeat
>   "is not a verdict on your baby's hearing" and that was cut as too close to reassurance about
>   an individual result.
> - `newborn-crying`, colic: "There may be little to do except comfort your baby and wait it out."
>   NHS's own framing, but it is advice about a specific crying baby.
> - Every red-flag box ends "Femio cannot assess a baby" for exactly this reason. If the phrasing
>   should change, change it in all eight.
>
> **Then do the work on this side**, in the order `HANDOVER_NEWBORN_BASICS.md` §6 sets out:
> re-run both lints; read the boxes and the baby sentences; add the new newborn topics to Track E's
> `content.foreground` lists and map them in `lib/experience/reading.ts` (`reading.test.ts` fails
> until every registry topic is mapped or listed in `NO_ARTICLE_YET` — the E2 topic
> `is-baby-getting-enough` now has a home in `feeding-your-newborn`, and
> `mastitis-and-blocked-ducts` still does not); run `pnpm content-import -- --apply` to write them
> as drafts; leave publication to the owner in the CMS; and raise the reviewer-posture question in
> `docs/runbooks/BLOCKERS.md` — doc 15 §8's reviewer statement is written for adult content, and
> eight pages about infants may want their own line.
>
> Nothing here is published, and nothing should be. `status` stays `draft` on all eight.

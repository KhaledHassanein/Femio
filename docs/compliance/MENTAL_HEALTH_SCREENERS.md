# Mental-health screener governance

Status: medically reviewed  
Reviewer: Mohamed K.  
Review date: 2026-07-23  
Next review due: 2027-07-23  
Owner: `femio-medical-content`

This is the source of truth for mental-health questionnaire selection, scoring,
licensing, and crisis routing in Femio personas.

## Universal rules

- A questionnaire result is a screen, not a diagnosis. Do not display “you
  have” a disorder.
- Use only the complete, unmodified instrument and a validated language
  version. Do not create “-style,” shortened, simplified, or AI-translated
  versions unless that adaptation has its own validation and permission.
- Show the instrument name, source, attribution, scoring basis, date, and
  version. Store consent separately from the result.
- A high score routes to clinical/support follow-up. It does not by itself
  establish suicide risk.
- Only a questionnaire with a self-harm/suicide item can trigger item-based
  urgent routing. Global urgent routing follows
  [`CRISIS_RESOURCES.md`](CRISIS_RESOURCES.md).

## GAD-7 / GAD-2

Allowed if the production copy uses an authorized, validated language version
without modification and preserves attribution.

- The original validation study describes a 0–21 score, severity cut points of
  5, 10, and 15, and a score of 10 as a reasonable threshold for further
  evaluation. These are screening bands, not diagnoses.
- **GAD-7 and GAD-2 contain no self-harm or suicide item.** A GAD score must
  never be described as detecting self-harm and must not be the sole trigger
  for an emergency route. A separately disclosed self-harm concern follows the
  urgent route independently of the GAD total.
- NHS England's current clinical-content licensing library lists GAD-7 as
  available and lists multiple translations, including Arabic, French, and
  Spanish. Confirm access to the exact production-language files through the
  appropriate repository before implementation.

Sources:

- [Spitzer et al., “A Brief Measure for Assessing Generalized Anxiety
  Disorder,” 2006, doi:10.1001/archinte.166.10.1092](https://jamanetwork.com/journals/jamainternalmedicine/articlepdf/410326/ioi60000.pdf)
- [NHS England National Clinical Content Repository tools and measures library,
  accessed 23 July 2026](https://digital.nhs.uk/services/national-clinical-content-repository-copyright-licensing-service/nccr-tools-and-measures-library)

## EPDS

Allowed only as the complete, unmodified EPDS using a validated language
version with the original attribution and copyright notice.

- EPDS is a screen, not a diagnosis. Do not set one universal global
  diagnostic threshold.
- As a conservative global presentation, scores are shown without a diagnostic
  label and route to clinician follow-up. A configured health-system module may
  use that system's reviewed threshold.
- NSW Health guidance uses 10–12 for monitoring/repeat screening and 13 or more
  for further assessment. It requires immediate further mental-health
  assessment for a positive Question 10 response and urgent action if suicidal
  ideation is disclosed. These are cited examples, not universal country rules.
- Reproduction permission is stated by an NHS Scotland resource; copyright
  remains with the British Journal of Psychiatry. Production must preserve the
  attribution and use a validated translation.

Sources:

- [NSW Health — Edinburgh Postnatal Depression Scale guidance and validated
  language forms, accessed 23 July 2026](https://www.mhcs.health.nsw.gov.au/publications/epds/english)
- [NHS Scotland — EPDS toolkit copyright statement, accessed 23 July
  2026](https://rightdecisions.scot.nhs.uk/mental-health-in-pregnancy-and-after-birth-sign/about-this-toolkit/)
- [NHS England National Clinical Content Repository tools and measures library,
  accessed 23 July 2026](https://digital.nhs.uk/services/national-clinical-content-repository-copyright-licensing-service/nccr-tools-and-measures-library)

## Adolescent depression screening

PHQ-9 may be considered for adolescents only through a clinician-supported
screening workflow with a validated adolescent version/language and a defined
safety response. ACOG identifies PHQ-9 as validated for adolescents; AAP
GLAD-PC supports formal self-report screening for people 12 and older and
warns that screening alone does not diagnose depression.

Femio must not launch an adolescent questionnaire until the exact version,
translation, consent/confidentiality flow, clinical follow-up pathway, and
self-harm response have been approved for the deployment. Until then, personas
use non-instrument wellbeing check-ins and direct clinician/support routing.

Sources:

- [ACOG Committee Opinion — Mental Health Disorders in Adolescents,
  July 2017](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2017/07/mental-health-disorders-in-adolescents)
- [AAP GLAD-PC Part I; reaffirmed June
  2025](https://publications.aap.org/pediatrics/article/141/3/e20174081/37626/Guidelines-for-Adolescent-Depression-in-Primary)

## Instruments excluded pending permission

- **SCOFF:** do not reproduce, shorten, translate, or make a “SCOFF-style”
  adaptation. The published questionnaire carries BMJ copyright. It may be
  reconsidered only after written permission and validation of each production
  language/version.
- **DRSP:** do not reproduce its item list or create a “DRSP-style” copy until
  the exact commercial reuse and translation permissions are documented.
- **DSM criteria:** do not reproduce exact DSM wording. Femio may provide
  independently written education citing clinical guidance, but diagnosis
  remains with a clinician.

Source:

- [Morgan et al., “The SCOFF questionnaire,” 2000; copyright notice displayed
  by the publisher archive](https://pmc.ncbi.nlm.nih.gov/articles/PMC1070794/)


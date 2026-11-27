# FR register proposal: tu to vous, outside `teen.*`

> **Lead review, 2026-10-08: accepted, 99 of 101 applied.** Read a random sample of 12 in
> context (all correct), then checked all 101 by script: each `current` still matched
> `fr.json`, placeholders and `<ltr>` tags identical, no tu-form left in any proposal.
> **Held (2):** `onboarding.mode.teen.desc` and `experience.modes.teen.desc` describe the
> teen option to the teen choosing it, so they keep *tu* like the rest of the teen copy.
> After applying, those two are the only tu-forms outside `teen.*`.


Date: 2026-10-08. Source: `apps/web/messages/fr.json` (committed text; the working-tree copy is identical for every key listed). `fr.json` is not edited. Machine-readable proposal: `2026-10-08-fr-register.json` (101 entries, each `{current, proposed}`).

## Counts by top-level section (101 strings changed)

| Section | Strings |
|---|---|
| calculators | 13 |
| onboarding | 13 |
| experience | 8 |
| dashboard | 7 |
| settings | 7 |
| phaseStrip | 7 |
| gallery | 6 |
| tools | 6 |
| calendar | 6 |
| symptomPatterns | 5 |
| firstRun | 4 |
| flowStrip | 4 |
| cycleReport | 4 |
| track | 3 |
| cycleVariability | 2 |
| log | 2 |
| symptoms | 1 |
| visitSummary | 1 |
| phaseEducation | 1 |
| modules | 1 |

Method: (1) every leaf string outside `teen` checked for tu/te/t'/toi/ton/ta/tes, with word boundaries so that "tests", "toute", "état" and "ces" are not matched; (2) sentence-initial, post-dash and post-conjunction imperatives checked by pattern (Ajoute, Appuie, Parle, Vois, Réessaie, Télécharge...); (3) imperfect and second-singular verbs checked in context. Each proposal was checked programmatically: placeholders (`{day}`, `{length}`, `{count}`, `{list}`, ...) and `<ltr>` tags identical, and no tu-form remains after applying the proposals.

## Unsure

- **`onboarding.mode.teen.desc` and `experience.modes.teen.desc`.** Both sit outside the top-level `teen` key, so they are converted as instructed ("Votre corps, vos règles..."). They are the descriptions of the teen option, which teens read when they choose it. If the teen-facing copy was meant to stay tu, these two need an exemption or a move under `teen.*`. Owner decision.
- **Noun homographs, left alone:** `medications.form.note` and `symptoms.noteLabel` ("Note"), `nav.search` and `search.title` ("Recherche"), `partnerSharing.create.desc` ("partage"). Infinitives such as "passer", "lire" and "relire" are also left alone.
- **First-person strings, left alone:** "Je suis enceinte", "Je suis adolescente", "Je me suis sentie...", "Quand suis-je la plus fertile ?". They do not address the reader.
- **Verb changes, not only pronoun changes:** "Où en es-tu" becomes "Où en êtes-vous" (inversion), and "Comment te sens-tu" becomes "Comment vous sentez-vous" (inversion). "Tu as noté" becomes "Vous avez noté".
- **Settings delete confirmation:** `settings.delete.confirm` keeps "Cela supprime" (third person, already neutral); only the possessives change.

## Where vous changes the meaning

No change of substance was found. Tone only:

- The two teen-option descriptions above become formal ("Votre corps et votre cycle expliqués simplement"). Same content, more distant tone for a teen reader.
- `gallery.feedback.redFlagTitle`: "Consulte sans attendre" becomes "Consultez sans attendre". Same instruction; the urgency is kept.
- `settings.consent.insights.note`: "Reste dans Femio" becomes "Restez dans Femio". Same meaning.

## Observations outside scope

- `apps/web/messages/{fr,en,ar,es}.json` show uncommitted working-tree changes made at 12:37 UTC, not by this task. In `fr.json` these are ICU plural edits to `appointments.inDays` and `appointments.prepCount`. They were left untouched. None of the 101 keys is among them, and the proposals were checked against both HEAD and the working tree.
- The imperative check is pattern-based, not a grammatical parse. A reviewer should still read the 101 proposals in context before they land.

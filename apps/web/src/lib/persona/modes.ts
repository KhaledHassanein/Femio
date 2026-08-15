/**
 * Life-stage modes, as their own module (R2.4).
 *
 * Same reason as `./age`: these lived in `state.ts`, which imports the Supabase
 * client, so `import type { PersonaMode }` dragged the data layer into tier 1 and
 * quietly made the condition vocabulary unportable. `state.ts` re-exports them, so
 * nothing else had to change.
 *
 * A **mode** is what the woman picks and what the UI calls a life stage; a
 * **track** is the taxonomy letter behind it (`docs/08`). The mapping between them
 * stays in `state.ts`, because it is application concern rather than vocabulary.
 */
export const PERSONA_MODES = [
  // Track A. Added 2026-08-16 (R2.5c) — the last track with no mode. The resolver
  // could answer A2 from ADR-057 onwards and nothing could render it, so a
  // 13-year-old got `general`: an adult cycle screen, with adult framing, for the
  // one audience whose specs are most explicit about not being adults.
  "teen",
  "cycle",
  "ttc",
  "pregnancy",
  // Track E. Added 2026-08-12 (R2.5) — before this it had no mode at all, so a
  // woman weeks after giving birth fell through to `general` and was shown a
  // next-period prediction built on cycles that had not returned. The resolver
  // could already answer E1/E6; nothing could render it.
  "postpartum",
  "menopause",
  "general",
] as const;

export type PersonaMode = (typeof PERSONA_MODES)[number];

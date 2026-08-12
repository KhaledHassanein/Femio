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
export const PERSONA_MODES = ["cycle", "ttc", "pregnancy", "menopause", "general"] as const;

export type PersonaMode = (typeof PERSONA_MODES)[number];

import { createClient } from "@/lib/supabase/client";
import type { Locale } from "@/i18n/routing";
import { CONSENT_VERSION } from "@/lib/consent/purposes";
import type { AgeBand } from "@/lib/persona/age";
import { purposeAllowedForAge } from "@/lib/persona/minor";
import { buildConditionRows, type ConditionCode } from "@/lib/persona/conditions";
import { resolveForStatedTrack, type Track } from "@/lib/persona/resolver";
import { flagsFromMode, trackFromMode, type PersonaMode } from "@/lib/persona/state";
import { EMPTY_SIGNALS, type PersonaSignals } from "@/lib/persona/signals";

// Consent policy version now lives with the purposes it describes (lib/consent),
// so onboarding and Settings can never record different versions of the same
// wording. Re-exported because it was published from here first.
export { CONSENT_VERSION };

/**
 * The stage she picks at signup — the same list every other surface uses.
 *
 * This was a hand-written copy of the mode union, the fifth in the codebase. The
 * wizard's own comment already noted that a fourth copy was how `postpartum` could
 * be added everywhere else and still not compile; `teen` (R2.5c) would have been
 * the same story here. `general` is "skip / I'm not sure" — Z1, a first-class
 * state rather than a failure (`docs/09` §4/§5).
 */
export type OnboardingMode = PersonaMode;

/**
 * The stage answer maps to the signals the resolver reads, so the persona comes
 * out of **triage** rather than a lookup table (P1.27.8).
 *
 * This is the whole point of the questionnaire: which conditions her clinician is
 * watching decides what Femio emphasises, exactly as a clinician would triage. It
 * is deliberately not driven by mood — mood belongs to contextual tips, not to
 * which version of the app she gets.
 */
function signalsFromWizard(choice: OnboardingChoice): PersonaSignals {
  return {
    ...EMPTY_SIGNALS,
    ageBand: choice.ageBand ?? null,
    ttcIntent: choice.mode === "ttc",
    pregnancyStatus: choice.mode === "pregnancy" ? ("active" as const) : null,
    conditions: choice.conditions ?? [],
    priorLoss: (choice.conditions ?? []).includes("prior_loss"),
    // She ticked "gestational diabetes" rather than "diabetes", which is the only
    // thing that separates D3 from D4 (docs/09 §8 rule 3).
    diabetesRecordedBeforePregnancy: (choice.conditions ?? []).includes("diabetes"),
    cycleRegularity: choice.mode === "menopause" ? "irregular" : "unknown",
  };
}

export type OnboardingChoice = {
  mode: OnboardingMode;
  /**
   * Age band, optional. It is the resolver's most-used gate — A2, F1 and F2 all
   * require one — and nothing collected it until R2.5b, so those rules could never
   * fire. `null` is a real answer ("prefer not to say") and is treated as a minor
   * for consent purposes; see `lib/persona/minor.ts`.
   */
  ageBand?: AgeBand | null;
  /** Triage answers — "conditions your clinician is watching". Always self-reported. */
  conditions?: ConditionCode[];
  email?: string;
  insights: boolean;
  research: boolean;
  analytics: boolean;
  locale: Locale;
};

type Result = { ok: true } | { ok: false; error: string };

/**
 * Completes onboarding: anonymous sign-in (native — ADR-010), then writes the
 * granted `core` consent BEFORE any health row (the DB gate requires it), then
 * the initial persona_state. An optional email is linked to the anonymous account
 * (upgrade without data loss). All writes are owner-scoped by RLS.
 */
export async function completeOnboarding(choice: OnboardingChoice): Promise<Result> {
  const supabase = createClient();

  const { data: auth, error: authError } = await supabase.auth.signInAnonymously();
  if (authError || !auth.user) return { ok: false, error: authError?.message ?? "sign_in_failed" };
  const profileId = auth.user.id;

  await supabase
    .from("profiles")
    .update({ locale: choice.locale, age_band: choice.ageBand ?? null })
    .eq("id", profileId);

  const { error: consentError } = await supabase.from("consent_records").insert([
    { profile_id: profileId, purpose: "core", granted: true, version: CONSENT_VERSION },
    { profile_id: profileId, purpose: "insights", granted: choice.insights, version: CONSENT_VERSION },
    {
      profile_id: profileId,
      purpose: "research",
      // A minor cannot meaningfully consent to this under GDPR Art. 8 without
      // verifiable parental consent, which Femio does not implement. Enforced at
      // the write rather than by hiding the toggle: a UI that merely omits a
      // control is one refactor away from granting it anyway.
      granted: choice.research && purposeAllowedForAge("research", choice.ageBand ?? null),
      version: CONSENT_VERSION,
    },
    // Product analytics is its own opt-in purpose (0005) and must never be
    // inferred from `insights` — see lib/analytics/consent.ts.
    {
      profile_id: profileId,
      purpose: "analytics",
      granted: choice.analytics && purposeAllowedForAge("analytics", choice.ageBand ?? null),
      version: CONSENT_VERSION,
    },
  ]);
  if (consentError) return { ok: false, error: consentError.message };

  // Conditions before persona_state: the resolver reads them, and a failure here
  // must not leave her with a persona resolved from answers we did not keep.
  const conditionRows = buildConditionRows(profileId, choice.conditions ?? []);
  if (conditionRows.length > 0) {
    const { error: conditionError } = await supabase
      .from("conditions_flagged")
      .insert(conditionRows);
    if (conditionError) return { ok: false, error: conditionError.message };
  }

  /**
   * Her stated stage wins the track; the resolver refines within it (R2.6).
   *
   * This used to be a bare `resolvePersona`, and it had the defect R2.6 fixed in
   * `switchMode` and never came back for: **onboarding wrote the resolver's track,
   * not hers.** Someone who chose "I recently gave birth" with no pregnancy row in
   * Femio — the common case, since she installs it *after* the birth — resolved to
   * Z1 and was filed as `general` from her very first screen, which is the
   * next-period-prediction defect R2.5 exists to prevent, planted at signup.
   * `general` still resolves freely: `trackFromMode("general")` is `Z`, so nothing
   * is forced on someone who said she does not want a stage.
   */
  const resolved = resolveForStatedTrack(
    signalsFromWizard(choice),
    trackFromMode(choice.mode) as Track,
  );
  const { error: stateError } = await supabase.from("persona_state").upsert({
    profile_id: profileId,
    track: resolved.track,
    persona_id: resolved.personaId,
    modifiers: resolved.modifiers,
    emotional_context: resolved.emotionalContext,
    confidence: resolved.confidence,
    flags_json: flagsFromMode(choice.mode),
  });
  if (stateError) return { ok: false, error: stateError.message };

  if (choice.email) {
    await supabase.auth.updateUser({ email: choice.email });
  }

  return { ok: true };
}

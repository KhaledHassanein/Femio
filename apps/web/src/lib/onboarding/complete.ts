import { createClient } from "@/lib/supabase/client";
import type { Locale } from "@/i18n/routing";
import { CONSENT_VERSION } from "@/lib/consent/purposes";
import { buildConditionRows, type ConditionCode } from "@/lib/persona/conditions";
import { resolvePersona } from "@/lib/persona/resolver";
import { EMPTY_SIGNALS, type PersonaSignals } from "@/lib/persona/signals";

// Consent policy version now lives with the purposes it describes (lib/consent),
// so onboarding and Settings can never record different versions of the same
// wording. Re-exported because it was published from here first.
export { CONSENT_VERSION };

export type OnboardingMode =
  | "cycle"
  | "ttc"
  | "pregnancy"
  | "postpartum"
  | "menopause"
  | "general";

// Life-stage mode → initial resolved state (docs/09). Emphasis only; access is
// never restricted.
//
// This comment used to end "Everything stays editable via the wizard later", which
// was false for months: nothing could change `persona_state` after onboarding.
// Settings → "Your Femio experience" makes it true for the mode (P1.27.1, ADR-050).
// Re-running the wizard itself is still open (P1.27.3), and the ~73-persona resolver
// these four hardcoded ids stand in for is P1.27.4.
const MODE_TO_STATE: Record<OnboardingMode, { flags: Record<string, boolean> }> = {
  cycle: { flags: {} },
  ttc: { flags: { ttc_intent: true } },
  pregnancy: { flags: { pregnant: true } },
  postpartum: { flags: {} },
  menopause: { flags: {} },
  // "Skip / I'm not sure" (docs/09 §4). Z1 is a first-class state, not a failure:
  // the full generic experience, progressively personalised as she logs (P1.27.5).
  general: { flags: {} },
};

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

  await supabase.from("profiles").update({ locale: choice.locale }).eq("id", profileId);

  const { error: consentError } = await supabase.from("consent_records").insert([
    { profile_id: profileId, purpose: "core", granted: true, version: CONSENT_VERSION },
    { profile_id: profileId, purpose: "insights", granted: choice.insights, version: CONSENT_VERSION },
    { profile_id: profileId, purpose: "research", granted: choice.research, version: CONSENT_VERSION },
    // Product analytics is its own opt-in purpose (0005) and must never be
    // inferred from `insights` — see lib/analytics/consent.ts.
    { profile_id: profileId, purpose: "analytics", granted: choice.analytics, version: CONSENT_VERSION },
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

  const resolved = resolvePersona(signalsFromWizard(choice));
  const state = MODE_TO_STATE[choice.mode];
  const { error: stateError } = await supabase.from("persona_state").upsert({
    profile_id: profileId,
    // The resolver decides the persona now, not a four-entry lookup table. It
    // answers Z1 whenever the triage answers do not justify more, which is the
    // honest result for someone who ticked nothing (docs/09 §5).
    track: resolved.track,
    persona_id: resolved.personaId,
    modifiers: resolved.modifiers,
    emotional_context: resolved.emotionalContext,
    confidence: resolved.confidence,
    flags_json: state.flags,
  });
  if (stateError) return { ok: false, error: stateError.message };

  if (choice.email) {
    await supabase.auth.updateUser({ email: choice.email });
  }

  return { ok: true };
}

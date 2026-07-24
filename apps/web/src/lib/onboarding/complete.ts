import { createClient } from "@/lib/supabase/client";
import type { Locale } from "@/i18n/routing";

// Consent policy version. Bump when the consent wording/purposes change so the
// ledger records exactly what a user agreed to (docs/13 §3).
export const CONSENT_VERSION = "2026-07-23";

export type OnboardingMode = "cycle" | "ttc" | "pregnancy" | "menopause";

// Life-stage mode → initial resolved state (docs/09). Emphasis only; access is
// never restricted. Everything stays editable via the wizard later.
const MODE_TO_STATE: Record<
  OnboardingMode,
  { track: string; persona_id: string; flags: Record<string, boolean> }
> = {
  cycle: { track: "B", persona_id: "B1", flags: {} },
  ttc: { track: "C", persona_id: "C1", flags: { ttc_intent: true } },
  pregnancy: { track: "D", persona_id: "D1", flags: { pregnant: true } },
  menopause: { track: "F", persona_id: "F1", flags: {} },
};

export type OnboardingChoice = {
  mode: OnboardingMode;
  email?: string;
  insights: boolean;
  research: boolean;
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
  ]);
  if (consentError) return { ok: false, error: consentError.message };

  const state = MODE_TO_STATE[choice.mode];
  const { error: stateError } = await supabase.from("persona_state").upsert({
    profile_id: profileId,
    track: state.track,
    persona_id: state.persona_id,
    flags_json: state.flags,
  });
  if (stateError) return { ok: false, error: stateError.message };

  if (choice.email) {
    await supabase.auth.updateUser({ email: choice.email });
  }

  return { ok: true };
}

/**
 * The private-beta signup gate (P0.12.5, B4).
 *
 * ## What this is for, stated honestly
 *
 * Signup is open on a live domain while the legal work (P0.12) is deliberately
 * deferred. That was fine while the only people storing health data were the owner
 * and nobody else — the trigger for P0.12 was never incorporation, it is **the
 * first real user**. This gate exists so "we are only testing" stays true rather
 * than merely intended when testers are invited.
 *
 * ## What it is not
 *
 * **It is not a security control, and it must never be described as one.** The code
 * is a `NEXT_PUBLIC_` value, so it is readable in the client bundle by anyone who
 * looks. That is a deliberate trade: the tracker is client-rendered and server-free
 * (ADR-048), so a server-checked code would need an endpoint that does not exist,
 * to resist an attacker who is not the threat here.
 *
 * The threat here is a stranger arriving from a search result and storing real
 * health data in a system whose privacy policy is still a draft. A speed bump stops
 * that completely. Someone determined to read the bundle and sign up anyway is
 * making an informed choice, which is the thing the notice is for.
 *
 * The real control is P0.12. This buys the time to do it properly.
 *
 * ## Fails open, on purpose
 *
 * With no code configured the gate is **off** and signup behaves exactly as before.
 * A misconfigured environment must not lock people out of a health app; and until
 * the owner sets a code, nothing about the current situation has changed.
 */

/**
 * Normalised down to letters and digits.
 *
 * Someone retyping `FEMIO-BETA` from a message will write `femio beta` or
 * `femiobeta` about as often as the hyphen. Since this is explicitly not a
 * security control, there is nothing to trade away by being forgiving — and a
 * tester locked out by punctuation is a support conversation for no benefit.
 */
function normalise(value: string): string {
  return value.toLowerCase().replace(/[^a-z0-9]/g, "");
}

export function betaCode(): string | null {
  const raw = process.env.NEXT_PUBLIC_BETA_INVITE_CODE ?? "";
  const trimmed = raw.trim();
  return trimmed.length > 0 ? trimmed : null;
}

export function isBetaGateOn(): boolean {
  return betaCode() !== null;
}

/**
 * Whether the entered code opens the gate.
 *
 * Returns `true` when the gate is off — the caller asks "may she proceed", and with
 * no gate configured the answer is always yes.
 */
export function codeAccepted(entered: string, expected: string | null = betaCode()): boolean {
  if (!expected) return true;
  return normalise(entered) === normalise(expected);
}

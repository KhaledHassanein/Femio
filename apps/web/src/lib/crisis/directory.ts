/**
 * The crisis directory link is the one outbound link on a safety-critical
 * surface, so it is locked to the canonical Find A Helpline host over HTTPS with
 * no query string or fragment — nothing that could carry an identifier or point a
 * user at an unvetted destination. A value that fails this FAILS THE BUILD
 * (env.ts) rather than shipping. Kept as a standalone pure function so it is unit
 * tested independently of the runtime env.
 */
export const CRISIS_DIRECTORY_HOST = "findahelpline.com";

export function isApprovedDirectoryUrl(value: string): boolean {
  let parsed: URL;
  try {
    parsed = new URL(value);
  } catch {
    return false;
  }
  return (
    parsed.protocol === "https:" &&
    parsed.hostname === CRISIS_DIRECTORY_HOST &&
    parsed.search === "" &&
    parsed.hash === ""
  );
}

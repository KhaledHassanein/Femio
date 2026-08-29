import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";

const SRC = join(process.cwd(), "src");
const read = (rel: string) => readFileSync(join(SRC, rel), "utf8");
const LOCALES = ["en", "ar", "fr", "es"] as const;

/**
 * Guards on the four screen states (RB-C7).
 *
 * These read source text rather than rendering, which is the shape this repo has
 * used before for exactly this class of bug (R1.9l). Rendering would prove the
 * component works today; what actually broke here was a *distinction* being
 * dropped — an error rendered as an empty state — and that survives every test
 * which only checks the happy path.
 */
describe("ScreenError distinguishes offline from broken", () => {
  const source = read("components/patterns/app-screen.tsx");

  it("asks whether the browser is online", () => {
    // Without this, a woman in a tunnel is told something went wrong and offered a
    // retry that cannot succeed.
    expect(source).toContain("useOnline");
  });

  it("softens to a warning when the reason is the connection", () => {
    // Losing signal is ordinary. Dressing it as `danger` tells her something is
    // broken when nothing is.
    expect(source).toMatch(/variant=\{online \? "danger" : "warning"\}/);
  });

  it("still offers a retry offline", () => {
    // She may be back by the time she taps it, and removing the control would
    // leave her with nothing to do.
    expect(source).toContain('t("offline.retry")');
  });
});

describe("the offline copy exists in every locale", () => {
  it.each(LOCALES)("%s carries states.offline and states.loadError", (locale) => {
    const messages = JSON.parse(
      readFileSync(join(process.cwd(), "messages", `${locale}.json`), "utf8"),
    ) as { states?: { offline?: { message?: string; retry?: string }; loadError?: string } };
    expect(messages.states?.offline?.message).toBeTruthy();
    expect(messages.states?.offline?.retry).toBeTruthy();
    expect(messages.states?.loadError).toBeTruthy();
  });
});

describe("a read in flight is never rendered as an empty record", () => {
  // Both of these cards said "you have nothing" while the fetch was still running,
  // which is a claim about her own record that nobody could know yet. The entry
  // form sits directly above each one, so the invitation reads as confirmation.
  it.each([
    "components/appointments/next-appointment-card.tsx",
    "components/pregnancy/weight-chart.tsx",
  ])("%s handles loading separately", (rel) => {
    const source = read(rel);
    expect(source).toContain('query.status === "loading"');
    expect(source).toContain("LoadingState");
  });
});

describe("screens use the shared state patterns rather than copies of them", () => {
  it("the summary screen no longer hand-rolls a skeleton", () => {
    // A longhand copy is how a screen quietly stops benefiting from a fix made
    // everywhere else — this page missed the offline distinction for that reason.
    const source = read("components/account/summary-screen.tsx");
    expect(source).toContain("LoadingState");
    expect(source).toContain("ScreenError");
    expect(source).not.toContain("animate-pulse");
  });
});

describe("offline is not signed out", () => {
  // The severe one. `getUser()` calls the auth server; offline it fails and the
  // first version of `AuthGate` read that as anon and redirected to onboarding —
  // telling a signed-in woman her account was gone, and making every offline state
  // in the app unreachable because she could never reach a screen showing one.
  const source = read("components/auth/auth-gate.tsx");

  it("checks the stored session before asking the server", () => {
    // `getSession()` reads storage with no network call, so "no session at all"
    // stays answerable offline.
    // Scoped past the doc comment: it discusses `getUser()` first, so an
    // ordering check over the whole file measures the prose, not the code.
    const body = source.slice(source.lastIndexOf("*/"));
    expect(body).toContain("getSession()");
    expect(body.indexOf("getSession()")).toBeLessThan(body.indexOf("getUser()"));
  });

  it("treats an unreachable server as still signed in, and a rejection as signed out", () => {
    expect(source).toContain("unreachable");
    expect(source).toMatch(/setGate\(unreachable \? "authed" : "anon"\)/);
  });

  it("still redirects when there is no stored session, whatever the network is doing", () => {
    expect(source).toMatch(/if \(!session\) \{\s*setGate\("anon"\);/);
  });
});

describe("a loading state that can never end is not a designed state", () => {
  // supabase-js retries a failed fetch with backoff, so on a dead connection the
  // promise does not settle and the screen held its skeleton indefinitely — no
  // explanation, no retry, nothing to do. The offline copy was unreachable behind
  // it even after `AuthGate` stopped redirecting.
  const source = read("lib/supabase/use-query.ts");

  it("races every read against a deadline", () => {
    expect(source).toContain("Promise.race");
    expect(source).toContain("QUERY_TIMEOUT_MS");
  });

  it("keeps the deadline generous, since this is for a dead connection not a slow one", () => {
    // Read from source rather than imported: the module pulls in the Supabase
    // browser client, which has no business booting inside a guard test.
    const declared = /QUERY_TIMEOUT_MS = ([\d_]+)/.exec(source)?.[1];
    expect(Number(declared?.replace(/_/g, ""))).toBeGreaterThanOrEqual(10_000);
  });
});

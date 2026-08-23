/**
 * The two new tables, through RLS, with a real anonymous session — read, write,
 * read back, and confirm one account cannot reach another's row.
 *
 * `readPrefs()` deliberately treats a missing row as the normal state, which is
 * why a 403 rendered as a perfectly correct-looking panel. So this asserts the
 * status codes rather than the screen.
 */
import { readFileSync } from "node:fs";

const env = Object.fromEntries(
  readFileSync("apps/web/.env.local", "utf8")
    .split(/\r?\n/)
    .filter((l) => l && !l.startsWith("#") && l.includes("="))
    .map((l) => [l.slice(0, l.indexOf("=")).trim(), l.slice(l.indexOf("=") + 1).trim()]),
);
const URL_ = env.NEXT_PUBLIC_SUPABASE_URL;
const KEY = env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;

let failures = 0;
const check = (name, ok, detail = "") => {
  console.log(`  ${ok ? "ok  " : "FAIL"}  ${name}${detail ? ` — ${detail}` : ""}`);
  if (!ok) failures += 1;
};

const api = async (path, { token, method = "GET", body, headers = {} } = {}) => {
  const res = await fetch(`${URL_}${path}`, {
    method,
    headers: { apikey: KEY, Authorization: `Bearer ${token ?? KEY}`, "Content-Type": "application/json", ...headers },
    body: body === undefined ? undefined : JSON.stringify(body),
  });
  return { status: res.status, text: (await res.text()).slice(0, 200) };
};
const signUp = async () => {
  const r = await fetch(`${URL_}/auth/v1/signup`, {
    method: "POST",
    headers: { apikey: KEY, "Content-Type": "application/json" },
    body: "{}",
  });
  const j = await r.json();
  return { token: j.access_token, id: j.user.id };
};

const a = await signUp();
const b = await signUp();
try {
  const read = await api("/rest/v1/notification_prefs?select=kinds", { token: a.token });
  check("she can read her own preferences", read.status === 200, `status ${read.status} ${read.text}`);

  const write = await api("/rest/v1/notification_prefs", {
    token: a.token,
    method: "POST",
    headers: { Prefer: "resolution=merge-duplicates,return=representation" },
    body: { profile_id: a.id, kinds: { periodWindow: true }, discreet: true, quiet_from: 22, quiet_to: 8 },
  });
  check("she can save them", write.status === 201, `status ${write.status} ${write.text}`);

  const back = await api("/rest/v1/notification_prefs?select=kinds,discreet", { token: a.token });
  check("they read back", back.status === 200 && back.text.includes("periodWindow"), back.text);

  const bad = await api("/rest/v1/notification_prefs", {
    token: b.token,
    method: "POST",
    body: { profile_id: b.id, kinds: { gossip: true } },
  });
  check("an unknown kind is rejected by the database", bad.status >= 400 &&
    /notification_prefs_kinds_allowed/.test(bad.text), `status ${bad.status}`);

  const peek = await api(`/rest/v1/notification_prefs?select=kinds&profile_id=eq.${a.id}`, { token: b.token });
  check("another account sees nothing of hers", peek.status === 200 && peek.text.trim() === "[]", peek.text);

  const sub = await api("/rest/v1/push_subscriptions", {
    token: a.token,
    method: "POST",
    body: { profile_id: a.id, endpoint: `https://example.test/${a.id}`, p256dh: "x", auth: "y" },
  });
  check("she can register a push endpoint", sub.status === 201, `status ${sub.status} ${sub.text}`);

  const otherSub = await api("/rest/v1/push_subscriptions?select=endpoint", { token: b.token });
  check("another account sees no endpoints of hers", otherSub.status === 200 && otherSub.text.trim() === "[]", otherSub.text);

  // ADR-068's boundary must survive 0014's blanket grant.
  const rpc = await api("/rest/v1/rpc/partner_shared_rows", {
    token: b.token,
    method: "POST",
    body: { recipient: b.id },
  });
  check("partner_shared_rows is still unreachable from a browser", rpc.status >= 400, `status ${rpc.status}`);
} finally {
  for (const u of [a, b]) await api("/rest/v1/rpc/delete_account", { token: u.token, method: "POST", body: {} });
}

console.log(failures === 0 ? "\nALL CHECKS PASSED" : `\n${failures} FAILED`);
process.exit(failures === 0 ? 0 : 1);

/**
 * End-to-end verification of partner sharing against the deployed project.
 *
 * Two real anonymous accounts, the publishable key only, every call going through
 * RLS exactly as a browser would. It asserts the three properties the design turns
 * on — a withheld category is absent, revocation is silent, the never-shareable
 * class is unrepresentable — and then deletes both accounts.
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
  console.log(`${ok ? "  ok  " : "  FAIL"}  ${name}${detail ? ` — ${detail}` : ""}`);
  if (!ok) failures += 1;
};

async function api(path, { token, method = "GET", body, headers = {} } = {}) {
  const res = await fetch(`${URL_}${path}`, {
    method,
    headers: {
      apikey: KEY,
      Authorization: `Bearer ${token ?? KEY}`,
      "Content-Type": "application/json",
      ...headers,
    },
    body: body === undefined ? undefined : JSON.stringify(body),
  });
  const text = await res.text();
  let json = null;
  try {
    json = text ? JSON.parse(text) : null;
  } catch {
    /* non-JSON body is fine; the status is what matters */
  }
  return { status: res.status, json, text };
}

const signUpAnon = async () => {
  const r = await api("/auth/v1/signup", { method: "POST", body: {} });
  if (!r.json?.access_token) throw new Error(`anon sign-up failed: ${r.status} ${r.text}`);
  return { token: r.json.access_token, id: r.json.user.id };
};

const rest = (t, path, opts = {}) => api(`/rest/v1/${path}`, { token: t, ...opts });
const rpc = (t, fn, args) =>
  api(`/rest/v1/rpc/${fn}`, { token: t, method: "POST", body: args ?? {} });

const today = new Date().toISOString().slice(0, 10);
const daysAgo = (n) => new Date(Date.now() - n * 86400000).toISOString().slice(0, 10);

const owner = await signUpAnon();
const partner = await signUpAnon();
const stranger = await signUpAnon();
console.log(`owner=${owner.id.slice(0, 8)} partner=${partner.id.slice(0, 8)} stranger=${stranger.id.slice(0, 8)}\n`);

try {
  // ---- Her record ---------------------------------------------------------
  await rest(owner.token, "consent_records", {
    method: "POST",
    body: { profile_id: owner.id, purpose: "core", granted: true, version: "test" },
  });
  await rest(owner.token, `profiles?id=eq.${owner.id}`, {
    method: "PATCH",
    body: { age_band: "25_34" },
  });
  for (const d of [daysAgo(60), daysAgo(32), daysAgo(4)]) {
    await rest(owner.token, "cycles", {
      method: "POST",
      body: { profile_id: owner.id, period_start: d, flow: "medium" },
    });
  }
  await rest(owner.token, "symptom_logs", {
    method: "POST",
    body: { profile_id: owner.id, type: "cramps", severity: 3 },
  });

  // ---- §4: the never-shareable class cannot be written --------------------
  const forbidden = await rest(owner.token, "partner_links", {
    method: "POST",
    body: {
      profile_id: owner.id,
      scope_json: { nextPeriod: true, screenerResults: true },
      expires_at: new Date(Date.now() + 86400000).toISOString(),
      invite_code: "ZZZZ9999",
    },
  });
  check(
    "a scope naming screenerResults is rejected by the database",
    forbidden.status >= 400 && /partner_links_scope_allowed/.test(forbidden.text),
    `status ${forbidden.status}`,
  );

  // ---- She shares the window and nothing else -----------------------------
  const code = "ABCD2345";
  const created = await rest(owner.token, "partner_links", {
    method: "POST",
    headers: { Prefer: "return=representation" },
    body: {
      profile_id: owner.id,
      partner_profile_id: null,
      scope_json: { nextPeriod: true },
      consent_ts: new Date().toISOString(),
      version: "partner-2026-08-23",
      invite_code: code,
      expires_at: new Date(Date.now() + 14 * 86400000).toISOString(),
    },
  });
  check("she can create an invite naming only shareable categories", created.status === 201,
    `status ${created.status} ${created.text.slice(0, 120)}`);
  const linkId = created.json?.[0]?.id;

  // ---- §3 + §2: the recipient can read no row at all ----------------------
  const beforeRedeem = await rest(partner.token, "partner_links?select=*");
  check(
    "the recipient cannot select the link row (no map of what she withheld)",
    beforeRedeem.status === 200 && Array.isArray(beforeRedeem.json) && beforeRedeem.json.length === 0,
    `status ${beforeRedeem.status}, rows ${beforeRedeem.json?.length}`,
  );

  // ---- The curated read is not reachable from a browser -------------------
  const direct = await rpc(partner.token, "partner_shared_rows", { recipient: partner.id });
  check(
    "partner_shared_rows is not executable by an authenticated client",
    direct.status >= 400,
    `status ${direct.status}`,
  );

  // ---- Redemption ---------------------------------------------------------
  const wrong = await rpc(partner.token, "redeem_partner_invite", { code: "QQQQ8888" });
  check("a wrong code returns false rather than an error", wrong.status === 200 && wrong.json === false,
    `status ${wrong.status}, body ${JSON.stringify(wrong.json)}`);

  const selfRedeem = await rpc(owner.token, "redeem_partner_invite", { code });
  check("she cannot redeem her own invite", selfRedeem.json === false);

  const redeem = await rpc(partner.token, "redeem_partner_invite", { code });
  check("the recipient redeems the code once", redeem.status === 200 && redeem.json === true,
    `status ${redeem.status}, body ${JSON.stringify(redeem.json)}`);

  const reuse = await rpc(stranger.token, "redeem_partner_invite", { code });
  check("the same code cannot be redeemed twice", reuse.json === false);

  // ---- What the recipient actually sees -----------------------------------
  const view = await api("/functions/v1/partner-view", {
    token: partner.token,
    method: "POST",
    body: { today },
  });
  const share = view.json?.shares?.[0];
  check("the recipient is served one share", view.status === 200 && Boolean(share),
    `status ${view.status} ${view.text.slice(0, 200)}`);
  if (share) {
    check("the granted category is present", "nextPeriod" in share);
    check("a withheld category is ABSENT, not empty or marked hidden",
      !("cycleDates" in share) && !("symptoms" in share) && !("medications" in share) &&
      !("fertility" in share) && !("phase" in share) && !("pregnancy" in share),
      `keys: ${Object.keys(share).join(", ")}`);
    check("nothing from the never-shareable class appears in the payload",
      !JSON.stringify(share).includes("screener") && !JSON.stringify(share).includes("prep"));
    check("the window is a range with its uncertainty attached",
      Boolean(share.nextPeriod?.windowStart && share.nextPeriod?.windowEnd && share.nextPeriod?.confidence),
      JSON.stringify(share.nextPeriod));
  }

  const strangerView = await api("/functions/v1/partner-view", {
    token: stranger.token,
    method: "POST",
    body: { today },
  });
  check("someone with no share sees an empty array",
    strangerView.status === 200 && strangerView.json?.shares?.length === 0);

  // ---- §5: unknown or under-18 age stops the disclosure -------------------
  await rest(owner.token, `profiles?id=eq.${owner.id}`, { method: "PATCH", body: { age_band: "16_17" } });
  const minorView = await api("/functions/v1/partner-view", {
    token: partner.token, method: "POST", body: { today },
  });
  check("a minor's record is not disclosed, even on a live grant",
    minorView.json?.shares?.length === 0, JSON.stringify(minorView.json).slice(0, 120));

  await rest(owner.token, `profiles?id=eq.${owner.id}`, { method: "PATCH", body: { age_band: null } });
  const unknownAgeView = await api("/functions/v1/partner-view", {
    token: partner.token, method: "POST", body: { today },
  });
  check("an unknown age counts as a minor here too",
    unknownAgeView.json?.shares?.length === 0);

  await rest(owner.token, `profiles?id=eq.${owner.id}`, { method: "PATCH", body: { age_band: "25_34" } });

  // ---- §2: revocation is silent -------------------------------------------
  const backView = await api("/functions/v1/partner-view", {
    token: partner.token, method: "POST", body: { today },
  });
  check("the share returns again once the age is adult", backView.json?.shares?.length === 1);

  await rest(owner.token, `partner_links?id=eq.${linkId}`, {
    method: "PATCH",
    body: { revoked_at: new Date().toISOString(), invite_code: null },
  });
  const afterRevoke = await api("/functions/v1/partner-view", {
    token: partner.token, method: "POST", body: { today },
  });
  check("after revocation the recipient sees exactly what a stranger sees",
    afterRevoke.status === 200 &&
      JSON.stringify(afterRevoke.json) === JSON.stringify(strangerView.json),
    `${JSON.stringify(afterRevoke.json)} vs ${JSON.stringify(strangerView.json)}`);

  // ---- Expiry stops it without anyone acting ------------------------------
  const expired = await rest(owner.token, "partner_links", {
    method: "POST",
    headers: { Prefer: "return=representation" },
    body: {
      profile_id: owner.id,
      partner_profile_id: partner.id,
      scope_json: { nextPeriod: true, symptoms: true },
      version: "partner-2026-08-23",
      expires_at: new Date(Date.now() - 1000).toISOString(),
    },
  });
  check("an expired grant can exist", expired.status === 201, expired.text.slice(0, 120));
  const expiredView = await api("/functions/v1/partner-view", {
    token: partner.token, method: "POST", body: { today },
  });
  check("an expired grant returns nothing", expiredView.json?.shares?.length === 0);
} finally {
  for (const u of [owner, partner, stranger]) {
    const del = await rpc(u.token, "delete_account");
    console.log(`  cleanup ${u.id.slice(0, 8)}: ${del.status}`);
  }
}

console.log(failures === 0 ? "\nALL CHECKS PASSED" : `\n${failures} CHECK(S) FAILED`);
process.exit(failures === 0 ? 0 : 1);

"""Builds the Stitch-vs-app comparison page from the rendered screenshots."""
import html
import pathlib

ROOT = pathlib.Path(r"E:\Femio\.claude\worktrees\firebase-hackathon-eligibility-833c52\testing-results\2026-11-24-stitch-compare")
E = html.escape

screens = [
    ("1_onboarding", "Onboarding",
     ["Ask for her life stage on the first real step, with a one-line promise under each choice (\"Honest fertile ranges and PCOS-aware support\").",
      "A visible \"On-device only\" badge and a step counter (Step 1 of 5)."],
     ["Language choice comes first, in four languages. Keep it before the life-stage step.",
      "The brand moment: the bloom and the privacy line on a full-colour ground."],
     ["Six life stages on one screen is a lot; the app's order (language, then stage) reads calmer."]),
    ("2_today_ttc_pcos", "Today: trying to conceive, PCOS",
     ["A Quick log row near the top, with \"Say it to log\" as the main chip. Today the app puts logging below four cards.",
      "An \"Evidence of ovulation so far\" card that sums up this cycle's fluid, ovulation-test and temperature logs.",
      "A \"Personal insight · seen in 4 of 6 cycles\" card.",
      "A stage chip in the header (\"TTC · PCOS\") that opens the stage switch."],
     ["\"No confident window this cycle\" with the reason, as the rules require for irregular cycles. Stitch shows a confident 12–16 March range for a PCOS profile.",
      "A source line under every tip (NHS, WHO, Office on Women's Health)."],
     ["In Arabic, Stitch's \"12–16\" renders as \"16–12\" and \"36.4 °C\" as \"C° 36.4\": a text-direction error. Keep the app's isolated number runs."]),
    ("3_today_pregnancy", "Today: pregnancy",
     ["A \"Next appointment\" card with her own questions as a checklist, linked to the visit pack.",
      "Quick log chips for movements, weight and symptoms.",
      "\"This week in plain words\" as the hero's heading."],
     ["Due date, days to go and full term from a date, with the note that a scan may change the dates.",
      "The urgent-signs card in full, with its sources."],
     ["Stitch's sample questions (iron, vitamin D, kick counts) are invented medical content. Questions must come from her or from the reviewed list."]),
    ("4_say_it_to_log", "Say it to log",
     ["Open it as a sheet over Today instead of a separate screen.",
      "Chips carry a detail (\"Cramps · Morning\", \"Fatigue · Moderate\") and an × to remove; add an \"Add entry\" chip.",
      "The save button counts what it saves: \"Save 2 entries to my phone\"."],
     ["The line saying her words are not saved or sent, and that Gemini Nano did the work."],
     []),
    ("5_ask_femio", "Ask femio",
     ["When it refuses to diagnose, offer a next step on the same card: \"Prepare doctor-visit pack\".",
      "A subtitle under the title: \"One question at a time · Cited library\"."],
     ["Numbered citations in the answer, a source list with review dates, and the on-device badge. Stitch shows two loose source chips."],
     ["Stitch's LH-strip answer and its \"ACOG 2024 Summary\" source are not in the trusted-source registry. Answers come only from the registry."]),
    ("6_calendar", "Calendar",
     ["Three looks for three states: solid for logged, outline for likely, dashed for possible (low confidence). The app has two.",
      "The Hijri month range under the month name (\"Shawwal 1447\")."],
     ["Hijri numbers in each day are already on by default in Arabic (this screenshot used a profile with them off).",
      "The note \"Estimates are shown in outline; what you log is filled in\"."],
     ["Stitch has five tabs including Tools; the app's four tabs are enough unless Patterns needs a home."]),
    ("7_patterns", "Patterns (missing in the app)",
     ["A Patterns screen: cycle-length history as bars with the range (\"29–36 days\"), and symptoms by phase, each \"seen in X of Y cycles\".",
      "A \"Doctor pack\" button on it."],
     ["Nothing yet: the app has the temperature chart on Today and \"Logged most in the last 90 days\" in the visit summary."],
     ["Stitch colours one cycle green and the rest plum, which reads as \"this one was normal\": a verdict. Use one colour.",
      "The minimum number of cycles before a pattern shows must be a rule in the medical rules register, not a screen choice."]),
    ("8_doctor_visit_pack", "Doctor-visit pack",
     ["Make it look like a one-page document: wordmark, \"Prepared 14 March 2026 · last 6 cycles\", numbered sections.",
      "A share button that opens Android's share sheet."],
     ["\"Questions you could ask\" from the reviewed list, and the counts from her logs."],
     ["A WhatsApp-branded button: use the system share sheet so she chooses.",
      "\"Should we check day 21–24 progesterone?\" and the supplements line are invented clinical suggestions."]),
    ("9_help_now", "Help now",
     ["Big call buttons per country, the ambulance number in red."],
     ["The approved red-flag list with sources, and sixteen countries with sourced numbers. Stitch's list and numbers are unsourced."],
     ["Stitch's red-flag wording. Crisis text changes only through the approved copy and its guard."]),
]

ranked = [
    ("Build a Patterns screen", "Cycle-length bars and \"seen in X of Y cycles\" symptoms by phase. The biggest gap: PCOS users want to see their own variation, and it feeds the visit pack.", "New feature · needs a rule for the minimum cycles"),
    ("Quick log row at the top of Today", "\"Say it to log\" first, then two or three chips for her stage. Logging is the daily habit; today it sits under four cards.", "Layout change"),
    ("Ovulation evidence card for TTC", "One card that sums up this cycle's fluid, ovulation tests and temperature, with no verdict.", "Small · reads existing logs"),
    ("Say it as a sheet, with a counted save", "Sheet over Today, chips with detail and ×, \"Save 2 entries to my phone\".", "Small"),
    ("Refusal with a next step", "A diagnosis refusal offers \"Prepare doctor-visit pack\" on the same card.", "Small"),
    ("Next appointment card in pregnancy", "Her appointment and her own questions, linked to the visit pack.", "Medium"),
    ("Three-state calendar", "Solid logged, outline likely, dashed possible; Hijri month range in the header.", "Small · the confidence level already exists"),
    ("Visit pack as a document", "Wordmark, prepared date, numbered sections, share sheet.", "Small"),
]

never = [
    "Any medical sentence from the mockups: the PCOS/LH answer, the pregnancy questions, the progesterone and supplement lines, the red-flag list, the emergency numbers. The app's versions are sourced and reviewed.",
    "The \"ACOG 2024 Summary\" citation: it is not in the trusted-source registry.",
    "Colouring one cycle green: it reads as a verdict on which cycle was normal.",
    "A WhatsApp-branded share button: use the system share sheet.",
    "Stitch's Arabic number runs: \"12–16\" shows as \"16–12\" and \"36.4 °C\" as \"C° 36.4\".",
    "A confident fertile window for a PCOS profile whose cycles vary from 29 to 36 days, where the rules say \"no confident window\".",
]


def li(items):
    return "".join(f"<li>{E(x)}</li>" for x in items)


img = ROOT / "page" / "img"
sections = []
for slug, name, take, keep, dont in screens:
    pics = ""
    for v, label in (("en_light", "English, light"), ("ar_dark", "Arabic, dark")):
        if (img / f"{slug}_{v}_app.jpg").exists():
            appfig = f'<figure><img loading="lazy" src="img/{slug}_{v}_app.jpg" alt="femio app, {E(name)}, {label}"><figcaption>femio app</figcaption></figure>'
        else:
            appfig = '<figure><div class="gap">Not in the app yet</div><figcaption>femio app</figcaption></figure>'
        hidden = " hidden" if v == "ar_dark" else ""
        pics += (f'<div class="pair" data-v="{v}"{hidden}><figure><img loading="lazy" src="img/{slug}_{v}_stitch.jpg" '
                 f'alt="Stitch mockup, {E(name)}, {label}"><figcaption>Stitch</figcaption></figure>{appfig}</div>')
    cols = (f'<div class="verdict"><div><h4 class="t">Take from Stitch</h4><ul>{li(take)}</ul></div>'
            f'<div><h4 class="k">Keep from the app</h4><ul>{li(keep)}</ul></div>')
    if dont:
        cols += f'<div><h4 class="d">Leave out</h4><ul>{li(dont)}</ul></div>'
    cols += "</div>"
    sections.append(f'<section class="screen"><h3>{E(name)}</h3><div class="body"><div class="pics">{pics}</div>{cols}</div></section>')

rank = "".join(f'<li><div class="rt">{E(a)}</div><p>{E(b)}</p><span class="cost">{E(c)}</span></li>' for a, b, c in ranked)

DARK = "--bg:#140D14; --surface:#1E151D; --soft:#261B25; --fg:#F1E6EC; --muted:#B9A8B2; --line:#3A2C37; --plum:#E7A6D3; --rose:#FF8FAE; --sage:#8FD3BF; --amber:#F2C46B; color-scheme:dark;"

page = """<title>femio Stitch Review</title>
<meta name="claude:viewport-fit-sides" content="cover">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Newsreader:opsz,wght@6..72,500&family=Plus+Jakarta+Sans:wght@400;600&display=swap">
<style>
/* Layout: one reading column; each screen is a pair of phones beside its verdict, stacked on phones. Tokens are femio's Dusk Bloom. */
:root { --bg:#FBF7F3; --surface:#FFFFFF; --soft:#F3ECE6; --fg:#21191E; --muted:#6E6068; --line:#E4D9DE;
  --plum:#6B2558; --rose:#BF2F59; --sage:#2F7163; --amber:#8A5A00;
  --display:"Newsreader", Georgia, serif; --body:"Plus Jakarta Sans", system-ui, sans-serif; }
@media (prefers-color-scheme: dark) { :root:not([data-theme="light"]) { DARK } }
:root[data-theme="dark"] { DARK }
body { background:var(--bg); color:var(--fg); font:15px/1.55 var(--body); }
body::before { content:""; position:fixed; inset:0 0 auto; height:env(safe-area-inset-top, 0px); z-index:10; background:var(--bg); }
.wrap { max-width:1080px; margin:0 auto; padding-block:40px 64px; padding-left:max(16px, env(safe-area-inset-left, 0px)); padding-right:max(16px, env(safe-area-inset-right, 0px)); display:flex; flex-direction:column; gap:40px; }
h1, h2, h3 { font-family:var(--display); font-weight:500; text-wrap:balance; margin:0; }
h1 { font-size:clamp(30px, 5vw, 44px); line-height:1.1; color:var(--plum); }
h2 { font-size:26px; }
h3 { font-size:22px; }
.lede { max-width:68ch; color:var(--muted); margin:8px 0 0; }
.meta { font-size:13px; color:var(--muted); margin:6px 0 0; }
code { font-size:12px; overflow-wrap:anywhere; }
ol.rank { list-style:none; counter-reset:r; padding:0; margin:16px 0 0; display:grid; grid-template-columns:repeat(auto-fit, minmax(260px, 1fr)); gap:12px; }
ol.rank li { counter-increment:r; background:var(--surface); border:1px solid var(--line); border-radius:16px; padding:16px; display:flex; flex-direction:column; gap:6px; min-width:0; }
.rt { font-weight:600; display:flex; gap:10px; align-items:baseline; }
.rt::before { content:counter(r); font-family:var(--display); color:var(--plum); font-size:22px; }
ol.rank p { margin:0; color:var(--muted); font-size:14px; }
.cost { font-size:12px; letter-spacing:.02em; color:var(--sage); font-weight:600; }
.never { background:var(--soft); border-radius:16px; padding:16px 20px; }
.never ul { margin:8px 0 0; padding-inline-start:20px; display:flex; flex-direction:column; gap:6px; }
.toggle { display:flex; gap:8px; flex-wrap:wrap; position:sticky; top:env(safe-area-inset-top, 0px); background:var(--bg); padding-block:10px; margin-top:8px; z-index:5; border-bottom:1px solid var(--line); }
.toggle button { font:600 14px var(--body); border:1px solid var(--line); background:var(--surface); color:var(--fg); border-radius:999px; padding:8px 16px; min-height:40px; cursor:pointer; }
.toggle button[aria-pressed="true"] { background:var(--plum); border-color:var(--plum); color:var(--bg); }
.toggle button:focus-visible { outline:2px solid var(--rose); outline-offset:2px; }
.screens { display:flex; flex-direction:column; gap:48px; margin-top:24px; }
.screen .body { display:grid; grid-template-columns:minmax(0, 1fr) minmax(0, 1fr); gap:24px; margin-top:12px; align-items:start; }
@media (max-width:760px) { .screen .body { grid-template-columns:minmax(0, 1fr); } }
.pair { display:grid; grid-template-columns:1fr 1fr; gap:10px; }
figure { margin:0; display:flex; flex-direction:column; gap:6px; min-width:0; }
figure img { width:100%; max-width:100%; border-radius:14px; border:1px solid var(--line); background:var(--surface); }
figcaption { font-size:12px; font-weight:600; letter-spacing:.06em; text-transform:uppercase; color:var(--muted); text-align:center; }
.gap { aspect-ratio:390/844; max-width:100%; border:1px dashed var(--line); border-radius:14px; display:grid; place-items:center; color:var(--muted); font-size:13px; text-align:center; padding:8px; }
.verdict { display:flex; flex-direction:column; gap:16px; min-width:0; }
.verdict h4 { margin:0 0 4px; font-size:13px; letter-spacing:.06em; text-transform:uppercase; }
.verdict ul { margin:0; padding-inline-start:18px; display:flex; flex-direction:column; gap:6px; }
.t { color:var(--sage); } .k { color:var(--plum); } .d { color:var(--amber); }
</style>
<div class="wrap">
<header>
  <h1>Stitch screens beside the femio app</h1>
  <p class="lede">Nine Stitch mockups beside the same screens rendered from the current app at 390×844 with synthetic data. Take Stitch's layout ideas; keep every medical sentence from the app, because the app's are sourced and reviewed.</p>
  <p class="meta">24 November 2026 · app screenshots from <code>apps/mobile/test/stitch_compare_screenshots_test.dart</code></p>
</header>
<section>
  <h2>What to take, ranked</h2>
  <ol class="rank">RANK</ol>
</section>
<section class="never">
  <h2>What not to take</h2>
  <ul>NEVER</ul>
</section>
<section aria-label="Screen by screen">
  <h2>Screen by screen</h2>
  <div class="toggle" role="group" aria-label="Which version to show">
    <button type="button" id="v-en" data-v="en_light" aria-pressed="true">English, light</button>
    <button type="button" id="v-ar" data-v="ar_dark" aria-pressed="false">Arabic, dark</button>
  </div>
  <div class="screens">SECTIONS</div>
</section>
</div>
<script>
document.querySelectorAll(".toggle button").forEach(function (b) {
  b.addEventListener("click", function () {
    var v = b.dataset.v;
    document.querySelectorAll(".toggle button").forEach(function (x) { x.setAttribute("aria-pressed", String(x === b)); });
    document.querySelectorAll(".pair").forEach(function (p) { p.hidden = p.dataset.v !== v; });
  });
});
</script>
"""
page = page.replace("DARK", DARK).replace("RANK", rank).replace("NEVER", li(never)).replace("SECTIONS", "".join(sections))
(ROOT / "page" / "index.html").write_text(page, encoding="utf-8", newline="\n")
print("ok", len(page))

# 02 — Design spec: Dusk Bloom v3, web teaser + Android app

**Owner:** Product designer (Opus 5.5), 2026-10-27. **Status:** ready to build; the lead reviews before merge.
**Binding sources, in order:** `CLAUDE.md` (six product rules) → `00_PLAN.md` → `docs/32_STUDY/reports/09-plans-architecture.md` §7
(Dusk Bloom: palette, type, motion, rejected patterns) → `assets/brand/tokens/femio.tokens.css` (canonical values; where a doc and
the CSS disagree, the CSS wins) → `docs/22_APP_UI_ARCHITECTURE.md` (controls, dates, bottom bars).
**Sketch:** `design/calendar-calculator-390-en-light.svg` (the calculator at 390×844, EN, light; resolved hex values for viewing only).
**How to read token names.** `--name` is a CSS custom property from `femio.tokens.css`; the Tailwind class is the same name through the
preset (`bg-success-soft`, `text-log-period`); the Dart name is its camelCase on `context.palette` (`p.successSoft`). Components use
**semantic** tokens only: never a primitive (`--sage-100`), never a hex. Sizes are px on the 4px grid unless marked.
**Flags.** `[NEEDS SOURCE]` = a medical number that needs a Tier-1/2 citation in `01_PRODUCT_SCOPE.md` §4 before it ships.
`[LEAD]` = a decision this spec takes by default that the lead may reverse.

---

## 1 · Design principles for v3

1. **Her data is the hero.** Every screen leads with her dates, drawn; decoration never competes with a number she needs.
2. **Calm.** Still by default. Motion is spent on four moments only (home hero, onboarding arrival, first prediction, a new pregnancy week).
3. **Honest about uncertainty.** A window with soft edges and a confidence word, never one certain day; the uncertain thing is the thing that moves.
4. **Arabic-native, not translated.** Designed in RTL first; Saturday-first weeks; Hijri as a quiet second line; Western digits; Latin wordmark **femio**.
5. **Premium, not clinical.** Warm porcelain, plum ink, soft plum-tinted elevation, Newsreader display; no hospital blue, no stock icons as decoration.
6. **One of each.** One raised element per screen, one accent element per view, one sentence per idea.
7. **Wellness, never verdict.** Totals and ranges, no grades, no pass marks, no "late", no "safe days"; red flags route to a clinician or Help now.
8. **No clichés.** No photos of people, no pink-for-women, no glitter babies, no rings, no anatomical shock.

**Rejected patterns (restated from report 09 §7.8; reintroducing any of them fails review):** (1) rings and circular progress, including
"today" rings around a day; (2) a single certain date, hard-edged predictions, "safe day" framing, a "late" counter; (3) a pregnancy bar
that fills toward the due date, any bar toward the 12-month menopause mark; (4) pass marks, verdicts, scores, kick targets, labour
verdicts; (5) stock Tailwind violet, stock-Inter look, text on decorative gradients, gradient text; (6) photos of women, stock portraits;
(7) more than one raised element or one accent per view, hard borders, harsh drops; (8) a floating crisis pill covering the product;
(9) colour as the only channel for status; (10) sexual-wellness imagery or "sex" log labels; (11) Arabic-Indic digits, a transliterated
wordmark; (12) physical `left`/`right` in layout; (13) preset edits without clearing `.next/cache`, token names missing from the preset.

---

## 2 · The interactive calendar calculator

### 2.1 What changes and what stays

The month grid **is** the input. It replaces every native `<input type="date">` in `apps/web/src/components/calculators/*` and the
display-only `MiniCalendar` (`aria-hidden`), and its Flutter twin replaces the onboarding `DateCard` and restyles `calendar_screen.dart`.
**The maths is owned by `01_PRODUCT_SCOPE.md` §4–5**, not by this spec: the fertile window is MR-07 (6 days ending on ovulation day,
ovulation 14 days before the next period) behind the D-02 gate, in one domain function with one fixture for both clients. This spec
only says how a result is drawn; where it names a day count, the register wins.

| Calculator (route) | Grid mode | Result drawn on the calendar | Extra result shape |
|---|---|---|---|
| Fertile window `/calculators/fertile-window` | `period` (start + optional end) | entered period, next-period dotted band; fertile band + ovulation dot **only when D-02/MR-08 passes** (regular, 21–35), else the MR-06 box (§2.5) | — |
| Period `/calculators/period` | `period` | entered period, next 3 periods as dotted bands that widen | — |
| Pregnancy test `/calculators/pregnancy-test` | `period`, or `single` (the unprotected-sex date; label worded per OD-5, Arabic by the owner, D-10) | next-period dotted band, "test from" open band | — |
| Due date `/calculators/due-date` | `single` (LMP) | LMP day; on the term months, the 37w0d–42w0d band | Term-window bar (§2.7) |
| Gestational age `/calculators/gestational-age` | `single` (LMP) | LMP day | Term-window bar with "you are here" |
| Cycle length `/calculators/cycle-length` | `multi` (2–12 period starts) | each start solid; spans between starts as thin sunken bands | The strip: one bar per cycle, length labelled |
| BMI `/calculators/bmi` | no calendar | — | unchanged (category labels: owner question, report 03 Q5) |

### 2.2 Interaction model (both clients)

| State | She does | Result |
|---|---|---|
| `empty` | sees the current month, today marked, prompt "Tap the day your last period started" | nothing drawn yet |
| `empty` | taps a past day D (or today) | D becomes the start; period days D…D+`DEFAULT_PERIOD_DAYS`−1 drawn; result draws at once; state `started` |
| `started` | taps a later day E with 2 ≤ E−D+1 ≤ 10 (`MIN_PERIOD`, `MAX_PERIOD`) **or long-presses any later day** | period length = E−D+1; period stepper updates; result redraws |
| `started` | taps D again | no change (start is already set); focus stays |
| `started` | taps a day before D, or more than `MAX_PERIOD` days after D | that day becomes the new start (period length keeps its last value) |
| `started` | presses **Clear** (text button under the grid) | back to `empty`; the live region says "Cleared" |
| any | taps a future day in `period`/`single` mode | inline message (§2.13); no selection |
| `multi` | taps a day | toggles it as a period start (max 12); result needs 2 |

`single` mode has no second tap. Long-press is `LONG_PRESS_MS = 500`, cancelled by a pointer move over 8px; the browser context menu is
suppressed on cells only. **Every gesture has a non-gesture twin:** the period-length stepper sets the end, Shift+Enter sets the end
from the keyboard, and Clear is a real button. Nothing about her dates ever goes into a URL, a query string or storage on the web.

### 2.3 Grid rules

- **Week start:** Saturday for `ar`, Monday for `en`, `fr`, `es`. One named map `WEEK_START_BY_LANGUAGE = { ar: 6, en: 1, fr: 1, es: 1 }`
  in `lib/calendar/grid.ts` and `lib/domain/calendar_grid.dart`, bound by fixture `fixtures/domain/calendar-grid.json`. Matches on the
  **language part** of the locale so `ar-u-nu-latn` still resolves to Saturday (report 12 risk 1). Flutter must not use
  `MaterialLocalizations.firstDayOfWeekIndex` (en_US gives Sunday). This changes `en` from Sunday to Monday `[LEAD]`.
- **Digits:** Western everywhere, Hijri included. Web formatters always carry `-u-nu-latn` (in the formatter, not in the locale value);
  the app keeps `main.dart`'s pin (ADR-069). Weekday headers use `narrow` in `en/fr/es` and `short` in `ar` (narrow Arabic is ambiguous).
- **Hijri (Arabic only by default):** a secondary label under each Gregorian day number, day-of-month only (`13`); the month header's
  second line names the Hijri months the grid spans (`جمادى الأولى – جمادى الآخرة 1448 هـ`). **Data rule:** everything is stored and
  computed in Gregorian ISO dates; Hijri is display only. Web: `Intl.DateTimeFormat("ar-SA-u-ca-islamic-umalqura-nu-latn", { day: "numeric", timeZone: "UTC" })`
  (no dependency). App: a pinned Umm al-Qura package chosen by the lead, bound to `fixtures/domain/hijri.json` (≈ 120 dates,
  2024–2030, generated once from Node's ICU by `scripts/domain/gen-hijri-fixture.mjs`), so both clients print the same day. Legend line:
  "Hijri dates follow the Umm al-Qura calendar and can differ by a day from local announcements." App Settings can switch Hijri on in
  any language. Umm al-Qura is the default pending the owner's Q4 in `01` §7.
- **Today** is the device's **local** date (MR-11), never UTC; the web's `todayISO()` (UTC today) must change before the grid uses it.
- **Range:** `period` mode accepts today and up to `CYCLE_LOOKBACK_DAYS = 90` back; `single` (pregnancy) up to `TERM_END_DAYS = 294`
  (42w0d, the literal already in `estimateDueDate`; name it). Days outside the range render in `--text-subtle`, `aria-disabled="true"`.
- **Navigation:** previous/next month buttons (44px, chevrons mirror in RTL). Pregnancy calculators add a **month strip** above the grid:
  a horizontal row of chips for the last 10 months ("Jan", "Feb"…, `radius-pill`, 44px tall), scrolled to the current month: a jump
  without a dropdown. After a result exists, the calendar shows **every month the result touches, stacked** (input month first; up to
  `MAX_MONTHS = 3`; side by side at ≥ 768px), each with its own header.
- **Today:** day number `--fw-bold` + a 16×3 bar under it in `--primary`, `aria-current="date"`. No circle, no ring.

### 2.4 Controls under the grid

| Control | Spec | Constant (one home: `lib/calculators/index.ts`, twin in Dart) |
|---|---|---|
| Cycle length | Stepper: label 14/600; `[−]` 44×44 round on `--surface-sunken`; value 22/600 `--text`, unit "days" 14 `--text-muted`; `[+]`. Range 21–45; the buttons disable at the bounds (never a silent clamp, `01` §5). 36–45 is accepted but the fertile result becomes the MR-06 box (MR-08) | `DEFAULT_CYCLE_DAYS = 28`, `CYCLE_STEPPER_MIN = 21`, `MAX_CYCLE = 45`. The lib's `MIN_CYCLE` is 20 and `01` §5 quotes 20–45 for the due date: one value `[LEAD]` |
| Irregular / not sure | Chip (`chipVariants`, `aria-pressed`) beside the stepper. When on, the one stepper becomes two, **Shortest** and **Longest**; the fertile result is always the MR-06 box (D-02); periods show as widening ranges | "Not sure" seeds `IRREGULAR_SEED = { shortest: 21, longest: 35 }`, the MR-03 accepted range `[LEAD]` |
| Period length | Stepper 2–10, set automatically by the second tap | `DEFAULT_PERIOD_DAYS = 5`, `MIN_PERIOD = 2`, `MAX_PERIOD = 10` (exist) |

The six copies of the literal `28` and the fallback `5` in the calculator components go (report 03 §8).

### 2.5 The result vocabulary (identical on web and app)

Facts are **filled**, estimates are **tinted, dotted or faded**. Bands are 32px tall, vertically centred behind the day number (6px from
the row's top), `radius-pill` at a true start or end, square where a band wraps to the next week row. "Soft edge" = the first and last
24px of a band fade from 0 to full opacity (CSS `mask-image`, Dart `ShaderMask`), direction following the reading direction.

| Mark | Shape | Light / dark from tokens | Number colour | Cell `aria-label` suffix (EN) |
|---|---|---|---|---|
| Start day she tapped | 36px filled circle | `--accent-solid` (rose-600 both themes) | `--on-accent-solid` (white, 5.58:1) | "first day of your period, selected" |
| Her period days | band, solid edges | `--log-period-alt` | `--log-period`, 600 | "your period" |
| Fertile window | band, **soft** edges, breathes (§2.10) | `--success-soft` | `--success-text`, 600 | "likely fertile, estimate" |
| Likely ovulation | 8px dot at the cell's block-end (4px up) | `--phase-ovulatory` (saffron-500 / saffron-300) | unchanged | "ovulation likely around this day, estimate" |
| Next period (predicted) | band, dotted 2px top and bottom stroke (`2 4` dash), soft start | fill `--log-period-alt`, stroke `--log-period` | `--log-period`, 500 | "next period may start, estimate" |
| Test from (pregnancy test) | open band from the day to the month's end, soft end | `--primary-soft` | `--primary-soft-text` | "a test is most reliable from here" |
| Term window (pregnancy) | band, soft edges | `--prediction-band` at 24% (Tailwind `/24`) | `--text` | "inside the 37 to 42 week window" |
| No confident window (D-02: irregular, PCOS, still learning, or cycle outside 21–35) | **no fertile band, no dot**; instead a box under the grid: `--surface-sunken`, `--radius-md`, info icon, the MR-06 sentence, a link "How to tell afterwards" (→ the `irregular-cycles-and-timing` article), and the MR-14 line | — | — | (none on cells) |

The ovulation dot is deliberately small and still (it never breathes, never glows) and its words always say "around", because `01` §5
forbids "one glowing most likely day". If the clinical lead reads even this as a single day, delete the dot row and the ovulation line;
nothing else in the vocabulary moves `[LEAD]`.

`[LEAD]` The app calendar today draws a predicted period in saffron and ovulation as a sage **ring**; both change to this table so web
and app match (rose dotted for period, saffron dot for ovulation). `--prediction-band` stays the colour of windows drawn on a **strip or
bar** (Today band, term window), per report 09 §7.2.

**Result sentence** (above the legend, the accessible statement of the result): eyebrow 14 `--text-muted` ("Likely fertile window"),
headline `--font-display` 22/600 ("15 – 20 October"), two lines 14 `--text-muted` (ovulation "around", next period range), then the
confidence line. Then, in 14 `--text-muted`, the lines `01` §5 requires per calculator: the **MR-15 sentence** on every fertile or
ovulation result (replacing today's shorter `awarenessNote`), the MR-16 strip line, "Your clinician may adjust it after a scan" (due
date), the red-flag box (pregnancy week, MR-29), the test-first line (period, MR-10/21), and the MR-40 wellness line under every tool.

### 2.6 Confidence label

A word, coloured by weight, never a traffic light (`--confidence-*`). Web calculators never claim "high": one date cannot.

| Situation | Word (EN) | Token |
|---|---|---|
| Regular; she set the cycle length herself | "Fair estimate · from your cycle length" | `--confidence-medium` |
| Regular; default 28 untouched | "Rough estimate · from one date and a typical cycle" | `--confidence-low` text weight 600 |
| Irregular / not sure (period ranges only; no fertile window, D-02) | "Wide estimate · your cycles vary" | `--confidence-low` |
| App, observed rule with ≥ 3 cycles | from `CyclePrediction.confidence` (existing domain) | high/medium/low |

### 2.7 The term-window bar (due date, gestational age; reused on app Today)

A horizontal axis from 0 to 42 weeks, 12px track, `radius-pill`. Trimester segments 0–14, 14–28, 28–42 (ACOG boundaries in
`trimesterOf`) are three `--surface-sunken` segments with 2px gaps and labels "1st · 2nd · 3rd trimester" (12, `--text-muted`) under them.
The **37w0d–42w0d term window** is a `--prediction-band` band with soft edges laid over the track (it breathes). "You are here" is a 12px
`--primary` dot with a 14/600 label ("Week 14 + 2 days") centred above it, positioned with `inset-inline-start`. **Nothing fills.** No
due-date tick, no countdown: the text reads "Due date around 12 May 2027 · most babies arrive between 21 April and 26 May". Over 42w the
dot parks at the end and the text says to talk to her midwife or doctor (copy from `01`). Replaces `pregnancy-progress.tsx`
(which draws coloured trimester fills and a 3px-bordered thumb) and the app's `_PregnancyBar`.

### 2.8 Layout at 390×844 (top to bottom)

| Block | Size | Tokens |
|---|---|---|
| Site header (sticky, frosted) | 56 | `--frost` + `--frost-blur`, bottom 1px `--divider` |
| Page gutter | 16 each side (24 at ≥ 768) | — |
| H1 | `--font-display` 28/34, 600, `--ls-tighter`; 24 above | `--text` |
| Intro | 16/24, max 2 lines, 8 above | `--text-muted` |
| Calculator card (the one raised element) | full width 358, padding 12, `--radius-lg` 24, 24 above | `--surface`, 1px `--border`, `--card-shadow` |
| Prompt | 16/24 600, 4 top | `--text`; `aria-live="polite"` region |
| Month header | 48: prev 44 · title 18/600 centred · next 44; Arabic adds Hijri line 12 (+16) | `--text`, Hijri `--text-subtle` |
| Weekday row | 24, 12/16 | `--text-subtle` |
| Grid | 7 columns `1fr`, gap 4 (cell ≈ 44.3 wide); rows 44 tall, **52 in Arabic** (number 16 + Hijri 12); 6 rows max = 284 (AR 332) | numbers 16/500 `--text-muted`; past-range `--text-subtle` |
| Clear | text button 44 tall, end-aligned, 4 above | `--text-link` |
| Divider + result sentence + confidence | 16 above, ≈ 132 | §2.5, §2.6 |
| Legend | wraps, 12/16, swatches 14 | only marks in use |
| Steppers + chip | 56 per row, 16 above | §2.4 |
| Hand-off card | 24 below the calculator card | §2.12 |

The result sentence is visible without scrolling after the first tap on a 390×844 phone in English (sketch: it sits at y ≈ 580–700).
At ≥ 768px the card becomes two columns: calendar(s) start, controls and result end.

### 2.9 Light, dark, RTL

Dark is the token remap only (no `dark:` overrides in the component): `--surface` #1E1520, bands become translucent washes by token. The
start-day circle stays rose-600 with white in both themes. RTL: the grid order comes from the locale's week start and the document
direction (`dir="rtl"` flips column order for free: Saturday sits at the inline start, the right edge); bands are positioned with
`inset-inline-start` and width; the soft-edge mask direction flips with `rtl:`; chevrons mirror (`rtl:-scale-x-100`); "previous month"
is always the inline-start button. Arrow keys follow the **visual** direction (§2.11). Numbers inside Arabic text are isolated with
`<bdi>` / `⁨…⁩` so "15 – 20" never reverses.

### 2.10 Motion

| Event | Motion | Token |
|---|---|---|
| Tap a day | press scale .98 on the cell (motion-safe only) | `--motion-press` |
| Start circle appears | scale .6 → 1 | `--motion-log-confirm` (spring) |
| Result draws | each band grows from its inline-start edge (`scaleX` 0 → 1, `transform-origin: inline-start`), rows staggered 40ms | `--motion-prediction` (400ms standard) |
| After draw | **the headline estimate breathes**: the fertile band on fertile-window, the next-period band on period/pregnancy-test, the term window on due-date/gestational | `.band-breathe`, but with `--breathe-scale: 1.12` (the default 1.35 would hit the Hijri line). Add the custom property to the keyframe; default stays 1.35 |
| Stepper change | bands re-position (no re-grow) | `--motion-prediction` |

Only one thing breathes per view. Reduced motion: no grow, no breathe, no spring; bands appear in place (the global rule plus
`motion-safe:` on every transform, `docs/22` §4). No JavaScript animation library.

### 2.11 Keyboard and screen reader (WAI-ARIA grid pattern)

- Markup: `<table role="grid" aria-labelledby={monthTitleId}>`; `<th scope="col" abbr="Monday">` headers; each day a
  `<td role="gridcell" aria-selected>` holding one `<button>`. **One tab stop** for the whole grid (roving `tabindex`): the selected day,
  else today, else day 1.
- Keys: Arrow Left/Right move one day **visually** (in RTL, ArrowLeft = next day); Up/Down ±7; Home/End = first/last day of the visual
  week; PageUp/PageDown ±1 month (focus keeps the day number, clamped); Shift+PageUp/Down ±1 year; Enter/Space = tap; Shift+Enter = set
  end (the long-press twin); Escape = cancel a pending end. Focus ring `--focus-ring` (3px), never removed, drawn outside the band.
- Labels: every day button has a full sentence: "Tuesday 20 October 2026, likely fertile, ovulation likely around this day, estimate";
  in Arabic the Hijri date follows, in Western digits (draft for the Arabic editor: "الثلاثاء 20 أكتوبر 2026، 9 جمادى الأولى 1448 هـ،
  يُرجَّح أنه من أيام الخصوبة، تقدير"). The Hijri day in this example is illustrative; the fixture decides.
- Announce: the result sentence lives in an `aria-live="polite"` region and is announced once after each change (debounced 300ms so a
  stepper held down does not chatter). Bands, dots and the legend are `aria-hidden`; the sentence and the labels carry the meaning.
- Steppers: `role="spinbutton"` with `aria-valuenow/min/max` and `aria-valuetext="28 days"`; Up/Down ±1, Home/End min/max; the `−`/`+`
  buttons have translated labels ("Shorter cycle", "Longer cycle"), fixing the bare-symbol tooltips in `widgets.dart:212,219`.

### 2.12 The "track this in the app" hand-off card

Appears under every calculator once a result exists, and at the end of each article. `--surface-sunken`, `--radius-lg`, padding 20, no
shadow (the calculator card is the one raised element). Small Bloom mark 32 at inline-start; title 18/600, the `01` §5 hand-off line
"Track this automatically in the femio app."; body 14 `--text-muted` "It stays on your phone, learns your real cycle as you log, and
nothing is uploaded. Android only for now."; button **`--accent-solid`** pill 48 "Get it on Google Play" → the Play listing; text link
"What the app does" → `/{locale}/app`. **The button is the page's one accent.** Neither link carries dates, a fragment, or UTM
parameters with health meaning.

### 2.13 Empty and error states (inline under the prompt, `aria-live`, never a modal)

| Case | Copy (EN, key under `calculators.calendar`) | Visual |
|---|---|---|
| Nothing tapped | `prompt`: "Tap the day your last period started" + `promptHelp`: "Not sure? Pick your best guess — you can change it." | grid only |
| Future day tapped | `futureDay`: "That day hasn't come yet. Tap the first day of your last period." | 14 `--warning-text` with the info icon; cell unchanged |
| Older than the range | `tooOld`: "That's more than 3 months ago. If you've had a period since, tap its first day." | same |
| Start older than one cycle | `pastCycle`: "This cycle has already ended. The results show where it would have fallen." | result still drawn |
| Pregnancy LMP over 42 weeks | `overTerm`: copy from `01` (talk to her midwife or doctor) | no bar |
| `multi` with one start | `needTwo`: "Tap at least one more period start." | first start drawn |
| No JavaScript | `<noscript>`: "The calendar needs JavaScript. How the estimate works is explained below." + the method paragraph | static |

### 2.14 Copy

All new strings go in `messages/{en,ar,fr,es}.json` under `calculators.calendar.*` (EN source above; Arabic by the Arabic medical editor:
feminine address, `،` not em dashes, Western digits, Latin **femio** inside Arabic sentences per S8). Plurals by ICU (`days`, all six
Arabic forms). No string is concatenated around a date; dates enter as ICU arguments.

### 2.15 React component tree (web)

```
components/calendar/                     (new; domain-free, reused by every calculator)
  month-calendar.tsx      <MonthCalendar months mode marks bands selection weekStart showHijri onPick onSetEnd />
    calendar-header.tsx   prev/next buttons · month title (id for aria) · Hijri line
    weekday-row.tsx       <thead> with abbr
    week-row.tsx          <tr role="row"> + <BandLayer> (aria-hidden, absolutely positioned per row)
      day-cell.tsx        <td role="gridcell"><button> number · HijriLabel · MarkerDot</button></td>
    use-grid-focus.ts     roving tabindex + key map (RTL-aware)
    use-long-press.ts     LONG_PRESS_MS, 8px slop
  calendar-legend.tsx     only marks in use
  stepper.tsx             spinbutton + two buttons
  term-window-bar.tsx     §2.7 (replaces calculators/pregnancy-progress.tsx)
  app-handoff-card.tsx    §2.12
components/calculators/
  calendar-calculator.tsx <CalendarCalculator kind=…> composes the above; holds selection state only
  *-calculator.tsx        thin: picks `kind`, copy keys; no maths, no literals
lib/calendar/grid.ts      weeksOf(monthISO, weekStart) → (ISO|null)[][]; WEEK_START_BY_LANGUAGE   (pure, fixture-bound)
lib/calendar/hijri.ts     hijriDay(iso), hijriMonthSpan(firstISO,lastISO)                          (Intl only)
lib/calculators/calendar-marks.ts  calendarResult(kind, input) → { marks: Map<ISO, DayMark[]>, bands: Band[], noConfidentWindow, sentence args, confidence }
                          drawing only: composes the single MR-07/D-02 fertile-window function from `01`, periodForecast, pregnancyTest*,
                          estimateDueDate; fixture fixtures/domain/calendar-marks.json
```
Delete `mini-calendar.tsx` and `pregnancy-progress.tsx` when the last caller moves. `calendar-calculator.tsx` stays under 300 lines.

### 2.16 Flutter equivalent (the app's calendar looks the same)

```
lib/widgets/calendar/
  month_calendar.dart     FemioMonthCalendar({month, mode, marks, bands, selection, weekStart, showHijri, onPick, onSetEnd})
  calendar_header.dart    IconButton 44 · title (titleMedium) · Hijri line (labelSmall)
  week_row.dart           Stack[ CustomPaint(BandPainter) excluded from semantics, Row(7 × Expanded(DayCell)) ]
  day_cell.dart           Semantics(button, selected, label: full sentence) › InkWell(radius 12) › Column[number, hijri?, MarkerDot]
  band_painter.dart       rounded rects; soft edges via LinearGradient shader; dotted stroke via PathMetric dashes; RTL from Directionality
  calendar_legend.dart · femio_stepper.dart · term_window_bar.dart
lib/domain/calendar_grid.dart · hijri.dart · calendar_marks.dart   (twins of the TS above, same fixtures)
```
Tokens the app needs that R1 generates from the CSS into `tokens.g.dart`: `FemioSpace.s1…s32` (4…128), `FemioRadius.xs/sm/md/lg/xl/pill`,
`FemioMotion.press/quick/standard/deliberate/crossfade` (Duration) and `FemioMotion.standardCurve/outCurve/springCurve`
(`Cubic(.2,0,0,1)`, `Cubic(0,0,.2,1)`, `Cubic(.34,1.56,.64,1)`), `FemioType` sizes 12/14/16/18/22/28/36/48. The calendar uses no literal
radius, padding or duration. Breathing: an `AnimationController` (4.8s, reverse repeat) driving opacity .85→1 and height ×1.12, created
only when `MediaQuery.disableAnimationsOf(context)` is false. The result sentence is `Semantics(liveRegion: true)`. Hardware keyboards:
`Shortcuts` + `Actions` with the §2.11 map. In the **Calendar tab** the same widget runs in `log` mode: tapping today or a past day opens
that day's Log; tapping a future day opens a sheet that explains the estimate on it.

### 2.17 Done when (evidence the lead attaches)

Playwright screenshots at 390×844 for fertile-window, period, due-date and cycle-length in EN and AR, light and dark (16 images);
`@axe-core/playwright` clean on each; a keyboard spec that picks a start, sets an end with Shift+Enter and reads the live region; Flutter
goldens of `FemioMonthCalendar` (en/ar × light/dark) in `screens_test.dart`; fixtures `calendar-grid`, `hijri`, `calendar-marks` passing
in both TS and Dart.

---

## 3 · Web teaser pages (390×844 first)

**Shared shell.** Header 56, sticky, frosted: Bloom mark 28 + wordmark **femio** (`--font-display` 22/600, `--primary`) at inline-start;
at inline-end three 44px icon buttons: search, **lifebuoy "Help now"** (label visible from 640px), menu. The menu sheet (`--radius-xl` top,
`--motion-sheet`) lists Learn, Calculators, Conditions, The app, language (endonyms), theme. No sign-in anywhere. Footer on
`--surface-sunken`: explore / trust / legal links (one shared list with the header, report 03 §8), the wellness disclaimer, the
"not a method of birth control" sentence, "Help now", © KM Digital Labs. Reading measure ≤ 68ch; grids ≤ 1080. `[LEAD]` The sticky header
lifebuoy satisfies "Help now in one tap from every page", so the floating crisis launcher is retired on the web (check against ADR-013).

| Page | Order at 390×844 | The one accent | Aurora | Not on the page |
|---|---|---|---|---|
| **Home** `/` | 1 Hero on `.aurora` (≈ 520 tall): H1 `--font-display` 36/40 white, one line 18 white, no button; the **fertile-window calendar card** starts inside the hero's lower edge (−96 overlap) as the one raised element: the site opens on her own calendar. 2 Three proof rows (motif 40 + 16/600 title + 14 line): windows not dates · stays on your phone · Arabic first. 3 "Start here" (3 TTC wedge articles, covers). 4 Calculators (six chips). 5 App band on `--gradient-hero-cycle`: phone mock, privacy line, button. 6 Footer | "Get femio for Android" in the app band | **Yes, hero only** (the only aurora on the web) | stock photos, testimonials, counters, "trusted by", newsletter pop-up, cookie banner (no cookies) |
| **Learn hub** `/learn` | H1 28 + search field (48, `--radius-sm`); "Start here" for TTC (wedge order from `topics.ts`); topic rows with covers (3:2, `--radius-md`, art never carries text); pregnancy weeks as a 6-column grid of week chips (44); conditions row | none | no | the deleted `meet-femio` slug, ads, popularity counts |
| **Article** `/learn/[slug]` | breadcrumb 14; H1 `--font-display` 28/34 (36 at ≥ 768); standfirst 18; byline + **honest review line** ("Reviewed by … on …" or "Not yet reviewed by a clinician"); "Last updated"; key points box (`--surface-sunken`); body 18/1.625 Latin, 18/1.7 Arabic; red-flag box (`--danger-soft`, 1px `--danger-border`, heading `--danger-text` with icon, `--radius-md`); related calculator embedded compact when the topic matches; citations; hand-off card; 3 related | hand-off button | no | share bars, sticky CTAs, photos of people, "every guide is clinician-reviewed" claims |
| **Condition hub** `/conditions/[slug]` (PCOS first) | H1 + one-paragraph overview; "What it can feel like" list; red-flag box; guides list; relevant tool (cycle-length calculator card); hand-off | hand-off button | no | symptom checkers, scores, "do you have PCOS?" quizzes (rule 1) |
| **Calculators index** `/calculators` | H1 + one line; seven cards, single column, 88 tall: a 40px glyph drawn from tokens (band/strip/term bar, not icons) + 16/600 name + 14 line + chevron; order: fertile window, period, pregnancy test, due date, gestational age, cycle length, BMI | none | no | a featured "most popular" badge |
| **Each calculator** | §2.8 | hand-off button | no | native date inputs, dropdowns |
| **/app** | Hero on `--gradient-hero-cycle`: H1 white 36, one line, Google Play badge (Google's artwork, unaltered), "Not on iPhone yet"; phone mock (tokens, no `#1d0f1c`); 3 feature rows (calendar, Learn offline, pregnancy tools); privacy block (on the phone, encrypted, backup you save, no account); Arabic-first line; FAQ (3); disclaimer + birth-control sentence | Play badge | no | prices, download counts, ratings until real |
| **Legal** (privacy, terms) | H1 + effective date; "In short" box (`--surface-sunken`, 5 lines); TOC anchors; sections at 68ch | none | no | motion, accent, hand-off card |
| **Help now** `/help-now` | Works with JS off. H1 28 "If you need help now"; the MR-38 global text first; then a country block (sixteen countries, Arabic-speaking first, `lib/crisis/country-numbers.ts`; a line points every other country to the Find a Helpline directory) with numbers as 56px `tel:` rows (number 22/700, label 14) **only once the owner has verified a named source** (MR-39, `03_LEGAL_PACK.md`); emergency and support services drawn apart; "Worried about someone else" | none (status tokens only) | no | the app, the hand-off card, any tracking, motion |
| **404** | Bloom art piece (§6), one line, links to Learn and Calculators | none | no | jokes |

---

## 4 · App screens for v1 (390×844, Flutter)

**Shell.** Bottom `NavigationBar`, 64 + safe area, `--surface` with a 1px `--divider` top; five destinations **Today · Calendar · Log ·
Learn · Tools**; icon 24 + label 12 always shown; indicator `--primary-soft`, selected icon and label `--primary`. Every top-level screen
has a 56px header: title (`--font-display` 28, start) and at the end two 44px icon buttons, **lifebuoy** (Help now) and **gear**
(Settings). Gutters 16. Cards are `--surface-sunken` or bordered `--surface`; the hero is the one raised element. The record lives on
the phone; nothing here makes a network call.

**Onboarding (the 11 steps that exist → v3).**

| Step | Change |
|---|---|
| welcome | **Arrival moment**: aurora (`AuroraBackground`, §4 end) behind the Bloom mark 96 + **femio** 48 white + one line; language chips (endonyms) at the bottom; "Start" pill `--primary-solid` 48; privacy line "Stays on this phone. No account."; the MR-40 wellness line in 14 |
| goal | Order TTC, pregnant, cycle, menopause (wedge first); "You can change this in Settings" becomes true; fix the Arabic gendered forms (report 12 §6b) |
| birthYear | keep the stepper; at exactly 18 add the one yes/no of D-01 |
| under18 | keep the stop; add "Read the guides" → Learn (rule 2: knowledge is never gated) |
| lastPeriod | **`FemioMonthCalendar` in `period` mode** (tap start, second tap or long-press sets end); "I don't remember" text button skips to cycle length |
| periodLength | **folded into lastPeriod** (the stepper sits under the grid); the separate screen goes |
| cycleLength | stepper 21–45 default 28 + two chips: "Irregular / not sure" (two steppers when on) and "I have PCOS". Both set the **My health** switches of A-05 (no questionnaire, never inferred) and turn on D-02 |
| trying | keep |
| dueMethod | keep the six methods |
| dueDate | `FemioMonthCalendar` in `single` mode with an inline preview: week + days and the term-window bar |
| menoLast | keep |
| *new* reminders | three switches (period window coming, fertile window starts, test day / appointments), all off by default; "discreet text" on by default (lock-screen text never names a health event) |

App lock is **not** an onboarding step: per D-12 it is offered once, as a quiet card on Today after her first entry ("Lock femio with
your phone's screen lock" · Turn on · Not now), and lives in Settings after that.

Progress: "3 of 7" text 14 `--text-muted` plus thin 4px dashes (a task, not a cycle; never a ring). Back is always available.

**The first-prediction moment** (after the last step, cycle and TTC goals): full screen, `AuroraBackground`. 0ms: everything is in
place except the band. 0–400ms: the headline rises 16px into place (movement, no fade). 400–800ms: the window band (white 32% track,
`--prediction-band` window, white today dot) grows from inline-start (`FemioMotion.deliberate`, standard curve). From 800ms it breathes.
Text: eyebrow "Your first estimate", headline the range in `--font-display` 36 white, the confidence word, and "It sharpens as you log
two or three periods." "Continue" (white pill, plum text) is present from the first frame; no auto-advance; one light haptic when the
band lands. With no confident window (D-02) the moment shows her next-period range instead, plus the MR-06 sentence, never an invented
fertile window. Pregnant goal: the week card instead (week motif, week + days, term bar). Reduced motion: the final frame, still.

**Today** (one hero, then quiet cards).

| Goal | Hero (raised, `--radius-lg`, padding 20, white text) | Below the hero, in order |
|---|---|---|
| TTC | `--gradient-hero-ttc`: eyebrow "Fertile window", range `--font-display` 28, the band strip (18 tall: track, soft-edged window, today dot), "Next period likely 30 Oct – 7 Nov", confidence word | "Log today" (`--primary-solid`) + "Period started" (outlined); test-timing card; "This cycle" (OPK and temperature summary → Tools); clinician nudge from `domain/` (quiet `NoticeCard`); one Learn card for her stage; privacy line |
| TTC, irregular or PCOS (D-02) | same gradient; eyebrow "This cycle", headline "No confident window this cycle", the MR-06 sentence, "How to tell afterwards" link; next-period range with the band strip; "Wide estimate" | the MR-14 line (no seek-help clock); ovulation-test and temperature tools first, with the MR-16 line; the PCOS hub card |
| Pregnancy | `--gradient-hero-warm`: trimester eyebrow, "Week 14 + 2 days" `--font-display` 36, white term-window bar (§2.7), "Due around 12 May 2027 · most babies arrive 21 Apr – 26 May". **The "N days to go / overdue" counter goes** (MR-02, rejected 3) | "When to call now" red-flag notice (compact, always present); tools list (movements, contractions, appointments, weight; the week-36 reorder moves to `domain/`); "This week" Learn card with the week motif; in the hero's overflow: "I've had my baby" (D-13) and "My pregnancy ended" (D-14), each behind a gentle confirm sheet |
| Pregnancy, first open of a new week | the hero becomes an **aurora week card** for that day: the week motif 120, week number, one line, "Read week 14" → the week article. The fourth motion moment | same |
| Cycle | `--gradient-hero-cycle`: "Next period", range, band strip, confidence | "Log today", "Period started"; Learn card |
| Menopause | `--gradient-hero-cycle`: months since the last period (no bar, no 12-month mark) | Learn-led list (tools beyond articles are out of v1) |

"Period started" opens the day's flow chips instead of writing `medium` blindly (report 04 #10). "Start over" leaves Today for Settings.

**Calendar.** Header + `FemioMonthCalendar` in `log` mode inside a bordered `--surface` card (§2.16); months swipe horizontally
(`PageView`, reversed in RTL); a "Today" chip appears when away from the current month; any logged entry (temperature and OPK
included) puts a 5px `--log-symptom` dot at the block-end (report 04 #13); legend below; tap rules as §2.16.

**Log.** Header: the date (tap opens the calendar in a sheet to jump; report 04 #14) with previous/next day chevrons (mirrored in RTL).
Sections as chip groups (`chipVariants`, 44 tall), ordered by goal; TTC: flow, ovulation test, temperature, discharge, intercourse (the
quietest styling, `--log-intercourse`), mood, symptoms. Saving is immediate; each save shows a 16px check that pops with
`FemioMotion.springCurve`, and the day's count updates. No "sex" label (rejected 10).

**Learn (new tab).** Bundled content from `packages/content` (EN + AR), offline. Header + search field (48); "For you" (3 articles by goal
and stage); "Start here"; topic grid, 2 columns, covers 3:2 (§6); pregnancy weeks row. **Reader:** back + title in the app bar; H1
`--font-display` 28; honest review line; body 18 (respects the system text scale); red-flag boxes as on the web; citations open in the
browser; a non-translated article shows "Not translated yet" and renders in English with `TextDirection.ltr`.

**Tools (new tab).** "For you now" (her stage's tools), "Calculators" (the same calendar calculators in-app), "Other stages" collapsed but
open (rule 2). Rows 64: 40px `--surface-sunken` tile with a 24 icon, title 16/600, line 14 `--text-muted`, mirrored chevron.

**Settings (gear).** Rows 56, grouped: **Language**; **Appearance** (system / light / dark, OLED black); **Hijri dates** (on in Arabic);
**App lock** (off / phone screen lock; lock after: immediately, 1 min, 5 min); **Backup** (save a backup file now, last saved date, restore
from file; the backup is encrypted with a passphrase she sets); **Reminders** (the onboarding switches + discreet text); **My health**
(the A-05 switches: PCOS, irregular cycles); **My details** (goal, cycle length, period length, due date: editable at last, report 04 #7); **Privacy** (what is stored, where, that
nothing is uploaded); **About** (version, licences, wellness disclaimer, the birth-control sentence); **Help now**; **Delete everything**
(danger zone: a sheet offers "Save a backup first", a checkbox "I understand this cannot be undone", then a `--danger` button; this
replaces the one-tap "Start over").

**Help now (crisis entry).** A full-screen route (not a sheet), reachable from the header lifebuoy on every top-level screen, Settings,
every red-flag box, and **the lock screen** (it never sits behind app lock). Same content and order as the web Help-now page, bundled,
offline; numbers as 56px rows that dial. Nothing is recorded.

**Lock screen.** `--aurora-ground` (plum-900) solid, Bloom 72, "Unlock femio" (white pill) calling the phone's screen lock, "Help now" link.

**`AuroraBackground` (Flutter).** Ground `p.auroraGround`; four `RadialGradient` circles in `aurora1…4` placed as the web's `.aurora`
(92%/8%, 96%/70%, 70%/38%, 18%/14%), drifting ±4% over 22s (reverse repeat); grain = `assets/images/grain.png` (§5) tiled at 14%. Used
on four surfaces only: welcome, first prediction, the pregnancy week card, OG images (web). Paused when off screen and under reduced motion.

---

## 5 · Brand surface

**Source of truth:** `assets/brand/logo/femio-app-icon-dusk.svg` (the art), colours read from `femio.tokens.css` (the script parses
primitives the way `generate-topic-art.mjs` does; it never hard-codes hex). **Dependency:** `sharp@0.35.5` is today a dependency of
`apps/cms` only, which is being retired; add it as a **root devDependency pinned to 0.35.5** (reason: brand raster generation; already in
`allowBuilds`). OG images use **Playwright Chromium** (already in `apps/web`) because it shapes Arabic correctly with the real fonts.

**New source files (hand-made once, committed):** `femio-mark-dusk.svg` (the icon's Bloom on transparent, viewBox 512, centre 256);
`femio-favicon.svg` (the icon simplified for ≤ 48px: petal scale 0.90, inner plum dot removed, cream centre r 48); `femio-logo.svg`,
`-stacked.svg`, `-logomark.svg` **recoloured**: mark uses the icon's petal gradient (`--rose-400` → `--peach-300` → `--saffron-300`) with a
cream (`--art-cream`) and `--plum-700` centre; wordmark lowercase **femio**, Newsreader 600, `--ls-tighter`, fill **`--plum-600` #8A3572**;
`femio-logo-reversed.svg` (wordmark `#FFFFFF`, for plum and aurora grounds); `femio-logo-mono.svg` ink `--neutral-900` #24141F. Delete the
v2 violet copies: `femio-app-icon.svg`, `apps/web/public/icons/app-icon.svg`, the old `apps/web/src/app/icon.svg` (git keeps them).
`assets/brand/fonts/NotoNaskhArabic-SemiBold.ttf` (OFL) is added and bundled in the app too, ending the web/app Arabic-headline split
(report 11 §6).

| Output | Path | Spec | Script |
|---|---|---|---|
| favicon.ico | `apps/web/src/app/favicon.ico` | 16, 32, 48 PNG entries in one ICO | `scripts/brand/generate-icons.mjs` (sharp renders; a 30-line ICO writer, no extra dependency) |
| SVG icon | `apps/web/src/app/icon.svg` | copy of `femio-favicon.svg` | same |
| PNG 16 / 32 | `apps/web/public/icons/favicon-16.png`, `favicon-32.png` | from the favicon SVG | same |
| Apple touch | `apps/web/src/app/apple-icon.png` | 180, opaque, full-bleed dusk (iOS masks it) | same |
| Android Chrome | `apps/web/public/icons/icon-192.png`, `icon-512.png` | `purpose: any`, full icon | same |
| Maskable | `apps/web/public/icons/icon-maskable-192.png`, `-512.png` | dusk background full bleed; Bloom at **scale 0.70** so petal tips sit at 58% of the radius, inside the 80% safe circle | same |
| Manifest | `apps/web/src/app/manifest.ts` (re-created; the R2 tree deleted the violet one with the service worker) | name/short_name "femio"; `theme_color` `#3F1534` (`--plum-900`), `background_color` `#FBF7F3` (`--neutral-50`); the four PNGs; no service worker. Viewport `themeColor`: light `#FBF7F3`, dark `#140D14` | hand edit; values asserted by `brand-lint` |
| OG / Twitter | `apps/web/public/og/og-{en,ar,fr,es}.png` | 1200×630; aurora ground + grain; Bloom 112 at inline-start top (64 inset); **femio** Newsreader 600 72 white (Latin in every locale); one line from `meta.ogLine` (EN Newsreader 44 / AR Noto Naskh Arabic 600 44, `dir="rtl"`, layout mirrored); "femioapp.com" 22 at 70% white; ≤ 250 KB | `scripts/brand/render-og.mjs` (Playwright screenshots `scripts/brand/og-template.html?locale=…` with local font files; sharp compresses) |
| Android legacy icons | `android/app/src/main/res/mipmap-{m,h,xh,xxh,xxxh}dpi/ic_launcher.png` (48/72/96/144/192) and `ic_launcher_round.png` (circle-masked) | full icon | `generate-icons.mjs` |
| Adaptive foreground | `mipmap-*/ic_launcher_foreground.png` (108/162/216/324/432) | Bloom on transparent at scale 0.70 of the 108dp canvas: tips inside the 66dp safe circle | same |
| Adaptive background | `mipmap-*/ic_launcher_background.png` (same sizes) | the icon's dusk radial gradient | same |
| Themed (Android 13+) | `mipmap-*/ic_launcher_monochrome.png` | petals as one white silhouette, no centre dots | same |
| Adaptive XML | `mipmap-anydpi-v26/ic_launcher.xml`, `ic_launcher_round.xml` | `<adaptive-icon>` with background, foreground, monochrome | hand-written once |
| Splash (≤ API 30) | `drawable/launch_background.xml`, `drawable-v21/…` | `--plum-900` colour + centred `@drawable/splash_bloom` (96dp; PNGs 96/144/192/288/384 in `drawable-*dpi`) | bitmaps by `generate-icons.mjs`; XML by hand |
| Splash (API 31+) | `values-v31/styles.xml`, `values-night-v31/styles.xml` | `windowSplashScreenBackground` `#3F1534`; `windowSplashScreenAnimatedIcon` `@drawable/splash_icon` (288dp canvas, Bloom inside the 192dp circle); same in night (the splash is dark in both themes, like the aurora) | same |
| Grain tile | `apps/mobile/assets/images/grain.png`, `apps/web/public/art/grain.png` | 128×128 monochrome noise, alpha 255 (opacity is applied in code) | `generate-icons.mjs` (seeded sharp noise, deterministic) |
| iOS | `ios/` | frozen; not regenerated (out of v1) | — |

Commands: `pnpm brand:icons`, `pnpm brand:og`, and **`pnpm brand-lint`** in the gate: every file above exists at the stated pixel size;
every hex in `assets/brand/logo/*.svg` is a token primitive; `manifest.ts` colours equal the tokens; no `#7C3AED` anywhere in `apps/`.

---

## 6 · Illustration brief (no photos of people; generated as SVG by a session)

**Common rules for every piece.** Built from the Bloom vocabulary in `apps/web/src/components/site/motifs.tsx` (petal, moon, spark) and
organic shapes; colours only from `--art-*` (plum, rose, peach, saffron, sage, each with `-soft`, and `--art-cream`), at most three hues
plus cream per piece; not themed (a cover is a printed object); no text, no faces, no bodies, no anatomy, no hearts, no babies, no
glitter; strokes ≤ 2px or none; soft overlap with 0.85–0.95 opacity instead of outlines; ≤ 6 KB minified; `role="img"` with a translated
`aria-label` supplied by the page, never baked in. A session generates each from the prompt below, saves to the path, and adds it to
`scripts/design/generate-topic-art.mjs` so colours stay token-driven.

**Prompt template:** "SVG, viewBox `0 0 W H`, ground `--art-cream`. Compose [SUBJECT] from petal-shaped forms derived from the Bloom
petal path (`M0,20 C40,-48 40,-144 0,-212 C-40,-144 -40,-48 0,20 Z`), scaled and rotated; use [HUES]; one focal form at the golden
section, inline-start of centre; generous empty space at the inline-end (≥ 40%); no text, no people."

**12 Learn covers** (3:2, viewBox 0 0 600 400, `apps/web/public/art/` and `apps/mobile/assets/art/`):

| Topic | Subject | Hues |
|---|---|---|
| ttc | two petals leaning together under a crescent moon | sage, saffron |
| pcos | a petal ring broken into scattered, uneven petals (rhythm that varies; not a target) | plum, peach |
| fertility-signs | a single petal with a small saffron spark above it | saffron, sage |
| early-pregnancy | a closed bud on a stem, one leaf | peach, sage |
| pregnancy (weeks) | an opening Bloom, three petals unfolded | peach, rose |
| birth-and-after | a full Bloom with one fallen petal resting beside it | rose, plum |
| cycles | a row of moon phases drawn as petals | plum, rose |
| period-health | three rose petals in a soft cluster, one paler | rose, peach |
| conditions | a petal under a protective arc of leaves | sage, plum |
| teens | a small sprout with two petals | sage, peach |
| menopause | a Bloom at dusk, petals resting open, low saffron sun | saffron, plum |
| wellbeing / more | a constellation of sparks forming a loose petal | plum, saffron |

**6 hero pieces** (`assets/illustrations/hero/`): home hero foreground (a large faint Bloom, 20% white, behind the H1 at inline-end,
on the aurora); onboarding welcome (the Bloom mark opening, 3 frames as separate SVGs for a CSS/Flutter cross-step); first prediction
(a horizon line of petals under the band); `/app` hero (petals framing the phone mock); pregnancy-week frame (a petal arch that holds the
week motif); empty/404 (a single petal on cream).

**40 pregnancy-week motifs** (weeks 3–42, viewBox 0 0 240 240, a cream rounded-square ground `radius 32`, `assets/illustrations/weeks/week-NN.svg`).
Each is one familiar object drawn in the Bloom style, chosen for women in Egypt and Saudi Arabia. **The size comparison in the copy must
come from a cited length table; the object list below is a proposal to be matched to that table** `[NEEDS SOURCE]`; copy says "about the
size of", never a measurement she should check. Proposal: 3 a grain of semolina · 4 a sesame seed · 5 an anise seed · 6 a lentil ·
7 a chickpea · 8 a broad bean (فول) · 9 an olive · 10 **a date** · 11 a fig · 12 an apricot · 13 a lime · 14 a lemon · 15 an orange ·
16 **a pomegranate** · 17 a guava · 18 a sweet potato · 19 a mango · 20 a banana · 21 a carrot · 22 a courgette · 23 a grapefruit · 24 an
ear of corn · 25 a cauliflower · 26 a lettuce · 27 a cabbage · 28 an aubergine · 29 a butternut squash · 30 a large pomegranate branch ·
31 a coconut · 32 a bunch of dates · 33 a pineapple · 34 a cantaloupe (شمام) · 35 a honeydew melon · 36 a bunch of molokhia · 37 a bunch of
Swiss chard · 38 a leek bundle · 39 a small watermelon · 40 a pumpkin · 41 a large watermelon · 42 a full basket of dates. Hues: dates and
pomegranates rose/plum, greens sage, citrus saffron/peach.

---

## 7 · Accessibility and RTL sign-off checklist

Every page and screen, before merge, with screenshots attached:

- [ ] Judged at **390×844** in EN light, EN dark, AR light, AR dark (web: Playwright; app: goldens).
- [ ] Contrast measured on **rendered pixels** with alpha composited (bands, washes, aurora); text ≥ 4.5:1, large text and marks ≥ 3:1.
- [ ] Focus ring 3px `--focus-ring` visible on every control, never clipped by a band or card edge.
- [ ] Touch targets ≥ 44×44 (calendar cells, steppers, chips, header icons, legend links).
- [ ] Status never by colour alone: every mark has a word in its label, the legend, or the result sentence.
- [ ] Calendar grid: one tab stop, arrows follow visual direction in RTL, PageUp/Down months, Shift+Enter sets the end.
- [ ] Every day button has a full-date label (Hijri appended in Arabic); the result is announced once per change.
- [ ] Reduced motion: no grow, no breathe, no aurora drift, no spring; every transform carries `motion-safe:` (web).
- [ ] Only one thing breathes per view; motion only in the four named moments plus feedback.
- [ ] One raised element, one accent element per view (name them in the PR).
- [ ] Logical properties only (`ms-`/`me-`/`ps-`/`pe-`/`start`/`end`, `EdgeInsetsDirectional`); no `left:` in new Flutter code; chevrons mirror.
- [ ] Arabic: Saturday-first weeks, Western digits (Hijri too), line-height 1.7, `،` not em dashes, feminine address, Latin **femio**.
- [ ] Mixed-direction runs (dates, ranges, the wordmark inside Arabic) isolated with `<bdi>` / FSI…PDI.
- [ ] Non-translated articles carry `lang`/`dir` of the source and the "Not translated yet" note.
- [ ] No rejected pattern (§1): no ring, no single date, no filling pregnancy bar, no verdict, no photo of a person, no violet.
- [ ] Help now reachable in one tap from every page and screen, including the app lock screen; nothing covers it.
- [ ] Text scale 200% (web zoom; Flutter `TextScaler`) reflows without clipping the calendar or the steppers.
- [ ] No health data in URLs, query strings, analytics, or browser storage on the web.
- [ ] axe (web) and Flutter `meetsGuideline` (tap target, labelled, contrast) pass.

---

## 8 · Open items this spec hands to the lead

1. Week start for `en` moves from Sunday to Monday (§2.3) and the app calendar's colours change to the shared vocabulary (§2.5).
2. One minimum cycle length (lib 20, stepper 21, `01` §5 quotes 20–45 for the due date) and the "not sure" seed of 21–35.
3. The small, still ovulation dot versus `01` §5's ban on "one glowing most likely day" (§2.5): keep, or drop the dot and its line.
4. The pregnancy "days to go / overdue" counter is removed in favour of the term-window sentence (MR-02).
5. The floating web crisis launcher is retired because the sticky header carries Help now (check ADR-013).
6. The week-motif objects must be matched to a cited size table before copy ships; Hijri variant waits on Q4.

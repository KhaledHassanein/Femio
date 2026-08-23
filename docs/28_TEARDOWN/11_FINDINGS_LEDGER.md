# 28.11 — Findings ledger

Everything learned in the teardown sessions of 2026-08-23, in one place, so that no
part of it depends on a conversation still being in context. Chapters 02–10 are the
analysis; this is the record: what was decided, what was corrected, what was judged,
where the evidence sits, and what is still open.

**If you are a new session and read only one file in this directory, read this one,
then `07_GAP_REGISTER.md`.**

---

## 1. Owner directions — the binding record

Every direction Khaled gave during the teardown, in the order given, with the
chapters each one changes. These are decisions, not suggestions; a later session
that contradicts one of these is wrong.

| # | Direction (2026-08-23) | Binds |
|---|---|---|
| **OD-1** | The gap register stays **reference-only** — no `TD-nn` line enters `07_MASTER_TODO.md` until the study is approved. A deliberate, approved exception to the MASTER_TODO covenant. | 07, `STATE.md` |
| **OD-2** | Depth: **deep on the experience surface, inventory the plumbing.** Not exhaustive module-by-module. | 02 |
| **OD-3** | The "beyond parity" layer comes from **our own corpus** — the 73 personas, the adaptation model, EMR-for-life, RTL, privacy — not from more teardowns. | 08 |
| **OD-4** | Capture the visual layer by **extracting assets from the APKs**; later extended to **running the apps** on an emulator. | 10 |
| **OD-5** | **Register: professional and conservative.** No "sex" or "anal sex" logging categories. Where the fact matters clinically it is an **intercourse** or **conception** day, worded conservatively **in every language**. We are not a sexual-education or sexual-wellness platform. Such education belongs in an article or a short conservative tip — never a product surface. Clinical symptoms (dyspareunia, dryness, bleeding after intercourse, libido change as a marker) stay, under clinical names. | 06 §C, 07 TD-06, 08, 10 §6 |
| **OD-6** | **Onboarding**: Flo's is "extensive, soliciting and boring rather than practical and comfortable" — a pain point to kill. Ours must be good-looking, detailed, **joyful but simple**, short, **no overselling**, ethical. | 07 TD-09, 10 §2 |
| **OD-7** | **Monetisation: freemium.** A genuinely useful free tier that shows what Femio can do, then monetise. Specific model to be decided later. | 09, 10 §5 |
| **OD-8** | **No messaging and no chat.** Not planned, not wanted. Flo's "Secret Chats" and "Messages" tabs are not a gap. Be creative with that space — the calculators are a candidate, and no competitor has any. | 07 TD-11 (closed) |
| **OD-9** | **AI assistant is post-V1.** No time or resources before the V1 mobile and web launch; discuss after. | 07 TD-12 (closed) |
| **OD-10** | **Dashboard**: fewer items than Flo, far more than Femio has today. Informative and appealing — daily insights, personalised learning, and the tools that suit *her* persona surfaced on the home screen, **with every one still reachable in its original place**. | 09, 10 §6a |
| **OD-11** | **The calendar should be more prominent** than in Flo, where it sits behind an icon. Detail deferred to the design pass. | 10 §6d |
| **OD-12** | **The Learn section** should follow Flo's Insights tab *structurally* — search, question-shaped topic chips, most-popular row, category rows, bold illustrated cards — with their subject matter excluded and our citations, clinician names and four languages added. | 07 TD-14, 10 §3 |
| **OD-13** | The thesis, stated on seeing the dashboard repaint after one logged period: *"See how when you move up in the persona you are mimicking, the experience changed and resources were provided to you according to your needs? That is the gap I am trying to tell Claude chats since we started Femio — this is how the app should be."* | Everything |
| **OD-14** | The standing rule: **Femio must be at least as good as the three apps combined, and then carry multiple features none of them have.** A gate, not an ambition. | 00, 06, 07, 08 |
| **OD-15** | **Calendar detail is not optional.** Every period day is highlighted, not just the start; the first and last day are further distinguished (bold or equivalent); the whole fertile window is highlighted; expected ovulation is marked distinctly. *"Pay attention to every detail. Flo is very excellent and descriptive for my needs but I need better too — I won't accept less."* | 10 §6d, the design pass |
| **OD-16** | **Build order: the mobile-first web app first**, as usual, tested in the browser (Claude browser or the Chrome extension). When that is right, then talk iOS — and Android. Supersedes chapter 09's web/Flutter split as a *sequencing* instruction: Flutter-only items stay Flutter-only, but nothing waits for a mobile client to start. | 09 |

## 2. Corrections — claims I made and then disproved

Recorded in full because each one changes strategy, and because a later session must
not resurrect the original version from an older chapter.

| # | I originally wrote | The truth | Found by |
|---|---|---|---|
| **C-1** | Femio has no kick counter or contraction timer | We have both — `contraction-timer.tsx` (187 lines) and `movement-counter.tsx` (229 lines), backed by real tables | Reading our own repo |
| **C-2** | GO Flo's strength is 140+ locales including Arabic | Its Arabic is a **40-string stub** of AndroidX library text against 764 English. French is real (621). **No competitor has real Arabic.** | Counting non-library strings |
| **C-3** | Flo's consent covers AppsFlyer | The live screen names **AppsFlyer, Firebase and TikTok Ad Manager** | Running the app |
| **C-4** | No competitor cites sources | **Flo cites in full scholarly format with DOIs** — numbered markers plus a References section. What it lacks is a **named reviewing clinician, review date and editorial policy**. | Running the app |
| **C-5** | Flo analyses none of what it logs | Flo has a **symptom-patterns feature** claiming insights "verified by medical experts". Depth unverified (needs multiple cycles). | Running the app |
| **C-6** | Flo ships six chart surfaces to our one | True of the binary, **misleading about the product**. The screen users actually reach for cycle analytics is a list of dot strips; the "Insights" tab is a content library with no chart. **Nobody here has a data-visualisation layer.** | Running the app |
| **C-7** | Uncertainty-honest prediction is our differentiator | Flo already hedges consistently ("likely", "on or around", ranges). **Table stakes we have not met**, not an edge. Our edge is *explaining* the confidence. | Reading strings, confirmed live |

| **C-8** | Femio has no home for BBT, discharge or an intercourse marker (`docs/29` ch.02 §3, as first written) | All three have existed since schema v1: `fertility_logs.bbt`, `.cm_type`, `.intercourse boolean` — and the boolean is exactly the conservative marker OD-5 asks for. The gap is **surfacing**, not schema: they are reachable only from the TTC screen. | Implementing A3 |

| **C-9** | Femio has no named focus ring (`docs/29` ch.05 §2, as first written) | `--shadow-focus: 0 0 0 3px var(--violet-200)` is applied by a global `:focus-visible` rule and aliased as `--focus-ring`. What was missing was the *width* as a token. | Implementing A8 |

**A second meta-lesson, from C-1, C-8 and C-9.** All three are the same mistake: a gap
asserted from a **count** rather than from a read. `docs/28` chapter 05 measured Femio
as 144 tokens, 27 tables, 40 routes — accurate, and blind to the fact that one token is
a focus ring, one column is a BBT reading and one boolean is exactly the conservative
intercourse marker the owner later asked for. **A gap is not real until someone has
looked for the thing itself.**

**The meta-lesson, and it should govern any future teardown:** reading a binary tells
you what was *built*; running the app tells you what users *reach*. Those differed
materially in six of seven cases above. Never ship a competitive claim that has only
been read from code.

## 3. What Flo actually is — the ten things that matter

Condensed from chapters 02 and 10. If the rest of this directory is lost, these are
the findings worth keeping.

1. **The client is a renderer; the server owns the product.** ~65 server-driven UI
   element types, and screens shipping in *pairs* — native beside `Uic` — behind a
   flag. Their migration is per-screen with no flag day. Ours can be too.
2. **Their element envelope has eleven fields; our `ModuleSpec` has three.** The
   missing ones include `accessibility` and `impressionConfig`, so on their side a
   served module *cannot* ship unlabelled or untracked. This is TD-03 and it should
   land before more modules are written.
3. **Onboarding is data, not code**: 442 steps, 634 conditional edges, 141 branching
   tags, precomputed progress per edge, no expression language. A shape our persona
   resolver should serialise to.
4. **The served product diverges from the shipped binary.** Bundled goals list nine
   with no menopause; the live one lists eight with four midlife. Flo is
   repositioning onto our Track E.
5. **State change repaints everything.** One logged period turned the background from
   peach to teal, recoloured the date strip, replaced the hero with a live prediction
   and re-layered the content cards. Phase is communicated by the whole screen.
6. **Their design system is real**: nine typed token files, semantic cycle-state and
   per-event-category colours each with an Alternate variant, five illustration skin
   tones, fifteen avatar backgrounds — on **stock Roboto**. Identity is carried by
   colour, illustration and motion, not type.
7. **They grade the cycle.** ABNORMAL / IRREGULAR verdicts shown on one logged period,
   beside empty placeholder bars, on a card that admits it needs two. We refuse to do
   this and should make the refusal visible.
8. **They have no data-visualisation layer.** See C-6.
9. **`supportsRtl="false"`, zero locale folders, runtime server-side localisation.**
   The market leader's Android app does not mirror for RTL.
10. **Their regulatory disclaimer sits at the point of risk** — attached to the
    fertility number itself, not buried in terms: *"Flo does not predict your
    fertility status and cannot be used as a method of contraception or to aid
    conception."*

## 4. Judgements — my reading, flagged as opinion

Separated from findings on purpose. These are inferences, and a future session is
free to disagree with them if it has better evidence.

**Femio's problem is not the engine.** `lib/experience` (2,909 lines) and
`lib/persona` (2,100) are better than anything in the three apps, and the three-source
resolution in `client.ts` has no competitor analogue. The problem is that 24 of 73
personas are wired, one chart exists, and there are zero animation assets. We built
the engine and most of the chassis and almost none of the body. That is a *cheaper*
problem than the reverse.

**The category's open ground is narrower than we assumed but still real.** Arabic and
RTL is genuinely unopposed. Attributed clinical review by a named person is
unopposed. A real chart layer is unopposed. Refusing to grade her cycle is
unopposed. The life-spanning record is structurally hard for anyone organised around
a current track. Everything else — cited content, hedged predictions, symptom
patterns, condition triage — has at least one competitor already there.

**The 442-step onboarding is a liability, not an asset.** 124 selling cards to 90
questions, six social-proof stat cards, a tap-and-hold commitment ritual and a
paywall at the end. OD-6 is right, and it is also a competitive opportunity: getting
her to a working dashboard fast is a thing they cannot copy without losing conversion.

**Content volume is the gap we cannot close by effort.** 1,000+ articles against our
105 authored / 31 live, English only. Beating that on volume is not realistic;
beating it on attribution, currency, language and persona-fit is.

**The most dangerous thing in our own repo** is that two-thirds of the persona
taxonomy is unwired while the docs describe it as if it were live. Anyone reading
`docs/08` and `docs/09` would assume 73 working personas. There are 24.

## 5. Evidence index

Nothing below is committed; all of it is outside the repository.

| Location | Contents |
|---|---|
| `E:/re/flo/` | Flo 10.3.0 decompiled (35,196 classes) |
| `E:/re/preg/`, `E:/re/preg2/` | Pregnancy Tracker 1.0.20 decompiled |
| `E:/re/goflo/` | GO Flo 1.1.9 decompiled |
| `E:/re/shots/` | 80+ device screenshots from the emulator walkthrough |
| `E:/re/notes/flo-activities.txt` | 157 Flo-owned activity classes |
| `E:/re/notes/flo-onboarding-steps.txt` | 442 step ids with types |
| `E:/re/notes/flo-onboarding-transitions.json` | 634 edges with conditions and progress |
| `E:/re/notes/flo-onboarding-condition-tags.txt` | 141 branching tags |
| `E:/re/notes/flo-onboarding-questions.md` | All 90 onboarding questions with answers |
| `E:/re/notes/flo-onboarding-featurecards.md` | 160 feature cards and announcements |
| `E:/re/notes/flo-symptoms.txt` | Flo's 47-symptom vocabulary |
| `E:/re/apks/flo/` | Extracted XAPK ready for `adb install-multiple` |

### Reproducing the environment

```bash
# jadx shim (the stock launcher builds a POSIX classpath Windows Java rejects)
export JAVA_HOME="/c/Program Files/Android/Android Studio/jbr"   # JDK 21, already installed
export PATH="$JAVA_HOME/bin:$HOME/.local/bin:$PATH"

# emulator
"$LOCALAPPDATA/Android/Sdk/emulator/emulator.exe" -avd Medium_Phone -no-snapshot-load
adb install-multiple -r /e/re/apks/flo/*.apk

# walk the UI: text-first, screenshot only what is visually distinctive
adb exec-out uiautomator dump /dev/tty | grep -oE 'text="[^"]+"'
adb exec-out screencap -p > shot.png
```

Helper scripts written during the session: `E:/re/step.sh` (tap by coordinate, dump,
screenshot) and `E:/re/tapp.sh` (tap the node matching a text label).

**Traps that cost time and will cost it again.** The skill's `decompile.sh` aborted
silently on XAPKs and still exited 0 — fixed at `decompile.sh:264`, but always verify
the output directories exist. The default JDK is 11, below jadx's floor; Android
Studio's bundled JDK 21 is already on disk, so install nothing. `uiautomator dump`
to a file on `/sdcard` returned nothing; `dump /dev/tty` works. Flo's year picker is a
wheel whose centre slot reads "Select" until a value is scrolled in — tapping it does
nothing.

## 6. Method rules that earned their place

For whoever runs the next teardown.

**Read the binary first, then run the app.** The binary gives structure, vocabulary
and the complete element inventory cheaply. Running gives what the server actually
serves and what users actually reach. Neither alone is sufficient — see §2.

**Walk the UI with text dumps, not screenshots.** `uiautomator dump` costs almost
nothing; a screenshot costs a great deal of context. Screenshot only what is visually
distinctive, and read only what you screenshot.

**Guard every automated tap.** Scan the dumped text for price patterns and purchase
verbs before advancing. A naive "tap Continue until something changes" loop walks
into a paywall.

**What Claude will not do, regardless of instruction:** create accounts, enter
passwords, or complete purchases. The owner did the one subscription involved, on his
own account. Consent screens were passed at the two required checkboxes only; the
optional ad-tracking consent was declined.

**Copyright boundary.** Structure, mechanism and taxonomy are documented because that
is where the engineering value is and it is not theirs to own. Their code, copy,
illustrations and animations are not copied into Femio, ever. Where a chapter says
"adopt this shape", it means design the equivalent from our own tokens and our own
voice.

## 7. Status and what remains

**Done.** Three apps decompiled. Flo walked end to end on a device — 57 onboarding
screens plus the subscribed dashboard, symptom panel, calendar, cycle history and
cycle details. Chapters 00–11 written. Fourteen owner directions recorded. Seven
corrections made.

**Next, in order.**

1. Finish Flo: perimenopause and pregnancy tracks, settings, the premium content
   library at depth, and the multi-cycle probability calendar (needs three or four
   logged cycles to force the two-tier "likely / may start" bands from chapter 02 §7).
2. Run the Pregnancy Tracker and GO Flo the same way, and write their running
   chapters.
3. **The revamp plan** — the deliverable this whole study exists to produce. Owner's
   framing: start from infrastructure and database, through the experience engine,
   up to UI and design, so the app is built as it needed to be from the first place.
   Everything in `07_GAP_REGISTER.md`, `08_DIFFERENTIATION.md` and this ledger feeds
   it. It should land as its own document, not as a chapter here.

### A worked example of OD-15 — what "better" has to mean

Flo's calendar carries four states: solid pink fill for every logged period day, teal
numeral for every fertile-window day, a dotted teal ring for predicted ovulation, grey
fill for today. It highlights the whole period and the whole window — not just start
days — which is the standard OD-15 sets as the floor.

Beating it, concretely, is a matter of adding information Flo has nowhere to put:

- **Period run, with its ends distinguished** — the first and last day visually
  bounded, so the length reads at a glance without counting.
- **The fertile window as a band, with its edges soft** — because the edges are the
  least certain part of the estimate, and a hard edge asserts a precision we do not
  have.
- **Expected ovulation marked distinctly from the window**, as Flo does, but tappable
  to say what it rests on.
- **Two-tier predicted period days** — Flo's own strings carry "likely to start" and
  "may start" bands; ours should render both, visibly different, from the first cycle
  where the data supports it.
- **A confidence affordance on the prediction itself**, per D2 — the thing Flo hedges
  but never explains.
- **Logged symptoms visible on the grid**, so the month reads as a record rather than
  only a forecast. None of the three apps does this.

All of it must survive the 390×844 test in light, dark and Arabic RTL, where a
right-to-left month grid changes which edge is "start".

**Still not observed in Flo.** The two-tier probability calendar with real history.
Partner mode proper (entered by accident, then abandoned). Perimenopause and
pregnancy tracks. Anonymous mode. The symptom-checker. Wellbeing scoring. Health
Connect wiring. Stories and vertical feed. Settings and the premium content library.

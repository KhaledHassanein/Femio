/**
 * Track F — perimenopause and menopause (R2.9, ADR-061).
 *
 * Encoded from `docs/personas/F1_perimenopause.md` and
 * `F2_menopause_postmenopause.md`, and drawn first as
 * `assets/mockups/R1.7_menopause_dashboard_reference.html`. Same rule as Track B:
 * these are the reference's module lists, and `docs/25` §1 says the reference is
 * the bug report when the two disagree.
 *
 * ## The brief for this track is one sentence
 *
 * `docs/25` §3.5: it **reports a count and refuses a conclusion, and that has to
 * read as respect rather than as evasion.** Everything below is an answer to it.
 * The clinical convention is twelve months without a period *with no other cause*,
 * and that last clause is why Femio counts and stops — pregnancy, thyroid disease
 * and several medicines also stop periods, and deciding which applies is diagnosis
 * (product rule 1, ADR-042/043).
 *
 * ## F2 does not extend F1, and that is the whole design
 *
 * Every other layered persona in this registry extends its general form, because
 * layers *add*. F2 cannot: §I is explicit that its home has **no cycle view, no
 * prediction, no "late" anything**, and `build.ts` has no code path that subtracts
 * a module — deliberately, since ADR-057 and `types.ts` both make "cannot express
 * restriction" a structural property rather than a habit. So the two records are
 * siblings, and the postmenopause screen is built from what it needs rather than
 * from what perimenopause left behind.
 *
 * ## What this track may never draw
 *
 * No ring, no bar filling toward twelve months, no countdown. A progress track
 * toward the marker would read as a countdown to a diagnosis, which is the
 * conclusion Femio is not allowed to reach. `tone.countdown` is false in both
 * records and a test asserts it; what replaces the ring is `menopause.trend` —
 * the shape of the transition with no endpoint drawn.
 */

import type { PersonaRecord } from "../types.ts";

/**
 * F1 — perimenopause, the transition.
 *
 * §I's home, in its order: *"Hero = uncertainty-first cycle trend ('cycles
 * lengthening — normal in perimenopause') + days-since-last-bleed — no 'late'
 * counter, no confident next-period date. MRS card pinned. Symptom-cluster
 * tracker pinned."*
 */
const F1: PersonaRecord = {
  id: "F1",
  track: "F",
  home: {
    // `default`, like Tracks A and B: `Phase` is Track D's vocabulary and a
    // transition has no trimester. STRAW+10 staging would be the natural
    // equivalent and Femio does not stage her (§I is a hint, not a stage).
    default: [
      /**
       * The hero is her own cycle lengths — 31, 24, 41, skipped, 38, 62 — with a
       * days-since count and the sentence saying Femio will not offer a date while
       * they vary this much. §I: *"Replace the point-date 'your period is due on
       * X' with a trend + range + narrative… We won't guess an exact date."*
       *
       * Skipped cycles are drawn, not omitted (R1.7). A gap reads as missing data;
       * a skipped cycle is data, and it is the most characteristic thing about
       * late transition.
       */
      { id: "menopause.trend", emphasis: "hero" },
      /**
       * What the count does and does not mean, directly under the hero rather than
       * inside it. Four lines of qualification in white-on-violet is not how you
       * present the most important sentence on the screen — the shipped panel
       * already made that call and it stands.
       */
      { id: "menopause.marker", emphasis: "primary" },
      { id: "menopause.symptomStrip", emphasis: "primary" },
      /**
       * The MRS (P2.4). A number, her own previous totals, and **no word** — no
       * band, no severity label, and the module carries no threshold. The
       * literature attaches cut-offs; applying them would be Femio assessing her,
       * and the woman that hurts is the one who reads "mild" and decides the
       * appointment can wait.
       */
      { id: "mrs", emphasis: "primary" },
      { id: "quickLog", emphasis: "primary" },
      /**
       * One list, not an HRT card (P2.4). A woman on a patch, levothyroxine, iron
       * and a vitamin has one list, and an HRT-shaped module here would rebuild
       * the restriction-by-data-structure that decision avoided. No dose guidance
       * and no adherence score travel with it.
       */
      { id: "medications", emphasis: "secondary" },
      { id: "visitPrep", emphasis: "secondary" },
      { id: "library", emphasis: "secondary" },
      { id: "explore", emphasis: "secondary" },
    ],
  },
  /**
   * `period` stays, and it matters. §G's cycle log is how the trend exists at all,
   * and it is also the only way she can tell Femio about bleeding that is worth
   * mentioning. `medication` is the MHT log, educational and entry-only.
   */
  tools: ["period", "symptom", "mood", "medication"],
  content: {
    skin: "perimenopause",
    // §F's modules, as topics. Three have published articles today.
    foreground: [
      "perimenopause-explained",
      "why-cycles-are-unpredictable",
      "tracking-menopause-symptoms",
      "menopause-care-options",
      "mood-and-brain-fog",
      "getting-taken-seriously",
    ],
  },
  alerts: [
    /**
     * §G's twelve-month milestone, as **education**: *"You've logged ~12 months
     * without a period. Clinically this is often when menopause is confirmed — a
     * good time to check in with your clinician."* A milestone `kind` would be
     * wrong twice over — it would render as a celebration, and it would state a
     * conclusion.
     */
    { id: "menopause.twelveMonths", kind: "education", params: { afterDays: 365 } },
    /**
     * §G's abnormal-bleeding awareness — flooding, very frequent bleeding, or any
     * bleeding after a twelve-month gap. Education here and a **red flag in F2**,
     * and the difference is real rather than a wording preference: in
     * perimenopause a heavy or close-together bleed is common and worth
     * mentioning; after twelve months it is the one thing this product routes on.
     */
    { id: "menopause.abnormalBleeding", kind: "education" },
    { id: "menopause.moodFollowUp", kind: "education" },
  ],
  emrView: ["daysSinceLastBleed", "cycleTrend", "mrsHistory", "hrtLog"],
  tone: {
    /**
     * Warm rather than neutral, and §B is the reason: this persona's recorded
     * experience is of being dismissed. Validation is the clinical-adjacent value
     * here in the way reassurance is for A1.
     */
    register: "warm",
    celebrationByDefault: false,
    // Never. §I: *"Never show a red 'X days late' state; reframe as 'days since
    // last period' neutrally."*
    countdown: false,
    readingLevel: "standard",
  },
};

/**
 * F2 — menopause and postmenopause.
 *
 * A sibling of F1, not a layer on it (see the file comment). §I: *"Hero =
 * long-term-health + persistent-symptom summary — no cycle view, no prediction, no
 * 'late' anything."*
 */
const F2: PersonaRecord = {
  id: "F2",
  track: "F",
  home: {
    default: [
      /**
       * "Two years and five months since your last period" is a fact. "You are
       * postmenopausal" is a conclusion, and this screen says the first. The word
       * postmenopause appears in this record only as the name of a content skin.
       */
      { id: "menopause.since", emphasis: "hero" },
      /**
       * The one danger surface in Track F, and it sits directly under the hero in
       * every state rather than appearing only after a bleed (§G: the box is
       * shown *every time*, "never normalized or dismissed"). Two rules travel
       * with it: **no phone number** (P1.26.1, global-only), and it is **never
       * attributed to dryness** — F6 §I calls that out because the GSM content is
       * the most plausible wrong explanation she could reach for on her own.
       */
      { id: "menopause.pmb", emphasis: "primary" },
      { id: "menopause.symptomStrip", emphasis: "primary" },
      { id: "mrs", emphasis: "primary" },
      /**
       * §I's bone and heart cards. Awareness, never risk-scoring: what Femio can
       * do is make sure she knows which questions exist, and the screening
       * decision is her clinician's.
       */
      { id: "menopause.longTerm", emphasis: "primary" },
      { id: "quickLog", emphasis: "primary" },
      /**
       * Surfaced, and deliberately dull. F6's content is reachable from search
       * whether a discreet mode is on or off — discreet mode hides *presentation*,
       * never access — and nothing here reads across a room.
       */
      { id: "gsm", emphasis: "secondary" },
      { id: "medications", emphasis: "secondary" },
      { id: "visitPrep", emphasis: "secondary" },
      { id: "library", emphasis: "secondary" },
      { id: "explore", emphasis: "secondary" },
    ],
  },
  /**
   * `period` is still here, and removing it would be the worst edit available in
   * this file. §G: in postmenopause the bleeding log's purpose **flips** from
   * "track your cycle" to "note and act on any bleeding". Same tool, different
   * meaning — and it is the only way she can tell Femio the one thing it most
   * needs to hear. `labs` is §G's entry-only long-term-health record: her DXA, her
   * blood pressure, her numbers, displayed and never interpreted.
   */
  tools: ["symptom", "mood", "period", "medication", "labs"],
  content: {
    skin: "postmenopause",
    foreground: [
      "menopause-explained",
      // §F module 10, and the most important unwritten page in this track: *any*
      // bleeding after twelve months, said calmly and without minimising.
      "postmenopausal-bleeding",
      "bones-after-menopause",
      "heart-after-menopause",
      "menopause-care-options",
      "gsm-explained",
    ],
  },
  alerts: [
    /**
     * The only `redFlag` in Track F. §G gives it its own box and says it is never
     * normalised and never reassured away — "probably nothing" is explicitly not
     * shown, and the word cancer is never used as a claim.
     */
    { id: "menopause.postmenopausalBleeding", kind: "redFlag" },
    { id: "menopause.boneAwareness", kind: "education" },
    { id: "menopause.heartAwareness", kind: "education" },
    { id: "menopause.gsm", kind: "education" },
    { id: "menopause.moodFollowUp", kind: "education" },
  ],
  emrView: ["yearsSinceFinalPeriod", "mrsHistory", "hrtLog", "longTermHealthEntries"],
  tone: {
    // §I's tone rule: healthy aging, not decline. Agency-forward, validating of
    // symptoms that persist, and neither doom nor toxic positivity.
    register: "warm",
    celebrationByDefault: false,
    countdown: false,
    readingLevel: "standard",
  },
};

/**
 * F3, F4, F5 and F6 are **not here, and F6 is a decision rather than a gap.**
 *
 * F3 (comorbidity) and F5 (premature / early) need context nothing records, and
 * F4 (surgical or induced) needs the cause capture its §I describes — a wizard
 * question that does not exist. Those three are the ordinary "no signal, no rule"
 * case, the same as B2/B3/B4.
 *
 * **F6 (GSM) is different, and it must not become a resolver rule.** The signals
 * to fire it already exist — P2.4 added vaginal dryness and urinary urgency to the
 * shared symptom vocabulary — so it would be easy, and it would be wrong. F6 §I
 * says entry offers **discreet mode first, before any content loads**, and every
 * route into it is an offer she accepts. A resolver that switched her home screen
 * to a GSM skin because she logged dryness twice would be announcing her intimate
 * symptoms on her own phone, unasked, possibly in front of someone — which is the
 * one failure that persona is written to prevent. F6 arrives when the opt-in
 * surface does (**P2.14**), and until then its content stays reachable from search
 * and from F2's `gsm` module, which is what hidden-but-reachable means.
 */
export const TRACK_F_RECORDS: readonly PersonaRecord[] = [F1, F2];

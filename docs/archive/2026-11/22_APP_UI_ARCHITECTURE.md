# 22 — App UI architecture and conventions

**Status:** living. Written 2026-08-07 after the P1.28 design workstream (ADR-051…055)
and the cleanup that followed it. Read this before adding a screen, a control, or a
design token. It is the "how", not the "why" — the reasoning lives in the ADRs it
cites, and the product rules that outrank all of it are in `CLAUDE.md`.

This document covers the **signed-in tracker UI**. The public content site
(`app/[locale]/(public)`) shares the token layer and `components/ui`, but its own
patterns are documented with the SEO work.

---

## 1. The shape of a screen

Every signed-in screen is a **client component that reads its own data**. No server
components on this path — that constraint is what makes the app shippable to iOS and
Android, and `pnpm native-readiness-lint` enforces it (ADR-048, `docs/21`).

A screen has exactly three states and one frame:

```tsx
export function ThingScreen() {
  const t = useTranslations("thing");
  const query = useSupabaseQuery(async (supabase) => { /* … */ });

  if (query.status === "loading") {
    return (
      <AppScreen busy>
        <LoadingState label={t("loading")} />
      </AppScreen>
    );
  }

  if (query.status === "error") {
    return (
      <AppScreen>
        <ScreenError
          title={t("title")}
          message={t("loadError")}
          retryLabel={t("retry")}
          onRetry={query.refresh}
        />
      </AppScreen>
    );
  }

  return <AppScreen>{/* … */}</AppScreen>;
}
```

`AppScreen` owns the frame — max width, gutters, vertical rhythm. Use it for all
three branches. It exists because the same class string had nine copies, and when
the shell was retuned for a phone the loading branch was missed, so the page visibly
reflowed the moment its query resolved.

**The error branch is not optional and must keep its heading.** To someone looking at
her own health record, "nothing here" and "we could not load it" are very different
statements (ADR-046). Never render an empty screen on a failed read.

Where the page file sits:

| File | Responsibility |
|---|---|
| `app/[locale]/(app)/thing/page.tsx` | `generateMetadata` + `setRequestLocale` + `<AuthGate>` only |
| `components/thing/thing-screen.tsx` | the screen: reads, branches, composes |

`page.tsx` must not read Supabase, use `force-dynamic`, take `searchParams`, or call a
Server Action. `AuthGate` replaces the server `redirect()`; **RLS is the security
boundary**, not the gate.

---

## 2. Layers, and which one your change belongs in

```
assets/brand/tokens/          the design system's values (CSS vars + Tailwind preset)
  ↓
components/ui/                domain-free primitives: Button, Chip, ChoiceGroup, HeroCard, Card…
  ↓
components/patterns/          screen-level compositions: AppScreen, ScreenError, LoadingState
  ↓
components/<feature>/         cycle/, pregnancy/, menopause/, account/, onboarding/
  ↓
app/[locale]/(app)/…          routing, metadata, auth gate
```

Two rules, both learned the hard way:

- **A component imported by two features belongs in `ui/`, not in the first feature
  that needed it.** `HeroCard` lived under `dashboard/` while pregnancy and menopause
  reached sideways for it.
- **A `lib/` module used by more than one domain loses its domain folder.**
  `predictionBand` was `lib/cycle/band.ts` while the pregnancy panel used it for a
  37w–42w term range and had to pass a computed LMP as `cycleStart`. It is now
  `lib/ui/range-band.ts` with an `axisStart`.

---

## 3. Controls: pick the right one

| Situation | Use | Why |
|---|---|---|
| Multi-select (symptoms) | `chipVariants({ selected })` + `aria-pressed` | genuinely toggles |
| Single-select cards (life stage, account type) | `<ChoiceGroup>` | radio semantics **with** roving tabindex |
| Single-select pills that can be cleared (flow, severity) | `chipVariants` + `aria-pressed` | clicking again deselects, so it is a toggle |
| An action | `<Button>` | press feedback and 44px come with it |

**`role="radio"` is a promise.** WAI-ARIA's radiogroup pattern is a single tab stop
with arrow-key movement. Announcing the role without the behaviour is worse than
plain buttons, because it tells a keyboard user to expect something that will not
happen. `ChoiceGroup` owns Arrow/Home/End and roving `tabindex` so no screen can
implement half of it again — this happened twice before it was centralised
(ADR-054, and the cleanup after).

**Touch targets are 44px minimum** (WCAG 2.2 AA). `chipVariants` and `Button` both
clear it. This was fixed once for cycle chips and had to be fixed *again* months
later for pregnancy chips, because there were four copies of the class string.
There is now one.

---

## 4. Motion

- **`prefers-reduced-motion` is enforced globally** in `globals.css`. You do not
  need to remember it, and a dependency's animation is covered too.
- **Keep writing `motion-safe:` on transforms anyway.** The global rule zeroes
  `transition-duration`, which makes a `scale` *instant* — it does not remove it.
  For transforms the prefix is load-bearing, not decoration. Do not delete it on the
  grounds that "the global rule covers it"; it does not.
- Durations and easings come from tokens: `duration-fast|base|slow`,
  `ease-standard|spring`. Do not hand-write milliseconds.

---

## 5. Bottom bars and the crisis launcher

Anything fixed to the bottom of the viewport carries the class **`app-bottom-bar`**.
That single hook does two jobs, both in `globals.css`:

1. defines `--bottom-bar-clearance` on `body` — which `.pb-bottom-bar` consumes, so
   scrolled content is never trapped under the bar;
2. lifts the global crisis-help launcher clear of it.

The launcher is a safety affordance (P1.26) and **must never be the thing that gets
covered**. It was, on the day the tab bar shipped, and only a phone-viewport
screenshot caught it. If you add a bottom bar and forget the class, you will
reintroduce that.

---

## 6. Design tokens

`assets/brand/tokens/femio.tokens.css` is the source of truth;
`femio.tailwind.preset.js` maps it into Tailwind. **A token that is not in the preset
does not exist as a utility** — Tailwind emits nothing for an unmapped class, with no
error of any kind. `pnpm tokens-parity-lint` now fails the build on that gap; it
found two more (`--z-base`, `--z-raised`) on its first run.

Two conventions:

- **Text on a gradient uses `--gradient-hero-*`.** The decorative gradients
  (`--gradient-brand`, `--gradient-fertile`) run out to tints where white text is
  4.1:1 and 1.7:1. Every stop of a hero gradient is AA-safe under white.
- **`HeroTone` names a palette, not a life stage** — `brand | fertile | warm`. The
  first version was `cycle | ttc | warm`, so menopause had to pass `tone="cycle"`,
  and the type would have needed a member per persona.

⚠️ **Editing the preset alone does not invalidate Next's PostCSS cache.** The build
will report success and ship the previous stylesheet. `rm -rf apps/web/.next/cache`
after any preset change, then grep `.next/static/css` for the class you expect.

---

## 7. Dates

Two rules, both of which have already caused a bug:

- **Rendering:** an ISO date is parsed as `new Date(`${iso}T00:00:00Z`)` and
  formatted with `timeZone: "UTC"`. Both halves are load-bearing — drop either and
  dates shift a day for users west of UTC.
- **Storing a backdated entry:** use `loggedAtForDate(date, today)`. It returns
  `null` for today (keeping the column's `now()` default and the real time of day)
  and **local noon** otherwise. Not UTC noon: that lands on the next day at UTC+13/+14.
  Not local midnight: it does not exist on dates when a zone springs forward at 00:00.

---

## 8. Saving, and the trap that survived two reviews

**`router.refresh()` does nothing on these screens.** It re-runs server components,
and ADR-048 removed all of them from the tracker path. A logger that calls it appears
to work — the write succeeds — while the screen keeps showing stale data until a full
page reload. This shipped, twice, and was invisible from inside the code.

The pattern:

```tsx
export function LogThing({ date, today, onSaved }: { date: string; today: string; onSaved?: () => void }) {
  // …
  const res = await saveOrQueue("table", rows);
  if (res === "synced") { reset(); setSaved(true); onSaved?.(); }
  else if (res === "queued") { reset(); setQueued(true); }
  else setError(res.error);
}
```

The screen passes `onSaved={query.refresh}`. Always confirm the save — before this,
a successful write produced no feedback at all beyond the selection disappearing.

---

## 9. i18n

- Four locales, EN is master. Arabic is **RTL-first**, not an afterthought: use
  logical properties (`ms-`/`me-`, `start`/`end`, `insetInlineStart`) and never
  `left`/`right`.
- The brand wordmark is always English **"femio"**, in every locale (product rule 6).
- The catalogs are Prettier-formatted and some maps are on one line. **Insert keys as
  text; never re-serialise with `json.dumps`** — it produces a 400-line reformat diff.
- Client payload is split: the root layout ships `PUBLIC_CLIENT_NAMESPACES`, the
  `(app)` layout adds `APP_CLIENT_NAMESPACES`. Add app strings freely; they no longer
  weigh on the SEO pages (ADR-050).
- A namespace copied from English renders perfectly and passes key-parity. Three of
  them shipped that way for months. `pnpm i18n-untranslated-lint` compares **values**.

---

## 10. Verification

Judge on a **390×844 phone viewport first**, in light and dark, and in Arabic RTL.
Mobile is the destination; the web is how we build it (ADR-048).

Every serious defect in this workstream was found by looking at a rendered screen or
by driving a browser — the covered crisis launcher, the square radio dots, the
Arabic bidi mangling, the stale list after saving. None were visible in a diff. A
screenshot is not a nice-to-have here; it is the test.

The full gate, before any push:

```
pnpm build && pnpm typecheck && pnpm lint
pnpm claims-lint && pnpm crisis-lint && pnpm analytics-lint
pnpm i18n-client-lint && pnpm i18n-untranslated-lint && pnpm tokens-parity-lint
pnpm content-lint && pnpm native-readiness-lint
pnpm test
CI=1 pnpm --filter web test:e2e:ci     # after a fresh build
```

**Watch a new guard fail before trusting it.** Every guard added in this workstream
was verified by breaking the thing it protects and seeing red.

---

## 11. Known gaps

Tracked rather than implied:

- `bmi-calculator.tsx`, `set-due-date.tsx` and `admin/translation-editor.tsx` still
  use `aria-pressed` for mutually-exclusive choices. Pre-existing, outside the
  tracker path; migrate to `ChoiceGroup` or a segmented control when touched.
- `patterns/EmptyState` and `patterns/ErrorState` are used only by the component
  gallery. `ErrorState` is a genuinely different surface from `ScreenError` (a
  full-bleed panel vs an inline retry alert) and should stay; `EmptyState` should be
  adopted or deleted.
- `daysUntilPredicted` in `lib/cycle/predict.ts` has no caller. It encodes product
  rule 3's "no late counter in irregular modes" as executable code, which is why it
  has not simply been deleted — decide deliberately.
- The `walk(dir)` filesystem crawler is copy-pasted across four `scripts/*-lint.mjs`.

"use client";

import { useMemo, useState } from "react";
import { ChevronDown, ChevronUp, Eye, EyeOff, Search } from "lucide-react";
import { useFormatter, useTranslations } from "next-intl";

import { AppScreen } from "@/components/patterns/app-screen";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { SeverityChip, nextSeverity, type Severity, type Tone } from "./severity-chip";
import { addDays, todayISO } from "@/lib/calculators/dates";
import {
  DEFAULT_DIMENSION_ORDER,
  moveDimension,
  orderedDimensions,
  searchTerms,
  type CategoryPreference,
} from "@/lib/experience/v2/log-search";
import {
  buildLogWrites,
  hasAnything,
  isSingleSelect,
  VITAL_UNITS,
} from "@/lib/experience/v2/log-write";
import { termsInDimension, type LogDimension, type LogTerm } from "@/lib/experience/v2/vocabulary";
import { createClient } from "@/lib/supabase/client";
import { saveOrQueue } from "@/lib/offline/sync";
import { Button } from "@/components/ui/button";
import { Alert, AlertDescription } from "@/components/ui/alert";

/**
 * The log screen (RB-C6, `docs/29_REBUILD/06` §3).
 *
 * Flo's `SymptomsPanel` is the best logging screen in the study and its mechanics
 * are tone-neutral, so they are taken wholesale: a date navigator so any day is
 * loggable without leaving, search across every trackable, one card per category,
 * and categories she can reorder and hide.
 *
 * Two deliberate divergences, both from chapter 02:
 *
 * - **The dimensions are ours.** Mood is its own section rather than scattered
 *   through symptoms, and the intercourse dimension holds **one conservative
 *   marker** (OD-5) rather than a taxonomy of acts.
 * - **Severity is first-class.** See `severity-chip.tsx` for the interaction and
 *   why it matters: Flo logs presence only, which is why its patterns can say a
 *   symptom recurred and never that it got worse.
 *
 * ## Category order is a preference, and preferences are not health data
 *
 * It lives in `localStorage`, not in Postgres. Which cards she likes at the top
 * says nothing about her body, and storing it server-side would put a UI
 * preference inside the record that `export`/`delete` and the visit report are
 * responsible for. The cost is that it does not follow her to a second device,
 * which is the right trade for something this cheap to re-set.
 *
 * Hiding a category hides it **here**. Search still finds its terms, because she
 * asked for them by name — product rule 2 in miniature.
 *
 * ## One surface, four tables
 *
 * `lib/experience/v2/log-write.ts` decides which table each dimension lands in;
 * this screen only collects and submits. Two consequences are visible here:
 * **cervical mucus is single-select**, because `fertility_logs.cm_type` is one
 * column and a day has one observation; and **vitals get fields, not chips**,
 * because a measurement is a number and a chip cannot hold one. This screen is the
 * first writer `public.vitals` has ever had.
 *
 * ## Changing the date clears the draft
 *
 * Unsaved selections do not follow her to another day. Carrying them would let a
 * Tuesday of symptoms be saved onto Wednesday with one arrow tap, and a wrong day
 * is worse than a lost one: it is silently in her record and in her charts.
 */

const PREF_KEY = "femio.log.categories.v1";

const TONE_BY_DIMENSION: Record<LogDimension, Tone> = {
  symptom: "symptom",
  mood: "mood",
  discharge: "discharge",
  vital: "vital",
  intercourse: "intercourse",
};

type Entry = { severity: Severity | null };

type SaveStatus = "idle" | "saving" | "saved" | "queued" | "empty" | "error";

export function LogScreenV2() {
  const t = useTranslations("log");
  const format = useFormatter();

  /**
   * Term labels resolved per namespace, not through a bare `useTranslations()`.
   *
   * `LogTerm.labelKey` spans three namespaces — `symptoms.items.*`,
   * `fertility.cm.*` and `vitals.*` — and reaching them with an unscoped hook
   * works at runtime while defeating `i18n-client-lint`, which scans for literal
   * namespaces to prove every one a client needs is actually shipped to it. A
   * namespace it cannot see is a namespace that can silently stop being sent, and
   * the failure would be a chip with no label in somebody's browser.
   *
   * So each is declared, and the prefix decides which one answers.
   */
  const tSymptoms = useTranslations("symptoms");
  const tFertility = useTranslations("fertility");
  const tVitals = useTranslations("vitals");

  const [date, setDateRaw] = useState(todayISO());
  const [query, setQuery] = useState("");
  const [entries, setEntries] = useState<Record<string, Entry>>({});
  const [vitals, setVitals] = useState<Record<string, string>>({});
  const [pref, setPref] = useState<CategoryPreference>(() => readPref());
  const [status, setStatus] = useState<SaveStatus>("idle");

  /** Any date move discards the draft — see the header. */
  const setDate = (next: (d: string) => string) => {
    setDateRaw((d) => {
      const moved = next(d);
      if (moved !== d) {
        setEntries({});
        setVitals({});
        setStatus("idle");
      }
      return moved;
    });
  };

  const label = (term: LogTerm) => {
    const [namespace, ...rest] = term.labelKey.split(".");
    const path = rest.join(".");
    try {
      if (namespace === "symptoms") return tSymptoms(path);
      if (namespace === "fertility") return tFertility(path);
      if (namespace === "vitals") return tVitals(path);
    } catch {
      // A term whose label has not been translated yet must still be selectable —
      // its key is stable English and better than an empty chip.
    }
    return term.key;
  };

  const { visible, hidden } = orderedDimensions(pref);
  // `label` closes over three translator functions that are stable for a locale,
  // so the memo depends on the query alone. Listing `label` would re-run the
  // search on every render and defeat the memo entirely.
  // eslint-disable-next-line react-hooks/exhaustive-deps
  const results = useMemo(() => searchTerms(query, label), [query]);

  const persist = (next: CategoryPreference) => {
    setPref(next);
    try {
      window.localStorage.setItem(PREF_KEY, JSON.stringify(next));
    } catch {
      // Storage blocked. The order still applies for this session.
    }
  };

  const toggle = (term: LogTerm) =>
    setEntries((prev) => {
      const next = { ...prev };
      if (next[term.key]) {
        delete next[term.key];
        return next;
      }
      // A singular column takes one answer. Clearing the dimension's other terms
      // here is the honest version of a save that would otherwise keep one
      // selection and drop the rest without saying so.
      if (isSingleSelect(term.dimension)) {
        for (const other of termsInDimension(term.dimension)) delete next[other.key];
      }
      next[term.key] = { severity: null };
      return next;
    });

  const cycle = (term: LogTerm) =>
    setEntries((prev) => ({
      ...prev,
      [term.key]: { severity: nextSeverity(prev[term.key]?.severity ?? null) },
    }));

  const selectedMap = new Map(
    Object.entries(entries).map(([key, e]) => [key, e.severity] as [string, number | null]),
  );

  const save = async () => {
    setStatus("saving");
    const supabase = createClient();
    const {
      data: { session },
    } = await supabase.auth.getSession();
    if (!session) {
      setStatus("error");
      return;
    }

    const writes = buildLogWrites(session.user.id, date, { selected: selectedMap, vitals });
    if (!hasAnything(writes)) {
      setStatus("empty");
      return;
    }

    // Each table is saved independently and each can queue on its own. A partial
    // save is reported as a save, because the rows that landed did land — telling
    // her nothing was recorded when some was is the worse of the two lies.
    const results = await Promise.all([
      writes.symptomLogs.length > 0 ? saveOrQueue("symptom_logs", [...writes.symptomLogs]) : null,
      writes.fertilityLog ? saveOrQueue("fertility_logs", writes.fertilityLog) : null,
      writes.vitals.length > 0 ? saveOrQueue("vitals", [...writes.vitals]) : null,
    ]);

    const attempted = results.filter((r) => r !== null);
    if (attempted.some((r) => typeof r === "object")) {
      setStatus("error");
      return;
    }
    setStatus(attempted.includes("queued") ? "queued" : "saved");
    setEntries({});
    setVitals({});
  };

  const chip = (term: LogTerm) => (
    <SeverityChip
      key={term.key}
      label={label(term)}
      selected={Boolean(entries[term.key])}
      severity={entries[term.key]?.severity ?? null}
      supportsSeverity={term.severityScale}
      tone={TONE_BY_DIMENSION[term.dimension]}
      onToggle={() => toggle(term)}
      onCycle={() => cycle(term)}
    />
  );

  return (
    <AppScreen>
      <h1 className="font-display text-lg text-text">{t("title")}</h1>

      {/* Date navigator — any day loggable without leaving the screen. Arrows use
          logical direction so "previous" is on the right in Arabic. */}
      <div className="flex items-center justify-between gap-2">
        <button
          type="button"
          onClick={() => setDate((d) => addDays(d, -1))}
          aria-label={t("previousDay")}
          className="min-h-11 rounded-sm px-3 text-sm text-text-muted hover:bg-surface-sunken rtl:rotate-180"
        >
          ←
        </button>
        <span className="text-sm font-semibold text-text">
          {format.dateTime(new Date(`${date}T00:00:00Z`), { dateStyle: "long", timeZone: "UTC" })}
        </span>
        <button
          type="button"
          onClick={() => setDate((d) => (d >= todayISO() ? d : addDays(d, 1)))}
          disabled={date >= todayISO()}
          aria-label={t("nextDay")}
          className="min-h-11 rounded-sm px-3 text-sm text-text-muted hover:bg-surface-sunken disabled:opacity-40 rtl:rotate-180"
        >
          →
        </button>
      </div>

      <div className="flex flex-col gap-2">
        <label htmlFor="log-search" className="sr-only">
          {t("searchLabel")}
        </label>
        <div className="relative">
          <Search
            aria-hidden
            className="pointer-events-none absolute start-3 top-1/2 size-4 -translate-y-1/2 text-text-subtle"
          />
          <Input
            id="log-search"
            type="search"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder={t("searchPlaceholder")}
            // Logical padding, so the room made for the icon is on the right in
            // Arabic. `px-3` from the base input would otherwise let the
            // placeholder start underneath it.
            className="ps-9"
          />
        </div>
      </div>

      {query.trim().length > 0 ? (
        <Card>
          <CardContent className="flex flex-col gap-3 p-6">
            <h2 className="text-sm font-semibold uppercase tracking-widest text-text-subtle">
              {t("searchResults", { count: results.length })}
            </h2>
            {results.length > 0 ? (
              <div className="flex flex-wrap gap-2">{results.map(chip)}</div>
            ) : (
              <p className="text-sm text-text-muted">{t("noResults")}</p>
            )}
          </CardContent>
        </Card>
      ) : (
        <>
          {visible.map((dimension, index) => (
            <Card key={dimension}>
              <CardContent className="flex flex-col gap-3 p-6">
                <div className="flex items-center justify-between gap-2">
                  <h2 className="font-display text-md text-text">{t(`dimensions.${dimension}`)}</h2>
                  <div className="flex items-center gap-1">
                    <IconButton
                      label={t("moveUp")}
                      disabled={index === 0}
                      onClick={() =>
                        persist({ ...pref, order: moveDimension(visible, dimension, -1) })
                      }
                    >
                      <ChevronUp className="size-4" aria-hidden />
                    </IconButton>
                    <IconButton
                      label={t("moveDown")}
                      disabled={index === visible.length - 1}
                      onClick={() =>
                        persist({ ...pref, order: moveDimension(visible, dimension, 1) })
                      }
                    >
                      <ChevronDown className="size-4" aria-hidden />
                    </IconButton>
                    <IconButton
                      label={t("hide")}
                      onClick={() =>
                        persist({ ...pref, hidden: [...(pref.hidden ?? []), dimension] })
                      }
                    >
                      <EyeOff className="size-4" aria-hidden />
                    </IconButton>
                  </div>
                </div>
                {dimension === "vital" ? (
                  <div className="grid grid-cols-2 gap-3">
                    {termsInDimension(dimension).map((term) => (
                      <div key={term.key} className="flex flex-col gap-1">
                        <label
                          htmlFor={`vital-${term.key}`}
                          // A form label, not commentary: `text-text`, with only
                          // the unit dimmed. `text-text-muted` on the dark surface
                          // put the field's own name at the bottom of the contrast
                          // range, which is the one word she has to read.
                          className="text-sm text-text"
                        >
                          {label(term)}
                          {/* The unit is shown, never typed. A field that accepts
                              "62 kg" and one that accepts "62" cannot both be
                              parsed safely, so the screen commits to the second.

                              `dir="ltr"` isolates it: without that, bidi reorders
                              "°C" to "C°" when it trails Arabic, and a unit that
                              renders backwards is a unit a reader cannot trust.
                              Omitted entirely when there is no real unit. */}
                          {VITAL_UNITS[term.key] ? (
                            <span className="text-text-subtle" dir="ltr">
                              {" "}
                              ({VITAL_UNITS[term.key]})
                            </span>
                          ) : null}
                        </label>
                        <Input
                          id={`vital-${term.key}`}
                          type="number"
                          inputMode="decimal"
                          value={vitals[term.key] ?? ""}
                          onChange={(e) =>
                            setVitals((prev) => ({ ...prev, [term.key]: e.target.value }))
                          }
                        />
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="flex flex-wrap gap-2">{termsInDimension(dimension).map(chip)}</div>
                )}
              </CardContent>
            </Card>
          ))}

          {hidden.length > 0 ? (
            <Card>
              <CardContent className="flex flex-col gap-2 p-6">
                <h2 className="text-sm font-semibold uppercase tracking-widest text-text-subtle">
                  {t("hiddenHeading")}
                </h2>
                {/* Offered back rather than dropped — hiding is a preference and
                    must be reversible without hunting through Settings. */}
                <div className="flex flex-wrap gap-2">
                  {hidden.map((dimension) => (
                    <IconButton
                      key={dimension}
                      label={t("show", { name: t(`dimensions.${dimension}`) })}
                      onClick={() =>
                        persist({
                          ...pref,
                          hidden: (pref.hidden ?? []).filter((d) => d !== dimension),
                        })
                      }
                    >
                      <Eye className="size-4" aria-hidden />
                      <span className="text-sm">{t(`dimensions.${dimension}`)}</span>
                    </IconButton>
                  ))}
                </div>
              </CardContent>
            </Card>
          ) : null}
        </>
      )}
      {/* Sticky rather than trailing the list: with 51 terms the button would
          otherwise sit below a long scroll, and a save she cannot see is a save
          she does not make.

          Offset by `--content-clearance`, never `bottom-0`. At zero it sticks to
          the viewport floor, which is already occupied by the tab bar and the
          crisis launcher — the same overlap that cost a pass on the consent
          screen. The variable exists precisely so a bottom-anchored control asks
          the layout how much room is taken rather than guessing a number that a
          safe-area inset then invalidates. */}
      <div
        className="sticky z-10 flex flex-col gap-2 bg-surface/95 py-3 backdrop-blur"
        style={{ bottom: "var(--content-clearance, 0px)" }}
      >
        {status === "queued" ? (
          <Alert>
            <AlertDescription>{t("queued")}</AlertDescription>
          </Alert>
        ) : null}
        {status === "error" ? (
          <Alert variant="danger">
            <AlertDescription>{t("saveFailed")}</AlertDescription>
          </Alert>
        ) : null}
        {status === "empty" ? (
          <Alert>
            <AlertDescription>{t("nothingToSave")}</AlertDescription>
          </Alert>
        ) : null}
        {status === "saved" ? (
          <Alert>
            <AlertDescription>{t("saved")}</AlertDescription>
          </Alert>
        ) : null}
        <Button onClick={() => void save()} disabled={status === "saving"} className="w-full">
          {status === "saving" ? t("saving") : t("save")}
        </Button>
      </div>
    </AppScreen>
  );
}

function IconButton({
  label,
  onClick,
  disabled,
  children,
}: {
  label: string;
  onClick: () => void;
  disabled?: boolean;
  children: React.ReactNode;
}) {
  return (
    <button
      type="button"
      aria-label={label}
      onClick={onClick}
      disabled={disabled}
      className="inline-flex min-h-11 items-center gap-1 rounded-sm px-2 text-text-muted hover:bg-surface-sunken disabled:opacity-30"
    >
      {children}
    </button>
  );
}

/** Her saved order, validated — a stale preference must never drop a category. */
function readPref(): CategoryPreference {
  if (typeof window === "undefined") return {};
  try {
    const raw = window.localStorage.getItem(PREF_KEY);
    if (!raw) return {};
    const parsed = JSON.parse(raw) as CategoryPreference;
    const known = (list?: readonly LogDimension[]) =>
      (list ?? []).filter((d) => DEFAULT_DIMENSION_ORDER.includes(d));
    return { order: known(parsed.order), hidden: known(parsed.hidden) };
  } catch {
    return {};
  }
}

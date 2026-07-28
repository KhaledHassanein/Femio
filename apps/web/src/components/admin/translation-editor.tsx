"use client";

import { useMemo, useState, useTransition } from "react";
import { useTranslations } from "next-intl";
import { saveUiString } from "@/lib/i18n/translation-actions";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { cn } from "@/lib/utils";

type Master = { key: string; en: string };
type Existing = Record<string, { value: string; status: string }>; // key → row
type Status = "human_reviewed" | "machine" | "missing";

// Target locales the portal reviews (English is the master).
const TARGETS = ["ar", "fr", "es"] as const;

export function TranslationEditor({
  masters,
  existing,
}: {
  masters: Master[];
  existing: Record<string, Existing>; // locale → (key → row)
}) {
  const t = useTranslations("admin");
  const [locale, setLocale] = useState<(typeof TARGETS)[number]>("ar");
  const [filter, setFilter] = useState("");
  const [drafts, setDrafts] = useState<Record<string, string>>({});
  const [statuses, setStatuses] = useState<Record<string, Status>>({});
  const [savedKey, setSavedKey] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [pending, startTransition] = useTransition();

  const rows = existing[locale] ?? {};

  const statusOf = (key: string): Status => {
    const local = statuses[`${locale}:${key}`];
    if (local) return local;
    const row = rows[key];
    return row ? (row.status === "human_reviewed" ? "human_reviewed" : "machine") : "missing";
  };
  const valueOf = (key: string) => {
    const d = drafts[`${locale}:${key}`];
    return d !== undefined ? d : rows[key]?.value ?? "";
  };

  const filtered = useMemo(() => {
    const q = filter.trim().toLowerCase();
    return q ? masters.filter((m) => m.key.toLowerCase().includes(q) || m.en.toLowerCase().includes(q)) : masters;
  }, [masters, filter]);

  const reviewed = masters.filter((m) => statusOf(m.key) === "human_reviewed").length;

  const save = (key: string) => {
    setError(null);
    setSavedKey(null);
    const value = valueOf(key).trim();
    if (!value) return;
    startTransition(async () => {
      const res = await saveUiString(key, locale, value);
      if (res.ok) {
        setStatuses((s) => ({ ...s, [`${locale}:${key}`]: "human_reviewed" }));
        setSavedKey(key);
      } else {
        setError(res.error);
      }
    });
  };

  const badge = (status: Status) =>
    status === "human_reviewed" ? (
      <Badge variant="success">{t("approved")}</Badge>
    ) : status === "machine" ? (
      <Badge variant="accent">{t("draft")}</Badge>
    ) : (
      <Badge variant="neutral">{t("missing")}</Badge>
    );

  return (
    <div className="flex flex-col gap-4">
      <div className="flex flex-wrap items-center gap-2">
        <div className="flex gap-1" role="group" aria-label={t("localeLabel")}>
          {TARGETS.map((l) => (
            <button
              key={l}
              type="button"
              onClick={() => setLocale(l)}
              aria-pressed={locale === l}
              className={cn(
                "rounded-sm px-3 py-1.5 text-sm uppercase",
                locale === l ? "bg-primary-soft font-medium text-primary-soft-text" : "text-text-muted hover:bg-surface-sunken",
              )}
            >
              {l}
            </button>
          ))}
        </div>
        <span className="text-sm text-text-muted">
          {t("reviewedCount", { reviewed, total: masters.length })}
        </span>
      </div>

      <Input
        value={filter}
        onChange={(e) => setFilter(e.target.value)}
        placeholder={t("filterPlaceholder")}
        aria-label={t("filterPlaceholder")}
      />

      {error ? <p className="text-sm text-danger-text">{error}</p> : null}

      <table className="w-full text-start text-sm">
        <thead>
          <tr className="text-text-muted">
            <th scope="col" className="py-1 text-start font-medium">{t("keyCol")}</th>
            <th scope="col" className="py-1 text-start font-medium">{t("master")}</th>
            <th scope="col" className="py-1 text-start font-medium">{t("translation")} ({locale})</th>
            <th scope="col" className="py-1 text-start font-medium">{t("statusCol")}</th>
            <th scope="col" className="py-1" />
          </tr>
        </thead>
        <tbody>
          {filtered.map((m) => (
            <tr key={m.key} className="border-t border-border align-top">
              <td className="py-2 pe-2 font-mono text-2xs text-text-muted">{m.key}</td>
              <td className="py-2 pe-2 text-text" dir="ltr">{m.en}</td>
              <td className="py-2 pe-2">
                <Input
                  value={valueOf(m.key)}
                  onChange={(e) => setDrafts((d) => ({ ...d, [`${locale}:${m.key}`]: e.target.value }))}
                  aria-label={`${m.key} — ${locale}`}
                />
              </td>
              <td className="py-2 pe-2">{badge(statusOf(m.key))}</td>
              <td className="py-2">
                <Button
                  variant="outline"
                  size="sm"
                  disabled={pending || !valueOf(m.key).trim()}
                  onClick={() => save(m.key)}
                >
                  {savedKey === m.key ? t("saved") : t("save")}
                </Button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

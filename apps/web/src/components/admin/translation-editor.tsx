"use client";

import { useMemo, useRef, useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";
import { importUiStrings, saveUiString } from "@/lib/i18n/translation-actions";
import { parseCsvRecords, toCsv } from "@/lib/i18n/csv";
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
  const router = useRouter();
  const [locale, setLocale] = useState<(typeof TARGETS)[number]>("ar");
  const [filter, setFilter] = useState("");
  const [drafts, setDrafts] = useState<Record<string, string>>({});
  const [statuses, setStatuses] = useState<Record<string, Status>>({});
  const [savedKey, setSavedKey] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [pending, startTransition] = useTransition();
  const fileRef = useRef<HTMLInputElement>(null);
  const [approveOnImport, setApproveOnImport] = useState(true);
  const [importMsg, setImportMsg] = useState<string | null>(null);
  const [importing, setImporting] = useState(false);

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

  const exportCsv = () => {
    const rows = masters.map((m) => ({ key: m.key, english: m.en, translation: valueOf(m.key) }));
    const csv = toCsv(["key", "english", "translation"], rows);
    const url = URL.createObjectURL(new Blob([csv], { type: "text/csv;charset=utf-8" }));
    const a = document.createElement("a");
    a.href = url;
    a.download = `femio-translations-${locale}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  };

  const onImportFile = async (file: File) => {
    setImporting(true);
    setImportMsg(null);
    setError(null);
    try {
      const { headers, records } = parseCsvRecords(await file.text());
      if (!headers.includes("key") || !headers.includes("translation")) {
        setError(t("importBadFormat"));
        return;
      }
      const rows = records.map((r) => ({ key: r.key ?? "", value: r.translation ?? "" }));
      const res = await importUiStrings(locale, rows, approveOnImport);
      if (!res.ok) {
        setError(res.error);
      } else {
        setImportMsg(
          t("importDone", { updated: res.updated, skipped: res.skipped }) +
            (res.unknownKeys.length ? ` ${t("importUnknown", { count: res.unknownKeys.length })}` : ""),
        );
        router.refresh();
      }
    } finally {
      setImporting(false);
      if (fileRef.current) fileRef.current.value = "";
    }
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

      {/* Bulk Excel/CSV round-trip. */}
      <div className="flex flex-wrap items-center gap-3 rounded-md border border-border bg-surface-sunken p-3">
        <Button variant="outline" size="sm" onClick={exportCsv}>
          {t("exportCsv")}
        </Button>
        <Button variant="outline" size="sm" disabled={importing} onClick={() => fileRef.current?.click()}>
          {importing ? t("importing") : t("importCsv")}
        </Button>
        <input
          ref={fileRef}
          type="file"
          accept=".csv,text/csv"
          className="hidden"
          onChange={(e) => {
            const f = e.target.files?.[0];
            if (f) void onImportFile(f);
          }}
        />
        <label className="flex items-center gap-2 text-sm text-text-muted">
          <input
            type="checkbox"
            checked={approveOnImport}
            onChange={(e) => setApproveOnImport(e.target.checked)}
          />
          {t("approveOnImport")}
        </label>
        {importMsg ? <span className="text-sm text-success-text">{importMsg}</span> : null}
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

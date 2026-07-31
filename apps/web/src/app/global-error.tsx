"use client";

import { getDir, isLocale, routing } from "@/i18n/routing";

/**
 * Last-resort error boundary (P1.2.4, completing P1.2.2).
 *
 * `global-error` replaces the **root layout** when a render fails above every
 * other boundary, so nothing from that layout is available here: no
 * `NextIntlClientProvider`, no theme provider, no global stylesheet guarantee.
 * That is why the copy is **bundled** rather than translated through next-intl,
 * and why the styling is inline — the same reasoning as the crisis dialog
 * (ADR-013): a surface that only appears when things are broken must not depend
 * on the machinery that broke.
 *
 * The locale is read from the URL, which is where it lives in every Femio route
 * (`/en/...`). Unknown or missing → English, LTR.
 */
const COPY = {
  en: {
    title: "Something went wrong on our side",
    body: "This page hit an unexpected error. Nothing you've logged is affected — your data is stored safely. Try again, or head back to the homepage.",
    retry: "Try again",
    home: "Go to the homepage",
  },
  ar: {
    title: "حدث خطأ من جانبنا",
    body: "واجهت هذه الصفحة خطأً غير متوقع. لم يتأثر أي شيء سجّلتِه — بياناتكِ محفوظة بأمان. أعيدي المحاولة أو ارجعي إلى الصفحة الرئيسية.",
    retry: "إعادة المحاولة",
    home: "الذهاب إلى الصفحة الرئيسية",
  },
  fr: {
    title: "Un problème est survenu de notre côté",
    body: "Cette page a rencontré une erreur inattendue. Rien de ce que vous avez enregistré n'est affecté — vos données sont en sécurité. Réessayez ou revenez à l'accueil.",
    retry: "Réessayer",
    home: "Aller à l'accueil",
  },
  es: {
    title: "Algo ha fallado por nuestra parte",
    body: "Esta página ha tenido un error inesperado. Nada de lo que has registrado se ve afectado: tus datos están guardados de forma segura. Inténtalo de nuevo o vuelve al inicio.",
    retry: "Reintentar",
    home: "Ir al inicio",
  },
} as const;

function localeFromPath(): (typeof routing.locales)[number] {
  if (typeof window === "undefined") return routing.defaultLocale;
  const first = window.location.pathname.split("/")[1];
  return isLocale(first) ? first : routing.defaultLocale;
}

export default function GlobalError({ reset }: { error: Error; reset: () => void }) {
  const locale = localeFromPath();
  const t = COPY[locale];
  const dir = getDir(locale);

  return (
    // global-error must render its own <html>/<body>: it stands in for the root layout.
    <html lang={locale} dir={dir}>
      <body
        style={{
          margin: 0,
          minHeight: "100vh",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          padding: "2rem",
          background: "#fdfcfd",
          color: "#2b2440",
          fontFamily: "system-ui, -apple-system, Segoe UI, sans-serif",
          lineHeight: 1.6,
        }}
      >
        <main style={{ maxWidth: "34rem" }}>
          <p style={{ margin: "0 0 0.5rem", fontSize: "0.875rem", color: "#726c82" }}>femio</p>
          <h1 style={{ margin: "0 0 0.75rem", fontSize: "1.75rem", fontWeight: 600 }}>{t.title}</h1>
          <p style={{ margin: "0 0 1.5rem", color: "#4a4359" }}>{t.body}</p>
          <div style={{ display: "flex", flexWrap: "wrap", gap: "0.75rem" }}>
            <button
              type="button"
              onClick={reset}
              style={{
                minHeight: "44px",
                padding: "0.6rem 1.1rem",
                borderRadius: "0.5rem",
                border: "none",
                background: "#7b3f6f",
                color: "#fff",
                fontSize: "1rem",
                cursor: "pointer",
              }}
            >
              {t.retry}
            </button>
            <a
              href={`/${locale}`}
              style={{
                minHeight: "44px",
                display: "inline-flex",
                alignItems: "center",
                padding: "0.6rem 1.1rem",
                borderRadius: "0.5rem",
                border: "1px solid #d8d3e0",
                color: "#2b2440",
                textDecoration: "none",
                fontSize: "1rem",
              }}
            >
              {t.home}
            </a>
          </div>
        </main>
      </body>
    </html>
  );
}

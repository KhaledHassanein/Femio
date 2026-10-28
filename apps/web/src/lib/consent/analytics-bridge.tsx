"use client";

import { useEffect, useRef } from "react";
import { usePathname } from "next/navigation";
import { outboundHost, pageTypeFor, track } from "./events";

/**
 * The one client component behind measurement (ADR-075). It turns what already
 * happens on the page into the allow-listed events, so no screen imports the tracker:
 *
 *  - on every route change: `femio_page` (page type + language), and `calculator_open`
 *    or `help_now_open` where the route says so;
 *  - after 45 s on an article: `article_read` (slug + locale), once per page view;
 *  - on a click of any element carrying `data-track="get_app_click"` or
 *    `data-track="language_switch"`: that event, with the attributes the element names;
 *  - on a click of an external link inside an article's sources: `outbound_source_click`
 *    with the host only.
 *
 * It never reads an input, a form, a calendar cell or the URL's query string. Without a
 * dataLayer (no container id) every `track` call is a no-op, so this component costs a
 * few listeners and sends nothing.
 */
const ARTICLE_READ_MS = 45_000;
const SITE_HOST = "femioapp.com";

export function AnalyticsBridge() {
  const pathname = usePathname();
  const lastPath = useRef<string | null>(null);

  useEffect(() => {
    if (!pathname || pathname === lastPath.current) return;
    lastPath.current = pathname;
    const [language, , slug] = pathname.split("/").filter(Boolean);
    const pageType = pageTypeFor(pathname);
    track("femio_page", { page_type: pageType, page_language: language });
    if (pageType === "calculator" && slug) track("calculator_open", { calculator_slug: slug });
    if (pageType === "help") track("help_now_open", {});
    if (pageType !== "article" || !slug) return;
    const timer = window.setTimeout(() => track("article_read", { article_slug: slug, article_locale: language }), ARTICLE_READ_MS);
    return () => window.clearTimeout(timer);
  }, [pathname]);

  useEffect(() => {
    const onClick = (e: MouseEvent) => {
      const target = e.target instanceof Element ? e.target.closest("a, button") : null;
      if (!target) return;
      const tracked = target.getAttribute("data-track");
      if (tracked === "get_app_click") {
        track("get_app_click", { page_type: pageTypeFor(window.location.pathname), placement: target.getAttribute("data-placement") ?? undefined });
        return;
      }
      if (tracked === "language_switch") {
        track("language_switch", { from_locale: window.location.pathname.split("/")[1], to_locale: target.getAttribute("data-to-locale") ?? undefined });
        return;
      }
      if (target instanceof HTMLAnchorElement && target.closest("[data-track-sources]")) {
        const host = outboundHost(target.href, SITE_HOST);
        if (host) track("outbound_source_click", { source_host: host });
      }
    };
    document.addEventListener("click", onClick, { capture: true });
    return () => document.removeEventListener("click", onClick, { capture: true });
  }, []);

  return null;
}

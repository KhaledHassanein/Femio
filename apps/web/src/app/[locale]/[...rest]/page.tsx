import { notFound } from "next/navigation";

// Any path no route matches lands here, so it gets the localized 404 inside the
// locale layout (lang, dir, header, recovery links) instead of Next's bare
// built-in page, which had no `lang` and no way back (public audit 2026-10-09).
export default function CatchAll() {
  notFound();
}

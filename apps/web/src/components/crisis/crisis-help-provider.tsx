"use client";

import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useRef,
  useState,
  type ReactNode,
} from "react";
import { useLocale } from "next-intl";
import { LifeBuoy, X } from "lucide-react";
import { getCrisisContent } from "@/lib/crisis/content";
import { env } from "@/lib/env";
import { cn } from "@/lib/utils";
import { CrisisContentView } from "./crisis-content-view";

/**
 * Global crisis-safety routing. Mounts a persistent launcher (a lifebuoy named
 * "Need help now?") and
 * an accessible native <dialog> in the locale layout so help is reachable from
 * every public, onboarding, calculator and signed-in page.
 *
 * Deliberate constraints (docs/compliance/CRISIS_RESOURCES.md, ADR-013):
 *  - `open()` takes NO arguments — no reason, score, country or health data is
 *    ever attached to the crisis interface.
 *  - No analytics of any kind here: opening the dialog could reveal mental-health
 *    intent, which must never be recorded or transmitted.
 *  - The copy is static and bundled, so the dialog opens instantly and offline.
 */

type CrisisHelpApi = {
  /** Open the crisis dialog. Accepts no payload by design. */
  open: () => void;
  close: () => void;
  isOpen: boolean;
};

const CrisisHelpContext = createContext<CrisisHelpApi | null>(null);

export function useCrisisHelp(): CrisisHelpApi {
  const ctx = useContext(CrisisHelpContext);
  if (!ctx) {
    throw new Error("useCrisisHelp() must be used within <CrisisHelpProvider>.");
  }
  return ctx;
}

export function CrisisHelpProvider({ children }: { children: ReactNode }) {
  const locale = useLocale();
  const content = getCrisisContent(locale);
  const directoryUrl = env.NEXT_PUBLIC_CRISIS_DIRECTORY_URL;

  const [isOpen, setIsOpen] = useState(false);
  const dialogRef = useRef<HTMLDialogElement>(null);

  const open = useCallback(() => setIsOpen(true), []);
  const close = useCallback(() => setIsOpen(false), []);

  // Drive the native modal from state. showModal() gives us focus-trap + Escape
  // (the browser fires `cancel`) for free; we sync those back into React state.
  useEffect(() => {
    const dialog = dialogRef.current;
    if (!dialog) return;
    if (isOpen && !dialog.open) dialog.showModal();
    else if (!isOpen && dialog.open) dialog.close();
  }, [isOpen]);

  const titleId = "crisis-help-title";

  return (
    <CrisisHelpContext.Provider value={{ open, close, isOpen }}>
      {children}

      {/* v3 (P1.5): a compact 44px lifebuoy instead of a wide violet pill. It stays on
          every page (ADR-013) and keeps the approved launcher text as its accessible
          name, but it no longer covers headings, consent labels or the onboarding
          Continue button the way the pill did. The public header carries a visible
          "Need help now?" link to /help-now as well. */}
      <button
        type="button"
        onClick={open}
        aria-label={content.strings.launcher}
        title={content.strings.launcher}
        lang={content.isFallback ? content.lang : undefined}
        className={cn(
          // `crisis-launcher` is a positioning hook, not a style: globals.css lifts
          // the launcher clear of the signed-in tab bar, which would otherwise sit
          // on top of it (P1.28.1). A safety affordance must never be the thing
          // that gets covered.
          "crisis-launcher fixed bottom-4 end-4 z-sticky inline-flex size-11 items-center justify-center rounded-pill",
          "border border-border bg-surface/90 text-primary shadow-md backdrop-blur",
          "hover:bg-surface hover:text-primary-hover focus-visible:outline-none print:hidden",
        )}
      >
        <LifeBuoy className="size-5" aria-hidden />
      </button>

      <dialog
        ref={dialogRef}
        aria-labelledby={titleId}
        onClose={close}
        onCancel={close}
        // Close when the backdrop (the dialog element itself) is clicked.
        onClick={(e) => {
          if (e.target === dialogRef.current) close();
        }}
        className={cn(
          "m-auto w-[calc(100%-2rem)] max-w-lg rounded-lg border border-border bg-surface p-0",
          "text-text backdrop:bg-black/50",
        )}
      >
        {/* Inner wrapper stops backdrop-close clicks from bubbling out. */}
        <div className="flex flex-col gap-4 p-6" onClick={(e) => e.stopPropagation()}>
          <div className="flex items-start justify-between gap-4" dir={content.dir}>
            <h1
              id={titleId}
              lang={content.isFallback ? content.lang : undefined}
              className="font-display text-xl text-text"
            >
              {content.strings.dialogTitle}
            </h1>
            <button
              type="button"
              autoFocus
              onClick={close}
              aria-label={content.strings.close}
              className="rounded-sm p-1 text-text-muted hover:bg-surface-sunken focus-visible:outline-none"
            >
              <X className="size-5" aria-hidden />
            </button>
          </div>

          <CrisisContentView content={content} directoryUrl={directoryUrl} />
        </div>
      </dialog>
    </CrisisHelpContext.Provider>
  );
}

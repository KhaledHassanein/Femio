/**
 * The early test build card on `/app` (R14.4, REL-2, UX-1): the one place a tester or a
 * hackathon judge finds an install path before femio is on Google Play.
 *
 * Why it exists: every "Get the app" on the site used to end at "Coming soon", so a judge
 * clicking "Try it out" found nothing to install. The download address lives in one named
 * constant (`APK_DOWNLOAD_URL` in `lib/site.ts`). While it is null the card says plainly
 * that the link is coming, with no button that leads nowhere; once it is set, the card
 * shows the download and the three sideload steps. Words come from `getApp.testBuild`.
 */
import { Download, Smartphone } from "lucide-react";

import { Button } from "@/components/ui/button";

/** Every sentence the card shows, already translated by the page. */
export type TestBuildStrings = {
  title: string;
  body: string;
  soon: string;
  soonBody: string;
  download: string;
  stepsTitle: string;
  steps: readonly string[];
};

/**
 * Renders the card.
 *
 * @param url the APK address, or null while the release does not exist yet.
 * @param strings the translated words; `steps` is shown as a numbered list, in order.
 */
export function TestBuildCard({ url, strings }: { url: string | null; strings: TestBuildStrings }) {
  return (
    <section
      id="test-build"
      aria-labelledby="test-build-title"
      className="mx-auto w-full max-w-5xl scroll-mt-20 px-6 pt-10"
    >
      <div className="flex flex-col gap-4 rounded-lg border border-border bg-surface p-6">
        <div className="flex items-start gap-4">
          <span className="flex size-11 shrink-0 items-center justify-center rounded-pill bg-primary-soft text-primary-soft-text">
            <Smartphone className="size-5" aria-hidden />
          </span>
          <div className="flex flex-col gap-1">
            <h2 id="test-build-title" className="font-display text-lg text-text rtl:font-bold">
              {strings.title}
            </h2>
            <p className="text-sm leading-relaxed text-text-muted">{strings.body}</p>
          </div>
        </div>

        {url ? (
          <div className="flex flex-col gap-4">
            <Button asChild variant="accent" size="lg" className="w-full sm:w-auto sm:self-start">
              <a href={url} rel="noopener" download>
                <Download className="size-5" aria-hidden />
                {strings.download}
              </a>
            </Button>
            <div className="flex flex-col gap-2">
              <h3 className="text-sm font-semibold text-text">{strings.stepsTitle}</h3>
              <ol className="flex list-decimal flex-col gap-1.5 ps-5 text-sm leading-relaxed text-text-muted">
                {strings.steps.map((step) => (
                  <li key={step}>{step}</li>
                ))}
              </ol>
            </div>
          </div>
        ) : (
          <div className="flex flex-col gap-1 rounded-md bg-primary-soft px-4 py-3 text-primary-soft-text">
            <p className="text-sm font-semibold">{strings.soon}</p>
            <p className="text-xs leading-relaxed">{strings.soonBody}</p>
          </div>
        )}
      </div>
    </section>
  );
}

/**
 * The "Demo" label every scripted app demo carries, with its one-line note.
 *
 * Why it exists: the site's chats and tools are canned examples of the Android app, not
 * live features. A visible badge plus a plain sentence ("nothing is sent") keeps that
 * honest wherever a demo appears (the app page, the home page and `/demo`). It is a
 * plain presentational component, so it works in server and client trees alike; the
 * words are passed in already translated.
 */
import { Sparkles } from "lucide-react";

export type DemoLabelStrings = { label: string; note: string };

/** A pill reading "Demo" followed by the scripted-example note. */
export function DemoLabel({ strings }: { strings: DemoLabelStrings }) {
  return (
    <p className="flex flex-wrap items-center gap-x-2 gap-y-1 text-2xs text-text-subtle">
      <span className="inline-flex items-center gap-1 rounded-pill bg-accent-soft px-2 py-0.5 font-semibold text-accent-soft-text">
        <Sparkles className="size-3" aria-hidden />
        {strings.label}
      </span>
      <span>{strings.note}</span>
    </p>
  );
}

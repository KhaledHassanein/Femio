import type { Topic } from "@/lib/content/topics";
import { cn } from "@/lib/utils";

/**
 * Cover art for a Learn card (v3 P2.4, docs/30_REVAMP/03 §3.5).
 *
 * One static SVG per topic (`public/art/<topic>.svg`, generated from the tokens by
 * `scripts/design/generate-topic-art.mjs`): blooms, the logo's petal form, over a
 * two-colour ground in the topic's palette. No stock photography.
 *
 * Half of the cards are mirrored, chosen by a hash of the slug, so a row is not a
 * repeat of one image; the box keeps the art's 2:1 ratio and shows all of it (the
 * earlier per-card crop read as cut-off images on a phone, owner note 2026-10-29). Earlier this was inline SVG per card, which put
 * ~95 SVGs into the HTML twice (markup and React payload): 484 KB for the Learn
 * page against a 50 KB budget. Now a card costs a few bytes and the browser caches
 * ten small files. Decorative, so hidden from assistive tech; nothing in it is
 * directional, so RTL needs no special case.
 */
function seed(text: string): number {
  let h = 2166136261;
  for (let i = 0; i < text.length; i++) h = Math.imul(h ^ text.charCodeAt(i), 16777619);
  return h >>> 0;
}

export function TopicArt({ topic, slug, className }: { topic: Topic; slug: string; className?: string }) {
  const s = seed(slug);
  return (
    <div
      aria-hidden
      className={cn((s >> 16) % 2 === 1 && "-scale-x-100", className)}
      style={{ backgroundImage: `url(/art/${topic}.svg)` }}
    />
  );
}

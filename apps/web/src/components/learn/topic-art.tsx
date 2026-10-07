import type { Topic } from "@/lib/content/topics";

/**
 * Procedural cover art for a Learn card (v3 P2.4, docs/30_REVAMP/03 §3.5).
 *
 * A bloom, the logo's petal form, drawn over a two-colour ground in the topic's
 * palette. The slug seeds rotation, scale and placement, so every card differs while
 * the set reads as one system. No stock photography (rule from `03` §3.1). Inline
 * SVG means no image request, no layout shift, nothing to translate, and it mirrors
 * correctly in RTL because there is nothing directional in it. It is decorative,
 * so it is hidden from assistive tech.
 */
const PALETTE: Record<Topic, [ground: string, glow: string, petal: string, accent: string]> = {
  ttc: ["--art-sage", "--art-saffron-soft", "--art-cream", "--art-saffron"],
  weeks: ["--art-peach", "--art-rose-soft", "--art-cream", "--art-rose"],
  pregnancy: ["--art-rose", "--art-peach-soft", "--art-cream", "--art-saffron"],
  afterBirth: ["--art-plum", "--art-rose-soft", "--art-rose-soft", "--art-peach"],
  newborn: ["--art-peach", "--art-sage-soft", "--art-cream", "--art-sage"],
  cycles: ["--art-rose", "--art-plum-soft", "--art-cream", "--art-plum"],
  conditions: ["--art-plum", "--art-saffron-soft", "--art-plum-soft", "--art-saffron"],
  teens: ["--art-peach", "--art-rose-soft", "--art-cream", "--art-plum"],
  menopause: ["--art-saffron", "--art-plum-soft", "--art-cream", "--art-plum"],
  more: ["--art-plum", "--art-peach-soft", "--art-cream", "--art-rose"],
};

/** A small, stable hash: the same slug always draws the same cover. */
function seed(text: string): number {
  let h = 2166136261;
  for (let i = 0; i < text.length; i++) h = Math.imul(h ^ text.charCodeAt(i), 16777619);
  return h >>> 0;
}

export function TopicArt({
  topic,
  slug,
  className,
}: {
  topic: Topic;
  slug: string;
  className?: string;
}) {
  const [ground, glow, petal, accent] = PALETTE[topic];
  const s = seed(slug);
  const rot = s % 360;
  const cx = 190 + (s % 70);
  const cy = 70 + ((s >> 8) % 40);
  const r = 34 + ((s >> 16) % 14);
  const petals = 5 + ((s >> 4) % 3);
  const id = `art-${s.toString(36)}`;
  const v = (name: string) => `var(${name})`;

  return (
    <svg
      viewBox="0 0 320 160"
      preserveAspectRatio="xMidYMid slice"
      aria-hidden
      className={className}
      focusable="false"
    >
      <defs>
        <radialGradient id={`${id}-g`} cx="85%" cy="15%" r="90%">
          <stop offset="0%" style={{ stopColor: v(glow) }} />
          <stop offset="100%" style={{ stopColor: v(ground) }} />
        </radialGradient>
      </defs>
      <rect width="320" height="160" style={{ fill: `url(#${id}-g)` }} />
      {/* A low sun behind the bloom: warmth, and a second depth plane. */}
      <circle
        cx={cx - r * 1.4}
        cy={cy + r * 0.9}
        r={r * 0.8}
        style={{ fill: v(accent), opacity: 0.55 }}
      />
      <g transform={`translate(${cx} ${cy}) rotate(${rot})`}>
        {Array.from({ length: petals }, (_, i) => (
          <ellipse
            key={i}
            rx={r * 0.42}
            ry={r}
            transform={`rotate(${(360 / petals) * i}) translate(0 ${-r * 0.55})`}
            style={{ fill: v(petal), opacity: 0.32 + (i % 2) * 0.12 }}
          />
        ))}
        <circle r={r * 0.28} style={{ fill: v(accent), opacity: 0.9 }} />
      </g>
    </svg>
  );
}

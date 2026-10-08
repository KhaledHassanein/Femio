/**
 * Feminine motifs for the public site (D8: "feminine symbols, like Flo"), drawn from
 * Femio's own mark rather than borrowed: the Bloom's petal, a crescent moon for the
 * cycle, a four-point spark. Decorative only (`aria-hidden`), coloured from the
 * Dusk Bloom art tokens so they follow the theme.
 */

const PETAL = "M0,4 C7.5,-9 7.5,-27 0,-40 C-7.5,-27 -7.5,-9 0,4 Z";

/** The six-petal Bloom, as in the logo. `id` keeps two gradients on a page apart. */
export function Bloom({ id, className }: { id: string; className?: string }) {
  return (
    <svg viewBox="-48 -48 96 96" className={className} aria-hidden focusable="false">
      <defs>
        <linearGradient id={id} x1="-34" y1="34" x2="34" y2="-34" gradientUnits="userSpaceOnUse">
          <stop offset="0" stopColor="var(--art-plum-soft)" />
          <stop offset=".5" stopColor="var(--art-rose)" />
          <stop offset="1" stopColor="var(--art-saffron)" />
        </linearGradient>
      </defs>
      <g fill={`url(#${id})`}>
        {[0, 60, 120, 180, 240, 300].map((r, i) => (
          <path key={r} d={PETAL} opacity={i % 2 ? 0.82 : 0.94} transform={`rotate(${r})`} />
        ))}
      </g>
      <circle r="7.5" fill="var(--art-cream)" />
      <circle r="4" fill="var(--art-plum)" />
    </svg>
  );
}

export function Petal({ className }: { className?: string }) {
  return (
    <svg viewBox="-10 -42 20 48" className={className} aria-hidden focusable="false">
      <path d={PETAL} fill="currentColor" />
    </svg>
  );
}

export function Moon({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" className={className} aria-hidden focusable="false">
      <path d="M15.5 2.5a9.5 9.5 0 1 0 6 16.9A8 8 0 0 1 15.5 2.5Z" fill="currentColor" />
    </svg>
  );
}

export function Spark({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" className={className} aria-hidden focusable="false">
      <path
        d="M12 0c.9 6.4 5.6 11.1 12 12-6.4.9-11.1 5.6-12 12-.9-6.4-5.6-11.1-12-12C6.4 11.1 11.1 6.4 12 0Z"
        fill="currentColor"
      />
    </svg>
  );
}

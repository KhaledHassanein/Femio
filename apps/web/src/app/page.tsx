export default function HomePage() {
  return (
    <main className="mx-auto flex min-h-dvh max-w-3xl flex-col justify-center gap-6 px-6 py-16">
      <p className="font-sans text-sm font-semibold uppercase tracking-widest text-primary">femio</p>
      <h1 className="font-display text-3xl text-text">Scaffold online.</h1>
      <p className="max-w-prose text-md text-text-muted">
        Next.js 15 + TypeScript + Tailwind, wired to the Femio design tokens. Internationalization
        (EN/AR/FR/ES, RTL), UI components, and the PWA shell land next.
      </p>
      <div className="flex flex-wrap gap-3" aria-hidden>
        <span className="rounded-pill bg-primary-soft px-4 py-2 text-sm text-primary-soft-text">
          Primary
        </span>
        <span className="rounded-pill bg-accent-soft px-4 py-2 text-sm text-accent">Accent</span>
        <span className="rounded-pill bg-success-soft px-4 py-2 text-sm text-success-text">
          Fertile
        </span>
        <span className="rounded-pill bg-warning-soft px-4 py-2 text-sm text-warning-text">
          Uncertainty
        </span>
      </div>
    </main>
  );
}

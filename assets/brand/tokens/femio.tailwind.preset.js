/**
 * Femio V2 — Tailwind preset
 * Maps semantic design tokens (femio.tokens.css) into Tailwind's theme.
 * Colors reference CSS variables so light/dark switch automatically via
 * [data-theme]. Import in tailwind.config.js: `presets: [require('./femio.tailwind.preset')]`
 * and import femio.tokens.css once in the global stylesheet.
 */
module.exports = {
  darkMode: ['class', '[data-theme="dark"]'],
  theme: {
    extend: {
      colors: {
        bg: 'var(--bg)',
        surface: { DEFAULT: 'var(--surface)', sunken: 'var(--surface-sunken)', raised: 'var(--surface-raised)' },
        text: { DEFAULT: 'var(--text)', muted: 'var(--text-muted)', subtle: 'var(--text-subtle)', 'on-brand': 'var(--text-on-brand)', link: 'var(--text-link)' },
        border: { DEFAULT: 'var(--border)', strong: 'var(--border-strong)' },
        primary: { DEFAULT: 'var(--primary)', hover: 'var(--primary-hover)', active: 'var(--primary-active)', soft: 'var(--primary-soft)', 'soft-text': 'var(--primary-soft-text)', fg: 'var(--on-primary)', solid: 'var(--primary-solid)', 'fg-solid': 'var(--on-primary-solid)' },
        accent: { DEFAULT: 'var(--accent)', hover: 'var(--accent-hover)', soft: 'var(--accent-soft)', 'soft-text': 'var(--accent-soft-text)', fg: 'var(--on-accent)', solid: 'var(--accent-solid)', 'fg-solid': 'var(--on-accent-solid)' },
        success: { DEFAULT: 'var(--success)', soft: 'var(--success-soft)', text: 'var(--success-text)', solid: 'var(--success-solid)', fg: 'var(--on-success)' },
        warning: { DEFAULT: 'var(--warning)', soft: 'var(--warning-soft)', text: 'var(--warning-text)' },
        danger: { DEFAULT: 'var(--danger)', soft: 'var(--danger-soft)', text: 'var(--danger-text)', border: 'var(--danger-border)' },
        info: { DEFAULT: 'var(--info)', soft: 'var(--info-soft)' },
        /**
         * One colour per LogVocabulary dimension (RB-C1). `alt` is the tinted fill
         * for chips, calendar days and chart bands; the base is text and strokes.
         * A symptom must look the same on the calendar, in the panel and in a chart.
         */
        log: {
          period: 'var(--log-period)', 'period-alt': 'var(--log-period-alt)',
          symptom: 'var(--log-symptom)', 'symptom-alt': 'var(--log-symptom-alt)',
          mood: 'var(--log-mood)', 'mood-alt': 'var(--log-mood-alt)',
          discharge: 'var(--log-discharge)', 'discharge-alt': 'var(--log-discharge-alt)',
          vital: 'var(--log-vital)', 'vital-alt': 'var(--log-vital-alt)',
          medication: 'var(--log-medication)', 'medication-alt': 'var(--log-medication-alt)',
          appointment: 'var(--log-appointment)', 'appointment-alt': 'var(--log-appointment-alt)',
          intercourse: 'var(--log-intercourse)', 'intercourse-alt': 'var(--log-intercourse-alt)',
        },
        /** Categorical series for the C3 chart primitives. No red: red means red flag. */
        chart: {
          1: 'var(--chart-1)', 2: 'var(--chart-2)', 3: 'var(--chart-3)',
          4: 'var(--chart-4)', 5: 'var(--chart-5)', 6: 'var(--chart-6)',
          inactive: 'var(--chart-inactive)', grid: 'var(--chart-grid)',
          axis: 'var(--chart-axis)', annotation: 'var(--chart-annotation)',
        },
        /** How strongly stated, never how good. One hue at three weights. */
        confidence: {
          high: 'var(--confidence-high)', medium: 'var(--confidence-medium)',
          low: 'var(--confidence-low)', band: 'var(--confidence-band)',
        },
        /** Illustration complexions. Identical in both themes — skin does not invert. */
        skin: {
          1: 'var(--skin-1)', 2: 'var(--skin-2)', 3: 'var(--skin-3)',
          4: 'var(--skin-4)', 5: 'var(--skin-5)',
        },
        phase: { menstrual: 'var(--phase-menstrual)', follicular: 'var(--phase-follicular)', ovulatory: 'var(--phase-ovulatory)', luteal: 'var(--phase-luteal)' },
        prediction: { band: 'var(--prediction-band)' },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        display: ['Fraunces', 'Georgia', 'serif'],
        arabic: ['IBM Plex Sans Arabic', 'Inter', 'sans-serif'],
        mono: ['JetBrains Mono', 'ui-monospace', 'monospace'],
      },
      fontSize: {
        '2xs': ['12px', { lineHeight: '1.5' }],
        xs: ['14px', { lineHeight: '1.5' }],
        sm: ['16px', { lineHeight: '1.5' }],
        md: ['18px', { lineHeight: '1.5' }],
        lg: ['22px', { lineHeight: '1.4' }],
        xl: ['28px', { lineHeight: '1.25' }],
        '2xl': ['36px', { lineHeight: '1.2', letterSpacing: '-0.01em' }],
        '3xl': ['48px', { lineHeight: '1.1', letterSpacing: '-0.02em' }],
        '4xl': ['60px', { lineHeight: '1.05', letterSpacing: '-0.02em' }],
        '5xl': ['72px', { lineHeight: '1', letterSpacing: '-0.02em' }],
      },
      spacing: {
        1: '4px', 2: '8px', 3: '12px', 4: '16px', 5: '20px', 6: '24px',
        8: '32px', 10: '40px', 12: '48px', 16: '64px', 20: '80px', 24: '96px', 32: '128px',
      },
      borderWidth: {
        // Mirrors --stroke-* in femio.tokens.css. `focus` is deliberately its own
        // key rather than an alias of `2`: the focus ring is an accessibility
        // commitment and must be changeable without touching every 2px border.
        0: '0', 1: '1px', 2: '2px', 3: '3px', 4: '4px', focus: '2px',
      },
      borderRadius: {
        // `round` mirrors --radius-round in femio.tokens.css. It was in the token
        // file and missing here, so `rounded-round` silently produced no radius at
        // all — a radio dot rendered as a square (P1.28.5). Tailwind emits nothing
        // for an unmapped utility, so the only symptom is the wrong shape.
        xs: '6px', sm: '10px', md: '16px', lg: '24px', xl: '32px', pill: '999px', round: '50%',
      },
      boxShadow: {
        xs: 'var(--shadow-xs)', sm: 'var(--shadow-sm)', md: 'var(--shadow-md)',
        lg: 'var(--shadow-lg)', xl: 'var(--shadow-xl)', focus: 'var(--shadow-focus)',
        'primary-glow': 'var(--shadow-primary-glow)',
      },
      backgroundImage: {
        'gradient-brand': 'var(--gradient-brand)',
        'gradient-fertile': 'var(--gradient-fertile)',
        'gradient-warm': 'var(--gradient-warm)',
        'gradient-dawn': 'var(--gradient-dawn)',
        // Text-safe hero gradients — see the token file for the contrast note.
        'gradient-hero-cycle': 'var(--gradient-hero-cycle)',
        'gradient-hero-ttc': 'var(--gradient-hero-ttc)',
        'gradient-hero-warm': 'var(--gradient-hero-warm)',
      },
      transitionTimingFunction: {
        standard: 'cubic-bezier(.2,0,0,1)', spring: 'cubic-bezier(.34,1.56,.64,1)',
      },
      transitionDuration: { fast: '150ms', base: '250ms', slow: '400ms' },
      screens: { xs: '360px', sm: '480px', md: '768px', lg: '1024px', xl: '1440px' },
      zIndex: {
        // base/raised mirror --z-base and --z-raised, which were in the token file
        // and unmapped here — the same gap that made `rounded-round` a no-op.
        base: '0', raised: '10',
        dropdown: '1000', sticky: '1100', overlay: '1200', modal: '1300', toast: '1400', tooltip: '1500',
      },
    },
  },
};

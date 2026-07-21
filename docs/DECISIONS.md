# Femio — Decision Log (ADR)

## ADR-001 (2026-07-16): Web-first PWA + shared Supabase backend
Context: V1 Flutter app had no backend/SEO/CMS. Decision: Next.js 15 PWA + Supabase, Capacitor wrap for stores in Phase 4. Alternatives: Flutter Web (poor SEO), parallel native (cost). Consequences: one TypeScript codebase, SEO engine, admin portal feasible.

## ADR-002 (2026-07-16): E-commerce via headless Shopify, not custom build
Context: store manageable per country. Decision: Shopify Basic + Storefront API + Shopify Markets. Consequences: months saved; swappable later.

## ADR-003 (2026-07-16): Project root = E:\Femio (docs/, references/, skills/, app/, assets/)

## ADR-004 (2026-07-16): Persona-driven adaptive-UX architecture
Context: Femio must personalize deeply across ~70 life-stage/condition scenarios while staying one coherent app and out of medical-device scope. Decision: a single Master Adaptation Model — one **constant EMR core + additive persona layers**, a wizard→persona resolver, a **Z1 "Other/Custom" nearest-persona fallback**, and a universal-events layer (positive test, loss, red-flags, mood-screen) inherited by all personas. Seven invariants govern it, headlined by **"personalize, never restrict"** (emphasis/defaults/tone/alerts change; access never does) and **"never diagnose/treat/prevent/contracept."** Alternatives: separate apps/modes per stage (fragmentation, the market's core failure); hard-coded per-persona UIs (unmaintainable at 70+). Consequences: remaining personas inherit invariants/events/data-model and only add their own fields+content+transitions; the C8→D7 (thyroid TTC→pregnancy) flow is the reference implementation. (→ 09_MASTER_ADAPTATION_MODEL.md)

## ADR-005 (2026-07-16): Keep orchestration lean — no external multi-agent platform yet
Context: Considered a "Femio Agent OS" (n8n + LangGraph + LiteLLM + Figma MCP + CI) to orchestrate research/build/test/translate across Gemini/OpenAI/Claude. Decision: **defer** it. Pro chat subscriptions (ChatGPT/Claude/Gemini) are not API access, so an orchestrator would require separate pay-per-token API accounts; and building the platform would precede building the product. Near-term: **GitHub as single source of truth**, Cowork subagents for research, per-provider coding CLIs (Claude Code/Codex/Gemini CLI) for build, GitHub Actions for deterministic tests, cross-provider PR review. Adopt n8n/LangGraph/LiteLLM only if/when manual coordination becomes the bottleneck and API spend is approved. Consequences: fast progress now, no premature infra; revisit trigger = coordination pain. (Persona research is synthetic/public — no real user health data through any research agent.)

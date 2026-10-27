# Study report template (every study agent follows this exactly)

Write ONE markdown file at the path you were given. Plain words; a one-line explanation the first time a term of art appears. Facts you measured are marked **Checked**; things the docs claim are marked **From the docs**; your reading is marked **Hypothesis**. Never invent. If you did not read a file, say so.

Sections, in this order:

1. **Purpose in one paragraph** — what this area is for and why it exists.
2. **Inventory table** — every file (or every folder when >60 files): `path | lines | one-line purpose | status` where status ∈ {live, app-only (closed web tracker), dead, duplicate, unknown}.
3. **Key modules and responsibilities** — the 5–15 modules that matter, each 2–4 lines: inputs, outputs, who calls it.
4. **Data flow** — where data enters, where it is stored, where it leaves. Name every external service touched (Supabase, Vercel, Sentry, PostHog, fonts, CDNs...).
5. **Dependencies** — what this area imports from elsewhere in the repo and what imports it.
6. **Strings and i18n** — where user-facing text lives, hard-coded strings found (path:line).
7. **Tests** — test files, what they cover, what is untested.
8. **Smells, risks, dead code** — concrete, with path:line.
9. **Keep / rebuild / delete verdict** — per module, one line each, with the reason. Judge against the current direction: a PRIVATE Android app (Flutter, records on the phone, no accounts) as the product; the website as a static teaser (articles, calculators, SEO) that sends people to the app; no Supabase at runtime; wedge = Arabic-first TTC → pregnancy with PCOS depth, Saudi + Egypt.
10. **Open questions** — things only the owner or a deeper read can answer.

Also write a graph file at the JSON path you were given:
{"area":"<name>","nodes":[{"id":"<unique-kebab>","label":"<short>","type":"module|screen|table|function|script|doc|service|fixture|asset","path":"<repo path>","status":"live|app-only|dead|duplicate|unknown"}],"edges":[{"from":"<id>","to":"<id>","kind":"imports|calls|reads|writes|renders|tested-by|generates|documents"}]}
Node ids must be stable kebab-case derived from the path (e.g. `web-lib-cycle-prediction`). Cross-area edges are welcome (use the same id scheme for the target). 30–120 nodes per area.

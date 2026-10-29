# The go-live dashboard

**Live page (private to Khaled):** https://claude.ai/artifact/V3exHDJpZasUkRoWuameDp

One page that holds every step between today and a live website with ads and a first app
upload: 69 steps in 9 phases, what sessions are waiting on, the two open decisions, and a log.
Ticks, flags, notes and decisions persist in the artifact's database and are read back by
sessions; the step list itself is content, built from the files here.

## Files

| File | What it is | Who edits it |
|---|---|---|
| `items.json` | the steps, by phase: title, owner (`owner` / `session`), why, click-by-click steps, done-when, links, dependencies, paste-ready values, guide reference, risk | a session, when a step changes or a new one is found |
| `requests.json` | what sessions need from the owner, newest first; each names what it unblocks | a session, every time it needs something from Khaled |
| `log.json` | what sessions did towards go-live, newest first | a session, at the end of a go-live task |
| `template.html` | the page without data | a session, for design or behaviour changes |
| `build-dashboard.mjs` | embeds the three data files into the template → `index.html` | run it, never edit by hand |
| `index.html` | the built page, what is published | generated |

## Rebuild and republish (a session does this)

```bash
node docs/34_GROWTH_OPS/dashboard/build-dashboard.mjs
```

Then publish `docs/34_GROWTH_OPS/dashboard/index.html` to the artifact URL above with the
Artifact tool (`url` set, so the page keeps its address and the owner's ticks). The build fails
on a duplicate id, a dependency on a missing step, a request that blocks a missing step, or an
id that looks like a Tag Manager, Analytics or AdSense id (those go into Vercel, never here).

## What the database holds (read with the ArtifactData tool)

- `items/<step id>` → `{ done, at, flag, note, updatedAt }` for steps; `items/req-<request id>` for requests.
- `decisions/adr-075` and `decisions/adr-076` → `{ choice, at }`.

A session opening a go-live task reads `items` and `decisions` first: a flag is a question
to answer, a note is context, a decision is binding.

## Rules

- A step id, once published, is never renamed: the owner's tick is keyed by it.
- Owner steps say exactly where to click and what "done" looks like; the value to paste is in
  `paste`, never only in prose.
- Ids, keys and passwords never enter these files. A step says *where* the id goes (Vercel,
  the password manager page), not the id.
- The wordmark is `femio`, lowercase, also in Arabic text.

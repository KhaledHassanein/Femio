# 28.01 — Method, evidence, and the boundary

## What was done

Three Android packages already present in `C:\Users\slash\Downloads` were decompiled
with jadx 1.5.6 on 2026-08-23, using the in-repo `android-reverse-engineering` skill
at `.claude/skills/android-reverse-engineering/`. Nothing was downloaded from any
app store, no account was created, and no request was made to any of these
companies' servers. Every finding in this study comes from bytes that were already
on the disk.

| App | Package | Version | Size | Classes | Output |
|---|---|---|---|---|---|
| Flo | `org.iggymedia.periodtracker` | 10.3.0 | 106 MB XAPK | 35,196 | `E:\re\flo\` |
| Pregnancy Tracker | `com.teamthree.pregnancytracker` | 1.0.20 | 44 MB XAPK | — | `E:\re\preg\`, `E:\re\preg2\` |
| GO Flo | `com.go.flo` | 1.1.9 | 11 MB APK | 5,346 | `E:\re\goflo\` |

All three are native Android with real `classes.dex`, so decompilation yields
readable Kotlin/Java rather than an opaque Flutter `libapp.so`. Flo's package names
are not obfuscated — `org.iggymedia.periodtracker.feature.*` and `core.*` survive
intact — which is why this study can be as specific as it is. Roughly 1% of Flo's
classes (334) failed to decompile cleanly, all of them deep in third-party
libraries; nothing load-bearing was lost.

Decompiled output lives in `E:\re\`, deliberately outside the repository, and is
**not** committed. Working extractions are in `E:\re\notes\`:

| File | Contents |
|---|---|
| `flo-activities.txt` | 157 Flo-owned activity class names |
| `flo-onboarding-steps.txt` | 442 onboarding step ids with their types |
| `flo-onboarding-transitions.json` | 634 transition edges with conditions and progress |
| `flo-onboarding-condition-tags.txt` | 141 distinct branching tags |
| `flo-onboarding-questions.md` | All 90 onboarding questions with answer sets |
| `flo-onboarding-featurecards.md` | 160 feature-card and announcement steps |
| `flo-symptoms.txt` | Flo's 47-symptom vocabulary |

## Two fixes the skill needed

Neither is a Femio problem, but both are recorded so the next session does not
rediscover them.

The stock `jadx` launcher builds a POSIX classpath that Windows Java rejects, so
`~/.local/bin/jadx` was replaced with a shim calling `java -cp` with a Windows path
and Android Studio's bundled JDK 21. No JDK was installed; the system default is
Java 11, which is below jadx's floor.

More seriously, the skill's `decompile.sh` combined `set -euo pipefail` with a
`find | head` pipeline and a `grep -v` that returns non-zero on no-match. Both abort
the script. On an XAPK — which contains a base APK plus split APKs — this killed the
run after the *first* split, which is resource-only, and still exited 0. Flo's base
APK, the only one that matters, was silently never decompiled. Fixed in
`decompile.sh:264`; the original is kept beside it as `decompile.sh.orig`. **Anyone
re-running an XAPK teardown should confirm every expected output directory exists
rather than trusting the exit code.**

## The boundary

These apps' code, copy, illustrations, animations and content are their copyright.
This study documents *structure, mechanism and taxonomy* — how a server-driven
element contract is shaped, how an onboarding graph branches, what a token naming
system looks like — because that is the part with engineering value and the part
that is not theirs to own. Specific strings and assets are quoted only where a short
quotation is needed to make a point about voice or approach.

Nothing from these binaries is copied into Femio. Not a colour ramp, not an
illustration, not a line of copy, not a schema verbatim. Where a chapter says
"adopt this shape", it means design an equivalent from our own tokens and our own
voice. If a future session finds itself pasting a competitor's value into a Femio
file, that is the error this paragraph exists to prevent.

One consequence worth stating plainly: Flo delivers most of its strings, content
and layout from its servers at runtime. We can see the *machinery* in full and the
bundled fallbacks, but the live content is not on our disk and was not fetched.
Where this study describes Flo's content volume, it is inferring from machinery and
fallbacks, and says so.

#!/bin/sh
# Vercel "Ignored Build Step" (vercel.json `ignoreCommand`). Exit 0 = skip, 1 = build.
#
# Most commits on this repo touch only docs/, and every push used to rebuild both
# Vercel projects (web + cms) — build minutes and a deploy for nothing. This skips
# a build only when it can PROVE nothing the app depends on changed; any doubt
# (no previous SHA, a shallow clone without it, a git error) falls through to build.
#
# Usage, from the project's root directory: sh ../../scripts/vercel/ignore-build.sh <paths…>
# Paths are relative to that directory.

# Dependabot branches are verified by CI; a preview deploy per bump is pure cost.
case "$VERCEL_GIT_COMMIT_REF" in
  dependabot/*) echo "skip: dependabot branch"; exit 0 ;;
esac

BASE="${VERCEL_GIT_PREVIOUS_SHA:-HEAD^}"
git cat-file -e "$BASE^{commit}" 2>/dev/null || { echo "build: base $BASE not in clone"; exit 1; }

if git diff --quiet "$BASE" HEAD -- "$@"; then
  echo "skip: nothing under $* changed since $BASE"
  exit 0
fi
echo "build: changes under $*"
exit 1

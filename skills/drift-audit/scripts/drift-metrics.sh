#!/usr/bin/env bash
# drift-metrics.sh <repo-or-dir> [extra-dir ...]
# Deterministic, read-only numbers for a drift audit. No interpretation here; the skill interprets.
set -u
ROOT="${1:?usage: drift-metrics.sh <repo-or-dir> [extra-dir ...]}"; shift || true
EXTRA=("$@")
cd "$ROOT" || exit 1

ATTRACTOR='auth|authority|security|secure|hardening|policy|trust|sign|signer|signed|attest|custody|custodian|ledger|audit|guard|permission|revocation|revoke|manifest|seal|sealed|journal|quarantine|escalat|approval|approve|privilege|uid|sudo|root_|protected|redact|hash|sha256|verify_|verifier|reviewer|gate'
VERSIONED='[_-]v[0-9]{2,}|[_-][0-9]{3}[_-]?v[0-9]+|handoff[0-9]+|-r[0-9]+$'
CODE_EXT='py|ts|tsx|js|jsx|mjs|go|rs|rb|java|kt|swift|c|cc|cpp|h|sh|sql'

say() { printf '\n== %s\n' "$*"; }
count_loc() { find "$@" -type f -regextype posix-extended -regex ".*\.($CODE_EXT)$" \
  -not -path '*/node_modules/*' -not -path '*/.venv/*' -not -path '*/venv/*' -not -path '*/.git/*' \
  -not -path '*/dist/*' -not -path '*/build/*' -print0 2>/dev/null | xargs -0 cat 2>/dev/null | wc -l; }

say "ROOT $ROOT  (extra: ${EXTRA[*]:-none})"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  say "GIT"
  first=$(git log --reverse --format=%cs | head -1); last=$(git log -1 --format=%cs)
  printf 'first commit %s | last commit %s | days %s | commits %s | authors %s\n' "$first" "$last" \
    "$(( ( $(date -d "$last" +%s) - $(date -d "$first" +%s) ) / 86400 + 1 ))" \
    "$(git rev-list --count HEAD)" "$(git log --format=%an | sort -u | wc -l)"
  printf 'commits last 7d %s | last 30d %s\n' "$(git log --since=7.days --oneline | wc -l)" "$(git log --since=30.days --oneline | wc -l)"
  printf 'files touched >=10 times (top 8):\n'; git log --name-only --format= | grep -v '^$' | sort | uniq -c | sort -rn | awk '$1>=10' | head -8
  printf 'tags matching version pattern: %s\n' "$(git tag | grep -cE 'v?[0-9]+' )"
  printf 'commit subjects mentioning attractors (of %s): %s\n' "$(git rev-list --count HEAD)" "$(git log --format=%s | grep -ciE "$ATTRACTOR")"
fi

say "SIZE"
total=$(count_loc .); printf 'code LOC total: %s\n' "$total"
attr_files=$(find . -type f -regextype posix-extended -regex ".*\.($CODE_EXT)$" -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/.venv/*' | grep -iE "$ATTRACTOR" || true)
attr_loc=0; [ -n "$attr_files" ] && attr_loc=$(printf '%s\n' "$attr_files" | tr '\n' '\0' | xargs -0 cat 2>/dev/null | wc -l)
printf 'code LOC in files whose PATH matches attractor words: %s (%s%% of total), files: %s\n' "$attr_loc" "$(( total>0 ? attr_loc*100/total : 0 ))" "$(printf '%s\n' "$attr_files" | grep -c . )"
printf 'top attractor-path files by LOC:\n'; [ -n "$attr_files" ] && printf '%s\n' "$attr_files" | tr '\n' '\0' | xargs -0 wc -l 2>/dev/null | sort -rn | grep -v ' total$' | head -8
printf 'largest code files overall:\n'; find . -type f -regextype posix-extended -regex ".*\.($CODE_EXT)$" -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/.venv/*' -print0 | xargs -0 wc -l 2>/dev/null | sort -rn | grep -v ' total$' | head -8
printf 'test LOC: %s\n' "$(find . -type f -regextype posix-extended -regex ".*(test|spec)[^/]*\.($CODE_EXT)$" -not -path '*/node_modules/*' -not -path '*/.git/*' -print0 | xargs -0 cat 2>/dev/null | wc -l)"

say "ARTIFACT CHURN (dirs/files/docs with version or handoff numbering)"
printf 'versioned names: %s\n' "$(find . ${EXTRA[@]:+"${EXTRA[@]}"} -not -path '*/.git/*' -not -path '*/node_modules/*' 2>/dev/null | grep -cE "$VERSIONED")"
printf 'handoff/continuation/checkpoint docs: %s\n' "$(find . ${EXTRA[@]:+"${EXTRA[@]}"} -type f -not -path '*/.git/*' 2>/dev/null | grep -ciE 'handoff|continuation|checkpoint|runbook|decision')"
printf 'systemd units: %s | shell scripts: %s | json docs: %s\n' \
  "$(find . ${EXTRA[@]:+"${EXTRA[@]}"} -name '*.service' -o -name '*.timer' 2>/dev/null | wc -l)" \
  "$(find . ${EXTRA[@]:+"${EXTRA[@]}"} -name '*.sh' -not -path '*/node_modules/*' 2>/dev/null | wc -l)" \
  "$(find . ${EXTRA[@]:+"${EXTRA[@]}"} -name '*.json' -not -path '*/node_modules/*' 2>/dev/null | wc -l)"

say "DOCS: constraint language (md/txt)"
docs=$(find . ${EXTRA[@]:+"${EXTRA[@]}"} -type f \( -name '*.md' -o -name '*.txt' \) -not -path '*/node_modules/*' -not -path '*/.git/*' 2>/dev/null)
if [ -n "$docs" ]; then
  printf 'doc files: %s\n' "$(printf '%s\n' "$docs" | wc -l)"
  for w in 'preserve' 'do not weaken' 'must not' 'never' 'exact(ly)? reviewed' 'authoriz' 'signed' 'irreversib' 'point of no return'; do
    printf '  "%s": %s lines\n' "$w" "$(printf '%s\n' "$docs" | tr '\n' '\0' | xargs -0 grep -hiE "$w" 2>/dev/null | wc -l)"
  done
  printf 'docs mentioning a $ or budget cap: %s | mentioning "done when"/"acceptance"/"success criteria": %s | "out of scope"/"not doing"/"non-goal": %s\n' \
    "$(printf '%s\n' "$docs" | tr '\n' '\0' | xargs -0 grep -liE '\$[0-9]|budget|cap ' 2>/dev/null | wc -l)" \
    "$(printf '%s\n' "$docs" | tr '\n' '\0' | xargs -0 grep -liE 'done when|acceptance|success criteri' 2>/dev/null | wc -l)" \
    "$(printf '%s\n' "$docs" | tr '\n' '\0' | xargs -0 grep -liE 'out of scope|not doing|non-goal|not in scope' 2>/dev/null | wc -l)"
fi

say "PROCESS: privilege and ceremony markers in code+scripts"
for w in 'sudo' 'systemd-run|systemctl' 'useradd|adduser|chown' 'ed25519|nacl|sign\(' 'sha256|hashlib|SHA256' 'redact|_safe_refusal'; do
  printf '  %-26s %s hits\n' "$w" "$(grep -rIiE "$w" --include='*.py' --include='*.sh' --include='*.ts' --include='*.js' --include='*.go' --include='*.rs' --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=.venv . 2>/dev/null | wc -l)"
done

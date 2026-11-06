#!/usr/bin/env bash
# comb-card.sh: pick option order by chance, and lint a rendered comb card.
#   order <2|3>       prints the plan's option numbers in the order to list them as A, B, C
#   lint <card-file>  prints one "card:<line>: <problem>" per failure and a summary; exit 1 on any failure
set -euo pipefail

usage() { echo "usage: comb-card.sh order <2|3> | lint <card-file>" >&2; exit 2; }

order() {
  local n=${1:-}
  [[ $n == 2 || $n == 3 ]] || usage
  local -a nums
  mapfile -t nums < <(seq 1 "$n")
  local i j tmp
  for ((i = n - 1; i > 0; i--)); do
    j=$((RANDOM % (i + 1)))
    tmp=${nums[i]}; nums[i]=${nums[j]}; nums[j]=$tmp
  done
  echo "${nums[*]}"
}

lint() {
  local file=${1:-}
  [[ -f $file ]] || usage
  awk '
    function fail(n, msg) { printf "card:%d: %s\n", n, msg; failures++ }
    function words(s,   a) { return split(s, a, /[ \t]+/) }
    { line[NR] = $0 }
    END {
      for (i = 1; i <= NR; i++) if (line[i] ~ /^\*\*Decision [0-9]+ of [0-9]+/) { title = i; break }
      for (i = NR; i >= 1; i--) if (line[i] ~ /[^ \t]/) { last = i; break }
      if (!title) { fail(1, "no title line \"**Decision N of M · <phase>**\""); title = 0 }
      if (!last || line[last] !~ /^(Your pick|Which felt right)/) fail(last, "last line is not the question (\"Your pick ...\" or \"Which felt right ...\")")
      body = last - title - 1
      if (body > 20) fail(title, "body is " body " lines between title and question; 20 maximum")

      fence = 0; maplines = 0; fences = 0; opts = 0; cur = 0; inwrong = 0; wrongs = 0; whynow = 0
      for (i = title + 1; i < last; i++) {
        s = line[i]
        if (s ~ /^```/) { fence = !fence; fences++; continue }
        if (fence) { maplines++; continue }
        low = tolower(s)
        if (s ~ /^why now:/) whynow = 1
        if (index(s, "?")) fail(i, "question mark outside the question line")
        if (low ~ /recommend|i.d pick|i would pick|best option|my pick|i prefer/) fail(i, "recommendation wording")
        if (index(s, "`")) fail(i, "code formatting outside the map")
        if (s ~ /[A-Za-z0-9_.\/-]+\.[A-Za-z]+:[0-9]+/) fail(i, "path:line")
        if (s ~ /[A-Za-z_][A-Za-z0-9_]*\(\)/) fail(i, "function call")
        if (s ~ /(^|[^A-Za-z])[a-z]+[A-Z][A-Za-z]*/) fail(i, "camelCase identifier")
        if (s ~ /(^|[^A-Za-z])[a-z]+_[a-z_]+/) fail(i, "snake_case identifier")
        if (low ~ /(^|[^a-z])(obviously|clearly|simply|basically|just)([^a-z]|$)/) fail(i, "empty hedge")

        if (s ~ /^if wrong:/) inwrong = 1
        else if (s !~ /^[ \t]/) inwrong = 0
        if (inwrong && index(s, "→")) {
          wrongs++
          if (s !~ /undo:/) fail(i, "\"if wrong\" line without undo")
        }

        if (s ~ /^[A-C]  /) { cur = ++opts; w[cur] = words(substr(s, 4)); continue }
        if (cur && s ~ /^   [^ ]/ && !inwrong) { w[cur] += words(substr(s, 4)); continue }
        cur = 0
      }
      if (fence) fail(last, "map fence not closed")
      if (fences > 2) fail(title, "more than one fenced block")
      if (maplines > 8) fail(title, "map is " maplines " lines; 8 maximum")
      if (!whynow) fail(title, "no \"why now:\" line")
      if (opts < 2) fail(title, "fewer than two options")
      if (opts > 3) fail(title, "more than three options")
      if (wrongs != opts) fail(title, "\"if wrong\" has " wrongs " lines for " opts " options")
      lo = 1e9; hi = 0; wl = ""
      for (k = 1; k <= opts; k++) { wl = wl (k > 1 ? "/" : "") w[k]; if (w[k] < lo) lo = w[k]; if (w[k] > hi) hi = w[k] }
      slack = hi * 0.2; if (slack < 4) slack = 4
      if (opts >= 2 && hi - lo > slack) fail(title, "option lengths differ (" wl " words); equal length hides the pick")
      printf "lines=%d map=%d options=%d words=%s failures=%d\n", body, maplines, opts, wl, failures
      exit (failures > 0)
    }
  ' "$file"
}

case "${1:-}" in
  order) order "${2:-}" ;;
  lint) lint "${2:-}" ;;
  *) usage ;;
esac

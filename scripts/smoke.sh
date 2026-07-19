#!/usr/bin/env bash
# Smoke-Test fuer das cmd-Plugin.
#
# ACHTUNG: startet echte Modell-Laeufe (claude -p) — kostet Tokens und Zeit,
# und die Ausgabe ist nicht deterministisch (loose Muster, kann selten flaken).
#
# Prueft NUR den Eroeffnungszug je Skill (laedt der Skill, produziert er seine
# charakteristische erste Ausgabe), NICHT die Schluss-/Abschlussnotiz: die
# erreicht ein Einzelaufruf bei den mehrschrittigen Skills nicht. Die erwartete
# Form der vollen Flows steht in examples/transcripts.md.
set -u

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)/cmd"
TIMEOUT="${SMOKE_TIMEOUT:-120}"
fail=0

# timeout ist auf macOS nicht per Default vorhanden (dort ggf. gtimeout via
# coreutils). Nur nutzen, wenn verfuegbar, sonst ohne Wrapper laufen.
TIMEOUT_CMD=""
if command -v timeout >/dev/null 2>&1; then TIMEOUT_CMD="timeout $TIMEOUT"
elif command -v gtimeout >/dev/null 2>&1; then TIMEOUT_CMD="gtimeout $TIMEOUT"
fi

run() {
  local name="$1" prompt="$2" pattern="$3" out
  echo "=== $name ==="
  if ! out="$($TIMEOUT_CMD claude --plugin-dir "$PLUGIN_DIR" -p "$prompt" 2>&1)"; then
    echo "FAIL ($name): Aufruf fehlgeschlagen oder Timeout"; fail=1; return
  fi
  if [ -z "$out" ]; then
    echo "FAIL ($name): leere Ausgabe"; fail=1; return
  fi
  if echo "$out" | grep -qiE "$pattern"; then
    echo "PASS ($name): Eroeffnungszug erkannt"
  else
    echo "FAIL ($name): Muster '$pattern' nicht gefunden"; fail=1
  fi
}

# grill: Steelman + genau eine Frage
run "plan-grill"   "/cmd:plan-grill Beispiel: soll ich Feature X bauen" "steelman|wohlwollend|\\?"
# review: braucht einen Plan -> Einordnung oder Bitte um einen Plan
run "plan-review"  "/cmd:plan-review" "plan|blickwinkel|einordnung|kein plan"
# execute: braucht freigegebenen Plan -> ExitPlanMode/Bitte um Plan
run "plan-execute" "/cmd:plan-execute" "plan|freigegeben|exitplanmode|umsetz"

echo
if [ "$fail" -eq 0 ]; then echo "SMOKE: alle Eroeffnungszuege OK"; else echo "SMOKE: mind. ein Skill FAIL"; fi
exit "$fail"

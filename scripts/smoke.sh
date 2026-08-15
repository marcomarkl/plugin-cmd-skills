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

# grill: Steelman + genau eine Frage. Der Skill SCHREIBT seit 0.8.0 am Ende die
# Plandatei — dieser Pfad wird headless nicht erreicht, weil er die Bestaetigung der
# Schlussnotiz voraussetzt, die ein "-p"-Lauf nicht liefert (wie bei session-handoff).
run "plan-grill"   "/cmd:plan-grill Beispiel: soll ich Feature X bauen" "steelman|wohlwollend|\\?"
# review: braucht einen Plan -> Einordnung oder Bitte um einen Plan
run "plan-review"  "/cmd:plan-review" "plan|blickwinkel|einordnung|kein plan"
# execute: braucht freigegebenen Plan -> ExitPlanMode/Bitte um Plan
run "plan-execute" "/cmd:plan-execute" "plan|freigegeben|exitplanmode|umsetz"
# project-rules: Eroeffnungszug ist die Aufloesung der Zieldatei plus das Projektprofil
# zur Bestaetigung. Der Skill SCHREIBT normalerweise die CLAUDE.md — dieser Pfad wird hier
# nicht erreicht: er setzt die bestaetigte Zieldatei und das bestaetigte Profil voraus, die
# ein "-p"-Lauf nicht liefert. Ohne Argument gibt es zudem keinen Pfad, also greift der
# Rueckfrage-Zweig ("frag kurz nach, statt zu raten").
run "project-rules" "/cmd:project-rules" "zieldatei|claude\.md|agents\.md|projektprofil|welche datei"
# session-learn: reflektiert die Session (headless kaum Historie -> nur Laden/Eroeffnung)
run "session-learn" "/cmd:session-learn" "learning|session|reflex|plan|keine"
# project-settings: Sonderfall wie session-handoff. Der Skill SCHREIBT normalerweise
# .claude/settings.json und .gitignore und legt den Ordner plans/ an — hier laeuft er im
# Repo selbst, also wird bewusst NUR der nebenwirkungsfreie Eroeffnungszug geprueft:
# Bestandsaufnahme und Vorschau vor der Freigabe. Zwei Dinge schuetzen zusaetzlich:
# "-p" erlaubt ohne "--permission-mode acceptEdits" kein Write, und der Skill holt vor
# jeder Aenderung eine Freigabe, die es headless nicht gibt.
# Achtung, ungleicher Schutz: Das Anlegen von plans/ liefe ueber Bash, nicht ueber Write —
# dort traegt allein die Freigabe. Bleibt nach dem Lauf ein plans/ im Repo zurueck, ist
# das ein Befund am Skill, kein Testartefakt: dann haelt er die Freigabe nicht ein.
# Die Permission-WIRKUNG ist headless grundsaetzlich nicht pruefbar: permissions.allow
# greift erst nach dem Workspace-Trust-Dialog, und der erscheint in "-p" nie.
run "project-settings" "/cmd:project-settings" "settings\.json|bestandsaufnahme|vorschau|kanon|freigabe"
# session-handoff: Sonderfall. Der Skill SCHREIBT normalerweise eine HANDOFF.md —
# genau das wird hier bewusst NICHT geprueft, weil der Test sonst eine Datei ins
# aktuelle Verzeichnis legt. Geprueft wird der nebenwirkungsfreie Zweig: Ein
# "claude -p"-Lauf hat keinen Gespraechsverlauf, also keinen uebergebbaren Stand,
# und der Skill muss das sagen statt einen Stand zu erfinden.
# Fuer den Schreibpfad braucht es zwei Dinge, die hier fehlen: synthetischen
# Verlauf im Prompt und "--permission-mode acceptEdits" (ohne das erlaubt -p kein
# Write, und der Test meldete einen falschen FAIL). Siehe DESIGN.md.
run "session-handoff" "/cmd:session-handoff" "kein.{0,30}(stand|verlauf|uebergabe|übergabe)|keine (datei|uebergabe|übergabe)|nichts zu uebergeben"

echo
if [ "$fail" -eq 0 ]; then echo "SMOKE: alle Eroeffnungszuege OK"; else echo "SMOKE: mind. ein Skill FAIL"; fi
exit "$fail"

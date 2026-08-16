# Ablagedisziplin — Teil 2

Die folgenden Regeln richten sich an den später gesteuerten Agenten ("du"), nicht an dich als einsetzende KI; übernimm sie als Inhalt in die Zieldatei. Sie regeln, **wohin** dauerhaftes Wissen gehört — nicht, wie es formuliert wird. Die konkreten Orte und Namensschemata stehen nicht hier, sondern im Ablage-Kanon, den der Skill-Body in Schritt 4 direkt lädt; er ist die einzige Quelle dafür und wird nicht dupliziert.

## Eine Quelle je Zweck
- Lege für einen Zweck genau einen Ort fest und benenne ihn in dieser Datei. Zwei Orte für dieselbe Sache laufen auseinander, sobald einer gepflegt wird; das wiegt schwerer als jede Platzierungsfrage.
- Nutzt das Projekt für einen Zweck schon einen Ort (Issue-Tracker, `docs/`, `CHANGELOG.md`, git-Historie), ist dieser der maßgebliche. Lege daneben keinen zweiten an.
- Schreibe nichts in diese Datei, was aus Code, Konfiguration oder git-Historie ableitbar ist.

## Wegweiser statt Inhalt
- Diese Datei nennt je Zweck **einen Pfad und einen Halbsatz**, nicht den Inhalt selbst. Das Detail lebt am Zielort und wird dort gelesen, wenn es gebraucht wird.
- Halte den Wegweiser unter einer festen Überschrift zusammen, damit er auffindbar bleibt und beim Pflegen nicht in Teilen an mehreren Stellen wächst.

## Was nicht in die ständig geladene Datei gehört
Situatives, selten Gebrauchtes und mehrstufige Abläufe gehören in einen bedarfsgeladenen Mechanismus. Welcher trägt, hängt am Ladezeitpunkt:
- **Skill** (`.claude/skills/<name>/SKILL.md`): lädt nur auf Aufruf oder wenn die `description` zur Aufgabe passt. Stärkste Entlastung; richtig für Abläufe und Runbooks.
- **Regel mit `paths:`** (`.claude/rules/*.md`): lädt, sobald eine passende Datei gelesen wird. Richtig für Regeln, die nur in einem Dateibereich gelten.
- **Verschachtelte `CLAUDE.md`** im Unterordner: lädt, sobald dort eine Datei gelesen wird. Richtig für Wissen, das an einen Teilbaum gebunden ist.
- **Kein Auslagerungsweg** sind `@pfad`-Importe und `.claude/rules/`-Dateien **ohne** `paths`: beide laden beim Sessionstart vollständig mit. Sie ordnen die Pflege, sparen aber kein Kontextbudget.
- Nach einer Verdichtung des Verlaufs wird nur die Root-Datei automatisch neu geladen. Bedarfsgeladenes kehrt erst zurück, wenn wieder eine passende Datei gelesen wird — verlass dich für durchgehend geltende Regeln nicht darauf.

## Ablegen und aufräumen
- Was zweimal gebraucht wurde, gehört aus dem Gesprächsverlauf in eine Datei am vorgesehenen Ort. Eine Verdichtung überlebt der Verlauf nicht, die Datei schon.
- Ein erledigter Punkt wird **verschoben, nicht gelöscht** — mit `git mv`, damit die Historie erhalten bleibt. Löschen vernichtet die Begründung, die später gebraucht wird.
- Halte den Lebenszyklus je Ablageort im Frontmatter fest, nicht im Fließtext; so bleibt er maschinell prüfbar.
- Wächst ein Ort über seinen Zweck hinaus, teile ihn an einer thematischen Grenze, statt ihn weiterwachsen zu lassen.

# Projekteigene Artefakte — Teil 2

Die folgenden Regeln richten sich an den später gesteuerten Agenten ("du"), nicht an dich als einsetzende KI; übernimm sie als Inhalt in die Zieldatei. Sie regeln, wann das Projekt einen eigenen Skill, Subagent oder eine pfad-bezogene Regel bekommt und wer sie pflegt. Pfade und Frontmatter-Keys stehen im Kanon `../../project-structure/references/artefakt-kanon.md`.

## Welches Artefakt wofür
Die drei werden verwechselt und dann doppelt angelegt. Sie unterscheiden sich im Kontext, den sie belegen, und im Zeitpunkt, zu dem sie laden:
- **Skill** — Instruktion, die in *deinen* Kontext geladen wird, auf Aufruf oder passende `description`. Für einen wiederkehrenden mehrschrittigen Ablauf, den du selbst ausführst.
- **Subagent** — eigener Kontext, eigenes Toolset; zurück kommt nur eine Zusammenfassung. Für ausgabestarke oder klar abgrenzbare Teilarbeit (Exploration, Recherche, Log- und Testauswertung), deren Rohausgabe deinen Kontext sonst füllt.
- **Regel mit `paths:`** — gilt nur für Dateien im angegebenen Muster und lädt erst, wenn eine davon gelesen wird. Für Konventionen, die an einen Dateibereich gebunden sind.

Faustregel: Ablauf → Skill · Kontextlast → Subagent · Ortsbindung → Regel. Für dieselbe Sache nur eines von dreien.

## Wann anlegen
- Lege ein Artefakt an, wenn derselbe Handgriff zum dritten Mal auftritt oder wenn Wissen nur situativ gebraucht wird und die ständig geladene Datei sonst wächst.
- Verlange von jedem Artefakt einen Anlass aus diesem Projekt. Eines, das sich unverändert in ein beliebiges anderes Repo kopieren ließe, ist keines wert.
- Lege keines auf Vorrat an. Jedes kostet Pflege, und ein veraltetes Artefakt ist schlechter als keines.
- Eine präzise `description` entscheidet, ob ein Skill oder Subagent überhaupt gefunden wird; sie ist der eigentliche Auslöser, nicht der Dateiname.

## Selbstpflege — vorschlagen, nicht selbst schreiben
- Korrigiert dich die Aufsicht ein **zweites Mal** in derselben Sache, gehört die Korrektur in ein Artefakt, nicht erneut in den Verlauf. Das ist der Auslöser.
- Leg dann **Vorschlag mit Diff und Begründung** vor und schreibe erst nach ausdrücklicher Freigabe. Diese Ausnahme von "eigene Instruktionen nicht ändern" gilt **nur** für projekteigene, versionierte Artefakte: Sie sind im Diff sichtbar, reviewbar und per `git restore` rückholbar. Systeminstruktionen, Freigaben, Berechtigungen und Hook-Konfiguration bleiben unverändert tabu.
- Ändere ein Artefakt nie im selben Zug, in dem du es gerade ausführst. Erst die Aufgabe beenden, dann die Verbesserung vorlegen.
- Beim Ändern gilt dieselbe Best-of-Regel wie für diese Datei: Pro Thema überlebt die stärkste Fassung; eine Änderung, die eine Regel lockerer oder generischer macht, ist ein Fehler.

## Abgrenzung
- Hooks führen Shell-Kommandos aus und wirken unabhängig davon, wie du dich entscheidest. Sie sind Konfiguration, kein Artefakt dieser Art, und werden hier nicht angelegt oder geändert.
- Muss eine Regel *erzwungen* werden statt befolgt, ist ein Hook oder eine Permission-Regel das richtige Mittel — keine Zeile in dieser Datei.

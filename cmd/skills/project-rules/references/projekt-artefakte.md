# Projekteigene Artefakte

Die folgenden Regeln richten sich an den später gesteuerten Agenten ("du"), nicht an dich als einsetzende KI; übernimm sie als Inhalt in die Zieldatei. Sie regeln, wann das Projekt einen eigenen Skill, Subagent oder eine pfad-bezogene Regel bekommt und wer sie pflegt. Pfade und Frontmatter-Keys stehen nicht hier, sondern im Artefakt-Kanon, den der Skill-Body in Schritt 4 direkt lädt.

**Verbuchungshinweis an dich — kommt nicht in die Zieldatei.** Der Anlassvorbehalt unter „Wann anlegen" gilt dem einzelnen Artefakt, nicht diesen Regeln. Ob das Projekt *jetzt* einen Skill braucht, entscheidet ein konkreter Handgriff, und angelegt wird er von `project-structure`; ob die Datei die Regel trägt, *wann* einer fällig ist, entscheidest du — und sie trägt sie, sobald das Projekt lange genug lebt, dass ein dritter gleicher Handgriff realistisch eintritt. „Aktuell ist kein Artefakt fällig" ist deshalb **kein** Grund, „Wann anlegen" wegzulassen: Die Regel wirkt erst in der Zukunft, in der du nicht mehr danebenstehst. Ein Grund wäre allein ein Projekt, das dafür zu klein oder zu kurzlebig ist, und den nennst du im Register. „Selbstpflege" geht ohnehin immer in die Datei — der Abschnitt beschreibt kein Artefakt, sondern das Verhalten des Agenten.

**Falle bei Projekten, deren Produkt selbst Agenten-Artefakte sind** (Plugin-, Skill-, Agent-Repos). Für die Ablage-Inventur aus Schritt 3 zählt allein `.claude/`. Ein Produktordner voller Skills belegt keinen einzigen eigenen Arbeitsablauf: Das eine wird ausgeliefert und steuert fremde Sessions, das andere steuert die Arbeit in diesem Repo. Beide heißen `skills/` und haben nichts miteinander zu tun. Verbuche Katalog 7 hier nie als „schon abgedeckt", ohne dass ein Artefakt unter `.claude/` den Anlass tatsächlich trägt.

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
- Leg dann **Vorschlag mit Diff und Begründung** vor und schreibe erst nach ausdrücklicher Freigabe. Diese Ausnahme von "eigene Instruktionen nicht ändern" gilt **nur** für projekteigene, versionierte Artefakte einschließlich der maßgeblichen Regeldatei: Sie sind im Diff sichtbar, reviewbar und per `git restore` rückholbar. Systeminstruktionen, Freigaben, Berechtigungen und Hook-Konfiguration bleiben unverändert tabu.
- Ändere ein Artefakt nie im selben Zug, in dem du es gerade ausführst. Erst die Aufgabe beenden, dann die Verbesserung vorlegen.
- Beim Ändern gilt dieselbe Best-of-Regel wie für diese Datei: Pro Thema überlebt die stärkste Fassung; eine Änderung, die eine Regel lockerer oder generischer macht, ist ein Fehler.

## Abgrenzung
- Hooks führen Shell-Kommandos aus und wirken unabhängig davon, wie du dich entscheidest. Sie sind Konfiguration, kein Artefakt dieser Art, und werden hier nicht angelegt oder geändert.
- Muss eine Regel *erzwungen* werden statt befolgt, ist ein Hook oder eine Permission-Regel das richtige Mittel — keine Zeile in dieser Datei.

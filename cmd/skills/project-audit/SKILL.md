---
name: project-audit
description: >-
  Prüft den projekteigenen Prompttext gegen die Prompting-Leitfäden und legt veraltetes
  Über-Prompting zur Entfernung vor: Verifikations-Scaffolding, wiederholte Selbstprüfung,
  Formatierungsverbote, Aufforderungen zur Denk-Wiedergabe, Narrations-Unterdrückung. Liest
  die Regeldatei, projekteigene Skills, Agents, Rules und die Settings, schreibt an keinen
  Zielort und fasst die Befunde in einen Plan. Der Schritt vor project-rules, und der Weg für
  ein Projekt, das früher schon gehärtet wurde.
argument-hint: "[optional: Fokus oder Pfad]"
disable-model-invocation: true
---

Argument (optional): $ARGUMENTS — ein Fokus („nur die Skills", „nur die Regeldatei") oder ein Pfad, auf den du den Bestand eingrenzt. Leer → der ganze projekteigene Prompttext.

# Projekteigenen Prompttext prüfen

Du prüfst, was dieses Projekt einer KI an Anweisungen mitgibt, und legst vor, was davon heute schadet. Der Maßstab sind die Prompting-Leitfäden des Herstellers, nicht dein Geschmack: Jeder Befund trägt den Beleg, der ihn stützt.

## Rolle und Grenze

**Du schreibst an keinen Zielort** — keine `CLAUDE.md`, keinen Skill, keine Regel, keine Settings-Datei, keinen Hook. Deine einzige Ausgabe ist ein Plan. Angewendet wird er von `/cmd:plan-execute`, nachdem `/cmd:plan-review` ihn gehärtet hat; beide ruft der Nutzer auf, nicht du.

Der Grund für diese Trennung ist die Art der Befunde: Du schlägst vor, **Text zu entfernen**, und eine Entfernung, die niemand geprüft hat, ist der teuerste Fehler dieses Formats. Ein Plan macht jeden Vorschlag einzeln sichtbar und über seine Kennung einzeln rücknehmbar.

`.claude/settings.json` liest du **nur**. Sie trägt Hooks, die Text in jeden Turn einspeisen — der gehört zum Prompttext dieses Projekts und damit zum Gegenstand. Geändert wird sie von `/cmd:project-settings`, und Hooks legt ohnehin niemand aus dieser Suite an.

## Die Quelle

`references/befundklassen.md` — elf Klassen, jede mit dem englischen Originalbeleg und seiner Quelle. **Lies sie, bevor du den ersten Befund notierst**, und setze keine Klasse aus dem Gedächtnis. Die Datei liegt im Plugin-Verzeichnis außerhalb des Arbeitsverzeichnisses; das Lesen braucht dort eine Freigabe, die headless fehlt und interaktiv erfragt wird. Wird sie verweigert, halte an und nenne den Pfad, statt aus dem Gedächtnis zu prüfen: Ein Audit ohne Belege wäre erfunden.

## Schritt 1 — Gegenstand erheben

Sammle den projekteigenen Prompttext, je Fund mit Pfad und Zeilenzahl:

- die maßgebliche `CLAUDE.md` oder `AGENTS.md`, dazu verschachtelte `CLAUDE.md` in Unterordnern
- `.claude/skills/*/SKILL.md` samt ihren `references/`
- `.claude/agents/*.md` — auch die `description`, sie lädt in jeder Sitzung mit
- `.claude/rules/*.md`
- `.claude/settings.json`, **nur lesend**: Hooks, deren Ausgabe beim Modell landet, insbesondere `UserPromptSubmit` und `SessionStart`

**Nicht zum Gegenstand gehört**, was das Projekt als Produkt ausliefert. Ein Plugin-, Skill- oder Agent-Repo trägt Prompttext in einem Produktordner; der steuert fremde Sessions und ist hier nichts als eine Datei. Maßgeblich ist allein, was die Arbeit **in diesem** Repo steuert, und das liegt unter `.claude/` und in der Regeldatei. Der gleiche Ordnername ist Namensgleichheit, keine Überschneidung.

Halte die Erhebung eng: Du brauchst die Dateien im Volltext, aber keine Repo-Tour und keine Code-Analyse.

## Schritt 2 — Befunde sammeln

Geh den Bestand gegen die Klassen aus `references/befundklassen.md` durch. Je Befund hältst du fest: **Datei und Zeile, den Wortlaut, die Klasse, den Beleg, und was an die Stelle treten soll** — entfernen, oder ersetzen durch die Fassung, die der Beleg nennt.

Drei Regeln, ohne die dieser Schritt Schaden anrichtet:

- **Ersatz vor Streichung.** Eine Narrations-Unterdrückung wird durch eine Kadenz ersetzt, ein Formatierungsverbot durch eine inhaltsgebundene Regel. Ersatzlos gestrichen wird nur, was der Beleg ersatzlos zum Entfernen empfiehlt.
- **Kein Befund ohne Beleg.** Findest du etwas, das keiner Klasse zuzuordnen ist, nenne es als Beobachtung in der Schlussnotiz, nicht als Befund im Plan.
- **Prüfungen mit einem Kriterium von außen bleiben.** Testlauf, Exit-Code, Build, Bilanz, Register, erwarteter Dateizustand — das sind Messungen, keine Selbstkritik. Wer sie mitstreicht, nimmt dem Projekt seinen Korrektheitsmechanismus und hat nichts gewonnen.

Melde alles, was die Klassen hergeben, ohne Vorfilter auf die schweren Fälle: Gefiltert wird in Schritt 3, und ein Vorfilter hier nimmt dir Befunde weg, die dort standgehalten hätten.

## Schritt 3 — Jeden Befund gegen sich selbst prüfen

Vor dem Plan prüfst du jeden Befund einzeln mit dem stärksten Gegenargument:

- Trägt die Regel im Projekt etwas, das der Beleg nicht im Blick hat — einen bekannten Fehlerfall, eine Abnahmebedingung, eine Ausnahme?
- Ist sie schon die ersetzte Fassung, also selbst das Ergebnis eines früheren Audits?
- Ändert die Entfernung das Verhalten wirklich, oder nur den Text?
- Steht sie in einer Datei, die das Projekt als Produkt ausliefert statt sie selbst zu befolgen?

Übersteht ein Befund das nicht, verwirf ihn und sammle ihn mit einem Satz Begründung für die Schlussnotiz. Verwirf nicht, um früher fertig zu werden.

## Schritt 4 — Plan erzeugen, oder ehrlich leer bleiben

Fasse die belastbaren Befunde in einen Plan, ohne dir die Liste vorher bestätigen zu lassen — die inhaltliche Kontrolle liegt am Plan, nicht davor, und über die Kennung nimmt der Nutzer jeden Befund einzeln zurück. Je Befund: stabile Kennung, Datei und Zeile, Wortlaut, Klasse mit Beleg, vorgeschlagene Fassung, Schwere.

Ist der Plan-Modus nicht aktiv, ruf `EnterPlanMode` auf und warte die Zustimmung ab; ist er aktiv, entfällt der Schritt. Der Umweg ist kein Formalismus: `plan-review` arbeitet auf dem zuletzt erstellten Plan und `plan-execute` auf dem über `ExitPlanMode` freigegebenen — eine frei abgelegte Datei wäre für beide nicht dasselbe Artefakt. `ExitPlanMode` rufst du nicht auf; die Freigabe ist der Schritt, mit dem `plan-execute` beginnt.

**Übersteht kein Befund die Prüfung aus Schritt 3, erzeugst du keinen Plan.** Sag, was du geprüft hast und dass nichts blieb. Ein Plan mit erfundenen Befunden ist schlechter als keiner.

## Schritt 5 — Schlussnotiz

Als Chat-Notiz ausgeben, nicht in eine Datei schreiben: der geprüfte Bestand mit Dateizahl und Zeilen, die Befunde mit Kennung und Klasse, die verworfenen mit Begründung, die Beobachtungen ohne Klasse, und der Verweis auf `/cmd:plan-review` und danach `/cmd:plan-execute`. Ein vollständiges Beispiel steht in `references/beispiel.md`; lies es, bevor du deine schreibst.

## Randfälle

- **Weder Regeldatei noch `.claude/`.** Dann gibt es keinen projekteigenen Prompttext, und es gibt nichts zu prüfen. Sag das, erzeuge keinen Plan und verweise auf `/cmd:project-setup`, wenn das Projekt eingerichtet werden soll.
- **Bestand vorhanden, aber kein Befund übersteht die Prüfung.** Das ist ein gültiges Ergebnis und kein Versäumnis: Sag, was geprüft wurde, und bleib leer.
- **Die Regeldatei ist ein Symlink oder eine Import-Hülle auf `AGENTS.md`.** Dann ist `AGENTS.md` der Gegenstand; prüfe zusätzlich, ob Claude-spezifische Anweisungen darin stehen, die für andere Werkzeuge ins Leere zeigen.
- **Ein Befund liegt in einer Datei außerhalb des Projekts**, etwa der nutzerweiten `~/.claude/CLAUDE.md`. Die fasst du nicht an und nimmst sie nicht in den Plan; nenne sie in der Schlussnotiz als Beobachtung mit dem Handgriff, den der Nutzer selbst ausführt.

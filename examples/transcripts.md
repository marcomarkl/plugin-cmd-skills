# Beispiel-Transkripte — erwartete Ausgabeform der Skills

Dokumentiert die erwartete Form der Flows, die `scripts/smoke.sh` nicht erreicht: Bei den mehrschrittigen Skills sieht ein `claude -p`-Einzelaufruf nur den Eröffnungszug, bei `session-handoff` nur den Zweig ohne Gesprächsverlauf. Kein Test, sondern Referenz: So soll die Ausgabe strukturiert sein.

## plan-grill

**Eröffnungszug** (was ein Einzelaufruf zeigt): Gegenstand in einem Satz wohlwollend wiedergegeben (Steelman) plus **genau eine** offene Frage — bei abzählbaren Optionen via `AskUserQuestion`, sonst als Prosa. Keine Datei wird geschrieben.

**Schlussnotiz** (nach erschöpften Entscheidungen), als Chat-Notiz —

```
Gegenstand: <ein Satz>
Ledger:
  E1  <Entscheidung>  → <gewählte Antwort>  (<Kurzbegründung>)  [bestätigt|vorläufig]
  E2  …
Nicht gefragt (Default): <Entscheidung> → <Default> (<Grund>)
Offen: <noch im Plan zu klären>
```
Danach die Bitte um Bestätigung des gemeinsamen Verständnisses — und hier endet der Zug. Rücknahme per Kennung: „nimm Entscheidung 2 zurück".

**Nach der Bestätigung** — der zweite und letzte Schreibzug: Ist der Plan-Modus nicht aktiv, wird zuerst `EnterPlanMode` angeboten; ist er aktiv, entfällt das. Dann entsteht die Plandatei mit **Context** (Ziel und Anlass), den zu Umsetzungsschritten ausgeformten Vorgaben, dem **Entscheidungs-Ledger** als eigenem Abschnitt und den **Belegen aus dem Faktenvorlauf** samt Quelle, dazu die offenen Punkte. Abschließend der Verweis auf `plan-review`. Umgesetzt wird nichts — auch nicht auf Bitte.

## plan-review

**Eröffnungszug:** Einordnung (Aufgabenart in einem Satz, Ziel als Steelman, Kandidaten-Pool an Blickwinkeln) und der erste Blickwinkel. Ohne vorhandenen Plan: Hinweis, dass es einen zu reviewenden Plan braucht.

**Schlussnotiz** (nach erschöpften Blickwinkeln), als Chat-Notiz, nicht in den Plan:

```
Blickwinkel (Reihenfolge): 1. … 2. … 3. …
Ledger:
  2.3  <Kurzbefund>  [Schwere]  → <betroffener Planschritt>
  …
Verworfen: <Befund> — <Ein-Satz-Begründung>
Status: Blickwinkel erschöpft, N Runden
```
Der Plan selbst wurde in den Runden direkt geändert. Rücknahme per Kennung: „nimm Änderung 2.3 zurück".

## plan-execute

**Eröffnungszug:** ruft `ExitPlanMode` auf, um den freigegebenen Plan umzusetzen; ohne freigegebenen Plan die Bitte, erst einen bereitzustellen.

**Abschlussbericht** (Chat-Notiz, nach Umsetzung): je Planschritt was umgesetzt und **womit verifiziert** (beobachtetes Kriterium + Ergebnis); aufgetretene Abweichungen samt Korrektur; Klassifikator-Blockaden und Reaktion; substanzielle Funde außerhalb des Plans und Nutzer-Entscheid; offene Blocker; abschließend der Commit-Status plus Angebot und nächster Schritt.

## project-rules

**Eröffnungszug:** Auflösung der Zieldatei — welche `CLAUDE.md`/`AGENTS.md` gehärtet wird, und bei mehreren Kandidaten oder fehlendem Pfad die Rückfrage statt einer Annahme. Direkt danach das erkannte **Projektprofil** als Vorschlag zur Bestätigung, weil es die Relevanzschwelle jeder Regel setzt. Existieren `CLAUDE.md` und `AGENTS.md` als getrennte echte Dateien mit überlappendem Inhalt, wird das Drift-Risiko benannt und eine Symlink-Konsolidierung angeboten.

**Eine Rückfragerunde in der Mitte:** alle Konflikte aus dem Abdeckungs-Register gebündelt — je vorhandene Regel wörtlich, Katalogregel wörtlich, Empfehlung. Bewusst **eine** Runde, nicht eine je Katalog. Ohne Aufsicht gilt der Fallback „strengere oder spezifischere Fassung", vermerkt im Protokoll.

**Was der Skill nicht tut:** verschieben, umbenennen, Ordner anlegen. Auslagerungsreife Blöcke erscheinen im Protokoll als markiert mit vorgesehenem Ziel, herausgelöst wird nichts — dafür folgt die Empfehlung, `/cmd:project-structure` zu fahren.

**Änderungsprotokoll** (Chat-Notiz, nach dem Token-Effizienz-Pass):

```
## Gehärtet: <Pfad zur maßgeblichen Datei>
Projektprofil: <Profil> (bestätigt: ja/nein)
Sprache: <de/en> · AGENTS.md/CLAUDE.md-Drift: <eine Quelle / Symlink vorgeschlagen / n/a>

### Ergänzt / Geschärft / Bereits vorhanden / Bewusst weggelassen / Konflikte / Verdichtet
- <Werkzeug> → <Abschnitt>: <Regel in Kurzform, im Projekt verankert>

### Ablage und Artefakte
- Vorgefunden / Verankert / Auslagerungsreif markiert / Empfohlen anzulegen

### Abdeckung
<X von Y Katalogregeln verbucht> — alle sieben Inhalts-Kataloge durchgegangen, Token-Effizienz-Pass angewendet.
```
Die letzte Zeile ist der Vollständigkeitsbeleg: Jede Katalogregel muss in genau einer Kategorie gelandet sein.

## project-structure

**Eröffnungszug:** die Inventur, nicht das Anlegen — welche Orte für Aufgaben, Entscheidungen, Wissen, Erledigtes und Agenten-Artefakte das Projekt schon hat, je mit Pfad und git-Status. Ein vorhandener Issue-Tracker oder ein generiertes `docs/` wird hier erkannt und schließt das jeweilige Anlegen aus.

**Die Rückfragen kommen gebündelt in Schritt 5**, in *einer* Vorschau: anzulegende Ordner, vorgeschlagene Umbenennungen samt gebrochener Verweise, das vollständige Verlagerungs-Register, die Artefakt-Vorschläge. Eine Umbenennung wird nie vorausgesetzt; bei Ablehnung gilt der vorhandene Name als kanonisch für dieses Projekt.

**Abschlussbericht** (Chat-Notiz), mit der Bilanz als Vollständigkeitsbeleg:

```
## Struktur: <Projektpfad>
Kanon-Abgleich: <X übernommen / Y umbenannt / Z angelegt / N weggelassen>

### Vorgefunden / Umbenannt / Angelegt / Verschoben / Aufgeteilt / Geblieben
- <Quelle> → <Ziel> (<Zeilen>) · Rückweg: <git restore … / .bak … / rmdir …>

### Entfallene Strukturzeilen
- <Quelle:Zeile> „<Text>" — ersetzt durch <Zielzeile>

### Artefakte vorgeschlagen
- <Skill|Subagent|Regel> <Pfad> — Anlass: <konkret> · <angelegt / abgelehnt>

### Bilanz
<Ausgangszeilen> = <in Zielen> + <verblieben> + <entfallene Strukturzeilen> — jede Quelle verbucht.
Zweiter Lauf ohne zwischenzeitliche Änderung: diff-frei.
```
Geht die Bilanz nicht auf, meldet der Skill den Lauf als fehlerhaft, statt die Differenz zu glätten. Ein zweiter Lauf ohne zwischenzeitliche Änderung erzeugt keinen Diff.

**Zwei Rückwege, nicht einer:** Eine 1:1-Verschiebung läuft über `git mv` und wird mit `git restore <datei>` zurückgenommen. Eine Aufteilung auf mehrere Ziele kennt kein `git mv` — dort gibt es kein eindeutiges Ziel für die Historie —, die Quelle wird per `git rm` entfernt und der Rückweg heißt `git restore --staged --worktree <quelle>`.

**Artefakte unter `.claude/` brauchen eine eigene Bestätigung**, die eine vorab erteilte Freigabe nicht ersetzt. Wird sie verweigert, bleibt der Inhalt an seinem alten Platz und der Vorschlag steht unter „Offen" — der Skill entfernt keine Quelle, deren Ziel er nicht schreiben konnte.

## project-settings

**Eröffnungszug:** Bestandsaufnahme statt Schreiben — welche der Zieldateien existieren, welche von git getrackt werden, was im Auto-Memory dieses Projekts liegt. Danach die gesammelte Vorschau aller Änderungen zur Freigabe. Nicht parsebares JSON in einer Zieldatei bricht hier ab, ohne etwas zu überschreiben.

**In der Vorschau steht auch das Anlegen von `plans/`**, sofern der Ordner fehlt — mit `rmdir plans` als Rückweg. Existiert er schon, taucht er dort gar nicht auf; liegt unter `plans` eine Datei statt eines Verzeichnisses, steht dort stattdessen der Konflikt, und der Ordner wird nicht angelegt.

**In Projekten, die vor 0.10.0 eingerichtet wurden, steht in der Vorschau zusätzlich die Räumung** des Kommunikationsprotokolls — der `SessionStart`-Hook mit der Marke `# cmd:project-settings:session-protocol` und `.claude/skills/session-protocol/SKILL.md`, erst der Hook, dann die Datei. Dabei der Hinweis, dass der Skill nicht prüfen kann, ob die Datei noch dem ausgelieferten Stand entspricht. Findet er keine Spur, kommt der Punkt in Vorschau und Bericht nicht vor.

**Zwischenschritte, die eine Rückfrage erzeugen:** übernehmbare Kandidaten aus `.claude/settings.local.json`; jede Wildcard-Zusammenfassung, die mehr freigäbe als die Summe der Einzeleinträge (mit benanntem Zugewinn); jeder Auto-Memory-Eintrag mit Zielvorschlag.

**Abschlussbericht** (Chat-Notiz): angelegt, geändert, übersprungen, abgelehnt — je mit Rückweg (`git restore <datei>` bei getrackten, `.bak`-Pfad bei untrackten). Dazu drei Punkte, die sonst als Fehlschlag gelesen werden:

```
Entfernt:        SessionStart-Hook + .claude/skills/session-protocol/ (nur wenn vorhanden)
Befund:          crossSessionInbound / isolatePeerMachines in ~/.claude/settings.json — nicht angefasst
Wirkt erst nach dem Workspace-Trust-Dialog: permissions.allow (deny/ask sofort)
Nicht abgedeckt: deny schützt das Read-Tool, nicht die Shell (cat & Co.)
Bewusst offen:   git restore / git checkout -- laufen ungefragt
```
Ein zweiter Lauf ohne zwischenzeitliche Änderung meldet, dass nichts zu tun war, und erzeugt keinen Diff.

## session-learn

**Eröffnungszug:** beginnt die Reflexion der Session — Einordnung, was zu betrachten ist. Bei leerer/kurzer Session der Hinweis, dass (noch) nichts Dauerhaftes zu lernen ist.

**Schlussnotiz** (nach erschöpften Learnings), als Chat-Notiz, plus der erzeugte Plan:

```
Learnings:
  L1  <Learning>  → Ziel: Projekt-CLAUDE.md            Beleg: <woran es sich zeigte>  Nutzen: <künftig>
  L2  <Learning>  → Ziel: cmd/skills/<x>/references/…  …
  L3  <Learning>  → Ziel: Repo-Edit                    …
Verworfen: <Kandidat> — <Grund>
```
Dann das Angebot, den Plan über `plan-review` zu härten und `plan-execute` anzuwenden. Übersteht kein Kandidat den Filter: Hinweis „keine dauerhaften Learnings", kein Plan.

**Keine Rückfrage vor dem Plan.** Schlussnotiz und geschriebener Plan kommen im selben Zug — die Learnings werden nicht vorab zur Bestätigung vorgelegt. Die einzige Zustimmung ist der Wechsel in den Plan-Modus, und die entfällt, wenn er schon aktiv ist oder wenn kein Learning den Filter übersteht. Zurückgenommen wird am Plan: „nimm L2 zurück".

## session-handoff

Der einzige Skill, dessen **voller Flow in einem Zug endet** — Eröffnungszug und Ergebnis fallen zusammen.

**Ohne Gesprächsverlauf** (was ein `claude -p`-Einzelaufruf zeigt): keine Datei, sondern die Feststellung, dass es keinen übergebbaren Stand gibt, samt dem, was aus dem Dateisystem *doch* belegbar war. Genau diesen Zweig prüft `scripts/smoke.sh`.

**Mit Verlauf:** eine geschriebene oder gepatchte `HANDOFF.md` (Obergrenze 60 Zeilen) plus die Schlussnotiz im Chat. Erwartete Form der Datei —

```
# Session-Handoff — <Thema>

## Ziel
<ein bis drei Zeilen>

## Harte Randbedingungen
<nur echte Constraints>

## Fertig
<Stichpunkte mit Commit-Hashes, keine Details>

## Offen — nächster Schritt zuerst
1. <konkret, ausführbar>

## Unsicher
- <Vermutung> — Quelle: <woher> — prüfbar an: <woran>

## Wichtige Dateien und Befehle
<Pfade, Testbefehle; Verweis auf Plandatei statt Nacherzählung>
```

Die Überschriften sind **Richtschnur, kein Schema**: Ein Abschnitt, der für das Projekt nichts trägt, bleibt weg; einmal gewählte Überschriften bleiben über Läufe hinweg stehen. Ohne Git-Repo tritt der Datei- und Ausgabezustand an die Stelle des Commit-Stands, und die Datei vermerkt das ausdrücklich.

**„Unsicher" ist der Abschnitt, der diesen Skill von einer Zusammenfassung unterscheidet.** Dorthin gehört, was der gekürzte Verlauf verschluckt hat — Entscheidungen ohne erkennbare Begründung, vage erinnerte Absprachen, aus dem Diff rekonstruierter Zweck. Er darf leer bleiben, aber nur wenn das stimmt: Sein Fehlen behauptet, dass nichts unsicher war, und das ist nach einem gekürzten Verlauf selten wahr.

**Schlussnotiz** (Chat-Notiz, nicht in die Datei): der Pfad der Datei und der nächste Schritt in einem Satz. Mehr ist nicht verlangt — die Übergabe trägt die Datei, das nächste Fenster startet mit „lies `<pfad>` und arbeite dort weiter". Dazu der Rückweg (löschen / `git restore` / `.bak`), aber nur, wenn die Datei neu angelegt oder ganz überschrieben wurde. Ein fertiger Einstiegssatz zum Kopieren wird **nicht** verlangt: Er dupliziert die Datei, die ohnehin für sich stehen muss.

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

**Nach der Bestätigung** — der zweite und letzte Schreibzug: Ist der Plan-Modus nicht aktiv, wird zuerst `EnterPlanMode` angeboten; ist er aktiv, entfällt das. Dann entsteht die Plandatei mit **Context** (Ziel und Anlass), den zu Umsetzungsschritten ausgeformten Vorgaben, dem **Entscheidungs-Ledger** als eigenem Abschnitt und den **Belegen aus dem Faktenvorlauf** samt Quelle, dazu die offenen Punkte. Abschließend der Verweis auf `plan-review`; `ExitPlanMode` wird nicht aufgerufen, die Freigabe kommt erst vor `plan-execute`. Umgesetzt wird nichts — auch nicht auf Bitte.

## plan-review

**Eröffnungszug:** Einordnung (Aufgabenart in einem Satz, Ziel als Steelman, Kandidaten-Pool an Blickwinkeln) und der erste Blickwinkel. Ohne vorhandenen Plan: Hinweis, dass es einen zu reviewenden Plan braucht. Stammt der Plan aus `/plan` oder wurde er direkt geschrieben, endet der Plan-Modus davor mit seiner Freigabefrage; die wird abgelehnt, dann `plan-review` aufgerufen.

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

## project-setup

**Eröffnungszug:** die vier Feststellungen, kurz und benannt — Wurzel leer oder gewachsen, git-Lage samt erkanntem Repo-Root, maßgebliche Regeldatei (`CLAUDE.md`, `AGENTS.md`, beide, keine, Symlink oder Import-Hülle), vorhandenes `.claude/`. Kein Kanon-Vergleich, keine Ablage-Inventur, kein Projektprofil.

**Dann die Liste**, alle drei Schritte immer enthalten, je Eintrag vier Angaben:

```
0. git init                       (nur ohne Repo)
   Vorbedingung: keine · Fasst an: das Verzeichnis selbst
   Abnahme (am Projekt): .git/ existiert
   Grund: ohne Repo kein `git mv` (Historie) und kein `git restore` als Rückweg

1. /cmd:project-settings          (kein Argument möglich)
   Vorbedingung: keine — läuft auch ohne Repo und im leeren Ordner
   Fasst an: .claude/settings.json (legt an oder ergänzt, aus Feststellung 4);
          bei Altlast zusätzlich .gitignore und .claude/skills/
   Abnahme (am Projekt): autoMemoryEnabled: false
          — Stichprobe, kein Vollnachweis des Permission-Kanons

2. /cmd:project-structure         (optional: Fokus oder Pfad)
   Vorbedingung: keine gegenüber Schritt 1 — die beiden sind unabhängig
   Fasst an: ...
   Abnahme (am Projekt): Abschnitt `## Ablage` in der maßgeblichen CLAUDE.md
          — im leeren Ordner legt project-structure die Datei selbst an, nur `## Ablage`
   Abnahme (im Bericht): die Zeilenbilanz geht auf

3. /cmd:project-rules             (optional: Pfad zur Zieldatei, hier gefüllt)
   Vorbedingung: Schritt 2 gelaufen (Wegweiser existiert und wird mitgehärtet);
          Zieldatei und Projektprofil bestätigt
   Fasst an: genau diese eine Datei
   Abnahme: kein Kriterium am Projekt — der Skill hinterlässt keine Marke;
          das schwächste hinreichende ist sein Abdeckungs-Register im Bericht
```

Die Vorbedingungen sind **Reihenfolge-Hinweise, keine Sperren** — jeder der drei läuft auch für sich. Die Reihenfolge trägt einen Halbsatz je *belegter* Abhängigkeit; für die Naht Schritt 1 → Schritt 2 gibt es keine, und der Skill sagt das, statt sie zu erfinden.

Jedes Kriterium ist gekennzeichnet, ob es **am Projekt** ablesbar ist oder nur **im Bericht** des Laufs steht. Randfälle erscheinen als Zusatz am betroffenen Schritt: fehlendes Repo, Aufruf aus einem Unterordner (mit offengelegtem Repo-Root und beiden Deutungen), `CLAUDE.md` und `AGENTS.md` als getrennte echte Dateien, leerer Ordner ohne erhebbares Projektprofil, und an Schritt 1 der Vorbehalt, dass der Zeitanker-Hook bei **neu angelegter** `settings.json` erst nach `/hooks` oder in einer neuen Session greift.

**Was der Skill nicht tut:** ausführen, schreiben, anlegen, und feststellen, was schon gelaufen ist. Er kann die drei nicht aufrufen (ihre Sperre `disable-model-invocation`) und macht ihre Arbeit auch nicht selbst nach. Ein Schritt wird nie weggelassen, weil er erledigt aussieht — was die Erhebung ergibt, wird zum Hinweis am Schritt.

## project-rules

**Eröffnungszug:** Auflösung der Zieldatei — welche `CLAUDE.md`/`AGENTS.md` gehärtet wird, und bei mehreren Kandidaten oder fehlendem Pfad die Rückfrage statt einer Annahme. Direkt danach das erkannte **Projektprofil** als Vorschlag zur Bestätigung, weil es die Relevanzschwelle jeder Regel setzt. Existieren `CLAUDE.md` und `AGENTS.md` als getrennte echte Dateien mit überlappendem Inhalt, wird das Drift-Risiko benannt und eine Symlink-Konsolidierung angeboten.

**Eine Rückfragerunde in der Mitte:** alle Konflikte aus dem Abdeckungs-Register gebündelt — je vorhandene Regel wörtlich, Katalogregel wörtlich, Empfehlung. Bewusst **eine** Runde, nicht eine je Katalog. Ohne Aufsicht gilt der Fallback „strengere oder spezifischere Fassung", vermerkt im Protokoll.

**Was der Skill nicht tut:** verschieben, umbenennen, Ordner anlegen. Auslagerungsreife Blöcke erscheinen im Protokoll als markiert mit vorgesehenem Ziel, herausgelöst wird nichts — dafür folgt die Empfehlung, `/cmd:project-structure` zu fahren.

**Änderungsprotokoll** (Chat-Notiz, nach dem Token-Effizienz-Pass):

```
## Gehärtet: <Pfad zur maßgeblichen Datei>
Projektprofil: <Profil> (bestätigt: ja/nein)
Prosasprache: <de/en> · AGENTS.md/CLAUDE.md-Drift: <eine Quelle / Symlink vorgeschlagen / n/a>

### Ergänzt / Geschärft / Bereits vorhanden / Bewusst weggelassen / Konflikte / Verdichtet
- <Werkzeug> → <Abschnitt>: <Regel in Kurzform, im Projekt verankert>

### Ablage und Artefakte
- Vorgefunden / Verankert / Auslagerungsreif markiert / Empfohlen anzulegen

### Abdeckung
Alle zehn Inhalts-Kataloge durchgegangen, jede Regel in genau einer Kategorie verbucht, Token-Effizienz-Pass angewendet.
```
Die letzte Zeile ist der Vollständigkeitsbeleg und trägt **keine Quote**: Was als eine Regel zählt, ist nicht festgelegt, also wäre eine Zahl nicht reproduzierbar und ein Fehlschätzer unauffällig. Sie behauptet nur, was tatsächlich getan wurde; den Nachweis trägt das Abdeckungs-Register.

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
- <Skill|Subagent|Regel> <Pfad> — Anlass: <konkret | aus Anhaltspunkten, bestätigt> · <angelegt / abgelehnt>

### Bilanz
<Ausgangszeilen> = <in Zielen> + <verblieben> + <entfallene Strukturzeilen> — jede Quelle verbucht.
Zweiter Lauf ohne zwischenzeitliche Änderung: diff-frei.
```
Geht die Bilanz nicht auf, meldet der Skill den Lauf als fehlerhaft, statt die Differenz zu glätten. Ein zweiter Lauf ohne zwischenzeitliche Änderung erzeugt keinen Diff. Fehlt jede Regeldatei, steht unter „Angelegt" auch die `CLAUDE.md` selbst, mit nichts als dem Wegweiser und dem Rückweg `rm`.

**Zwei Rückwege, nicht einer:** Eine 1:1-Verschiebung läuft über `git mv` und wird mit `git restore <datei>` zurückgenommen. Eine Aufteilung auf mehrere Ziele kennt kein `git mv` — dort gibt es kein eindeutiges Ziel für die Historie —, die Quelle wird per `git rm` entfernt und der Rückweg heißt `git restore --staged --worktree <quelle>`.

**Artefakte unter `.claude/` brauchen eine eigene Bestätigung**, die eine vorab erteilte Freigabe nicht ersetzt. Wird sie verweigert, bleibt der Inhalt an seinem alten Platz und der Vorschlag steht unter „Offen" — der Skill entfernt keine Quelle, deren Ziel er nicht schreiben konnte.

## project-settings

**Eröffnungszug:** Bestandsaufnahme statt Schreiben — welche der Zieldateien existieren, welche von git getrackt werden, was im Auto-Memory dieses Projekts liegt. Danach die gesammelte Vorschau aller Änderungen zur Freigabe. Nicht parsebares JSON in einer Zieldatei bricht hier ab, ohne etwas zu überschreiben.

**Der Zeitanker-Hook steht in der Vorschau eigens ausgewiesen**, nicht als weiterer Wert in der Aufzählung: Eine Permission-Regel erlaubt etwas, dieser Hook führt bei jeder Nachricht `date` aus. Dazu der Halbsatz, dass er nichts liest, nichts schreibt und nicht ins Netz geht.

**In Projekten, die früher eingerichtet wurden, steht in der Vorschau zusätzlich die Räumung.** Vor 0.10.0 das Kommunikationsprotokoll — der `SessionStart`-Hook mit der Marke `# cmd:project-settings:session-protocol` und `.claude/skills/session-protocol/SKILL.md`, erst der Hook, dann die Datei, dabei der Hinweis, dass der Skill nicht prüfen kann, ob die Datei noch dem ausgelieferten Stand entspricht. Bis 0.17.0 das projektlokale Planverzeichnis — der Key `plansDirectory` bei exakt `"./plans"`, danach die `.gitignore`-Zeile, aber nur mit gefundenem Key und nur bei leerem `plans/`; der Ordner selbst bleibt unangetastet, mit dem Hinweis, wo neue Pläne künftig entstehen. Findet er keine Spur, kommt der Punkt in Vorschau und Bericht nicht vor.

**Zwischenschritte, die eine Rückfrage erzeugen:** übernehmbare Kandidaten aus `.claude/settings.local.json`; jede Wildcard-Zusammenfassung, die mehr freigäbe als die Summe der Einzeleinträge (mit benanntem Zugewinn); jeder Auto-Memory-Eintrag mit Zielvorschlag.

**Abschlussbericht** (Chat-Notiz): angelegt, geändert, übersprungen, abgelehnt — je mit Rückweg (`git restore <datei>` bei getrackten, `.bak`-Pfad bei untrackten). Dazu fünf Punkte, die sonst als Fehlschlag gelesen werden:

```
Entfernt:        SessionStart-Hook + .claude/skills/session-protocol/ (nur wenn vorhanden)
Befund:          crossSessionInbound / isolatePeerMachines in ~/.claude/settings.json — nicht angefasst
Wirkt erst nach dem Workspace-Trust-Dialog: permissions.allow (deny/ask sofort)
Nicht abgedeckt: deny schützt das Read-Tool, nicht die Shell (cat & Co.)
Bewusst offen:   git restore / git checkout -- laufen ungefragt
Zeitanker:       bei neu angelegter settings.json erst nach /hooks oder in neuer Session;
                 unter disableAllHooks bleibt der Wert stumm
Kanonwert:       aus der Datei entfernt holt ihn der nächste Lauf zurück
```
Ein zweiter Lauf ohne zwischenzeitliche Änderung meldet, dass nichts zu tun war, und erzeugt keinen Diff.

## session-learn

**Eröffnungszug:** beginnt die Auswertung des Verlaufs — Einordnung, was daran zu betrachten ist. Bei leerer/kurzer Session der Hinweis, dass (noch) nichts Dauerhaftes zu lernen ist.

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

**Ohne Gesprächsverlauf** (was ein `claude -p`-Einzelaufruf zeigt): keine Datei, sondern die Feststellung, dass es keinen übergebbaren Stand gibt, samt dem, was aus dem Dateisystem *doch* belegbar war. Das gilt **auch bei vollem `git status`**: Der Verlauf ist die Bedingung, der Projektzustand nur das Belegmittel. Genau diesen Zweig prüft `scripts/smoke.sh`.

**Mit Verlauf:** eine geschriebene oder gepatchte `HANDOFF.md` (Obergrenze 60 Zeilen) plus die Schlussnotiz im Chat. Erwartete Form der Datei —

```
# Session-Handoff — <Thema>

Stand: <Datum, Uhrzeit, Zeitzone>

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

## Verworfen, mit Grund
- <erwogener oder versuchter Weg> — beiseitegelegt, weil <Grund>

## Wichtige Dateien und Befehle
<Pfade, Testbefehle; Verweis auf Plandatei statt Nacherzählung>
```

Die Überschriften sind **Richtschnur, kein Schema**: Ein Abschnitt, der für das Projekt nichts trägt, bleibt weg; einmal gewählte Überschriften bleiben über Läufe hinweg stehen. Ohne Git-Repo tritt der Datei- und Ausgabezustand an die Stelle des Commit-Stands, und die Datei vermerkt das ausdrücklich.

**„Unsicher" ist der Abschnitt, der diesen Skill von einer Zusammenfassung unterscheidet.** Dorthin gehört, was der gekürzte Verlauf verschluckt hat — Entscheidungen ohne erkennbare Begründung, vage erinnerte Absprachen, aus dem Diff rekonstruierter Zweck. Er darf leer bleiben, aber nur wenn das stimmt: Sein Fehlen behauptet, dass nichts unsicher war, und das ist nach einem gekürzten Verlauf selten wahr.

**„Verworfen" hält den Grund, nicht nur den Verzicht.** Ohne ihn probiert das nächste Fenster dieselbe Sackgasse erneut. Dazu die Gewichtung der beiden Stimmen: Was der Nutzer verlangt, entschieden oder ausgeschlossen hat, steht nah an seinem Wortlaut, während die eigenen Erklärungen auf ihr Ergebnis eingedampft werden.

**Schlussnotiz** (Chat-Notiz, nicht in die Datei): der Pfad der Datei und der nächste Schritt in einem Satz. Dazu der Weg, damit die Übergabe nicht bei einer Datei endet, die niemand aufnimmt: neues Fenster, dort `/cmd:session-resume`, plus ein Halbsatz zu Gegenprobe und Aufräumen. Mehr ist nicht verlangt — den Inhalt trägt die Datei. Dazu der Rückweg (löschen / `git restore` / `.bak`), aber nur, wenn die Datei neu angelegt oder ganz überschrieben wurde. Ein fertiger Einstiegssatz zum Kopieren wird **nicht** verlangt: Er dupliziert die Datei, die ohnehin für sich stehen muss.

## session-resume

**Eröffnungszug:** der Fundort der Übergabedatei, benannt statt vorausgesetzt — Projektroot, der Ort, auf den der `## Ablage`-Wegweiser für Wissen zeigt, oder ein Doku-Verzeichnis. Ohne Fund die Feststellung, dass keine da ist, und Ende; bei mehreren Kandidaten alle mit Pfad, ohne Wahl. Eine `.bak` ist kein Kandidat, und eine bloße Plandatei auch nicht: Die Datei muss sich als Übergabe ausweisen.

**Dann die Gegenprobe**, der Kern des Skills:

```
## Übergabe aufgenommen: <Pfad>

### Abgeglichen
- Alter: erhoben <Zeitpunkt aus der Datei>, jetzt <Systemzeit> → <Alter> / Zeile fehlt
- Versionsstand: <Datei sagt X> · <Projekt zeigt Y> → deckungsgleich / abweichend
- Genannte Dateien: <alle vorhanden / diese fehlen>

### Unsicher (aus der Datei, einzeln)
- <Punkt> → jetzt belegbar: <Beleg> / weiterhin offen

### Offen — nächster Schritt zuerst
1. <konkret, ausformuliert>
```

Fehlt in der Datei der Abschnitt „Unsicher", erscheint das als Befund, nicht als gute Nachricht: Sein Fehlen behauptet, es sei nichts unsicher gewesen. Findet die Gegenprobe keine Abweichung, wird auch das ausdrücklich gesagt.

**Zum Schluss die Aufräumfrage**, im selben Zug: ob die Übergabedatei entfernt werden soll, samt dem Rückweg für die konkrete git-Lage (`git restore` nur bei getrackt und unverändert; bei uncommitteten Änderungen holt es die ältere Fassung, nicht die gelöschte; untrackt bleibt ohne Rückweg). Gelöscht wird erst nach ausdrücklicher Bestätigung, mit einem einzelnen `rm` auf genau diesen Pfad.

**Was der Skill nicht tut:** die Punkte abarbeiten, ungefragt löschen, in den Plan-Modus wechseln. Verweist die Datei auf eine Plandatei, nennt er sie und liest sie, wechselt aber nicht. Und nach der Antwort auf die Löschfrage hört er auf, statt mit Schritt 1 zu beginnen — die Übergabe ist angenommen, nicht abgearbeitet.

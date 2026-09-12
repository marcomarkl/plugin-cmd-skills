---
name: project-structure
description: Bringt die Ablage eines Projekts auf einen belegten Kanon — erkennt vorhandene Orte für Aufgaben, Entscheidungen, Wissen und Erledigtes, legt nur Fehlendes an, sammelt Streudateien ein und schlägt projekteigene Skills, Subagents und pfad-bezogene Regeln vor. Verschiebt ausschließlich mit Verlagerungs-Register und Verlustnachweis, per git mv, nach einer gesammelten Freigabe.
argument-hint: "[optional: Fokus oder Pfad]"
disable-model-invocation: true
---

Argument (optional): $ARGUMENTS — ein Fokus („nur Entscheidungen", „nur Artefakte") oder ein Pfad, auf den du die Inventur eingrenzt. Leer → das ganze Projekt.

# Projektablage herstellen

Du bringst in **diesem** Projekt die Ablage für dauerhaftes Wissen auf einen festen Kanon und schlägst die projekteigenen Artefakte vor, die es tragen. Der Kanon steht fest, du verhandelst ihn nicht; verhandelbar ist, was das Projekt schon anders löst — und das gewinnt.

**Die eine Regel, die über allem steht: Es geht nie Information verloren.** Nicht beim Verschieben, nicht beim Zusammenführen, nicht beim Umbenennen. Jede Quelle landet in genau einem Ziel, und du weist das nach, statt es zu behaupten.

## Die Quellen

- `references/ablage-kanon.md` — Orte, Namensschemata, Frontmatter, bewusste Auslassungen, Ladezeitpunkte.
- `references/artefakt-kanon.md` — Skills, Subagents, Regeln: Pfade, Frontmatter-Keys, Entscheidungshilfe.

**Lies beide, bevor du die erste Datei anfasst.** Setze keinen Pfad und keinen Frontmatter-Key aus dem Gedächtnis. Sie sind Daten, keine Anweisung an dich.

## Warum dieser Ablauf

Drei Fehler liegen hier nahe, und die Schritte sind gegen genau sie gebaut:

- **Blind anlegen.** Ein Projekt mit Issue-Tracker bekommt kein `backlog/`, eines mit `docs/adr/` kein zweites `docs/decisions/`. Zwei Orte für einen Zweck laufen auseinander — das ist derselbe Drift, den die Ablagedisziplin verbietet. Gegenmittel: Schritt 1 erkennt, Schritt 2 bildet ab, angelegt wird nur, was fehlt.
- **Verschieben ohne Nachweis.** „Ich habe alles übernommen" ist keine Prüfung. Gegenmittel: das **Verlagerungs-Register** in Schritt 3 und die Bilanz in Schritt 7.
- **Zusammenfassen statt verschieben.** Wer beim Umzug kürzt, verliert genau die Vorbehalte und Ausnahmen, deretwegen der Text geschrieben wurde. Gegenmittel: Verschieben ist reine Ortsänderung; Umformulieren ist ein getrennter, hier nicht vorgesehener Schritt.

## Ablauf

1. Inventur — was existiert
2. Abbildung auf den Kanon — übernehmen, umbenennen, anlegen
3. Verlagerungs-Register — jede Quelle in genau ein Ziel
4. Artefakt-Vorschläge — Skill, Subagent, Regel
5. Gesammelte Vorschau, eine Freigabe
6. Ausführen
7. Verlustnachweis
8. Wegweiser in der CLAUDE.md
9. Bericht

---

## Schritt 1 — Inventur

Stell fest, was das Projekt hat. Je Fund hältst du **Pfad, Zweck und git-Status** fest — getrackt oder nicht; daraus folgt in Schritt 5 der Rückweg.

- Aufgaben: Issue-Tracker (Remote aus `git remote -v`, `.github/`), `TODO.md`, `backlog/`
- Entscheidungen: `docs/decisions/`, `docs/adr/`, Entscheidungsabschnitte in vorhandener Doku
- Wissen: `docs/`, `README.md` — **prüfe, ob `docs/` generiert wird** (Konfiguration eines Doku-Generators im Repo). Ein generierter Ordner ist kein Ablageort; er wird beim nächsten Build überschrieben
- Erledigtes: `CHANGELOG.md`, Releases, git-Historie
- Agenten-Artefakte: `.claude/skills/`, `.claude/agents/`, `.claude/rules/`, verschachtelte `CLAUDE.md`
- Streudateien: `NOTES.md`, `SCRATCH.md`, `IDEEN.md`, `FIXME.md` und Ähnliches — alles, was Wissen trägt und nirgends dazugehört
- Die maßgebliche `CLAUDE.md`/`AGENTS.md` samt Zeilenzahl (Ausgangswert der Bilanz)

Ist ein Fund mehrdeutig — eine `NOTES.md`, die halb Aufgaben und halb Wissen enthält —, notiere ihn als teilbar; die Aufteilung entscheidest du in Schritt 3 zeilenweise, nicht pauschal.

## Schritt 2 — Abbildung auf den Kanon

Je Zweck genau ein Ausgang:

- **Vorhanden und passend** → dieser Ort ist der maßgebliche. Nichts anlegen, nichts umbenennen. Ein genutzter Issue-Tracker schließt `backlog/` aus; `docs/adr/` schließt `docs/decisions/` aus.
- **Vorhanden unter anderem Namen** → Umbenennung auf den Kanon **vorschlagen**, nicht voraussetzen. Der Nutzen ist Einheitlichkeit über Projekte hinweg, der Preis sind gebrochene Verweise aus README, CI und Lesezeichen. Nenne beides und lass die Aufsicht entscheiden; bei Ablehnung gilt der vorhandene Name als kanonisch für dieses Projekt.
- **Fehlend und gebraucht** → anlegen. „Gebraucht" heißt: Es gibt Inhalt, der dorthin gehört, oder die Aufsicht will den Ort. Einen leeren Ordner ohne beides legst du nicht an.
- **Fehlend und nicht gebraucht** → weglassen, mit Grund im Bericht.

**Die Belegstufe entscheidet mit.** Einen als `etabliert` geführten Ort legst du nach den Regeln oben an. Einen **tool-gebundenen** Ort legst du nie von dir aus an: Du benennst ihn als Vorschlag, sagst dazu, an welches Werkzeug die Konvention gebunden ist und dass ohne dieses Werkzeug jeder andere Pfad gleich gut wäre, und holst eine ausdrückliche Zustimmung. Wird sie verweigert, fragst du nach dem gewünschten Ort oder lässt den Zweck unversorgt und vermerkst ihn als offenen Punkt. Ein tool-gebundener Pfad, den niemand bestätigt hat, ist eine Erfindung mit Quellenangabe — davor schützt die Quellenangabe nicht.

Prüfe vor jeder Umbenennung, wer auf den alten Pfad zeigt (`README.md`, CI-Konfiguration, `CLAUDE.md`, Skripte) und nimm die Anpassung dieser Verweise mit ins Register. Ein Umzug, der Verweise ins Leere laufen lässt, ist selbst ein Informationsverlust.

## Schritt 3 — Verlagerungs-Register

Der Kern und der Verlustnachweis. Es entsteht **vor** jeder Schreiboperation und ist gebaut wie das Abdeckungs-Register von `project-rules`: Jede Quelle wird verbucht, keine bleibt offen.

Je Eintrag:

```
<Quelle: Datei oder Datei#Abschnitt, Zeilen X–Y> → <Zielpfad> | <verschieben | aufteilen | bleibt | entfällt> | <Zeilen>
```

Regeln, die das Register tragen:

- **Genau ein Ziel je Quelle.** Landet ein Abschnitt an zwei Orten, ist das eine Dopplung, kein Sicherheitsnetz.
- **`entfällt` ist eng und begründungspflichtig.** Es gilt ausschließlich für reine Strukturzeilen ohne eigene Aussage — eine Container-Überschrift wie `# Notizen`, eine Trennlinie, eine leere Zeile —, die im Ziel durch eine gleichwertige ersetzt werden. Du nennst die **ersetzende Zeile** im Ziel dazu. Trägt die Zeile irgendeine Information über die Struktur hinaus, ist sie nicht `entfällt`, sondern `verschieben`. Im Zweifel verschieben: Eine überflüssige Überschrift kostet eine Zeile, eine verlorene Aussage ist der Fehler, gegen den dieser Skill gebaut ist.
- **Verschieben heißt Ortsänderung, nicht Bearbeitung.** Der Text wandert unverändert. Nötige Anpassungen beschränken sich auf die Überschriftenebene und das ergänzte Frontmatter. Kürzen, Umformulieren und Zusammenfassen sind hier verboten — dafür ist `/cmd:project-rules` da, und zwar danach.
- **Teilbare Quellen zeilenweise aufteilen.** Eine `NOTES.md` mit Aufgaben und Wissen wird in beide Ziele zerlegt; die Summe der Teile muss die Ausgangsdatei ergeben. Diese Summe hältst du fest.
- **Was bleibt, wird auch verbucht** — mit Kategorie `bleibt` und Grund. Nur so ist am Ende belegbar, dass nichts vergessen wurde.
- **Im Zweifel bleibt es liegen.** Eine Quelle, deren Ziel unklar ist, kommt als offener Punkt in den Bericht, statt geraten zu werden.

## Schritt 4 — Artefakt-Vorschläge

Sichte, was einen Skill, Subagent oder eine `paths:`-Regel rechtfertigt — nach der Entscheidungshilfe in `references/artefakt-kanon.md`. Je Vorschlag nennst du den **Anlass aus diesem Projekt** (welcher Handgriff, wie oft, wo belegt), das gewählte Artefakt mit Begründung und den Zielpfad.

**Für einen Subagent-Vorschlag gilt die Stufung des Delegations-Maßstabs.** Ad-hoc-Delegation braucht kein Artefakt; eine Agent-Datei rechtfertigt erst Wiederkehr oder eine festzuschreibende Rückgabeform. Den Anlass bildest du aus den Anhaltspunkten des Kanons und markierst ihn im Vorschlag als **unbestätigt** — bestätigt wird er in Schritt 5, nicht hier. Findest du keinen Anhaltspunkt, schlägst du nichts vor. Deckt ein installiertes Plugin den Anlass mit einem eigenen Agenten ab, ebenfalls nicht: Die Inventur sieht ihn nicht, er zählt trotzdem.

Angelegt wird ein Artefakt nur mit Freigabe, und nur als tragfähiger Erstentwurf mit vollständigem Frontmatter — kein leeres Gerüst.

**Schreiben unter `.claude/` verlangt eine eigene, interaktive Bestätigung.** `.claude` ist ein geschützter Pfad (wie `.git`), und die Schutzprüfung läuft **vor** der Auswertung der allow-Regeln — eine vorab erteilte Freigabe wie `Edit(.claude/**)` hebt sie deshalb nicht auf. In den Modi `default` und `acceptEdits` kommt ein Prompt, unter `dontAsk` wird abgelehnt; der Prompt bietet an, `.claude/`-Schreibzugriffe für die laufende Sitzung freizugeben. Beides ist dokumentiert und gemessen. Wird sie verweigert oder ist der Lauf unbeaufsichtigt, gilt: **Quelle nicht entfernen.** Den Block aus der `CLAUDE.md` zu löschen, obwohl das Ziel nicht geschrieben werden konnte, wäre genau der Informationsverlust, gegen den dieser Ablauf gebaut ist. Der Vorschlag bleibt dann als offener Punkt im Bericht stehen, mit der nachzuholenden Freigabe. Findest du keinen belegten Anlass, schlägst du nichts vor; das ist ein gültiges Ergebnis, kein Versäumnis.

Bereits vorhandene Artefakte fasst du nicht an. Sie zu verbessern ist eine eigene Aufgabe mit eigener Freigabe.

**Prüfe vor jedem Vorschlag den Zweck, nicht den Namen.** Deckt ein vorhandenes Artefakt denselben Anlass bereits ab, schlägst du nichts vor — auch dann nicht, wenn du es anders benannt hättest. Der Name eines Vorschlags ist nicht stabil: Derselbe Anlass kann in zwei Läufen zu `deploy` und `deploy-prod` führen. Ohne diese Prüfung legte ein zweiter Lauf ein zweites Artefakt für denselben Zweck an, und der Skill bräche seine eigene Regel „eine Quelle je Zweck" ausgerechnet bei sich selbst.

## Schritt 5 — Vorschau und Freigabe

**Eine** Vorschau über alles, **eine** Freigabe: anzulegende Ordner, Umbenennungen, das vollständige Verlagerungs-Register, anzupassende Verweise, Artefakt-Vorschläge, die Änderung am Wegweiser.

Trägt ein Subagent-Vorschlag einen unbestätigten Anlass, legst du ihn hier zur Bestätigung vor; ohne sie wird er nicht angelegt und steht auch nicht als offener Punkt, denn dann gab es ihn nie. Eine eigene Rückfrage in Schritt 4 gibt es nicht: Diese Vorschau bleibt die einzige Unterbrechung.

**Rückweg je Datei, nicht pauschal:**

- Getrackte Datei → `git restore <datei>`, und du nennst ihn so.
- **Untrackte Datei → vorher `.bak`-Kopie.** `git restore` stellt eine nie eingecheckte Datei nicht wieder her. Das ist keine Formalie, sondern der einzige Rückweg, den es dort gibt.
- Neu angelegter Ordner → `rmdir <ordner>`. Kein `rm -rf`: Es löschte inzwischen abgelegte Inhalte kommentarlos mit, `rmdir` scheitert stattdessen.

Ein pauschales `git restore` schlägst du nie vor — in einem Projekt mit anderen uncommitteten Änderungen verwürfe es fremde Arbeit.

**Ohne git-Repo** gibt es kein `git mv` und kein `git restore`: Dann ist jede Quelle wie eine untrackte zu behandeln, also `.bak` vor jeder Bewegung. Sag ausdrücklich dazu, dass der Umzug dort schlechter reversibel ist, und biete an, vorher zu initialisieren.

## Schritt 6 — Ausführen

- **`git mv` statt `mv`**, damit die Historie der Datei erhalten bleibt und der Umzug im Diff als Umbenennung erscheint, nicht als Löschen plus Neuanlegen. Bei untrackten Quellen erst `.bak`, dann bewegen.
- **Bei einer Aufteilung auf mehrere Ziele gibt es kein `git mv`.** Ein `mv` braucht genau ein Ziel; bei 1→n gäbe es keins, dem die Historie folgen könnte, und eine willkürlich bevorzugte Zieldatei wäre eine erfundene Zuordnung. Schreib in dem Fall die Ziele und entferne die Quelle mit `git rm` — der Löschvorgang steht im Index und bleibt über `git restore --staged --worktree <quelle>` rückholbar. Nenne diesen Rückweg im Bericht, er ist ein anderer als bei einer Verschiebung.
- Ordner vor dem Anlegen auf Vorhandensein prüfen — sonst ist der zweite Lauf nicht diff-frei. Liegt am Zielpfad eine **Datei** statt eines Verzeichnisses, überschreibst du sie nicht: Der Konflikt geht in den Bericht als offener Punkt.
- Frontmatter beim Verschieben ergänzen, nicht ersetzen. Hat die Quelle schon eines, führst du beide zusammen und behältst im Zweifel den vorhandenen Wert.
- **Trägt die Quellzeile den Status im Text** („Offen: …", „TODO: …", „Erledigt: …"), gehört er ins Frontmatter und **nicht zusätzlich** in den Titel. Das Statuswort am Zeilenanfang samt Doppelpunkt entfällt dort, der Rest der Zeile bleibt wörtlich; im Register verbuchst du das als Ortsänderung mit dem Vermerk „Statuswort ins Frontmatter". Das ist die einzige Textänderung, die ein Umzug vornehmen darf — sie überführt Information von einer Darstellungsform in die andere, statt sie zu entfernen. Steht der Status mitten im Satz oder ist unklar, ob er einer ist, lässt du die Zeile unangetastet und vermerkst die Dopplung.
- Ist ein Zielname vergeben, vergibst du die nächste freie Nummer und vermerkst es. Eine vorhandene Datei wird nie überschrieben.
- Verweise auf umbenannte Pfade in derselben Runde nachziehen.
- **Bei Abbruch mittendrin** — Fehler, Unterbrechung — halte an und melde den Stand. Bau nicht auf einem halb angewandten Zustand weiter.

## Schritt 7 — Verlustnachweis

Erst prüfen, dann berichten:

- **Jede Quelle verbucht:** Steht jeder Eintrag des Registers in genau einer Kategorie (`verschoben`, `aufgeteilt`, `bleibt`, `entfällt`)? Ein offener Eintrag ist eine Lücke.
- **Bilanz:** Summe der Zeilen in den Zielen plus verbliebene Zeilen in den Quellen plus entfallene Strukturzeilen = Ausgangssumme aus Schritt 1. Die entfallenen führst du **einzeln** auf, nie als Sammelposten — ein Sammelposten macht aus der Bilanz eine Restgröße, in der sich ein echter Verlust versteckt. Weicht die Summe ab, benenne die Differenz und ihre Ursache, statt sie zu übergehen.
- **Nichts überschrieben:** Keine vorhandene Datei ersetzt, kein Ordner mit einer gleichnamigen Datei kollidiert.
- **Verweise intakt:** Kein Verweis zeigt auf einen Pfad, den es nicht mehr gibt.
- **Treue:** Behaupte keine Bewegung, die du nicht ausgeführt hast, und keine Prüfung, die du nicht durchgeführt hast.

Bei einem Fund: korrigieren, dann erneut prüfen.

## Schritt 8 — Wegweiser in der CLAUDE.md

Schreibe oder aktualisiere in der maßgeblichen `CLAUDE.md` **einen** Abschnitt unter der festen Überschrift `## Ablage`. Nur du weißt, was tatsächlich angelegt wurde; die feste Überschrift macht ihn für `/cmd:project-rules` auffindbar, das ihn danach härtet und verdichtet.

Der Wegweiser nennt je Zweck **einen Pfad und einen Halbsatz**, sonst nichts — das Detail lebt am Zielort:

```
## Ablage
- Offene Punkte: <Pfad oder Tracker> · erledigt → <Ziel> per `git mv`
- Entscheidungen: <Pfad>, `NNNN-titel.md`
- Wissen: <Pfad>
- Erledigtes/Releases: `CHANGELOG.md` und git-Historie
- Agenten-Artefakte: <vorhandene Pfade>
```

Nur vorhandene Orte aufnehmen. Nicht angelegte Orte gehören in den Bericht, nicht in die Datei — ein Verweis auf einen nicht existierenden Pfad ist eine Erfindung.

**Eine Ausnahme, und sie ist wichtig: der Lebenszyklus-Pfad.** Das Ziel, in das ein erledigter Punkt wandert (etwa `backlog/completed/`), nennst du **auch dann**, wenn der Ordner noch nicht existiert. Er ist keine Ortsangabe, sondern die Konvention, wie hier erledigt wird, und er entsteht beim ersten Erledigen. Lässt du ihn weg, weil der Ordner leer wäre, steht in der Datei zwar kein falscher Pfad — aber auch nicht mehr, *wohin* Erledigtes gehört. Damit fiele genau der Pflegeauslöser weg, ohne den die Ablage wieder zuwächst. Schreib ihn erkennbar als Konvention (`erledigt → <Pfad> per git mv`), nicht als Bestandsangabe.

Vor dem Schreiben denselben Rückweg sichern wie für jede andere Datei. Existiert der Abschnitt schon, ersetzt du **nur ihn**; den Rest der Datei fasst du nicht an.

## Schritt 9 — Bericht

```
## Struktur: <Projektpfad>
Kanon-Abgleich: <X übernommen / Y umbenannt / Z angelegt / N weggelassen>

### Vorgefunden und übernommen
- <Zweck> → <Pfad> (maßgeblich, unverändert)

### Umbenannt
- <alt> → <neu>; angepasste Verweise: <Dateien>

### Angelegt
- <Pfad> — Grund: <…> · Rückweg: `rmdir <pfad>`

### Verschoben
- <Quelle> → <Ziel> (<Zeilen>) · Rückweg: <git restore … / .bak unter …>

### Aufgeteilt
- <Quelle> → <Ziel A> (<Zeilen>) + <Ziel B> (<Zeilen>)

### Geblieben
- <Quelle> — Grund: <…>

### Entfallene Strukturzeilen
- <Quelle:Zeile> „<Text>" — ersetzt durch <Zielzeile>

### Artefakte vorgeschlagen
- <Skill|Subagent|Regel> <Pfad> — Anlass: <konkret aus diesem Projekt | aus Anhaltspunkten, bestätigt> · <angelegt / abgelehnt>

### Offen
- <Konflikt, unklares Ziel, abgelehnte Umbenennung>

### Bilanz
<Ausgangszeilen> = <in Zielen> + <verblieben> + <entfallene Strukturzeilen> — jede Quelle verbucht.
Zweiter Lauf ohne zwischenzeitliche Änderung: diff-frei.
```

Die Bilanzzeile ist der Vollständigkeitsbeleg. Geht sie nicht auf, ist der Lauf nicht fertig, sondern fehlerhaft — sag das so, statt die Differenz zu glätten.

**Idempotenz ist Abnahmekriterium:** Ein zweiter Lauf ohne zwischenzeitliche Änderung erzeugt in keiner Datei einen Diff, und du meldest das ausdrücklich.

**Bei jedem Abbruch** — Fehler, Ablehnung, Unterbrechung — gibst du dieselbe Bilanz: was geschrieben ist, was offen blieb, und der Rückweg für das bereits Geschriebene.

**Danach:** Empfiehl `/cmd:project-rules`, wenn der Wegweiser neu ist oder Inhalt aus der `CLAUDE.md` abgeflossen ist — die Datei ist dann inhaltlich richtig, aber weder gehärtet noch verdichtet. Sag dabei ausdrücklich, dass dies der **letzte** Schritt der Reihe `project-settings` → `project-structure` → `project-rules` ist: Findet `project-rules` danach noch auslagerungsreife Blöcke, sind es solche, die dieser Lauf bewusst hat liegen lassen — dann ist die Antwort eine Entscheidung darüber, nicht ein weiterer Lauf von `project-structure`. Schick den Nutzer nicht im Kreis.

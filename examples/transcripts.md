# Beispiel-Transkripte — erwartete Ausgabeform der Skills

Dokumentiert die erwartete Form der Flows, die `scripts/smoke.sh` nicht erreicht: Bei den mehrschrittigen Skills sieht ein `claude -p`-Einzelaufruf nur den Eröffnungszug, bei `session-handoff` nur den Zweig ohne Gesprächsverlauf. Kein Test, sondern Referenz: So soll die Ausgabe strukturiert sein.

## plan-grill

**Eröffnungszug** (was ein Einzelaufruf zeigt): Gegenstand in einem Satz wohlwollend wiedergegeben (Steelman) plus **genau eine** offene Frage — bei abzählbaren Optionen via `AskUserQuestion`, sonst als Prosa. Keine Datei wird geschrieben.

**Schlussnotiz** (nach erschöpften Entscheidungen): ein selbsttragender Übergabeblock, den `/plan` verlustarm übernimmt —

```
Gegenstand: <ein Satz>
Ledger:
  E1  <Entscheidung>  → <gewählte Antwort>  (<Kurzbegründung>)  [bestätigt|vorläufig]
  E2  …
Nicht gefragt (Default): <Entscheidung> → <Default> (<Grund>)
Offen: <noch im Plan zu klären>
```
Danach die Bitte um Bestätigung des gemeinsamen Verständnisses und das Angebot der Übergabe an `/plan` oder den Plan-Modus. Rücknahme per Kennung: „nimm Entscheidung 2 zurück".

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

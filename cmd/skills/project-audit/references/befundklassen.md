# Befundklassen — mit Originalbeleg und Quelle

Diese Datei gehört zu Schritt 2 von `/cmd:project-audit`. Sie ist **Arbeitsanweisung an dich**, kein Zieltext: Nichts hieraus wird in eine Projektdatei kopiert. Sie lädt selbst keine weitere Datei.

**Setze keinen Befund aus dem Gedächtnis.** Jede Klasse unten trägt den englischen Originalsatz, auf den sie sich stützt, samt Leitfaden und Abschnitt. Findest du im Projekt etwas, das zu keiner Klasse passt, ist es kein Befund dieses Skills — nenne es als Beobachtung, statt eine Klasse zu erfinden.

Belege geholt am 18. September 2026 als Roh-Markdown von `platform.claude.com/docs/en/build-with-claude/prompt-engineering/`. Die Angaben sind an die Leitfassung dieses Tages gebunden; ändert sich ein Leitfaden, ändert sich die Klasse.

## A — Verifikations-Scaffolding

**Erkennen:** Anweisungen, die eine eigene Prüfrunde vorschreiben, ohne ein Kriterium von außen zu nennen — „führe vor dem Abschluss eine Verifikation durch", „prüfe deine Antwort noch einmal", „lass einen Subagenten das Ergebnis verifizieren", ein Abschnitt „Vor fertig verifizieren".

**Beleg** (Prompting Claude Opus 5, „Task scope and over-verification"):

> If your prompt contains explicit verification instructions ("include a final verification step for any non-trivial task," "use a subagent to verify"), remove them: instructions like these cause over-verification on Claude Opus 5, and removing them reduces wasted tokens with no loss in quality. The same applies to legacy harness scaffolding that adds separate verification steps.

**Nicht betroffen, und das ist die wichtigste Abgrenzung dieses Skills:** Prüfungen mit einem Kriterium von außen — Testlauf, Exit-Code, Build, Zeilenbilanz, Abdeckungsregister, erwarteter Dateizustand. Sie sind keine Selbstkritik, sondern Messungen, und sie bleiben. Ebenso bleibt die **Belegpflicht**: „Behaupte keine Prüfung, die du nicht durchgeführt hast" verbietet eine Behauptung, statt eine zusätzliche Runde zu verlangen.

## B — Wiederholte Selbstprüfung

**Erkennen:** „double-check", „prüfe noch einmal", „vergewissere dich", „re-verify before responding".

**Beleg** (Prompting Claude Opus 5, „Self-correction"):

> Avoid instructing re-checks it already performs ("double-check your answer," "re-verify before responding"); like verification instructions, these compound with the model's own behavior and add cost without improving results.

## C — Anti-Formatierungsregeln

**Erkennen:** pauschale Verbote von Listen, Überschriften, Fettung oder Tabellen, oft als „antworte in Fließtext, keine Bulletpoints".

**Beleg** (Prompting Claude Fable 5.1, „Formatting in chat"):

> Earlier models overused bullets and bold in chat, and many prompts carry anti-formatting rules written to hold that down. Claude Fable 5.1 leans the other way: it uses bold less and is less likely to reach for headers, lists, or quotation marks. If your prompt contains anti-formatting language, remove it or replace it with a rule that says when specific formatting is appropriate.

**Nicht betroffen:** eine Regel, die Formatierung **an den Inhalt bindet** („Listen für gleichartige Mengen, Prosa für zusammenhängende Logik"), und eine Regel, die einen ausdrücklichen Wunsch des Nutzers nach minimaler Formatierung befolgt.

## D — Das eigene Denken wiedergeben

**Erkennen:** „erkläre deinen Denkprozess", „zeig deine Überlegungen", „gib dein Reasoning im Antworttext wieder", Aufforderungen zur Selbstreflexion über das eigene Denken.

**Beleg** (Prompting Claude Fable 5, „Recommended scaffolding changes"):

> Prompts, skills, or harness instructions that tell the model to echo, transcribe, or explain its internal reasoning as response text can trigger the `reasoning_extraction` refusal category on Claude Fable 5, causing elevated fallbacks to Claude Opus 4.8. Audit existing skills and system prompts for reflection or show-your-thinking instructions when migrating.

**Nicht betroffen:** die Aufforderung, eine **Begründung** oder eine **Annahme** zu nennen. Gemeint ist das Wiedergeben des internen Denkens, nicht das Begründen eines Ergebnisses.

## E — Narrations-Unterdrückung

**Erkennen:** „melde dich nicht zwischendurch", „keine Zwischenmeldungen", „halte Befunde bis zum Schluss zurück".

**Beleg** (Prompting Claude Opus 5, „User-facing progress updates"):

> To tune narration down, describe the cadence and shape you want […] Positive examples of the communication style you want tend to be more effective than instructions about what not to do.

**Gegenmaßnahme:** durch eine Kadenz ersetzen, nicht ersatzlos streichen — ein Satz vor dem ersten Tool-Aufruf, kurze Meldung bei Wichtigem oder Richtungswechsel, Ergebnis im ersten Satz am Ende.

## F — Denk-Verbote

**Erkennen:** „denke nicht nach", „kein Reasoning", Regeln, die Denk-Tags namentlich verbieten.

**Beleg** (Prompting Claude Opus 5, „Running with thinking disabled"):

> If your system prompt contains a rule instructing the model not to think or not to reason, remove it; that kind of instruction increases tag leakage.

## G — Over-Prompting bei der Werkzeugwahl

**Erkennen:** „nutze im Zweifel immer [Tool]", „verwende standardmäßig [Tool]".

**Beleg** (Prompting best practices, Migrationshinweise):

> **Remove over-prompting.** Tools that undertriggered in previous models are likely to trigger appropriately now. Instructions like "If in doubt, use \[tool]" will cause overtriggering.

> **Replace blanket defaults with more targeted instructions.** Instead of "Default to using \[tool]," add guidance like "Use \[tool] when it would enhance your understanding of the problem."

## H — Vorfilter im Review

**Erkennen:** „melde nur schwerwiegende Befunde", „sei konservativ", „nenne höchstens drei Punkte".

**Beleg** (Prompting Claude Opus 5, „Capability improvements"):

> If your review prompt says "only report high-severity issues" or "be conservative," the model may follow that instruction literally and report less; ask it to report everything and filter in a separate pass instead.

## I — Aufzählung statt kurzer Instruktion

**Erkennen:** lange Listen, die dasselbe Verhalten in Varianten durchdeklinieren, wo ein Satz trüge.

**Beleg** (Prompting Claude Fable 5, „Strong instruction following"):

> Instruction-following is improved enough that you can steer most behaviors with a brief instruction rather than enumerating each behavior by name.

**Vorsicht:** Das ist die Klasse mit dem höchsten Fehlalarm-Risiko. Eine Schrittkette mit einem Register oder einer Bilanz ist keine Aufzählung dieser Art, sondern der Korrektheitsmechanismus des Ablaufs. Belege den Befund daran, dass zwei Punkte **dasselbe** Verhalten in anderen Worten verlangen.

## J — Zu präskriptive Altanweisung

**Erkennen:** Regeln, die auf ein Modellverhalten zielen, das die Leitfäden für die heutigen Modelle nicht mehr beschreiben.

**Beleg** (Prompting Claude Fable 5, „Recommended scaffolding changes"):

> Skills developed for prior models are often too prescriptive for Claude Fable 5 and can degrade output quality. Review and consider removing older instructions if default performance is better.

**Ohne Beleg aus dem Projekt kein Befund:** Diese Klasse rechtfertigt keine Streichung, nur weil eine Regel alt wirkt. Nenne, welches Verhalten sie adressiert und warum es heute nicht mehr auftritt.

## K — Altlast aus früheren `project-rules`-Läufen

Diese Gruppe ist die verlässlichste, weil der Wortlaut bekannt ist: Frühere Fassungen dieses Plugins haben ihn selbst in fremde Regeldateien geschrieben, und ein neuer `project-rules`-Lauf holt ihn nicht zurück — die Best-of-Regel verbucht Vorhandenes als `bereits vorhanden`. Such nach diesen Stellen im Wortlaut:

- Ein Abschnitt `## Vor "fertig" verifizieren`, meist mit der Zeile „Erkläre nichts für erledigt, ohne es zu prüfen." → Klasse A. **Die letzte Zeile des Abschnitts bleibt:** „Behaupte keine Prüfung, keinen Test und keinen Schritt, den du nicht tatsächlich durchgeführt hast." Sie gehört zur Belegpflicht und wird unter einen passenden Abschnitt gezogen, statt mit dem Rest zu fallen. Bei Code bleibt ebenso „Build, Tests und Lint laufen lassen und das Ergebnis nennen" — das ist ein Kriterium von außen.
- „Verifiziere jede Teilaufgabe gegen ihr Kriterium, bevor du zur nächsten gehst, statt erst am Ende." → Klasse A.
- „Verfeinere das Verständnis, bis kein Raum für Fehldeutung bleibt." → Klasse J, ersetzt durch eine Wesentlichkeitsschwelle: nachfragen nur, wo verschiedene Lesarten zu wesentlich verschiedener Arbeit führen.
- Ein Abschnitt `## Mehrdeutigkeit zuerst klären` → derselbe Fall wie die vorige Zeile; heute heißt er „Mehrdeutigkeit nach Wirkung klären".

Diese vier sind der Grund, warum ein bereits gehärtetes Projekt diesen Skill braucht.

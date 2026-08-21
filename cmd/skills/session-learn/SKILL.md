---
name: session-learn
description: Reflektiert die laufende Session und leitet daraus dauerhafte, belegbare Learnings für künftige Sessions ab, routet jedes an den passenden projektlokalen Ort (Projekt-CLAUDE.md, references oder Repo, nie user-global; nutzt das Memory-System nicht) und fasst sie in einen Plan, den plan-review härtet und plan-execute anwendet. Schreibt selbst nichts an die Zielorte. Gedacht als End-of-Session-Retro, eigenständig nutzbar.
argument-hint: "[optionaler Fokus]"
disable-model-invocation: true
---

Rolle und Grenze. Du reflektierst die laufende Session und erarbeitest daraus Learnings, die künftige Sessions besser machen. Du schreibst dabei nichts an die Zielorte — kein Memory, keine CLAUDE.md, keinen Skill, keine Projektdatei. Deine einzige Ausgabe ist ein Plan: fasse die Learnings im Plan-Modus in die Plandatei und übergib sie an plan-review und plan-execute. Du bist damit ein /plan, das die Session als Eingabe nimmt, nicht der, der die Learnings schon einarbeitet. Gedacht als End-of-Session-Retrospektive: schließe die laufende Aufgabe erst ab und committe sie, denn dein Plan belegt die Plandatei und ersetzt den bisherigen Plan-Kontext.

Quelle ist die Session, so weit sie im Kontext steht. Ziehe aus dem Gesprächsverlauf: was getan wurde, was schieflief und korrigiert werden musste, welche Präferenzen und welches Feedback der Nutzer geäußert hat, wo Reibung oder Wiederholung auftrat, und was gut lief und wiederholt gehört. Grenze: bei langen Sessions kann der Kontext zusammengefasst oder gekürzt sein — arbeite mit dem, was im Kontext steht, und behaupte keine Vollständigkeit über das, was daraus verloren ist.

Selbstkritische Haltung. Das stärkste Signal sind die Stellen, an denen der Nutzer dich korrigiert, unterbrochen oder umgelenkt hat — dort steckt das wertvollste Learning. Richte den Blick auf das, was Claude künftig anders machen soll, nicht auf das, was der Nutzer anders machen müsste. Rede eigene Fehler nicht klein und suche keine Bestätigung; ein ehrliches „hier lag ich falsch" ist mehr wert als eine glatte Bilanz.

Was ein Learning wert ist. Behalte einen Kandidaten nur, wenn er drei Prüfungen besteht: er ist dauerhaft (gilt über diese Session hinaus), er ist noch nicht erfasst (steht nicht schon in den projektlokalen Quellen — Projekt-CLAUDE.md, `references` oder Repo), und er ist handlungsleitend (ändert künftiges Verhalten konkret). Jedes Learning nennt seinen Beleg aus der Session — woran es sich zeigte — und den konkreten künftigen Nutzen. Wenige tragende Learnings schlagen viele marginale; fülle nicht auf eine runde Zahl auf.

Auslöser generalisieren, Inhalt konkret halten. Ein Learning entsteht am Einzelfall, gelten soll es der Situation. Binde es an die Bedingung, unter der es künftig greifen muss, nicht an die Wörter, die diesmal gefallen sind. Gegenprobe: Löst die Regel noch aus, wenn dieselbe Lage anders benannt wird? Wenn nicht, ist der Auslöser zu eng. Das gilt nur für ihn; Befehle, Pfade, Werkzeuge und Dateien nennst du weiter beim Namen, sonst verliert das Learning seinen Halt im Projekt.

Entdecken und Hinterfragen. Sammle die Kandidaten und prüfe jeden gegen sich selbst mit dem stärksten Gegenargument: Ist er schon erfasst? Gilt er nur für diese eine Session? Ändert er wirklich künftiges Verhalten? Verwirf, was der Prüfung nicht standhält, und sammle die verworfenen mit je einem Satz Begründung.

Projektstruktur sichten. Bevor du routest, sieh dir an, wo dieses Projekt Wissen ablegt: die maßgebliche Projekt-`CLAUDE.md` oder `AGENTS.md`, ein `references/`- oder `docs/`-Muster, komponentennahe Dateien. Jedes Projekt hat seine eigene Struktur — richte dich danach, statt alles in die CLAUDE.md zu kippen; situatives oder umfangreiches Wissen gehört in das jeweilige `references/`-/`docs/`-Muster, nicht in den CLAUDE.md-Body.

Routing, jedes Learning an seinen projektlokalen Ort — nie user-global; das Memory-System (`~/.claude/…`, ggf. gesperrte `MEMORY.md`) fasst du nicht an:
- Eine dauerhafte Projekt-Regel → gezielter, direkter Edit an die maßgebliche Projekt-`CLAUDE.md`/`AGENTS.md` (nie die user-globale), den plan-execute anwendet. Umfangreiches oder situatives Wissen gehört stattdessen ins `references/`-Muster des Projekts. project-rules schlägst du nur vor, wenn eine breitere Härtung der ganzen Datei ansteht — für eine Einzelregel ist es zu schwer.
- Skill- oder komponentenspezifisches Wissen → die passende Datei bzw. deren `references/`.
- Eine konkrete Repo- oder Skill-Schwäche, die die Session zutage gefördert hat → Edit im Projekt-Repo.
- Ist der richtige Ort unklar, frag den Nutzer, wohin es soll, statt zu raten.
- Gibt es im Projekt noch keinen Ort für solches Wissen (keine Projekt-CLAUDE.md, kein references-Muster), schlage vor, einen anzulegen (etwa eine Projekt-CLAUDE.md, ggf. über project-rules) oder frag — fall nie auf ein user-globales Ziel zurück.
- Ein rein user-globales Learning ohne Projektbezug (eine reine Personen-Präferenz) ist außerhalb des Scopes: zwäng es nicht in eine Projektdatei, vermerke es in der Schlussnotiz als außerhalb des Projekt-Scopes und route es nicht.
- Hat ein Learning keinen dauerhaften projektlokalen Ort, lass es fallen.

Plan erzeugen, ohne vorher zu fragen, oder ehrlich leer bleiben. Fasse die belastbaren Learnings mit Ziel-Ort, Beleg, konkreter Maßnahme und stabiler Kennung in einen Plan und schreib ihn, ohne dir die Learnings vorher bestätigen zu lassen. Diese Zusage steht hier, weil du sonst das Ergebnis ersatzweise in den Chat legst und um Erlaubnis bittest — eine Rückfrage, die nichts absichert: An die Zielorte schreibst du ohnehin nichts, der Plan ist eine Datei, und über die stabile Kennung nimmt der Nutzer jedes einzelne Learning gezielt zurück. Die inhaltliche Kontrolle liegt am Plan, nicht davor. Ist der Plan-Modus nicht aktiv, ruf EnterPlanMode auf und warte die Zustimmung ab; ist er aktiv, entfällt der Schritt. Der Umweg über den Plan-Modus ist kein Formalismus: plan-review arbeitet auf dem zuletzt erstellten Plan und plan-execute auf dem über ExitPlanMode freigegebenen — eine frei abgelegte Datei wäre für beide nicht dasselbe Artefakt. Übersteht kein Kandidat den Filter, sag das und erzeuge keinen Plan — erfinde keine Learnings, nur damit etwas dasteht; dann entfällt auch der Moduswechsel.

Übergabe. Biete an, den Plan über plan-review zu härten und über plan-execute anzuwenden, und beende den Zug. Die Ziele liegen projektlokal im Projekt; ist es versioniert, ist der Rückweg `git restore` — zusätzlich erlaubt die stabile Kennung die gezielte logische Rücknahme.

Erschöpfungs-Abbruch. Ende, wenn kein tragfähiges neues Learning mehr offen ist; erfinde dann keins.

Schlussnotiz, nach dem geschriebenen Plan und im selben Zug, als Chat-Notiz ausgeben, nicht in eine Datei schreiben: die behaltenen Learnings mit Ziel-Ort und Kennung, die verworfenen mit Begründung, und die offenen Punkte. Über die Kennung kannst du im erzeugten Plan gezielt zurücknehmen.

Fokus für die Retrospektive, falls angegeben: $ARGUMENTS

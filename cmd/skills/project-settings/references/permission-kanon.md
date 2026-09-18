# Der Settings-Kanon

Adressatenhinweis: Diese Datei ist Nachschlagewerk für dich beim Ausführen von `project-settings`. Die JSON-Blöcke wandern in die Zieldateien, der Fließtext nicht.

## Inhalt
- Projekt: `.claude/settings.json` — die zu setzenden Werte
- Zeitanker — der Hook, der jedem Turn die Systemzeit gibt, und was er nicht leistet
- Was bewusst nicht gesetzt wird — und warum
- Pfad-Präfixe — `//`, `~/`, `/`, `./` und stumme Mischformen
- Workspace-Trust — wann `allow` greift, und was die Kandidaten-Übernahme daran ändert
- Geschützte Pfade — `.claude` und `.git`, gegen die keine allow-Regel hilft
- Was die deny-Liste nicht abdeckt — Read-Tool statt Shell
- Was die deny-Liste zusätzlich abdeckt — Read-deny sperrt auch Edit und Write
- Bewusst offene Lücke bei git
- Regelsyntax, kurz

Stand der Belege, an der Herstellerdoku (`code.claude.com/docs/en/`) nachgeprüft: `permissions`, `permission-modes`, `settings` und `tools-reference` am 16. August 2026, `hooks` am 12. September 2026. Ein gemeinsames Datum stünde für eine Prüfung, die so nicht stattgefunden hat.

## Projekt: `.claude/settings.json`

```jsonc
{
  "autoMemoryEnabled": false,
  "permissions": {
    "allow": [
      "WebSearch",
      "WebFetch(domain:*)",
      "Bash(git *)",
      "Bash(date:*)",
      "Read(//**)"
    ],
    "ask": [
      "Bash(git push *)",
      "Bash(git reset *)",
      "Bash(git clean *)",
      "Bash(git rebase *)",
      "Bash(git filter-branch *)",
      "Bash(git worktree remove *)"
    ],
    "deny": [
      "Read(//**/.ssh/**)",
      "Read(//**/.aws/**)",
      "Read(//**/.gnupg/**)",
      "Read(//**/.netrc)",
      "Read(//**/id_rsa*)",
      "Read(//**/id_ed25519*)",
      "Read(//**/*.pem)",
      "Read(//**/*.key)",
      "Read(//**/credentials*)",
      "Read(~/Library/Keychains/**)",
      "Read(//**/.config/gh/**)",
      "Read(//**/.config/gcloud/**)",
      "Read(//**/.kube/config)",
      "Bash(cat ~/.ssh/*)",
      "Bash(cat ~/.aws/*)",
      "Bash(cat ~/.gnupg/*)",
      "Bash(cat ~/.netrc)",
      "Bash(cat ~/.config/gcloud/*)",
      "Bash(cat ~/.kube/config)"
    ]
  }
}
```

### Was die allow-Regeln leisten

Je Regel, was sie freigibt, was sie nicht freigibt, und warum sie im Kanon steht. Getrennt ist dabei, was die Skills dieser Suite **brauchen**, und was der Kanon **darüber hinaus** freigibt; das Zweite ist eine Entscheidung des Maintainers für seine Maschine, keine Anforderung der Suite, und wer den Kanon übernimmt, trifft sie neu.

| Regel | Leistet | Leistet nicht | Warum im Kanon |
|---|---|---|---|
| `WebSearch` | Websuche ohne Prompt | Keinen Seitenabruf; das ist `WebFetch` | Bedarf der Suite: der Faktenvorlauf von `plan-grill` und die Belegpflicht der Ausführungsdisziplin, die Versionsnummern und Fakten per Websuche verifizieren lässt, statt sie zu raten |
| `WebFetch(domain:*)` | Abruf jeder Domain ohne Prompt | Keine Downloads oder Skripte über die Shell | Bedarf der Suite: nur Doku-Domains wie `code.claude.com`. **Alle** Domains sind darüber hinaus Entscheidung des Maintainers; eine Liste der Doku-Domains wäre für die Suite gleichwertig |
| `Bash(git *)` | Jedes git-Kommando ohne Prompt, soweit keine `ask`-Regel greift | Nicht die sechs Formen der `ask`-Liste; nicht `cd <anderswo> && git …`, das wegen fremder Hooks prompt | Bedarf der Suite: Inventur (`git status`, `git log`, `git remote -v`), Verschieben mit Historie (`git mv`) und der Rückweg (`git restore`) in `project-structure`, `project-settings` und `session-handoff` |
| `Read(//**)` | Lesen im ganzen Dateisystem ohne Prompt, soweit keine `deny`-Regel greift | Nicht die dreizehn `deny`-Pfade; nicht die Shell (`cat`, siehe unten) | Bedarf der Suite, erstmals gemessen am 12. September 2026 gegen Claude Code 2.1.269 (damals vier Skills mit zwölf `references/`-Dateien), Stand 18. September 2026: **acht Skills laden 27 `references/`-Dateien** aus dem Plugin-Cache unter `~/.claude/plugins/` nach, außerhalb des Arbeitsverzeichnisses. Im Standardmodus prompt jeder dieser Zugriffe und scheitert headless („Claude requested permissions to read from …, but you haven't granted it yet"). Fremde Repos und `~/.claude/` darüber hinaus zu lesen ist Entscheidung des Maintainers |

Alle vier wirken erst nach angenommenem Workspace-Trust (siehe unten). Bis dahin prompten die Zugriffe, und `Read(//**)` deckt das Nachladen der `references/` erst danach; unmittelbar nach der Einrichtung trägt es also noch nicht.

### Zeitanker: Systemzeit je Turn

Ergänzung **derselben** Datei, kein zweites Ziel: derselbe `.claude/settings.json`, ein weiterer Top-Level-Key neben `permissions`.

```jsonc
"hooks": {
  "UserPromptSubmit": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "date '+Current system time: %Y-%m-%d %H:%M:%S %Z' # cmd:project-settings:zeitanker",
          "timeout": 5
        }
      ]
    }
  ]
}
```

**Wozu.** Ein Agent hat keinen Zeitsinn. Der Verlauf ist eine Folge von Turns ohne Uhr: Zwischen zwei Nachrichten können zwanzig Sekunden oder sechs Stunden liegen, und im Kontext sieht beides gleich aus. Ein Messwert aus einem früheren Turn wirkt so frisch wie beim Erheben. Claude Code liefert von sich aus das **Datum** im Systemprompt, nicht die Uhrzeit, und setzt es beim Sessionstart. Der Hook trägt Uhrzeit und Turn-Aktualität nach.

Der Hook macht den Verzug nur *sichtbar*. Die Pflicht, die daraus folgt, formuliert der Regelkatalog von `project-rules` als eigenständige Regel; wer nur diesen Wert entfernt, entfernt die Sichtbarkeit, nicht die Pflicht.

| Entscheidung | Grund |
|---|---|
| `UserPromptSubmit` | Eines der wenigen Events, deren stdout beim Modell landet. Doku wörtlich: „For most events, Claude Code writes stdout to the debug log and doesn't show it in the transcript. The exceptions are `UserPromptSubmit`, `UserPromptExpansion`, `SessionStart`, and `PostModelSwitch`, where Claude Code adds plain-text stdout as context that Claude can see and act on." Ein `PostToolUse`-Hook wäre wirkungslos, sein stdout ginge ins Debug-Log. |
| Kein zusätzlicher `SessionStart` | Stünde in derselben Ausnahmeliste, wäre also möglich, ist aber überflüssig: `UserPromptSubmit` deckt den ersten Turn mit ab. |
| Plain-Text statt JSON | Für dieses Event genügt reines stdout. Eine strukturierte Ausgabe brächte Quoting und Schema-Validierung mit, und ein Schema-Verstoß fällt **still** aus. Doku wörtlich, für Events mit dem Standard-Entscheidungsmodell: „exit 0 with a parsed object that fails schema validation is a non-blocking error: the action proceeds, and the transcript shows a `<hook name> hook error` notice with the validation message." Der Turn liefe weiter, nur ohne Zeitstempel, und genau dieser Ausfall fällt nicht auf. |
| Shell Form, kein `args` | Doku wörtlich: „A command hook runs as exec form when `args` is set, and shell form when `args` is omitted." Hier gibt es keinen Pfad-Platzhalter, und `date` braucht eine Shell. |
| Kein `matcher` | Nicht nur überflüssig, sondern nicht unterstützt. Die Doku führt `UserPromptSubmit` in der Zeile „no matcher support — always fires on every occurrence". Ein `matcher` hier ist ein Denkfehler, kein Feintuning. |
| Kein `statusMessage` | Der Hook feuert bei jeder Nachricht; ein Spinner-Text pro Turn wäre Lärm ohne Nutzen. |
| Zeitformat `%Y-%m-%d %H:%M:%S %Z` | Das **Datum gehört zwingend dazu**: Der auslösende Fehlerfall lief über zwei Kalendertage, und eine reine Uhrzeit hätte den Tageswechsel verschleiert. Die Zeitzone macht den Vergleich mit UTC-Zeitstempeln aus Logs möglich. |
| `timeout: 5` | Für `date` um Größenordnungen genug. Der Default läge auf diesem Event bei 30 (Doku: Claude Code senkt den `command`-Default von 600 auf 30 für `UserPromptSubmit`); der kleinere Wert begrenzt den Schaden, falls der Befehl je durch etwas Aufwendigeres ersetzt wird. |
| Marke im Kommando | `# cmd:project-settings:zeitanker` als Shell-Kommentar hinter dem Befehl, von der Shell ignoriert und nicht ausgegeben. Ohne sie ist der eigene Eintrag nicht von einem fremden `UserPromptSubmit`-Hook zu unterscheiden, und der Kanon wäre nicht idempotent. |
| `Bash(date:*)` in `allow` | **Gemessen redundant, bewusst behalten als Absicherung.** Am 12. September 2026 lief `date '+…'` in einem Verzeichnis **ohne jede** `settings.json` prompt-frei durch, während `touch` und `mkdir` im selben Modus abgelehnt wurden: Die Prompt-Ebene war wirksam, und `date` passierte sie ohne Regel. Nötig ist der Eintrag also nicht. Er bleibt, weil ihn **keine** Kanon-Regel abdeckt und die Klassifikation, die `date` durchlässt, weder konfigurierbar noch in ihrem Bestand zugesichert ist; in der Aufzählung des Read-only-Satzes (siehe unten) steht `date` nicht. Anders als bei den lesenden git-Formen, die `Bash(git *)` ohnehin deckt, wäre Weglassen hier keine vermiedene Redundanz, sondern eine Wette auf undokumentiertes Verhalten. Er kostet nichts: `date` liest nichts, schreibt nichts und geht nicht ins Netz. **Verlass dich für den Normalfall nicht auf ihn**, denn er wirkt erst nach angenommenem Workspace-Trust: Gemessen meldet ein Lauf in einem nicht getrusteten Verzeichnis ausdrücklich „Ignoring N permissions.allow entries from .claude/settings.json: this workspace has not been trusted" und nennt neben dem Dialog `projects[<pfad>].hasTrustDialogAccepted: true` in `~/.claude.json`. Unmittelbar nach der Einrichtung ist ein Projekt typischerweise nicht getrustet, die Regel trägt dort also nichts — dass `date` trotzdem läuft, verdankt sich der Klassifikation, nicht ihr. Immerhin ist der Zustand **nicht stumm**: Die Meldung erscheint beim Start, samt Anzahl der ignorierten Einträge. |

**Nicht aufladen.** Keine Zusatzinformation in dieses Kommando, also kein git-Branch, keine Uptime, keine offenen Tasks. Zwei Gründe, und der zweite wiegt schwerer: Der Hook läuft bei jeder Nachricht, jede Zeile kostet in jedem Turn Kontext und ein langsamer Befehl verzögert jeden Prompt. Und sobald der Befehl **Fremdinhalt** ausgibt, etwa eine Commit-Betreffzeile oder einen Dateinamen, wandert ungeprüfter Text je Turn in den Kontext, und aus dem Zeitanker wird eine Injektionsfläche. `date` ist genau deshalb geeignet: konstante Form, kein Fremdinhalt.

**Grenzen, und sie gehören in den Bericht statt verschwiegen:**

- **Wirktiefe unbekannt.** Die Doku sagt, der Text werde als Kontext aufgenommen, „that Claude can see and act on"; wie stark er auf das Verhalten durchschlägt, sagt sie nicht. Bleibt der Hinweis folgenlos, trägt die Regel aus `project-rules`, nicht dieser Wert.
- **Kosten:** ein Prozessaufruf und geschätzt rund fünfzehn Tokens je Turn. Nicht nachgemessen, vernachlässigbar, aber nicht null.
- **Der Hook misst die Systemzeit des Rechners**, auf dem Claude Code läuft, nicht die eines Zielsystems. Steuert das Projekt ein System in anderer Zeitzone, bleibt die Umrechnung Aufgabe des Agenten.
- **Über Mitternacht fallen zwei Datumsangaben auseinander.** Das Datum im Systemprompt steht ab Sessionstart fest, der Hook liefert es je Turn neu. Eine Session über den Tageswechsel trägt beide Werte gleichzeitig. Maßgeblich ist der Hook-Wert, und das gehört gesagt: Genau dieser Tageswechsel war der auslösende Fehlerfall, und ein unaufgelöster Widerspruch im Kontext ist schlechter als eine einzige Quelle.
- **Fehlt `date` oder eine POSIX-Shell**, schlägt der Hook bei **jedem** Turn fehl und erzeugt je Nachricht eine Fehlermeldung. Das ist schlechter als kein Hook. Die Doku nennt für Shell Form `sh -c` auf macOS und Linux, auf Windows Git Bash, und PowerShell, wenn Git Bash fehlt; unter PowerShell ist `date '+…'` nicht dasselbe Kommando. Deshalb: Befehl vorab in der Shell prüfen, eine Zeile und Exit 0 erwarten, und bei Fehlschlag den Wert nicht setzen.
- **Ungeprüft** bleiben Windows und Linux im Zusammenspiel mit diesem Wert sowie `disableAllHooks` und managed settings, die ihn stumm wirkungslos machen können. `%Y-%m-%d %H:%M:%S %Z` selbst ist POSIX-`date` und GNU-`date` bekannt.

## Was bewusst nicht gesetzt wird

| Key | Grund |
|---|---|
| `autoMode` | Wird aus Projekt- und Local-Settings nicht gelesen. Ein Eintrag dort wäre stumm wirkungslos. |
| `dialogExpiry` | Wird nur aus Nutzer-, managed- und `--settings`-Quellen gelesen. Ein Eintrag in den Projekt-Settings wäre stumm wirkungslos. |
| `language` | Gehört in den Nutzer-Scope: Die Sprache ist eine Eigenschaft der Person, nicht des Repos. Ein Projektwert überschriebe sie für alle Mitwirkenden. |
| Lesende git-Formen | `git status`, `git log`, `git diff` gehören zum eingebauten Read-only-Satz und laufen ohne Prompt. Eine eigene Allow-Regel wäre Redundanz — `Bash(git *)` deckt sie ohnehin. Nicht „in jedem Fall prompt-frei": Ein unquotiertes Glob-Argument lässt `git` prompten (es könnte zu einem schreibenden Flag expandieren), und `cd <anderes Verzeichnis> && git …` ebenfalls, weil git dort fremde Hooks ausführen könnte. |
| `Read(**)` fürs Projekt | Lesen innerhalb des Working Directory braucht ohnehin keine Permission. |
| `.env` in `deny` | Eine deny-Regel kennt keine Ausnahme. `Read(//**/.env)` sperrte auch die `.env` des Projekts, an dem gerade gearbeitet wird. |
| `WebSearch(...)` mit Specifier | Der Key akzeptiert keinen; nur der bare Eintrag existiert. |

## Pfad-Präfixe

Vier Formen, nicht mischbar:

| Form | Anker |
|---|---|
| `//pfad` | Filesystem-Root |
| `~/pfad` | Home-Verzeichnis |
| `/pfad` | Quelle der Settings-Datei — bei Projekt-Settings der Projekt-Root, bei `settings.local.json` dagegen das **Startverzeichnis** von Claude Code (ab 2.1.211). In einer Sitzung, die im Repo-Root startet, fällt beides zusammen; in einem Worktree nicht. |
| `pfad`, `./pfad` | aktuelles Verzeichnis |

Eine Mischform wie `//~/Library/…` wird als absoluter Pfad `/~/Library/…` gelesen und trifft nichts. Sie erzeugt keinen Fehler — die Regel ist einfach stumm wirkungslos. Deshalb steht der Keychain-Eintrag als `~/Library/Keychains/**`, alle übrigen deny-Einträge filesystem-weit als `//**/…`.

Pfadregeln werden nur für `Read` und `Edit` ausgewertet. Ein Pfad an `Write`, `Glob` oder `NotebookEdit` wird angenommen, nie konsultiert, und löst eine Startup-Warnung aus.

## Workspace-Trust

`permissions.allow` aus einer Projekt-`.claude/settings.json` gewährt Capability und wird deshalb erst angewendet, nachdem der Nutzer den Workspace-Trust-Dialog für diesen Ordner angenommen hat; der Dialog listet die Regeln vorher auf. `deny` und `ask` schränken nur ein und greifen sofort.

Trust wird pro Workspace gespeichert, gekeyt auf den git-Repo-Root, außerhalb eines Repos auf das Startverzeichnis. Im Home-Verzeichnis gilt er nur für die laufende Sitzung. In einer `claude -p`- oder SDK-Session erscheint der Dialog nie, dort greifen die allow-Regeln also nicht.

**Für den Bericht:** Direkt nach dem Schreiben sind die Einschränkungen aktiv, die Erleichterungen noch nicht. Ohne diesen Hinweis wirkt der Skill fehlgeschlagen.

**Die Übernahme aus `settings.local.json` verschiebt allow-Regeln in den trust-pflichtigen Scope.** `.claude/settings.local.json` gehört dem Nutzer und nicht dem Repository; ihre allow-Regeln greifen deshalb **ohne** den Trust-Schritt. Wandert eine solche Regel bei der Kandidaten-Übernahme in `.claude/settings.json`, gilt sie erst nach angenommenem Trust-Dialog — sie wird durch den Umzug also kurzzeitig schwächer, nicht stärker. Das ist der Preis dafür, sie mit dem Team zu teilen, und gehört beim Vorlegen der Kandidaten gesagt. (Liefert das Repository die `settings.local.json` selbst aus, etwa weil sie eingecheckt wurde, gilt Trust ohnehin auch für sie.)

## Geschützte Pfade — `.claude` und `.git`

Schreibzugriffe auf eine feste Liste von Pfaden werden nie vorab genehmigt: `.git`, `.config/git`, `.vscode`, `.idea`, `.husky`, `.cargo`, `.devcontainer`, `.yarn`, `.mvn` und `.claude` (ausgenommen `.claude/worktrees`). In `default` und `acceptEdits` prompten sie, im Auto mode gehen sie an den Klassifikator, unter `dontAsk` werden sie abgelehnt, unter `bypassPermissions` erlaubt.

**Die Schutzprüfung läuft vor der Auswertung der allow-Regeln.** Ein Eintrag wie `Edit(.claude/**)` hebt sie deshalb nicht auf, in keiner Settings-Datei. Praktische Folge für diesen Skill: Er schreibt selbst `.claude/settings.json` und löst damit einen Prompt aus, den keine Freigabe im Voraus abnimmt — das ist kein Fehlschlag und keine fehlende Berechtigung. Der Prompt bietet **„Yes, and allow Claude to edit its own settings for this session"**; diese Wahl gilt für die restliche Sitzung und erspart die Rückfrage bei jedem weiteren `.claude/`-Schreibzugriff.

## Was die deny-Liste nicht abdeckt

Die `Read(…)`-Einträge schützen die Datei-Tools, nicht die Shell. `ls`, `cat`, `echo`, `pwd`, `head`, `tail`, `grep`, `find`, `wc`, `which`, `diff`, `stat`, `du`, `cd` und die lesenden git-Formen gehören zum eingebauten Read-only-Bash-Satz, der in jedem Modus ohne Prompt läuft und nicht konfigurierbar ist. Der dokumentierte Weg, für ein solches Kommando doch einen Prompt zu erzwingen, ist genau eine `ask`- oder `deny`-Regel — daher die sechs `Bash(cat …)`-Einträge im selben Array.

Das ist **kein vollständiger Schutz**, aber die Lücke ist kleiner, als sie klingt — die beiden Fälle sind zu trennen:

- **Prompt-frei und damit wirklich offen** ist nur, was im Read-only-Satz steht: `head ~/.ssh/id_rsa`, `tail`, `grep` und `find` über dieselben Pfade laufen ungefragt.
- **Nicht prompt-frei**, weil nicht im Satz enthalten, sind `base64`, `xxd`, `od`, `strings` und jedes Skript: Sie sind von keiner deny-Regel gedeckt, prompten aber, weil der Kanon keine allgemeine `Bash`-Freigabe erteilt — allow enthält an Bash-Regeln nur `Bash(git *)` und `Bash(date:*)`.

Eine vollständige Aufzählung wäre eine Blacklist, die nie fertig wird; die Herstellerdoku warnt ausdrücklich, dass Bash-Regeln, die Argumente einschränken sollen, brüchig sind. Zwei Mechaniken verschieben die Grenze noch: Vor dem Abgleich werden Wrapper wie `timeout`, `nice`, `nohup`, `command` und flagloses `xargs` abgestreckt, `xargs cat ~/.ssh/id_rsa` fällt also unter die deny-Regel. Umgebungsrunner wie `npx`, `docker exec` oder `devbox run` werden **nicht** abgestreckt und führen an ihr vorbei. Der Riegel deckt den naheliegendsten Weg ab; die eigentliche Schranke bleibt, dass solche Dateien ohne Anlass nicht gelesen werden. Nenne die Grenze im Bericht, statt einen Schutz zu suggerieren, den die Konfiguration nicht leistet.

## Was die deny-Liste zusätzlich abdeckt

Umgekehrt wirkt sie an einer Stelle weiter als geschrieben: Eine `Read`-deny-Regel blockiert auf demselben Pfad auch **Edit und Write**, das Anlegen einer neuen Datei eingeschlossen — die Tools müssten den Inhalt zurücklesen können. Die dreizehn `Read(…)`-Einträge verhindern also nicht nur das Lesen von Schlüsseln und Credentials, sondern auch ihr Überschreiben. Das ist erwünscht und trotzdem nennenswert, weil es aus dem Regeltext nicht hervorgeht. Zwei Vorbehalte: `NotebookEdit` ist davon nicht erfasst (dafür bräuchte es eine eigene `Edit`-deny-Regel), und die Erweiterung setzt Claude Code ≥ 2.1.208 für Edits und ≥ 2.1.228 für Writes voraus.

## Bewusst offene Lücke bei git

`Bash(git restore *)` und `Bash(git checkout -- *)` stehen **nicht** in der ask-Liste und laufen unter `Bash(git *)` ungefragt, obwohl beide uncommittete Arbeit unwiederbringlich löschen — sachlich dieselbe Klasse wie `git clean`.

Sie bleiben draußen, weil `git restore` der dokumentierte Rückweg aus einem Fehlversuch ist; eine ask-Regel unterbräche den Rückweg bei jedem Gebrauch mit einer Rückfrage. Die Regelsyntax kann „restore gegen einen Commit" nicht von „restore über uncommittete Arbeit" trennen. Der Schutz liegt damit außerhalb der Konfiguration, in der Arbeitsweise: ein funktionierender Stand ist committet, bevor großflächig umgeschrieben wird. Ob das Zielprojekt diese Regel führt, weißt du nicht — nenne die Lücke im Bericht und sag dazu, dass sie genau darauf angewiesen ist, damit sie eine sichtbare Entscheidung bleibt und keine Auslassung.

## Regelsyntax, kurz

- `Bash(x *)` mit Leerzeichen vor dem Stern erzwingt Wortgrenze **oder** Zeilenende: `Bash(git push *)` trifft auch `git push` ohne Argumente. Ohne Leerzeichen (`Bash(ls*)`) trifft es auch `lsof`.
- `:*` am Ende ist gleichbedeutend mit ` *`. Nur am Ende erkannt.
- Eine `deny`-Regel schlägt jede `allow`-Regel, auch die spezifischere — es gibt keinen Ausnahme-Mechanismus. Eine `ask`-Regel schlägt ebenso jede `allow`-Regel und prompt auch in `bypassPermissions` und im Auto mode.
- Regeln gelten je Subkommando: `Bash(git *)` erlaubt nicht `git log && rm -rf /`.
- Permission-Regeln **mergen** über Scopes hinweg, statt sich zu überschreiben. Eine Nutzer-Regel gilt im Projekt bereits; sie dorthin zu kopieren erzeugt eine Doppelung.
- Ein bloßer Dateiname folgt gitignore-Semantik: `Read(.netrc)` und `Read(**/.netrc)` sind gleichbedeutend und greifen ab dem aktuellen Verzeichnis abwärts. Filesystem-weit wird daraus erst `Read(//**/.netrc)`, und genau deshalb steht die deny-Liste in dieser Form.
- Ein einzelnes relatives Verzeichnissegment trifft je nach Regeltyp verschieden tief: `Edit(src/**)` als **allow** nur `<cwd>/src`, dasselbe Muster als **deny** oder **ask** ein `src` in beliebiger Tiefe. Die schärfere Auslegung gilt also dort, wo sie schützt.
- **Beim Wechsel in den Auto mode werden breite allow-Regeln verworfen**, die beliebige Codeausführung gewähren: pauschales `Bash(*)`, wildcardierte Interpreter wie `Bash(python*)`, Package-Manager-Run-Kommandos und `Agent`-Regeln. `Bash(git *)` aus diesem Kanon fällt unter keine der vier Kategorien und bleibt wirksam — es sei denn, `autoMode.classifyAllShell` steht auf `true`, was jede Bash-allow-Regel im Auto mode aussetzt.

# Der Settings-Kanon

Adressatenhinweis: Diese Datei ist Nachschlagewerk für dich beim Ausführen von `project-settings`. Die JSON-Blöcke wandern in die Zieldateien, der Fließtext nicht.

## Inhalt
- Projekt: `.claude/settings.json` — die zu setzenden Werte
- Was bewusst nicht gesetzt wird — und warum
- Pfad-Präfixe — `//`, `~/`, `/`, `./` und stumme Mischformen
- Workspace-Trust — wann `allow` greift, und was die Kandidaten-Übernahme daran ändert
- Geschützte Pfade — `.claude` und `.git`, gegen die keine allow-Regel hilft
- Was die deny-Liste nicht abdeckt — Read-Tool statt Shell
- Was die deny-Liste zusätzlich abdeckt — Read-deny sperrt auch Edit und Write
- Bewusst offene Lücke bei git
- Regelsyntax, kurz

Stand der Belege: an der Herstellerdoku nachgeprüft am 16. August 2026 (`code.claude.com/docs/en/` — `permissions`, `permission-modes`, `settings`, `tools-reference`).

## Projekt: `.claude/settings.json`

```jsonc
{
  "autoMemoryEnabled": false,
  "permissions": {
    "allow": [
      "WebSearch",
      "WebFetch(domain:*)",
      "Bash(git *)",
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
- **Nicht prompt-frei**, weil nicht im Satz enthalten, sind `base64`, `xxd`, `od`, `strings` und jedes Skript: Sie sind von keiner deny-Regel gedeckt, prompten aber, weil der Kanon keine allgemeine `Bash`-Freigabe erteilt — allow enthält nur `Bash(git *)`.

Eine vollständige Aufzählung wäre eine Blacklist, die nie fertig wird; die Herstellerdoku warnt ausdrücklich, dass Bash-Regeln, die Argumente einschränken sollen, brüchig sind. Zwei Mechaniken verschieben die Grenze noch: Vor dem Abgleich werden Wrapper wie `timeout`, `nice`, `nohup`, `command` und flagloses `xargs` abgestreckt, `xargs cat ~/.ssh/id_rsa` fällt also unter die deny-Regel. Umgebungsrunner wie `npx`, `docker exec` oder `devbox run` werden **nicht** abgestreckt und führen an ihr vorbei. Der Riegel deckt den naheliegendsten Weg ab; die eigentliche Schranke bleibt, dass solche Dateien ohne Anlass nicht gelesen werden. Nenne die Grenze im Bericht, statt einen Schutz zu suggerieren, den die Konfiguration nicht leistet.

## Was die deny-Liste zusätzlich abdeckt

Umgekehrt wirkt sie an einer Stelle weiter als geschrieben: Eine `Read`-deny-Regel blockiert auf demselben Pfad auch **Edit und Write**, das Anlegen einer neuen Datei eingeschlossen — die Tools müssten den Inhalt zurücklesen können. Die dreizehn `Read(…)`-Einträge verhindern also nicht nur das Lesen von Schlüsseln und Credentials, sondern auch ihr Überschreiben. Das ist erwünscht und trotzdem nennenswert, weil es aus dem Regeltext nicht hervorgeht. Zwei Vorbehalte: `NotebookEdit` ist davon nicht erfasst (dafür bräuchte es eine eigene `Edit`-deny-Regel), und die Erweiterung setzt Claude Code ≥ 2.1.208 für Edits und ≥ 2.1.228 für Writes voraus.

## Bewusst offene Lücke bei git

`Bash(git restore *)` und `Bash(git checkout -- *)` stehen **nicht** in der ask-Liste und laufen unter `Bash(git *)` ungefragt, obwohl beide uncommittete Arbeit unwiederbringlich löschen — sachlich dieselbe Klasse wie `git clean`.

Sie bleiben draußen, weil `git restore` der dokumentierte Rückweg aus einem Fehlversuch ist; eine ask-Regel unterbräche die Notbremse bei jedem Gebrauch. Die Regelsyntax kann „restore gegen einen Commit" nicht von „restore über uncommittete Arbeit" trennen. Der Schutz liegt damit außerhalb der Konfiguration, in der Arbeitsweise: ein funktionierender Stand ist committet, bevor großflächig umgeschrieben wird. Ob das Zielprojekt diese Regel führt, weißt du nicht — nenne die Lücke im Bericht und sag dazu, dass sie genau darauf angewiesen ist, damit sie eine sichtbare Entscheidung bleibt und keine Auslassung.

## Regelsyntax, kurz

- `Bash(x *)` mit Leerzeichen vor dem Stern erzwingt Wortgrenze **oder** Zeilenende: `Bash(git push *)` trifft auch `git push` ohne Argumente. Ohne Leerzeichen (`Bash(ls*)`) trifft es auch `lsof`.
- `:*` am Ende ist gleichbedeutend mit ` *`. Nur am Ende erkannt.
- Eine `deny`-Regel schlägt jede `allow`-Regel, auch die spezifischere — es gibt keinen Ausnahme-Mechanismus. Eine `ask`-Regel schlägt ebenso jede `allow`-Regel und prompt auch in `bypassPermissions` und im Auto mode.
- Regeln gelten je Subkommando: `Bash(git *)` erlaubt nicht `git log && rm -rf /`.
- Permission-Regeln **mergen** über Scopes hinweg, statt sich zu überschreiben. Eine Nutzer-Regel gilt im Projekt bereits; sie dorthin zu kopieren erzeugt eine Doppelung.
- Ein bloßer Dateiname folgt gitignore-Semantik: `Read(.netrc)` und `Read(**/.netrc)` sind gleichbedeutend und greifen ab dem aktuellen Verzeichnis abwärts. Filesystem-weit wird daraus erst `Read(//**/.netrc)`, und genau deshalb steht die deny-Liste in dieser Form.
- Ein einzelnes relatives Verzeichnissegment trifft je nach Regeltyp verschieden tief: `Edit(src/**)` als **allow** nur `<cwd>/src`, dasselbe Muster als **deny** oder **ask** ein `src` in beliebiger Tiefe. Die schärfere Auslegung gilt also dort, wo sie schützt.
- **Beim Wechsel in den Auto mode werden breite allow-Regeln verworfen**, die beliebige Codeausführung gewähren: pauschales `Bash(*)`, wildcardierte Interpreter wie `Bash(python*)`, Package-Manager-Run-Kommandos und `Agent`-Regeln. `Bash(git *)` aus diesem Kanon fällt unter keine der vier Kategorien und bleibt wirksam — es sei denn, `autoMode.classifyAllShell` steht auf `true`, was jede Bash-allow-Regel im Auto mode aussetzt.

# Der Settings-Kanon

Adressatenhinweis: Diese Datei ist Nachschlagewerk für dich beim Ausführen von `project-settings`. Die JSON-Blöcke wandern in die Zieldateien, der Fließtext nicht.

## Projekt: `.claude/settings.json`

```jsonc
{
  "autoMemoryEnabled": false,
  "plansDirectory": "./plans",
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
| `language` | Steht bereits in den Nutzer-Settings und wirkt. Ein Projektwert wäre die Doppelung, die dieser Skill vermeiden soll. |
| Lesende git-Formen | `git status`, `git log`, `git diff` gehören zum eingebauten Read-only-Satz und laufen in jedem Modus prompt-frei. Eine Allow-Regel wäre wirkungslose Redundanz. |
| `Read(**)` fürs Projekt | Lesen innerhalb des Working Directory braucht ohnehin keine Permission. |
| `.env` in `deny` | Eine deny-Regel kennt keine Ausnahme. `Read(//**/.env)` sperrte auch die `.env` des Projekts, an dem gerade gearbeitet wird. |
| `WebSearch(...)` mit Specifier | Der Key akzeptiert keinen; nur der bare Eintrag existiert. |

## Pfad-Präfixe

Vier Formen, nicht mischbar:

| Form | Anker |
|---|---|
| `//pfad` | Filesystem-Root |
| `~/pfad` | Home-Verzeichnis |
| `/pfad` | Quelle der Settings-Datei (bei Projekt-Settings der Projekt-Root) |
| `pfad`, `./pfad` | aktuelles Verzeichnis |

Eine Mischform wie `//~/Library/…` wird als absoluter Pfad `/~/Library/…` gelesen und trifft nichts. Sie erzeugt keinen Fehler — die Regel ist einfach stumm wirkungslos. Deshalb steht der Keychain-Eintrag als `~/Library/Keychains/**`, alle übrigen deny-Einträge filesystem-weit als `//**/…`.

Pfadregeln werden nur für `Read` und `Edit` ausgewertet. Ein Pfad an `Write`, `Glob` oder `NotebookEdit` wird angenommen, nie konsultiert, und löst eine Startup-Warnung aus.

## Workspace-Trust

`permissions.allow` aus einer Projekt-`.claude/settings.json` gewährt Capability und wird deshalb erst angewendet, nachdem der Nutzer den Workspace-Trust-Dialog für diesen Ordner angenommen hat; der Dialog listet die Regeln vorher auf. `deny` und `ask` schränken nur ein und greifen sofort.

Trust wird pro Workspace gespeichert, gekeyt auf den git-Repo-Root, außerhalb eines Repos auf das Startverzeichnis. Im Home-Verzeichnis gilt er nur für die laufende Sitzung. In einer `claude -p`- oder SDK-Session erscheint der Dialog nie, dort greifen die allow-Regeln also nicht.

**Für den Bericht:** Direkt nach dem Schreiben sind die Einschränkungen aktiv, die Erleichterungen noch nicht. Ohne diesen Hinweis wirkt der Skill fehlgeschlagen.

## Was die deny-Liste nicht abdeckt

Die `Read(…)`-Einträge schützen das Read-Tool, nicht die Shell. `cat`, `head`, `tail`, `grep` und `find` gehören zum eingebauten Read-only-Bash-Satz, der in jedem Modus ohne Prompt läuft und nicht konfigurierbar ist. Der dokumentierte Weg, für ein solches Kommando doch einen Prompt zu erzwingen, ist genau eine `ask`- oder `deny`-Regel — daher die sechs `Bash(cat …)`-Einträge im selben Array.

Das ist **kein vollständiger Schutz**: `head`, `tail`, `grep`, `base64`, `xxd` und jede Umleitung über ein Skript bleiben offen. Eine vollständige Aufzählung wäre eine Blacklist, die nie fertig wird. Der Riegel deckt den naheliegendsten Weg ab; die eigentliche Schranke bleibt, dass solche Dateien ohne Anlass nicht gelesen werden. Nenne die Grenze im Bericht, statt einen Schutz zu suggerieren, den die Konfiguration nicht leistet.

## Bewusst offene Lücke bei git

`Bash(git restore *)` und `Bash(git checkout -- *)` stehen **nicht** in der ask-Liste und laufen unter `Bash(git *)` ungefragt, obwohl beide uncommittete Arbeit unwiederbringlich löschen — sachlich dieselbe Klasse wie `git clean`.

Sie bleiben draußen, weil `git restore` der dokumentierte Rückweg aus einem Fehlversuch ist; eine ask-Regel unterbräche die Notbremse bei jedem Gebrauch. Die Regelsyntax kann „restore gegen einen Commit" nicht von „restore über uncommittete Arbeit" trennen. Der Schutz liegt damit bei der Regel, vor großflächigem Umschreiben einen funktionierenden Stand zu committen. Nenne die Lücke im Bericht, damit sie eine sichtbare Entscheidung bleibt und keine Auslassung.

## Regelsyntax, kurz

- `Bash(x *)` mit Leerzeichen vor dem Stern erzwingt Wortgrenze **oder** Zeilenende: `Bash(git push *)` trifft auch `git push` ohne Argumente. Ohne Leerzeichen (`Bash(ls*)`) trifft es auch `lsof`.
- `:*` am Ende ist gleichbedeutend mit ` *`. Nur am Ende erkannt.
- Eine `deny`-Regel schlägt jede `allow`-Regel, auch die spezifischere — es gibt keinen Ausnahme-Mechanismus. Eine `ask`-Regel schlägt ebenso jede `allow`-Regel und prompt auch in `bypassPermissions` und im Auto mode.
- Regeln gelten je Subkommando: `Bash(git *)` erlaubt nicht `git log && rm -rf /`.
- Permission-Regeln **mergen** über Scopes hinweg, statt sich zu überschreiben. Eine Nutzer-Regel gilt im Projekt bereits; sie dorthin zu kopieren erzeugt eine Doppelung.
- Ein bloßer Dateiname folgt gitignore-Semantik: `Read(//**/.netrc)` trifft jede `.netrc` auf dem Dateisystem.

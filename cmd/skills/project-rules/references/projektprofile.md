# Projektprofile — die fünf Denkhilfen

Diese Datei gehört zu Schritt 2 von `/cmd:project-rules`. Sie ist **Arbeitsanweisung an dich**, kein Zieltext: Nichts hieraus wird in die gehärtete Datei kopiert. Sie lädt selbst keine weitere Datei.

Die Profile sind **Denkhilfen, keine starren Tabellen**: Prüfe jede Zuordnung gegen das konkrete Projekt und weiche begründet ab, wenn es passt.

| Projektart | Kern (gründlich übernehmen) | Situativ (nur bei Anlass) |
|---|---|---|
| **Software/Coding (Mensch im Loop)** | Aufgabenzerlegung, Ausführung (inkl. Build/Test/Lint), Fehler, Sprache | Sicherheit: commit/push/Geheimnisse ja, MCP/Deploy nur bei Evidenz · Kontext bei großem Repo · Ablage ab mehreren Mitwirkenden oder langer Laufzeit; Artefakte *anlegen* dann, die Regel dafür schon ab langer Laufzeit |
| **Autonomer Agent / agentisches System** | Sicherheit, Fehler, Kontext, Ausführung, Ablage | Aufgabenzerlegung je nach Aufgabenkomplexität · Artefakte, sobald Abläufe sich wiederholen · Sprache, sobald das System selbst Code schreibt |
| **Daten / Analyse / Research** | Ausführung (v. a. keine Erfindung), Kontext, Ablage (Befunde überleben die Session) | Zerlegung · Sicherheit v. a. Datenabfluss/Geheimnisse · Fehler geringer · Artefakte für wiederkehrende Auswertungen · Sprache bei Bezeichnern in Notebooks und Skripten |
| **Infrastruktur / DevOps** | Sicherheit (Deploy, CI, Secrets), Fehler (Rollback), Artefakte (Runbooks als Skill), Sprache (Branch-Namen, Konfig-Schlüssel, DB-Spalten) | Zerlegung, Ausführung · Kontext bei großen Systemen · Ablage v. a. für Entscheidungen |
| **Bibliothek / Framework** | Ausführung, Aufgabenzerlegung, Ablage (Entscheidungen und öffentliche Doku), Sprache (öffentliche API-Namen wiegen hier am schwersten) | Fehler/Kontext situativ · Sicherheit v. a. Secrets/geringste Rechte · Artefakte *anlegen* selten nötig, die Regel dafür trotzdem ab langer Laufzeit |

Passt keine Zeile, beschreibe das Profil in eigenen Worten anhand derselben Frage: *Handelt der Agent selbstständig nach außen? Läuft er lang? Berührt er Geheimnisse/Deploys? Wird gebaut und getestet?* Daraus folgt, welche Disziplinen tragen.

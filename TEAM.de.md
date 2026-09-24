[English](TEAM.md) · [Українська](TEAM.uk.md) · Deutsch

# Arbeitsprinzipien des Teams

Arbeitsprinzipien des Agenten-Teams: was das Projekt vor dem Zerfall bewahrt, wie eine Mission abläuft, wer schreibt und wer prüft.

## Missionskette

```
Nutzer -> Tech Lead: Anfrage
  -> Tech Lead: Datensammlung + Befragung
  -> Tech Lead: Vertrag -> Freigabe durch den Nutzer
  -> Developer: Code
  -> Checker: Regressionen und Konsistenz   (Schleife Developer <-> Checker, bis alles sauber ist)
  -> Reviewer: Scope-Review (bei großen Änderungen)
  -> Tester: Testvorbereitung (vor dem Deploy)
  -> Developer: Schritt-für-Schritt-Anleitung für den Deploy
  -> Nutzer: deployt von Hand nach der Anleitung, erhält das Ergebnis
  -> Tester: Testlauf nach dem Deploy (automatisiert + für den Nutzer, B/C)
  -> Nutzer: führt die abschließenden Tests durch (B/C)
```

## Rollen

Eine Rolle ist ein Agent mit eigener Spezialisierung und Anweisung; je komplexer das Projekt, desto mehr Rollen (einem einfachen reichen ein paar, ein komplexes braucht alle). Manche Rollen ändern Dateien (schreibende), manche prüfen nur (lesende) - ändern darf immer nur eine zur gleichen Zeit, lesende sind ungefährlich und laufen parallel. Die Ausnahme ist der Tester auf der Produktion: Seine Anfragen erreichen die Live-Site, daher arbeitet er in dieser Zeit allein.

Die Rollen in `team/roles/` sind ein funktionierendes Muster für PHP auf Shared Hosting. Die Prinzipien unten lassen sich unverändert auf jedes Projekt übertragen, und die Stack-Regeln der Rollen werden mit dem Skill `new-role` für Ihren eigenen Stack umgeschrieben.

- **Tech Lead** (schreibend) - Koordinator; in einer Mission der Einzige, der mit dem Nutzer spricht (das ist eine Empfehlung: Bei Bedarf arbeitet der Nutzer direkt mit jeder Rolle, ohne den Tech Lead), erstellt den Vertrag, verteilt Aufgaben, bewertet Berichte.
- **Developer** (schreibend) - setzt Code gemäß der Aufgabe um, strikt in den ihm übergebenen Dateien.
- **Architect** (schreibend) - entwirft die Architektur und pflegt ihr Dokument; fasst Produktionscode nicht an.
- **Checker** (lesend) - sucht nach dem Developer nach Regressionen, Abweichungen von Patterns und Unstimmigkeiten (Konsistenz): Das Neue weicht nicht von dem ab, was bereits existiert.
- **Reviewer** (lesend) - abschließendes Review: Sicherheit und Struktur.
- **Tester** (lesend) - plant und führt Tests nach dem Deploy durch; auf der Produktion macht er selbst nur Prüfungen ohne Folgen und läuft nicht parallel zu anderen.
- **Researcher** (lesend) - sammelt Informationen aus dem Web und aus Dateien.

Wen wann starten - `team/ROLES.md`. Wie starten - `team/RUN.md`.

## Tragende Elemente

Tragende Elemente sind das, was das Projekt vor dem Zerfall bewahrt. Je größer es ist, desto leichter zerfällt es: Kontext geht verloren, Entscheidungen verschwimmen, die Arbeit läuft auseinander. Desto mehr tragende Elemente braucht es, um es zusammenzuhalten. Die Auswahl wird pro Projekt getroffen - einer kleinen Aufgabe reichen ein paar, eine große braucht alle; wie viele genommen werden, entscheidet der Tech Lead zu Beginn, bei der Datensammlung.

- **Vertrag** - legt fest, was wir als Ergebnis bekommen und wie wir es abnehmen.
- **Architektur** - Grenzen, Schichten, Verbindungen.
- **Team** - Rollenbeschreibungen für Agenten: von einer Rolle bis zu vielen.
- **Pläne** - für Arbeiten, Entwicklung, Tests.
- **Patterns** - der Kanon des „Wie“: Benennung, Aufbau, welche Methode. Einem einfachen Projekt reicht eine einzige `PATTERNS.md`, ein komplexes braucht Sets nach Rollen oder nach Schichten (`patterns/<name>.patterns.md`); was angelegt wird, entscheidet der Tech Lead.
- **Sicherheit** - Regeln für sicheren Code.

## Gates

Ein Gate ist ein Punkt, über den die Arbeit nicht hinausgeht, bis sie geprüft wurde. So wandert ein Fehler nicht weiter die Kette entlang.

- **Vertrag** - die Arbeit beginnt nicht, bis Sie freigegeben haben, was Sie bekommen und wie es geprüft wird.
- **Checker** - Code geht nicht weiter, bis er auf Fehler, Unstimmigkeiten und Konsistenz geprüft wurde.
- **Reviewer** - eine große Änderung wird nicht ohne Sicherheits-Review abgeschlossen.
- **Tester** - das Ergebnis wird nicht ohne Tests abgenommen.
- **Deploy** - gilt nicht als erledigt, bis der Code ausgerollt ist und funktioniert.

Wann ein Gate übersprungen werden kann, entscheidet der Tech Lead anhand der Bedingungen in `team/workflow.md` („When to skip a step“).

## Grundregeln

- **Einer ändert, viele prüfen.** Dateien bearbeitet immer nur eine Rolle zur gleichen Zeit, die prüfenden Rollen arbeiten parallel: Zwei bearbeitende Rollen würden gegenseitig ihre Arbeit überschreiben.
- **Sie sprechen mit dem Tech Lead.** Er kommt nur mit einem Blocker, einem Schritt außerhalb des Vertrags oder einer Entscheidung, die bei Ihnen liegt, zu Ihnen.
- **Das Team ändert seine eigenen Anweisungen** (`team/`) nicht ohne Ihre Zustimmung.
- **Eine Mission ist abgeschlossen, wenn der Vertrag abgeschlossen und der Plan aktualisiert ist.** Sonst weiß der nächste Chat nicht, dass die Arbeit bereits erledigt ist.

## Kontext des Tech Lead

Die Regeln werden zu Beginn der Session in den Tech Lead geladen, und bis zur Mitte des Kontexts vergisst er sie. Wenn Sie sehen, dass er sie vergisst - lassen Sie ihn seine Rolle erneut lesen (`team/roles/techlead.md`) und bitten Sie ihn zu sagen, was er gerade tut und wo er einen Fehler gemacht hat. Er muss seine Fehler selbst aufarbeiten.

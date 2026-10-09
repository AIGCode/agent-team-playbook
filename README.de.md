[English](README.md) · [Українська](README.uk.md) · Deutsch

# team-playbook - Anleitung

Ich arbeite mit künstlicher Intelligenz, seit es sie gibt, und versuche die ganze Zeit, sie so einzubauen, dass es weniger Arbeit wird oder dass ich mehr schaffe. Weniger Arbeit ist es bisher nicht geworden, aber die Produktivität ist um ein Vielfaches gestiegen.

Das Hauptproblem, mit dem ich gekämpft habe: Chats geben Informationen nicht aneinander weiter. All diese Modi, die den Verlauf beim Wechsel in eine neue Session komprimieren, funktionieren schlecht - irgendetwas geht immer verloren. Deshalb habe ich angefangen, in Projekten zu arbeiten: Alle getroffenen Entscheidungen und Absprachen liegen in den Dateien des Projekts, nicht im Gedächtnis des Chats. Chat geschlossen - nichts ist verloren, ein neuer Chat macht an derselben Stelle weiter.

Dann stieß ich auf das Nächste: Ein Chat stemmt kein großes Projekt als Ganzes. Ich musste die Arbeit an Agenten verteilen - jeder mit seiner eigenen Rolle (Entwickler, Prüfer usw.) - und durchdenken, wie sie einander Daten übergeben. So ist team-playbook entstanden. Alles ist mit einem normalen Claude-Max-5x-Abo (107 Euro im Monat) getestet, und immer mit den neuesten Modellen: Angefangen habe ich mit GPT und Claude, jetzt arbeite ich mit Claude Code und Opus 5.5 in Visual Studio Code. Für alle, die in Cursor arbeiten, gibt es eine eigene Datei `team/RUN_CURSOR.md`: Sie ist eine Anleitung für die KI - danach startet sie die Agenten des Teams mit den Mitteln von Cursor, und die Arbeit selbst läuft genauso.

Welche Aufgaben löse ich so? Von einfachen E-Mail-Verläufen zu einem Thema bis zu komplexen Anwendungen. Zum Beispiel schreibe ich gerade einen Connector zwischen Zoho CRM, Shopify und Reverb (dem führenden Marktplatz für den Wiederverkauf von Gitarren, so etwas wie eBay).

Installieren Sie es und starten Sie Ihr erstes Projekt - unten steht alles Schritt für Schritt.

## Installation

Legen Sie den Ordner `team-playbook/` unter `~/.claude/team-playbook/` ab. Das ist das Framework - ein Quellordner, kein Projekt: Aus ihm nehmen die Skills bei jedem neuen Projekt das Team und die Vorlagen. Sie können ihn auch woanders ablegen - dann fragt `team-init` (es nimmt das Team und die Vorlagen aus dem Framework) nach dem Pfad dorthin. Kopieren Sie die Skills aus `skills/` nach `~/.claude/skills/`, einen Ordner pro Skill.

> Die Rollen-Prompts und die Komplexität der Aufgaben sind auf Modelle der Klasse Opus 4.8 und höher ausgelegt. Bei schwächeren Modellen ist die Qualität nicht garantiert. Das Framework ist für Claude Code geschrieben. Wenn Sie mit einem anderen Tool oder Modell arbeiten, bitten Sie es, im Framework die Abhängigkeiten von Claude Code zu finden und sie an sich selbst anzupassen.

## Erste Schritte

**Es gibt noch kein Projekt.**
1. Grundlegende Recherche: die Ausgangsinformationen zur Aufgabe sammeln.
2. `project-init`: das Projekt anlegen.
3. `team-init`: das Team aufsetzen.
4. `new-role`: wenn Ihr Stack nicht PHP ist - die Rollen für den Stack des Projekts umschreiben.

**Es gibt bereits ein Projekt.**
1. Öffnen Sie einen neuen Chat und geben Sie ihm die `AGENTS.md` des Projekts: „Wir arbeiten in diesem Projekt“.
2. Geben Sie ihm die Rollendatei: „Das ist deine Rolle, sag mir, wie du sie verstanden hast“.
3. Ist es die Rolle des Tech Lead (`team/roles/techlead.md`), berichtet er, wie er die Rolle verstanden hat, und führt die Arbeit gemäß dem Workflow. Ist es eine andere Rolle, ist das eine kurze Arbeit innerhalb des Projekts ohne Tech Lead.

## Lebenszyklus

```
Aufgabe
  -> Recherche: sammeln, was bekannt ist
  -> Projekt: Materialien und Entscheidungen liegen an einem Ort
  -> Team: kommt hinzu, wenn die Aufgabe gewachsen ist
  -> Architektur: wenn es etwas zusammenzuhalten gibt
  -> Missionen im Kreislauf:
       Vertrag -> Arbeit -> Prüfung -> Abnahme -> Abschluss
       (Plan und Entscheidungen des Projekts werden nach jeder aktualisiert)
  -> Projekt abgeschlossen
```

Wurde das Team zurückgestellt - setzen Sie es später mit dem Skill `team-init` auf.

## Was drin ist

- `team/` - das Team-Framework: Rollen (`roles/`), die Missionskette (`workflow.md`), das Starten von Agenten (`RUN.md`), Vorlagen (Vertrag, Aufgabe, Frage an den Nutzer, Deploy, Architektur-Kanon, Sicherheit - `security-template.md` und das PHP-Beispiel `security-example.md`), Bewertung von Berichten. Die Platzhalter (`<project>`, `<app>`, `<SERVER_ROOT>`, `[brief project description]`, „Local environment“ beim Developer und beim Tester) werden für das konkrete Projekt ausgefüllt; ist der Stack des Projekts nicht PHP, reicht das Ausfüllen nicht - die Rollen werden zusätzlich für den Stack umgeschrieben (siehe `TEAM.md`, „Rollen“).
- `skills/` - drei Skills:
  - `project-init` - ein neues Projekt anlegen und organisieren (Dateistruktur).
  - `team-init` - das Team aus dem Framework in einem Projekt aufsetzen.
  - `new-role` - eine neue Rolle im Team anlegen oder eine bestehende für Ihren Stack umschreiben.
- `TEAM.md` - die Arbeitsprinzipien des Teams (vor der ersten Mission lesen).

## Was Sie als Nächstes lesen

1. `README.md` (diese Datei) - was wo liegt.
2. `TEAM.md` - die Prinzipien: Kette, Rollen, Gates, Regeln.
3. `team/roles/` - die Rollen, ein funktionierendes Muster für PHP (developer, checker, reviewer, tester, researcher, architect, techlead); für Ihren Stack werden sie mit dem Skill `new-role` umgeschrieben.
4. `team/workflow.md` und `team/RUN.md` - die Mechanik einer Mission und des Startens.

Von dort aus folgen Sie den Links in diesen Dateien: Wo ein Thema in einem anderen Dokument ausführlicher behandelt wird, steht ein Link darauf.

---

> **Haftungsausschluss.** Die Beispiele und Vorlagen in diesem Set sind illustrativ - es sind keine realen Konfigurationen und keine fertigen „100%“-Lösungen. Für die Sicherheit, die Daten und das Geld Ihrer eigenen Anwendungen sind Sie selbst verantwortlich, und den nötigen Umfang an Regeln stellen Sie selbst zusammen. Prüfen Sie alles für Ihr eigenes Projekt: Ein Fehler kann Sie Daten, Geld oder Ihren Job kosten.

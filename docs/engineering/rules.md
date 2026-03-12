# Flutter Development Rules & Best Practices

## 1. Code-Architektur & Qualität
* **Modularität:** UI-Elemente konsequent in eigene Widgets auslagern. Keine "Monster-Build-Methoden".
* **DRY & KISS:** Vermeide Duplikate, aber verhindere Over-Engineering. Nutze Flutter-Standards vor Eigenlösungen.
* **Logic Separation:** UI (Widgets) strikt von der Logik trennen. Die `build`-Methode bleibt rein deklarativ.
* **Immutability:** Nutze `final` und `const` konsequent für Performance und Vorhersehbarkeit.

## 2. GitHub Workflow & Issue Tracking
* **Issue-Zwang:** Jede Änderung muss einem GitHub Issue zugeordnet sein. Nutze die GitHub CLI (`gh`), um Issues zu verwalten, zu listen oder zu erstellen, falls eine Aufgabe noch nicht dokumentiert ist.
* **Referenzierung:** Verknüpfe Code-Änderungen immer mit der entsprechenden Issue-Nummer.
* **Automatisches Schließen:** Nutze in Commits oder PR-Beschreibungen Closing-Keywords (z.B. `fixes #123`), um den Workflow zu automatisieren.

## 3. Git- & Commit-Disziplin
* **Conventional Commits:** Nutze strikt das Format `type: description` (z.B. `feat:`, `fix:`, `refactor:`, `chore:`).
* **Issue-Integration:** Die Issue-Nummer muss Teil der Commit-Nachricht sein (z.B. `feat: add biometric login (#42)`).
* **Scope-Reinheit:** Ein Commit sollte nur Änderungen enthalten, die zum referenzierten Issue gehören.

## 4. Sicherheit & Fehlerbehandlung
* **Null Safety:** Vermeide Force-Unwraps (`!`). Nutze Type-Checks oder Default-Werte.
* **Async-Stabilität:** Verpflichtendes Error-Handling (`try-catch`) bei allen asynchronen Operationen und API-Calls.
* **Logging:** Nutze professionelle Logging-Lösungen statt `print()` im Produktivcode.

## 5. Coding Style & Dokumentation
* **Semantisches Naming:** Variablen und Methoden müssen ihre Funktion präzise beschreiben.
* **Intents dokumentieren:** Kommentiere das "Warum" hinter komplexen Entscheidungen, nicht das offensichtliche "Was".
* **Dateistruktur:** "One Class Per File"-Prinzip zur Wahrung der Übersichtlichkeit.

# 📋 GitHub Issues Roadmap
_Last updated: 18.03.2026 11:26_
_Sorted by Release and Priority (High > Medium > Low)_

## 🔥 ✨ #2: feat: hardcoded dfl weekend timeline ui [prio: 1, feature] 🏁 [Release 1 (MVP)]
---
**Status / Description:**

Implementation of the central weekend overview. All sessions (Inputs, Tests, Prayer times) are displayed as a clickable list. Content is hardcoded for the MVP to prioritize stability.

---

## 🔥 ✨ #1: feat: project scaffolding & hydrated bloc setup [prio: 1, feature] 🏁 [Release 1 (MVP)]
---
**Status / Description:**

Setup of GoRouter, DFL Theme (Typography/Colors), and Hydrated BLoC for local-first persistence. This ensures all user data remains on the device without a backend (KISS principle).

---

## ⚡ ✨ #3: feat: implement generic editor/result pattern [prio: 2, feature] 🏁 [Release 1 (MVP)]
---
**Status / Description:**

Creation of base components: EditorView (input forms), ResultView (read-only visualization), and the KeyTakeaway widget to capture core insights from each session.

---

## ⚡ ✨ #5: feat: spiritual tests and life tree visualization [prio: 2, feature] 🏁 [Release 1 (MVP)]
---
**Status / Description:**

Implementation of the Spiritual Gifts Test, Values Test, and a basic version of the Life Tree visualization (local logic and storage).

---

## ⚡ ✨ #4: feat: modules for notes, listening prayers and goals [prio: 2, feature] 🏁 [Release 1 (MVP)]
---
**Status / Description:**

Implementation of text-based modules: Notes for inputs, Listening Prayer lists, and personal Goals – all persisted locally.

---

## ⚡ ✨ #6: feat: big picture synthesis matrix and data aggregation [prio: 2, feature]
---
**Status / Description:**

## Beschreibung
Implementierung einer zentralen Synthesis-Ansicht (The Big Picture), die die 'Top 3' Ergebnisse/Takeaways aus allen Modulen aggregiert.

## Anforderungen
- **Daten-Standardisierung:** Sicherstellen, dass alle Module (Life Tree, Gaben, Werte, Prayer) ihre Kern-Ergebnisse im 'Top 3' Format speichern.
- **SynthesisBloc:** Erstellung eines zentralen Blocs, der die Zustände der verschiedenen Modul-Blocs überwacht und konsolidiert.
- **Matrix-Visualisierung:** Implementierung einer MatrixResultView für das Modul 'Entwicklung einer Zukunftsidee', die alle Bausteine übersichtlich darstellt.
- **Integration:** Nutzung des bestehenden DflModuleScaffold Patterns für eine konsistente UX.

## Akzeptanzkriterien
- [ ] Daten werden automatisch aus den Quell-Modulen in die Matrix übernommen.
- [ ] Änderungen in Einzeltests (z.B. Wertetest) spiegeln sich sofort in der Matrix wider.
- [ ] Die Matrix ist als Result-View im Modul 'Zukunftsidee' verfügbar.

---


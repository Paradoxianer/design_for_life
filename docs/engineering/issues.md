# 📋 GitHub Issues Roadmap
_Last updated: 20.03.2026 15:45_
_Sorted by Release and Priority (High > Medium > Low)_

## ⚡ ✨ #11: feat: implement values assessment module [prio: 2, feature] 🏁 [Release 1 (MVP)]
---
**Status / Description:**

## Description
Implement the values assessment module based on the requirements in alues_test.md. This module is a core part of the self-profile and serves as input for the Synthesis Matrix (#6).

## Requirements
- **Phase 1: Rating**
  - Interactive list of values to be rated: 1 (very important), 2 (important), 3 (not important).
  - Validation: Ensure exactly 8 values are marked with '1'.
- **Phase 2: Personal Definitions**
  - Input fields for personal definitions of the top 8 selected values.
- **Phase 3: Reflection & Future Outlook**
  - Implement reflection questions.
  - 'Next Life Phase' matrix to compare current vs. future values.
- **Data Persistence**
  - Integration with SynthesisBloc to share the top 8 values.

## Technical Details
- Follow the DflModuleScaffold pattern.
- Ensure proper localization support (l10n).

---

## ✨ #9: feat: implement seminar feedback form [feature] 🏁 [Release 1 (MVP)]
---
**Status / Description:**

Abschluss-Fragebogen (Rating + Text) für das Ende des Kurses (Wireframe 3.10).

---

## #12: enhance the editor result workflow with a share worflow 🏁 [Release 1 (MVP)]
---
**Status / Description:**

Just fo the MVP we could use a "normale" share package like "share plus" for sharing details.
We could implemtn that in the result view there will be a extra button share in the appbar...
when clicked the user can choose what to share ... and it will then open the normal "share" dialog of the device.

---

## ✨ #10: feat: simple event selection screen [feature] 🏁 [Release 2]
---
**Status / Description:**

Startbildschirm zur Auswahl des DFL-Events (Wireframe 1.0). Geplant für R2.

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

## ✨ #8: feat: simple event selection screen [feature]
---
**Status / Description:**

Startbildschirm zur Auswahl des DFL-Events (verschoben auf R2).

---

## ✨ #7: feat: implement seminar feedback form [feature]
---
**Status / Description:**

Abschluss-Fragebogen (Rating + Text) für das Ende des Kurses.

---


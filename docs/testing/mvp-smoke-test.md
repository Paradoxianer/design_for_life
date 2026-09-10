# MVP Smoke-Test-Checkliste – DFL App

Kurze, manuelle Kernflow-Prüfung vor jedem Pilot-/Release-Build. Deckt nur das ab, was tatsächlich in der App existiert (siehe `docs/requirements/mvp.md` für den verbindlichen Scope) - nicht die ältere, breitere Vision aus `docs/testing/test-plan.md`/`test-cases.md`, die noch Server-/Account-Funktionen beschreibt, die für Release 1 bewusst nicht gebaut werden.

**Nutzung:** Vor jedem Build durchgehen, Ergebnis (✅/❌ + Datum + Build-Version + Plattform) in der Tabelle am Ende eintragen. Ein ❌ bei einem P0-Punkt blockiert den Build (siehe `mvp.md` Abschnitt 9).

## 1. Start & Navigation
- [ ] App startet ohne Absturz, Timeline erscheint als Startbildschirm
- [ ] Alle Module sind über die Timeline erreichbar
- [ ] Bereits erledigte Module sind in der Timeline grün markiert
- [ ] Auf breitem Fenster (Tablet/Desktop, ≥840dp) erscheint die Split-View: Timeline links, Modul rechts; Modulauswahl aktualisiert das rechte Panel korrekt
- [ ] Sprachumschaltung (DE/EN) wirkt sich auf zentrale Texte aus

## 2. Kernmodule (Edit → Result)
Für jedes Modul: Eingabe machen, zu Result wechseln, App neu starten, prüfen dass Daten erhalten bleiben.
- [ ] Notizen
- [ ] Hörendes Gebet
- [ ] Ziele (SMART)
- [ ] Geistesgaben-Test (inkl. Referenz-Einladung/-Import per Link)
- [ ] Werte (alle 3 Phasen: Bewertung, Top-8-Sortierung per Drag&Drop, Reflexion)
- [ ] Persönlichkeitsprofil
- [ ] Imagine
- [ ] Lebensbaum (Notizen/Zeichnungen + digitaler Baum)
- [ ] Verknüpfungen/Synthesis (Karten per Drag&Drop sortierbar)
- [ ] Gruppenfoto
- [ ] Feedbackbogen

## 3. Teilen & Export
- [ ] Teilen-Dialog öffnet sich aus mind. einem Modul, Auswahl funktioniert
- [ ] Bildzentrierte Inhalte (v.a. Lebensbaum) bleiben beim Teilen lesbar, kein Verkleinern in ein starres Template
- [ ] PDF-Abschlussdokument lässt sich erzeugen, Inhalts-Auswahl funktioniert
- [ ] PDF ist lesbar, öffnet sich, Text und Bilder sind vollständig enthalten

## 4. Deep-Links (#49, #42)
- [ ] `?modules=...`-Link beschränkt die Timeline korrekt auf die angegebenen Module
- [ ] Gaben-Referenz-Einladungslink öffnet den externen Mini-Flow
- [ ] Gaben-Referenz-Ergebnislink wird nur importiert, wenn er von diesem Gerät selbst eingeladen wurde (#70)

## 5. Robustheit
- [ ] Kein kritischer RenderOverflow auf einem kleinen Smartphone-Display (z.B. 360×640)
- [ ] App funktioniert vollständig im Flugmodus (Offline-Check)
- [ ] Rotation/Fenstergrößenänderung führt zu keinem Absturz

---

## Testprotokoll

| Datum | Build-Version | Plattform | Ergebnis | Bekannte Mängel (nicht blockierend) |
|---|---|---|---|---|
| | | | | |

# Maintenance and Support – DFL App

## 1. Systemüberwachung (Monitoring)
- **Verfügbarkeit:** Die Backend-API sollte während aktiver DFL-Wochenenden überwacht werden.
- **Fehler-Logging:** Einsatz von Sentry oder Firebase Crashlytics zur Erfassung von Laufzeitfehlern.

## 2. Backup & Recovery
- **Datenbank-Backups:** Täglich automatisierte, verschlüsselte Backups.
- **Wiederherstellung:** Fokus auf die Konsistenz der geteilten Daten (Eindrücke, Kleingruppen-Zuweisungen).

## 3. Synchronisations-Strategie
- **Persönliche Daten:** (Lebensbaum, Notizen, Testergebnisse) werden primär für den Nutzer synchronisiert, damit er auf verschiedenen Geräten darauf zugreifen kann. Diese Daten bleiben Eigentum des Nutzers.
- **Geteilte Daten:** (Hörendes Gebet, Feedback, freigegebene Zusammenfassungen) werden über das Backend an die jeweiligen Empfänger (Leiter/Teilnehmer) verteilt.

## 4. Fehlerbehebung (Troubleshooting)
- **Sync-Probleme:** Prüfen der Internetverbindung. Manueller Sync-Trigger in den Einstellungen.
- **Login-Probleme:** Admin kann Magic Links neu versenden.

## 5. Wartungsfenster
- Keine Updates während der Wochenenden (Fr-So), außer bei kritischen Sicherheitslücken.

## 6. Daten-Bereinigung & Privatsphäre (GDPR)
- **Persönliche Reflexionsdaten:** Bleiben für den Nutzer dauerhaft bestehen, da sie Teil seiner persönlichen Reise sind (digitales Journal).
- **Event-spezifische Daten:** Daten, die nur für die Durchführung des Wochenendes relevant sind (z.B. temporäre Kleingruppen-Zuweisungen), können nach 30 Tagen anonymisiert werden.
- **Löschantrag:** Nutzer können jederzeit die Löschung ihres gesamten Profils inkl. aller Reflexionsdaten anfordern.
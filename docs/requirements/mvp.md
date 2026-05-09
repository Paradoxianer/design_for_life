# MVP Definition – DFL App

## 1. Ziel des MVP

Das MVP der DFL App soll eine **arbeitsfähige, lokal nutzbare Teilnehmer-App** für ein Design-for-Life-Wochenende bereitstellen.

Das MVP soll Teilnehmer dabei unterstützen,
- ihren Wochenend-Ablauf zu sehen,
- persönliche Reflexionen festzuhalten,
- ausgewählte Fragebögen auszufüllen,
- Ergebnisse übersichtlich anzusehen,
- Inhalte lokal zu speichern,
- ausgewählte Ergebnisse sinnvoll zu teilen,
- und am Ende ein persönliches Abschlussdokument zu erzeugen.

Das MVP ist **kein vollständiges DFL-Ökosystem**, sondern eine erste verlässliche Produktversion mit Fokus auf **Teilnehmer, Offline-Nutzung und einfache Bedienung**.

---

## 2. Zielgruppe des MVP

### Primäre Zielgruppe
- Teilnehmer eines DFL-Wochenendes

### Sekundäre Zielgruppe
- Leiter und Organisatoren nur indirekt, z. B. über geteilte Ergebnisse oder Feedback-Auswertung außerhalb der App

---

## 3. Produktprinzipien

- **Support, not replace**: Die App unterstützt das Wochenende, ersetzt es nicht.
- **Offline first**: Zentrale Funktionen müssen lokal auf dem Gerät nutzbar sein.
- **Einfachheit vor Vollständigkeit**: Weniger Features, dafür zuverlässig und verständlich.
- **Privatsphäre zuerst**: Persönliche Inhalte bleiben lokal, solange keine bewusste Freigabe erfolgt.
- **Konsistentes Nutzungserlebnis**: Module sollen sich ähnlich bedienen und visuell zusammengehören.
- **Bleibender persönlicher Nutzen**: Die App soll am Ende ein persönliches, weiter nutzbares Ergebnis liefern.

---

## 4. In Scope für das MVP

Die folgenden Funktionen gehören verbindlich zum MVP.

### 4.1 Timeline / Startscreen
- Anzeige des Wochenend-Ablaufs
- Einstiegspunkt in die verfügbaren Module
- sichtbarer Fortschritt bzw. Status pro Modul/Sitzung

### 4.2 Notizen
- Teilnehmer können Notizen pro Session erfassen und speichern
- Notizen bleiben lokal verfügbar
- Notizen können wieder geöffnet und bearbeitet werden

### 4.3 Werte-Modul
- Nutzer können Werte durch den vorgesehenen Flow bearbeiten
- Auswahl, Bewertung, Reflexion und Ergebnisansicht funktionieren stabil
- Ergebnis ist verständlich und visuell konsistent dargestellt

### 4.4 Geistesgaben-Modul
- Fragebogen/Auswahlprozess ist funktional benutzbar
- Ergebnisse werden lokal gespeichert
- Ergebnisansicht ist verständlich und konsistent

### 4.5 Ziele
- Teilnehmer können Ziele erfassen, speichern und wieder anzeigen

### 4.6 Feedback
- Teilnehmer können einen Feedbackbogen ausfüllen
- Eingaben werden lokal gespeichert
- Abschluss ist nachvollziehbar

### 4.7 Lokale Speicherung
- Relevante Eingaben und Ergebnisse bleiben nach App-Neustart erhalten

### 4.8 Mehrsprachige Basis
- App unterstützt die vorhandene Lokalisierungsstruktur
- zentrale Nutzertexte sind übersetzbar
- Layouts bleiben auch mit längeren Texten benutzbar

### 4.9 Teilen ausgewählter Inhalte
- ausgewählte Module können Inhalte teilen
- textzentrierte Inhalte und bildzentrierte Inhalte werden sinnvoll behandelt
- insbesondere beim Lebensbaum darf das Ausgangsbild nicht unbrauchbar verkleinert werden

### 4.10 Persönlicher Abschluss-Export
- Teilnehmer können aus gesammelten Inhalten ein persönliches Abschlussdokument erzeugen
- das Dokument ist für Speichern, Teilen und Drucken geeignet
- Ausgabe erfolgt im MVP als PDF
- Nutzer können auswählen, welche Bereiche aufgenommen werden
- textliche und bildliche Inhalte können gemeinsam exportiert werden

### 4.11 Einheitliches UI-Grundverhalten
- Module nutzen wiedererkennbare Layout- und Navigationsmuster
- wichtige Buttons, Header, Karten und Ergebnisansichten folgen einem konsistenten Stil

---

## 5. Nicht im MVP enthalten

Die folgenden Funktionen sind **ausdrücklich nicht Teil des MVP**, auch wenn sie langfristig sinnvoll sein können.

### 5.1 Accounts und Registrierung
- Account-Erstellung
- Login
- Event-Registrierung
- Nutzerverwaltung

### 5.2 Rollenbasierte Leiter-/Admin-Funktionen
- Gruppenverwaltung
- Admin-Oberflächen
- Teilnehmerlisten für Leiter
- Rechte- und Rollenlogik

### 5.3 Serverbasierte Synchronisation
- automatischer Cloud-Sync
- Event-Backend
- serverseitige Auswertung
- zentrale Datenhaltung für persönliche Inhalte

### 5.4 Komplexe Echtzeit-/Kommunikationsfunktionen
- Relay-Prayer mit Server-Zustellung
- Chat
- Live-Kommunikation

### 5.5 Erweiterte Inhaltsverwaltung
- Material-Upload durch Admins
- servergesteuerte Event-Konfiguration
- komplexe Medienverwaltung

### 5.6 Erweiterte Ergebnis-Features
- Summary Collage
- Präsentationsmodus mit erweiterten Freigaben
- komplexe Sharing- und Freigabe-Workflows
- mehrere frei gestaltbare Export-Templates
- serverseitige Dokumentengenerierung

---

## 6. Qualitätsanforderungen für das MVP

### 6.1 Benutzbarkeit
- Die App muss auf gängigen Smartphone-Größen nutzbar sein
- Kein kritischer RenderOverflow in zentralen Nutzerflows
- Texte, Buttons und Interaktionen müssen verständlich sein

### 6.2 Stabilität
- Kernmodule dürfen bei normaler Nutzung nicht abstürzen
- Fehlerhafte Share-Erzeugung darf nicht den restlichen Flow blockieren
- Fehlerhafte optionale Exportinhalte dürfen keinen vollständigen PDF-Abbruch verursachen
- Eingaben dürfen bei App-Neustart nicht verloren gehen

### 6.3 Konsistenz
- Module sollen ähnliche Navigationsmuster nutzen
- Ergebnisansichten sollen einem gemeinsamen Muster folgen
- Farben, Abstände und Hauptaktionen sollen wiedererkennbar sein
- Abschluss-Export folgt einer klaren, konsistenten Dokumentstruktur

### 6.4 Performance
- Bildschirmwechsel und typische Eingaben sollen flüssig bleiben
- Teilen und lokale Ergebnisdarstellung sollen auf üblichen Geräten in akzeptabler Zeit reagieren
- PDF-Erzeugung soll in angemessener Zeit auf dem Gerät abgeschlossen werden

### 6.5 Datenschutz
- Persönliche Inhalte bleiben lokal auf dem Gerät
- Teilen erfolgt nur bewusst durch den Nutzer
- Es gibt keine unbeabsichtigte automatische Freigabe
- Der PDF-Export wird nur explizit durch den Nutzer erzeugt

### 6.6 Druck- und Exportqualität
- Das Abschlussdokument muss auf typischen Geräten lesbar erzeugt werden
- Seiteninhalte dürfen nicht unkontrolliert abgeschnitten werden
- Bilder müssen sinnvoll eingebettet werden
- Das erzeugte Dokument muss speicherbar und teilbar sein

---

## 7. MVP-Abnahmekriterien

Das MVP gilt als arbeitsfähig, wenn alle folgenden Bedingungen erfüllt sind:

1. Die App startet stabil und zeigt die Timeline als funktionalen Einstieg.
2. Notes, Values, Spiritual Gifts, Goals und Feedback sind ohne Blocker benutzbar.
3. Relevante Eingaben bleiben nach App-Neustart erhalten.
4. Es gibt keine bekannten kritischen RenderOverflow-Probleme auf typischen Smartphone-Displays.
5. Ergebnisansichten sind verständlich und visuell konsistent genug für einen Pilotbetrieb.
6. Teilen funktioniert für die freigegebenen Module reproduzierbar.
7. Beim bildzentrierten Teilen (z. B. Lebensbaum) bleibt das eigentliche Bild lesbar und wird nicht in ein ungeeignetes starres Template gepresst.
8. Ein Nutzer kann ein persönliches Abschlussdokument als PDF aus ausgewählten Inhalten erzeugen.
9. Das PDF ist lesbar, speicherbar, teilbar und grundsätzlich druckbar.
10. Zentrale Texte sind lokalisiert bzw. lokalisierbar.
11. Für die Kernflows existiert eine manuelle Smoke-Test-Checkliste.
12. Bekannte Restmängel sind dokumentiert und blockieren den Pilotbetrieb nicht.

---

## 8. Offene Risiken

- Unklare MVP-Abgrenzung zwischen Teilnehmer-App und vollständigem DFL-System
- UI-Probleme auf kleinen Displays
- Inkonsistente Modul-UX
- Unvollständige fachliche Inhalte in einzelnen Modulen
- technisch zu generische Share-Architektur
- zu geringe Testtiefe vor Pilot-Einsatz
- Export-Layout wird zu komplex, wenn zu viele Sonderfälle gleichzeitig unterstützt werden

---

## 9. Priorisierungsregel

### P0 – Muss vor MVP-Release gelöst sein
- Blockierende UI-Probleme
- unvollständige Kernmodule
- fehlerhafte Persistenz
- unbrauchbare Ergebnisansichten
- kritische Share-Probleme
- kein verlässlich nutzbarer Abschluss-Export

### P1 – Sollte für Pilotbetrieb gelöst sein
- konsistentes Look & Feel
- bessere Modularisierung
- zusätzliche Tests
- saubere UX-Verbesserungen
- robuster und ansprechender PDF-Export

### P2 – Nach MVP / Post-Pilot
- Rollen und Backend
- Sync
- Registrierung
- Admin-Features
- erweiterte Sharing-Modelle
- komplexe Kollagen- oder Präsentationsfunktionen
- mehrere Export-Layouts und Template-Varianten

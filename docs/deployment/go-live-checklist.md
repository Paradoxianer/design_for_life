# Go-Live-Checkliste – DFL App

Zentrale Freigabe-Checkliste für den ersten öffentlichen Build und alle folgenden Releases. Deckt Produkt, QA, Technik und Distribution ab. Vor jedem Release komplett durchgehen; Ergebnis im Protokoll am Ende festhalten.

## 1. Produkt & Scope
- [ ] MVP-Scope ist final abgestimmt (`docs/requirements/mvp.md`, #20)
- [ ] Keine offenen P0-Issues (siehe Priorisierungsregel in `mvp.md` Abschnitt 9)
- [ ] Bekannte P1/P2-Restmängel sind dokumentiert und bewusst akzeptiert

## 2. QA / Kernflow-Validierung
- [ ] MVP-Smoke-Test (`docs/testing/mvp-smoke-test.md`, #31) vollständig durchlaufen, Ergebnis dort protokolliert
- [ ] Reale Gerätetests auf mindestens: 1x kleines Android-Phone, 1x kleines iOS-Phone, 1x Tablet/großes Fenster für die Split-View (#36)
- [ ] Performance-Check auf einem repräsentativen (nicht Top-End-) Gerät: keine spürbaren Ruckler bei Timeline, Gaben-Carousel, Lebensbaum-Zoom, PDF-Erzeugung (#35)
- [ ] Teilen-Flow (Text + Bild) auf mind. einer echten Zielapp (z.B. WhatsApp/Mail) getestet, nicht nur im Simulator/Web
- [ ] PDF-Export auf einem echten Gerät geöffnet und geprüft (nicht nur im Browser-PDF-Viewer)

## 3. Build & Signierung (#37)
- [ ] Android: Release-Keystore vorhanden, Signing-Konfiguration dokumentiert und getestet
- [ ] iOS: Apple-Team-ID, Bundle-ID und Provisioning für Release konfiguriert
- [ ] Web: Deployment-Workflow (GitHub Pages, `.github/workflows/deploy.yml`) läuft grün
- [ ] Debug-Logging ist im Release-Build stumm (#38 - erledigt: `lib/core/utils/app_logger.dart`)
- [ ] Versionsnummer (`pubspec.yaml`) und Build-Nummer wurden nach `docs/deployment/versioning.md` erhöht

## 4. Store-Materialien (#34)
- [ ] Store-Listing-Texte (Kurz-/Langbeschreibung) für DE und EN vorhanden
- [ ] Screenshots für Zielgeräte erstellt
- [ ] App-Icon und Store-Grafiken final
- [ ] `scripts/init_store_metadata.ps1` bzw. Store-Metadaten synchronisiert

## 5. Datenschutz & Recht (#33)
- [ ] Datenschutzerklärung ist aktuell und deckt die tatsächliche Datenverarbeitung ab (lokal, kein Server-Sync in Release 1)
- [ ] Impressum/rechtliche Pflichtangaben vorhanden
- [ ] Consent-Texte (falls Freigabe-Dialoge Zustimmung einholen) geprüft
- [ ] `docs/technical/security-and-privacy.md` spiegelt den aktuellen (lokalen) Stand wider, nicht die ältere Server-Sync-Vision

## 6. Versionierung / Release Notes
- [ ] `docs/deployment/release-notes.md` ist aktualisiert und beschreibt den **tatsächlichen** Funktionsumfang (aktuell noch veraltet: beschreibt Server-Sync/Admin-Tools/Event-Discovery, die es in Release 1 nicht gibt - vor Veröffentlichung überarbeiten)
- [ ] Git-Tag für den Release gesetzt (siehe `versioning.md`)

---

## Go-/No-Go-Kriterien

**Go**, wenn:
- Alle P0-Punkte in Abschnitt 1–3 abgehakt sind
- Der Smoke-Test ohne kritischen Fehlschlag durchlief
- Keine unbehandelten Datenschutz-/Rechtslücken offen sind

**No-Go**, wenn:
- Ein P0-Issue offen ist
- Der Smoke-Test auf einem Kernflow fehlschlägt
- Datenschutz-/Rechtstexte fehlen oder nicht zum tatsächlichen Funktionsumfang passen

---

## Release-Protokoll

| Datum | Version | Ergebnis (Go/No-Go) | Verantwortlich | Anmerkungen |
|---|---|---|---|---|
| | | | | |

# Test Plan – DFL App

## 1. Introduction
This test plan defines the strategy for verifying the DFL App, ensuring it meets both functional requirements and the high privacy standards required for spiritual reflection.

## 2. Test Strategy

### 2.1 Unit Testing (Flutter & Backend)
- **Goal:** Verify individual functions and logic components.
- **Focus:** 
  - Questionnaire calculation logic (Gifts & Values).
  - Sync conflict resolution logic.
  - Encryption/Decryption utilities.
  - Data mapping for the Life Tree builder.

### 2.2 Integration Testing
- **Goal:** Verify communication between the Flutter app and the Backend API.
- **Focus:**
  - Authentication flow (Magic Links).
  - Offline-to-Online synchronization.
  - Permission enforcement (Leaders cannot access private data).

### 2.3 UI & Widget Testing
- **Goal:** Ensure the UI behaves as described in the Wireframes.
- **Focus:**
  - The "Unified Module Pattern" (Edit vs. Result view).
  - Drag & Drop behavior in the Collage module.
  - Presentation Mode (Safe-View isolation).

### 2.4 Security & Privacy Testing (Critical)
- **Goal:** Validate the strict privacy rules.
- **Focus:**
  - "Sender-loses-access" logic for Prayer Notes.
  - 4-Step Sharing Dialog confirmation.
  - Automatic expiration of Presentation Mode tokens.

---

## 3. Scope of Testing

### 3.1 Functional Features
- Event Selection & Registration.
- All Reflection Modules (Gifts, Values, Life Tree, Prayer, Notes).
- Key Takeaway capture.
- Visual Collage creation.
- SMART Goal validation.
- Admin: Event Editor & Schedule management.

### 3.2 Non-Functional Features
- **Offline Capability:** Testing the app in Airplane mode.
- **Performance:** Load times for large Life Tree structures.
- **Internationalization:** Switching between German and English.

---

## 4. Test Environment
- **Devices:** iOS (iPhone/iPad), Android (various screen sizes), Web (Chrome/Safari).
- **Network:** Stable WiFi, Edge/Slow 3G, and Offline.

---

## 5. Pass/Fail Criteria
- 100% of "Security & Privacy" test cases must pass.
- No critical bugs in the "Offline Sync" mechanism.
- All functional User Stories from `user-stories.md` are verified.
- UI follows the "Unified Module" structure consistently.
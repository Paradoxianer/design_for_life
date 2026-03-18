# Requirements – DFL App (Lean Edition)

## 1. Purpose
The DFL App is a **Local-First** tool to support participants during the Design for Life weekend. It focuses on personal reflection, offline capability, and minimal server dependency.

---

## 2. User Roles & Core Sync-Needs

### **Participants**
- **Offline-First:** All tests (Gifts, Values) and reflections (Notes, Goals) work without internet.
- **Relay-Prayer:** Receive encrypted spiritual impressions directly into the `ListeningPrayerResult` view (Sender-Name & Mail-Icon included).
- **Personal Data Sovereignty:** Reflection data stays on the device. Optional private cloud-sync for backup.
- **Seminar Feedback:** Shared at the end of the event (visible to Leaders/Admins).

### **Small Group Leaders**
- **Coordination:** View group assignments (synced from server).
- **Preparation:** Access leader-only materials (PDFs/Images).
- **Insight:** View "Shared Takeaways" of their group members during the session.
- **Ministry:** Send prayer impressions to participants (One-way push to recipient's local storage).

### **Administrators**
- **Event Management:** Define schedule (Timeline) and rooms.
- **Group Management:** Simple assignment of participants to leaders.

---

## 3. Simplified Functional Modules

### **3.1 Static Reflection Modules**
- **Logic:** The logic for Gifts/Values tests is bundled in the app. No server-side questionnaire engine.
- **Updates:** Changes to tests are delivered via App-Store updates.

### **3.2 Listening Prayer (Relay Mode)**
- **One-Way-Push:** Impressions are sent from a leader/participant to a recipient.
- **Integration:** Received notes appear seamlessly in the recipient's result view.
- **Ephemeral Relay:** The server only holds notes until they are delivered to the recipient's app.

### **3.3 Event Coordination**
- **Timeline:** Managed centrally, synced to all participants.
- **Cleanup:** Coordination data (groups, temporary shares) is deleted 30 days after the event.

---

## 4. Non‑Functional Requirements (Optimized)
- **KISS:** No complex backend logic. Flat JSON storage for test results.
- **Privacy:** Multi-layer encryption for spiritual impressions.
- **Battery & Data:** Minimal background sync. No persistent web-socket connections required.

---

## 5. Out of Scope
- Real-time chat or social networking.
- Server-side evaluation of spiritual tests.
- Complex resource/room booking systems.

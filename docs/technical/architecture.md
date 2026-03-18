# Architecture – DFL App (Lean & Local-First)

## 1. Overview
The DFL App follows a **Local-First** philosophy. The primary "Source of Truth" for all personal reflection data is the user's device. The backend acts primarily as a **Coordinator** for event metadata and a **Relay** for interpersonal communication (Listening Prayer).

---

## 2. High‑Level Architecture

```
+------------------------+       +----------------------------+
|  Mobile Client (App)   | <---->|      Lean Backend          |
|  (Flutter + Hydrated)  |       |  (Relay & Coordinator)     |
+-----------+------------+       +-------------+--------------+
            |                                  |
            v                                  v
+------------------------+       +----------------------------+
|  Local Storage         |       |  Server Storage            |
|  (Encrypted / SQLite)  |       |  (PostgreSQL / Redis)      |
|                        |       |                            |
| - Tests & Results      |       | - Event Schedules          |
| - Personal Notes       |       | - Group Assignments        |
| - Life Tree Data       |       | - Prayer Note Inbox (Temp) |
+------------------------+       +----------------------------+
```

---

## 3. Client Strategy (The Core)

### 3.1 Local-First Persistence
- All reflection modules (Gifts, Values, Tree, Notes, Goals) store data locally immediately.
- Use of `HydratedBLoC` for seamless state persistence across app restarts.
- No mandatory internet connection required for core functionality.

### 3.2 UI/Logic Separation
- **Static Assets:** Questionnaire questions and logic are bundled within the app (no server-side rendering).
- **Module Pattern:** Every feature uses the `Editor` -> `Result` -> `Takeaway` flow.

---

## 4. Backend Strategy (The Minimalist)

### 4.1 Event Coordinator
- Serves the current weekend schedule (Timeline).
- Manages registrations and group assignments (who is in which small group).
- Does **not** store full questionnaire answers, only high-level results if shared.

### 4.2 Prayer Note Relay (Message-Oriented)
- Acts as a temporary "Inbox" for Listening Prayer impressions.
- **Workflow:** Sender pushes encrypted note -> Server stores temporarily -> Recipient's app pulls and persists locally -> Server deletes note.
- **Privacy:** Content is encrypted on the sender's device. The server never sees the plain text.

---

## 5. Sync & Privacy Rules

### 5.1 Personal Data
- **Notes, Goals, Tree:** Private by default. Optional sync to a private user partition only for multi-device support.
- **Test Results:** Stay local unless "Shared with Leader" is active.

### 5.2 Interpersonal Sharing
- **Shared View:** When a participant joins a session, their "Top 3 Takeaways" are made visible to the assigned group leader for the duration of the event.
- **Listening Prayer:** Received notes are integrated directly into the recipient's `ListeningPrayerResult` view, marked with a sender reference (e.g., Mail icon + Name).

---

## 6. Technical Stack
- **Frontend:** Flutter (iOS/Android).
- **State Management:** BLoC + HydratedBLoC.
- **Database (Local):** SQLite (via sqflite or drift) for larger datasets like Life Tree.
- **Backend:** Lightweight API (Node.js/Go/Python) + PostgreSQL.
- **Relay:** Simple message queue or REST-Inbox.

---

## 7. Data Retention & Cleanup
- Personal reflection data is permanent (stored on device/private cloud).
- Event-specific data (Group assignments, temporary shared takeaways, Relay inbox) is purged 30 days after an event concludes.

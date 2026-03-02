
# Architecture – DFL App

## 1. Overview
The DFL App uses a modular, privacy-first architecture designed for spiritual sensitivity, offline capability, and strict control over visibility and sharing. The system consists of three main layers:

1. **Client Application (Flutter Frontend)** – iOS, Android and optionally Web
2. **Backend API Service** – Secure REST/GraphQL API
3. **Database + Secure File Storage** – Encrypted relational DB and object storage

An additional **Interpersonal Prayer Notes Module** supports leaders and participants who receive spiritual impressions for others.

---

## 2. High‑Level Architecture Diagram (Improved ASCII Version)

```
                           +------------------------+
                           |     Admin Web Panel    |
                           |  (Optional Future)      |
                           +-----------+------------+
                                       |
                                       v
                             Authentication & Roles
                                       |
                                       v
+---------------------+       +-------------------------+       +----------------------------+
|  Mobile/Web Client  | <---->|      Backend API        | <---->|  Database & File Storage   |
| (Flutter Frontend)  |       |  (Node.js /.NET Core)   |       | (PostgreSQL + Encrypted    |
|                     |       |                         |       |  Object Storage - EU)      |
| - Offline Storage   |       | - Auth & RBAC           |       |                            |
| - Local Encryption  |       | - Questionnaire Logic   |       | - Users                    |
| - Sync Engine       |       | - Sharing Rules         |       | - Groups                   |
| - Presentation Mode |       | - Prayer Notes Handling |       | - Questionnaires           |
+---------------------+       | - Materials & Schedule  |       | - Visibility Settings      |
                              | - Sync Processing       |       | - Prayer Notes (Encrypted) |
                              +-------------------------+       +----------------------------+
```

---

## 3. Client Application (Flutter Frontend)

### 3.1 Responsibilities
- Render UI (questionnaires, Life Tree, notes, materials)
- Handle offline-first data entry
- Store data encrypted on-device
- Sync changes to backend when online
- Allow participants to decide visibility of each item:
    - **Private**
    - **Shared with Leader**
    - **Temporary Presentation**
- Provide Presentation Mode for group sessions
- Allow writing *Prayer Notes* for others

### 3.2 Offline Capability
- Notes, questionnaires, Life Trees and prayer notes must work fully offline
- Local encrypted database required
- Sync queue must merge changes gracefully

### 3.3 Presentation Mode
Creates a clean, minimal, non-editable view of:
- Life Tree summaries
- Gift/Values summaries
- Listening prayer summaries

Used for:
- Showing content on screen
- Temporary sharing with leaders  
  (Leader access ends automatically)

---

## 4. Backend API Layer

### 4.1 Responsibilities
- Authentication (JWT/OAuth)
- Role-based access control (RBAC)
- Enforcement of all visibility and sharing rules
- Store & retrieve questionnaire results
- Manage Life Trees and materials
- Manage prayer notes (leader/participant → participant)
- Handle sync jobs for offline clients

### 4.2 Privacy Enforcement
The backend **always** checks visibility flags before returning data:

- Leaders never see private or unshared content
- Leaders never see full Life Trees or listening prayer details
- Admins never see prayer notes
- Prayer notes are encrypted and only visible to the recipient

### 4.3 API Endpoints (Conceptual)
- `/auth/*`
- `/questionnaires/*`
- `/life-tree/*`
- `/notes/*`
- `/materials/*`
- `/groups/*`
- `/visibility/*`
- `/prayer-notes/*` ← NEW

---

## 5. Database & Storage Layer (Updated)

### 5.1 Core Tables
- `users`
- `groups`
- `user_group_assignments`
- `questionnaire_gifts`
- `questionnaire_values`
- `life_tree`
- `notes_private`
- `notes_shared_summary`
- `materials`
- `event_schedule`
- `visibility_settings`

### 5.2 NEW: Prayer Notes Table
```
prayer_notes
------------
id (PK)
from_user_id (FK -> users)
to_user_id   (FK -> users)
content_encrypted
created_at
immutable (boolean)
visibility = 'private_to_recipient'
read_at (nullable)
```

### 5.3 File Storage
Encrypted storage for:
- Life Tree images
- PDF/materials
- Optional: audio notes (future)

Stored in EU region (GDPR compliant).

---

## 6. Role-Based Access Control (RBAC)

### Participant
- Create, edit, view their own content
- Decide what is shared with leader
- Send prayer notes to others
- Receive prayer notes

### Small Group Leader
- See **only shared summaries**
- Create prayer notes for group members
- Cannot read prayer notes after sending
- Cannot edit sent prayer notes

### Administrator
- Full system configuration
- Upload materials
- Manage accounts
- Can NEVER see prayer notes

---

## 7. Sharing & Visibility Rules (Updated)

### Sharing Levels
- `private`
- `shared_leader`
- `temporary_session` (presentation-only)

### Prayer Notes Exception
Prayer notes:
- Are always private to the recipient
- Do NOT use the normal sharing system
- Do NOT appear in "Leader's View"
- Cannot be made public or shared

---

## 8. Interpersonal Prayer Notes Module (New)

### Purpose
To enable leaders and participants to deliver spiritually sensitive impressions to others, securely and privately.

### Key Properties
- Sender writes → note goes to recipient’s private inbox
- Sender can see only metadata afterward (optional)
- Content encrypted at rest
- Backend enforces immutability
- No one except the recipient can view it
- Not included in leader dashboards

---

## 9. Sync & Conflict Handling

### Behavior
1. User edits offline
2. Local changes saved encrypted
3. When online, sync engine attempts upload
4. Backend merges changes or flags conflicts
5. Prayer notes & questionnaires are append-only

---

## 10. Deployment & Hosting
- EU Cloud (AWS Frankfurt, Azure EU, Hetzner Cloud)
- Docker-based backend
- Static file hosting for materials
- Automated backups daily

---

## 11. Scalability & Future Enhancements
- Multi-event support
- Deep linking for reference-person invitations
- Extended questionnaire types
- Audio-based prayer notes (optional future)  

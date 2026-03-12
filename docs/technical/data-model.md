# Data Model – DFL App (Simplified)

## 1. Overview
The DFL App uses a simplified relational data model designed for offline-first synchronization. Personal reflection data is permanent, while event-specific coordination data is transient.

---

## 2. Core Entities

### 2.1 Event & Participant Management
- **Event**
    - `id` (UUID)
    - `title` (String)
    - `description` (Text)
    - `location_name` (String)
    - `start_date` (DateTime)
    - `end_date` (DateTime)
    - `status` (Enum: DRAFT, PUBLISHED)

- **Registration (The central link)**
    - `id` (UUID)
    - `user_id` (FK)
    - `event_id` (FK)
    - `role` (Enum: PARTICIPANT, LEADER, ADMIN)
    - `group_name` (String) – *Simplified: Managed via inline dropdown (1, 2, +).*
    - `status` (Enum: PENDING, APPROVED)

---

### 2.2 Schedule & Leader-Materials
- **Session**
    - `id` (UUID)
    - `event_id` (FK)
    - `title` (String)
    - `start_time` (DateTime)
    - `end_time` (DateTime)
    - `room_name` (String) – *Simplified: Direct text input with autocomplete.*
    - `module_type` (Enum: TEACHING, LIFE_TREE, GIFTS, VALUES, PRAYER, COLLAGE, GOALS, FEEDBACK)
    - `is_locked` (Boolean)

- **Material (Leader-Only)**
    - `id` (UUID)
    - `event_id` (FK)
    - `title` (String)
    - `file_url` (String)
    - `type` (Enum: PDF, IMAGE)
    - *Note: Can be copied from previous events as templates.*

---

### 2.3 Permanent Reflection Data (User-Owned)
These entities are stored permanently for the user's personal journey.

- **ModuleEntry (Base for all modules)**
    - `id` (UUID)
    - `user_id` (FK)
    - `key_takeaways` (List<String>)
    - `visibility` (Enum: PRIVATE, SHARED_LEADER, PRESENTATION)

- **LifeTreeData**, **QuestionnaireResult**, **Goal**, **CollageData**
    - *Linked to User, stored across multiple events if necessary.*

- **PrayerNote (Recipient-Owned)**
    - `id` (UUID)
    - `from_user_id` (FK)
    - `to_user_id` (FK)
    - `content_encrypted` (Text)
    - `created_at` (DateTime)

---

### 2.4 Event Feedback (Shared)
- **SeminarFeedback**
    - `id` (UUID)
    - `event_id` (FK)
    - `user_id` (FK)
    - `rating` (Integer, 1-5)
    - `answers` (JSON: Question-Answer pairs)
    - `comments` (Text)
    - `created_at` (DateTime)
    - *Visibility: All Leaders and Admins of the event.*

## 3. Sync & Privacy Strategy

### 3.1 Personal Sync (Private)
- Data like the **Life Tree**, **Private Notes**, and **Goals** are synced to the user's private cloud storage.
- The backend serves only as a relay to ensure multi-device availability.

### 3.2 Shared Sync (Interpersonal)
- Data explicitly marked as **Shared** (e.g., Listening Prayer impressions, Seminar Feedback) is distributed by the backend to the respective Leader/Group.
- **Prayer Notes** are moved to the recipient's partition upon sending (Sender loses access).

### 3.3 Data Retention
- **Permanent:** All reflection modules (Gifts, Values, Tree, Notes, Goals).
- **Transient (30 days post-event):** Event registrations, group assignments, session locks, and Seminar Feedback (unless archived by Admins).
# Data Model – DFL App

## 1. Overview
The DFL App uses a relational data model designed for offline-first synchronization and strict privacy. All sensitive spiritual data is linked to a specific user and event.

---

## 2. Core Entities

### 2.1 Event Management
- **Event**
    - `id` (UUID)
    - `title` (String)
    - `description` (Text)
    - `location_name` (String)
    - `address` (String)
    - `start_date` (DateTime)
    - `end_date` (DateTime)
    - `map_image_url` (String, optional)
    - `status` (Enum: DRAFT, PUBLISHED, ARCHIVED)

- **Room**
    - `id` (UUID)
    - `event_id` (FK)
    - `name` (String)

- **Registration**
    - `id` (UUID)
    - `user_id` (FK)
    - `event_id` (FK)
    - `role` (Enum: PARTICIPANT, LEADER, ADMIN)
    - `group_id` (FK, optional)
    - `status` (Enum: PENDING, APPROVED, REJECTED)

- **Group**
    - `id` (UUID)
    - `event_id` (FK)
    - `name` (String)
    - `leader_id` (FK -> User)

---

### 2.2 Schedule & Content
- **Session**
    - `id` (UUID)
    - `event_id` (FK)
    - `room_id` (FK)
    - `title` (String)
    - `start_time` (DateTime)
    - `end_time` (DateTime)
    - `module_type` (Enum: TEACHING, LIFE_TREE, GIFTS, VALUES, PRAYER, COLLAGE, GOALS)
    - `is_locked` (Boolean)

- **Material**
    - `id` (UUID)
    - `session_id` (FK)
    - `title` (String)
    - `file_url` (String)
    - `type` (Enum: PDF, IMAGE, MARKDOWN)

---

### 2.3 Participant Data (Reflection Modules)
Every module entry is linked to a `user_id` and `event_id`.

- **ModuleEntry (Base fields for all modules)**
    - `id` (UUID)
    - `user_id` (FK)
    - `session_id` (FK)
    - `key_takeaways` (List<String>)
    - `visibility` (Enum: PRIVATE, SHARED_LEADER, PRESENTATION)

- **LifeTreeData**
    - `id` (UUID)
    - `nodes` (JSON: Array of {id, parent_id, label, type})
    - `red_threads` (List<String>: Max 3)

- **QuestionnaireResult (Gifts & Values)**
    - `id` (UUID)
    - `type` (Enum: GIFTS, VALUES)
    - `raw_answers` (JSON)
    - `top_results` (List<String>)

- **PrayerNote**
    - `id` (UUID)
    - `from_user_id` (FK)
    - `to_user_id` (FK)
    - `content_encrypted` (Text)
    - `is_anonymous` (Boolean)
    - `created_at` (DateTime)

- **CollageData**
    - `id` (UUID)
    - `elements` (JSON: List of {type, content, x, y, scale, rotation})
    - `background_style` (String)

- **Goal**
    - `id` (UUID)
    - `description` (String)
    - `smart_s`, `smart_m`, `smart_a`, `smart_r`, `smart_t` (Boolean)

---

### 2.4 Leader Feedback
- **ConversationResult**
    - `id` (UUID)
    - `leader_id` (FK)
    - `participant_id` (FK)
    - `notes_private` (Text)
    - `feedback_shared` (Text)
    - `is_shared_with_participant` (Boolean)

---

## 3. Privacy & Sync Metadata
Each record contains:
- `created_at` (DateTime)
- `updated_at` (DateTime)
- `deleted_at` (DateTime, for soft deletes)
- `sync_status` (Enum: SYNCED, PENDING, CONFLICT)
- `device_id` (String)
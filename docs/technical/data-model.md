# Data Model – DFL App (Lean & Local-First)

## 1. Philosophy
We distinguish between **Permanent Local Data** (User-owned) and **Transient Coordination Data** (Server-owned).

---

## 2. Permanent Local Data (Device-Level)
Stored via `HydratedBLoC` or Local SQLite.

- **Profile:** Basic user info.
- **ModuleResults:**
    - `module_id` (Gifts, Values, Tree, Goals)
    - `result_data` (Flat JSON - e.g., "Top 3 Gifts")
    - `key_takeaways` (List of Strings)
    - `last_updated` (DateTime)
- **PersonalNotes:** Collection of private thoughts linked to sessions.
- **ReceivedImpressions:**
    - `id`
    - `sender_name`
    - `content_encrypted`
    - `timestamp`
    - *Note: Once pulled from relay, it lives here permanently.*

---

## 3. Transient Coordination Data (Server-Level)
Managed via a lightweight REST API.

- **EventMeta:**
    - `id`, `title`, `start_date`, `end_date`
    - `timeline_json` (The weekend schedule)
- **GroupAssignment:**
    - `user_id` <-> `group_id` <-> `leader_id`
- **RelayInbox (The Ephemeral Table):**
    - `to_user_id` (Recipient)
    - `payload_encrypted` (The Note)
    - `sender_metadata` (Name, Role)
    - *Rule: Delete row immediately after successful delivery to client.*

---

## 4. Shared Insights (Short-Lived)
- **SharedTakeaways:**
    - A temporary "window" where leaders can see the `key_takeaways` of their group members.
    - *Retention:* Cleared after the event.

# Wireframes – DFL App (Complete Structural Description)
This document defines all wireframes as **textual structural descriptions**.

---------------------------------------------------------------------

# 1. Event Selection & Registration
- **Event List:** Card-based list of upcoming DFL weekends.
- **Admin Feature:** "+" Button in AppBar to create a new event.
- **Pre-fill:** Creating an event automatically loads the standard DFL schedule template.

---------------------------------------------------------------------

# 2. Participant Dashboard
- **Timeline View:** Vertical list of sessions.
- **Session Card:** Title, Time, Type, and **Room Name (Text)**.
- **Status:** Locked/Unlocked based on schedule.

---------------------------------------------------------------------

# 3. Leader & Admin Tools (Simplified)

## 3.1 Event Editor (Inline)
- **Schedule:** Edit sessions directly.
- **Room Field:** Each session has a text input for the room with autocomplete based on previously entered rooms in the same event.

## 3.2 Participant & Group Management (One Screen)
- **List View:** All registered participants.
- **Role Toggle:** Switch between Participant, Leader, Admin.
- **Group Selector:** A **Dropdown menu** next to each participant's name.
    - Options: "Group 1", "Group 2", etc.
    - Last item in dropdown: **"+" (Create new group)**.
    - Selecting "+" opens a small popup to name the group, then assigns it.

## 3.3 Materials (Leader-only)
- **Material View:** Only accessible for users with the "Leader" or "Admin" role.
- **Content:** List of PDFs and images.
- **Template Feature:** When setting up an event, select "Copy materials from previous DFL" to pre-fill the list.

---------------------------------------------------------------------

# 4. Module Architecture (No changes)
- All modules (Life Tree, Gifts, etc.) remain as personal reflection tools with "Key Takeaways".
- Personal data is always private unless shared via the 4-step sharing dialog.

---------------------------------------------------------------------

# 5. Presentation Mode
- Clean, fullscreen view of shared summaries for group sessions.
- No private navigation or notes visible.
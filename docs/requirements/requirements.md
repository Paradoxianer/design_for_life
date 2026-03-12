# Requirements – DFL App

## 1. Purpose of the Application
The DFL App supports the Design for Life weekend by providing simple tools for
preparation, reflection, and organization.  
It reduces paperwork, helps leaders prepare, and gives participants quick access
to everything they need—while keeping the focus on personal interaction and the
spiritual experience of the weekend.

---

## 2. User Roles

### **Participants**
- Discover and register for DFL events.
- Fill in questionnaires (spiritual gifts and values).
- Upload or create their personal “Life Tree”.
- Take private notes and "Key Takeaways" for every session.
- Create a "Summary Collage" of their insights.
- Define SMART Goals.
- View the weekend schedule and room assignments (as text).
- Decide which information is shared with leaders.
- **Provide Feedback:** Fill out a seminar feedback form at the end of the event.
- *Note:* Participants do NOT see teaching materials/PDFs in the app (Leader-only).

### **Small Group Leaders**
- View participants assigned to their group via a simplified dropdown.
- Access participants’ shared questionnaire results and summaries.
- Add leader-only preparation notes.
- Access teaching materials, PDFs, and images for preparation.
- Plan 1:1 conversations and share specific results/feedback with participants.
- **View Feedback:** View aggregated or individual feedback from participants to improve future seminars.

### **Administrators**
- Full event management (Create events with pre-filled standard schedule).
- Manage user accounts, roles, and group assignments (inline dropdowns).
- Manage leader-only materials and copy them from previous events as templates.
- **Analyze Feedback:** Access all participant feedback for seminar evaluation and quality management.

---

## 3. Functional Requirements

### **3.1 Event & Registration**
- **Event Discovery:** Browse upcoming events.
- **Registration:** Simple register/unregister.
- **Template Logic:** New events automatically load the standard DFL schedule.

### **3.2 Module Architecture (Unified Pattern)**
All reflection modules (Gifts, Values, Life Tree, Listening Prayer) follow:
- **Edit Mode:** For data entry.
- **Result Mode:** For visualization.
- **Key Takeaways:** 1–3 main points per module (stored for Collage).

### **3.3 Participant Features**
- **Schedule:** View timeline with session titles and room names (text field).
- **Reflection Tools:** Gifts, Values, Life Tree, Listening Prayer, Collage, Goals.
- **Privacy:** Personal reflection data is permanent and private unless shared.
- **Seminar Feedback:** A dedicated form at the end of the schedule to rate the experience and provide comments.

### **3.4 Small Group Leaders**
- **Leader Materials:** Access to PDFs/Images for session preparation.
- **Inline Grouping:** Assign participants to groups (e.g., "1", "2") via a simple dropdown in the participant list.
- **Feedback Access:** View submitted feedback from participants (visible to all Leaders and Admins).

### **3.5 Administrators & Event Management**
- **Simplified Schedule:** Edit session titles, times, and rooms (text field with autocomplete).
- **Grouping:** Create new groups via a "+" option in the participant's group dropdown.
- **Material Templates:** Choose to copy materials from a previous event when creating a new one.
- **Feedback Management:** Export or view all seminar feedback for analysis.

---

## 4. Non‑Functional Requirements
- **Simplicity (KISS):** No complex room or group management screens. Inline editing where possible.
- **Data Permanence:** Personal reflection data (Life Tree, Notes) belongs to the user and is kept permanently.
- **Privacy:** Only explicitly shared data (e.g., Listening Prayer impressions, Feedback) is distributed via the backend.

---

## 5. Out of Scope
- Participant access to teaching materials.
- Automated spiritual scoring.
- Complex infrastructure management.
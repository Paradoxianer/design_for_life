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
- Discover and register for DFL events
- Fill in questionnaires (spiritual gifts and values)
- Upload or create their personal “Life Tree”
- Take private notes and "Key Takeaways" for every session
- Create a "Summary Collage" of their insights
- Define SMART Goals
- View the weekend schedule and assigned rooms
- Access materials (texts, PDFs, instructions)
- Decide which information is shared with leaders

### **Small Group Leaders**
- View participants assigned to their group
- Access participants’ shared questionnaire results and summaries
- Add leader-only preparation notes
- Plan 1:1 conversations and share specific results/feedback with participants
- Manage event details (if authorized)

### **Administrators**
- Full event management (Create, Edit, Schedule)
- Room and infrastructure planning
- Manage user accounts, roles, and group assignments
- Upload seminar materials and manage translations

---

## 3. Functional Requirements

### **3.1 Event & Registration**
- **Event Discovery:** Browse upcoming DFL events with location, date, and language.
- **Registration:** Register/Unregister for events.
- **Status Tracking:** See registration status (Pending/Approved) and "Registered" badges.

### **3.2 Module Architecture (Unified Pattern)**
All reflection modules (Gifts, Values, Life Tree, Listening Prayer, Teachings) must support:
- **Edit Mode:** For data entry.
- **Result Mode:** For visualization.
- **Key Takeaways:** Requirement to capture 1–3 main points per module.
- **Sharing Controls:** Granular control over what is shared.

### **3.3 Participant Features**
- **Questionnaires:** Spiritual gifts and values assessments with autosave.
- **Life Tree:** Specialized tree builder (Roots, Branches, Labels) with "3 Red Threads".
- **Lesson Notes:** Capture text and photos (slides/flipcharts) during teachings.
- **Listening Prayer:** Dynamic list of impressions (own and received).
- **Summary Collage:** Visual dashboard/collage of all "Key Takeaways" from all modules.
- **SMART Goals:** Definition of exactly 3 goals with SMART-criteria validation.
- **Information Controls:** Clearly mark content as Private, Shared with Leader, or Temporary Presentation.

### **3.4 Small Group Leaders**
- **Participant Overview:** See group members and their completion status.
- **Shared Results:** Access shared summaries of all participant modules.
- **1:1 Conversation Results:** Document 1:1 sessions and explicitly "Share with Participant" to make feedback visible in their result screen.
- **Leader Notes:** Private notes for preparation.

### **3.5 Administrators & Event Management**
- **Event Editor:** Create events with title, description, location, and address.
- **Infrastructure:** Define Rooms and upload Map/Building plans.
- **Schedule Editor:** Create/Edit the weekend timeline using templates. Assign modules and rooms to sessions.
- **User & Group Management:** Assign roles and organize small groups.

---

## 4. Non‑Functional Requirements
- **Simplicity:** Intuitive interface (max 2-3 taps to core features).
- **Multilingual UI:** Support for multiple languages.
- **Privacy:** Explicit consent for sharing; "Presentation Mode" for safe viewing.
- **Offline Support:** Full functionality for notes and questionnaires without internet.
- **Cross‑Platform:** iOS, Android, and Web.

---

## 5. Out of Scope
- Payment systems
- Social networking/chat (except Prayer Notes)
- Automated spiritual "scoring"

---

## 6. Success Criteria
- High completion rate of questionnaires and "Key Takeaways".
- Leaders report better preparation for 1:1 sessions.
- Efficient room and group coordination by admins.
- Zero unauthorized data access.
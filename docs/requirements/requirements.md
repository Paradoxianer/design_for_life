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
- Fill in questionnaires (spiritual gifts and values)
- Upload or create their personal “Life Tree”
- Take private notes
- Bring all insights together (Life Tree, gifts, values, listening prayer)
- View the weekend schedule
- Access materials (texts, PDFs, instructions)
- Decide which information is shared with leaders

### **Small Group Leaders**
- View participants assigned to their group
- Access participants’ shared questionnaire results
- See only shared summaries of Life Tree and listening-prayer reflections  
  (never private notes or unshared content)
- Add leader-only preparation notes
- Plan 1:1 conversations

### **Administrators**
- Manage user accounts and roles
- Assign groups and leaders
- Upload seminar materials
- Manage translations and language versions
- Configure the event schedule and announcements

---

## 3. Functional Requirements

### **3.1 Participants**
- **Questionnaires:** Fill in spiritual gifts and values assessments with autosave.
- **Life Tree:** Upload an image (photo/drawing) or create one digitally.
- **Notes:** Private notes visible only to the participant.
- **Schedule:** Access the current DFL weekend timeline.
- **Materials:** View PDFs, biblical passages, and session instructions.
- **Information Controls:** Clearly mark which information stays private and which may be shared.
- **Sharing Overview:** Ability to view “What my leader can see about me.”

### **3.2 Small Group Leaders**
- **Participant Overview:** See all members of their group.
- **Results View:** Access only the participant’s shared assessment summaries.
- **Shared Life Tree:** View the participant’s shared Life Tree summary.
- **Leader Notes:** Add personal preparation and conversation notes (leader-only).
- **1:1 Planning:** Create and manage simple time slots for individual conversations.

### **3.3 Administrators**
- **User Management:** Create, edit, and assign participants and leaders.
- **Group Assignment:** Organize users into small groups.
- **Content Management:** Upload teaching materials and instructions.
- **Translation Settings:** Manage multilingual content.
- **Event Settings:** Configure schedule, structure, and general settings.

---

## **3.4 Extended Feature: Reference Feedback for Gift Assessment**
Participants can invite one or more “reference persons” (friends, mentors, leaders)
to provide external feedback on their spiritual gifts.

### **Purpose**
To create a more holistic view by combining self-reflection with external impressions.

### **Requirements**
- Invitations can be sent via link or email.
- Reference persons do not need a full account (temporary access link).
- They fill out a simplified gift questionnaire about the participant.
- Responses are stored separately from the participant’s own answers.
- Leaders can view aggregated (self + references) results.
- Participants decide whether leaders may view the reference feedback.
- Reference persons can never view participant data.

### **Privacy**
- Fully optional.
- Explicit participant consent required before inviting references.
- Reference feedback aggregated where appropriate to protect anonymity.

---

## **3.5 Information Visibility & Sharing Controls**

### **Participant Control**
Participants must be able to decide for each item individually:
- Life Tree (summary only)
- Gift assessment results (summary only)
- Values assessment (summary only)
- Listening prayer reflections
- Other reflections or insights

Each item can be marked as:
- **Private** (default)
- **Shared with Group Leader**
- **Temporary Share** (session‑based)

Participants must have:
- A clear overview: **“What the leader can see”**
- The ability to change sharing choices at any time

### **Leader Permissions**
Leaders may:
- View **only** content explicitly shared by participants
- Access summaries but **not** private notes or raw data
- Never override visibility settings

Leaders may **not**:
- Access unshared Life Tree or prayer notes
- View participant private journaling
- Access drafts or uncompleted questionnaires

### **Temporary Sharing (“Presentation Mode”)**
Participants may temporarily display specific content:

- Via a “Share with Leader” button
- Or via a clean “Presentation Mode” view suitable for a beamer or large screen
- No permanent access for leaders
- Temporary access expires automatically

---

## 4. Non‑Functional Requirements
- **Simplicity:** Intuitive interface for all user types.
- **Multilingual UI:** All UI text and questionnaires support multiple languages.
- **Privacy:** All personal data handled securely and with explicit consent.
- **Offline Support:** Notes and questionnaires must work offline.
- **Accessibility:** Clear design, proper contrast, and screen‑reader support.
- **Cross‑Platform:** Available on iOS, Android, and optionally Web.

---

## 5. Out of Scope (for now)
- Payment or external registration systems
- Automated spiritual assessments
- Social networking or chat features
- Full digital or online-only DFL experiences
- Integrations with external platforms

---

## 6. Success Criteria
- Most participants complete their questionnaires before/during the event
- Leaders feel better prepared for group and 1:1 sessions
- Administrators report significantly reduced paper and coordination work
- High user engagement with schedule, notes, and materials
- Zero privacy-related issues or unauthorized data access
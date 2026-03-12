# Wireframes – DFL App (Complete Structural Description)
This document defines all wireframes as **textual structural descriptions**.

No ASCII mockups included.  
This is the single source of truth for UI/UX behaviour for MVP+.

---------------------------------------------------------------------

# 0. Introduction
This document describes:
- Screens
- Navigation flow
- Module behaviour
- Edit vs Result views
- Sharing & Presentation logic
- Leader/Admin tools (Event Editing, Grouping, Roles)
- Event selection, registration, and management

The goal is a **maximally simple UX** for all participants, even at the cost
of more implementation work.

All modules follow a unified pattern:
- Edit Screen
- Result Screen
- Key Takeaways (min. 1 required)
- Share Summary/Full
- Presentation Mode (safe view)

---------------------------------------------------------------------

# 1. Event Selection Screen

## Purpose
First screen before login, allowing users to find & join their DFL event.

## Components
### 1. Event List
- List of *upcoming* DFL courses
- Each event card shows:
    - Event Title
    - Location
    - Date & Time
    - Language
    - Registration Status (Registered / Not Registered)
    - Button: **Register / Unregister**
    - Button: **Continue** (if registered)
    - If not logged in → shows „Login required for personal content“

### 2. Filters
- **Automatic filter**:
    - based on device region or language
- **Manual filter** (icon in app bar):
    - by date
    - by language
    - by country
    - by host/organisation

### 3. Login Area (Bottom Section)
- Email + Password / Magic Link Login
- CTA: “Continue without login” (read-only materials)

### 4. Admin/Leader Feature (NEW)
- AppBar now contains:
    - **“+” button → Create new Event**
    - Only visible for Leaders/Admins

---------------------------------------------------------------------

# 2. Participant Home / Dashboard

## Purpose
Shows the full DFL course flow as cards.

## Card Layout
Each Session Card contains:
- **Time** (e.g., 09:00–10:30)
- **Title** (e.g., “Values Session”)
- **Type Marker**:
    - Lecture (icon)
    - Group Work (icon)
    - Personal Reflection (icon)
- **Room Name** (NEW, if defined)
- **Group Assignment** (optional, if small groups defined)
- **Status**:
    - Done (result exists)
    - Not started
    - Locked (not yet in schedule)
    - Override (leader unlocked)

## Behaviour
- Tap → opens relevant Module (Edit or Result)
- Auto-locking based on event schedule (time windows)
- Leader can override locks

---------------------------------------------------------------------

# 3. Module Architecture (Unified System)

All modules have:
- Edit Screen
- Result Screen
- Minimum 1 Key Takeaway
- Optional Sharing
- Presentation mode

Modules:

3.1 Lesson Notes  
3.2 Life Tree  
3.3 Spiritual Gifts  
3.4 Values  
3.5 Listening Prayer  
3.6 Summary/Collage  
3.7 Goals (SMART)  
3.8 1:1 Conversation Results  
3.9 Group Photo (Result-only)

---------------------------------------------------------------------

# 3.1 Lesson Notes (Teachings)

## Edit Screen
- Input:
    - Text notes
    - Photos (slides, flipcharts, room pics)
- Guidance text: “Write down what stands out to you.”
- Required:
    - 1–3 Key Takeaways (user writes them)

## Result Screen
- Shows notes
- Shows images
- Shows key takeaways
- Share / Present available

---------------------------------------------------------------------

# 3.2 Life Tree (Special Editor)

## Edit Screen
- NOT a free canvas — dedicated tree builder:
    - Start with **Root = Birth**
    - Add Branch
    - Add Sub‑Branch
    - Add short labels per branch
    - Optional animations (future release)
- Required:
    - “Your 3 red threads”

## Result Screen
- Final tree view
- Key takeaways
- Share / Present

---------------------------------------------------------------------

# 3.3 Spiritual Gifts

## Edit Screen
- Structured slider-based questionnaire
- Multi-step wizard
- Auto-save

## Result Screen
- Computed Top 3 Gifts
- User-provided Key Takeaways
- Share/Present

---------------------------------------------------------------------

# 3.4 Values Assessment

## Edit Screen
- List of values
- Rating per value
- Sort options optional

## Result Screen
- Top 3 values
- Value interpretation notes
- Key Takeaways
- Share/Present

---------------------------------------------------------------------

# 3.5 Listening Prayer (Full Module)

## Edit Screen
A dynamic list of impressions.

### Behaviour:
- Each “Impression Card” has:
    - text input
    - image upload (optional)
    - assign-to-person selector (optional)
- Whenever user writes in the last empty impression,
  → **the system automatically adds a new empty card underneath**
- No “+” button required

## Result Screen
- List of own impressions
- List of received impressions (from others)
    - clearly marked „Received“
    - includes sender name
- Key takeaways (“3 highlights from listening prayer”)
- Share / Present

---------------------------------------------------------------------

# 3.6 Summary / Collage (Big Picture)

## Edit Screen
- Auto-loads all key takeaways from modules:
    - Values
    - Gifts
    - Life Tree
    - Listening Prayer
- Allows collage creation:
    - background
    - drag/drop elements
    - images
    - text chips

## Result Screen
- Final collage
- Share / Present

---------------------------------------------------------------------

# 3.7 Goals (SMART)

## Edit Screen
- Exactly 3 goal fields:
    - Goal 1 / Goal 2 / Goal 3
- Each has:
    - SMART check (tap to confirm S, M, A, R, T)

## Result Screen
- Goals displayed with SMART indicators
- Share / Present

---------------------------------------------------------------------

# 3.8 1:1 Conversation Results (Leader → Participant)

## Leader Edit Screen
- Leader writes:
    - feedback
    - recommendations
    - optional goal refinements
- Option “Share this with participant?”

## Participant Result Screen
- Only displays fields marked as “shared”
- Non-shared content is invisible

---------------------------------------------------------------------

# 3.9 Group Photo (Simple Result)

- Shown at end of weekend
- Downloadable
- No edit mode

---------------------------------------------------------------------

# 4. Sharing Dialog (4 Steps)

### Step 1 – Select Content
- Summary (recommended)
- Full content (requires confirmation)

### Step 2 – Preview
- Shows EXACT content others will see

### Step 3 – Select Audience
- Leader
- Group
- Presentation Mode

### Step 4 – Confirm
- Checkbox: “I understand what will be shared”
- Confirm button

---------------------------------------------------------------------

# 5. Presentation Mode

### Behaviour
- Always shows **“Shared by <Name>”**
- No private content visible
- Clean fullscreen
- Compatible with:
    - second monitor
    - Chromecast / AirPlay
    - in-app fullscreen

---------------------------------------------------------------------

# 6. Leader View

## Purpose
Leader sees **the same dashboard**, but cards open:

- Material/Teaching Screen
- Shared participant results

## Additional Leader Features
- Toggle: Leader View ↔ Participant View
- Access participant list
- Access group management (NEW)
- Access event editing (NEW „+“ button in Event Selection Screen)
- Access invitations & roles

---------------------------------------------------------------------

# 7. Materials / Teachings

- List of all sessions
- Documents:
    - PDFs
    - Markdown
    - Slides
- Each:
    - View
    - Download
    - “Create Lesson Notes” button

---------------------------------------------------------------------

# 8. Event Editor (Leader/Admin)

## Trigger
- On Event Selection Screen: AppBar has “+” button
- When selecting an existing event: “Edit Event” button

## Event Info Section
Editable text fields:
- Event title
- Description
- Location
- Address
- Event Date & Time
- Rooms (list)
- Map / building plan upload

## DFL Schedule Editor
- Load default DFL template (recommended)
- Each session:
    - Title
    - Time start/end
    - Room assignment
    - Module assignment (Values, Gifts, etc.)
    - Locking rules
- Reordering supported

## Group & Role Management
- List of people (searchable)
- For each person:
    - Assign role (Participant, Leader, Staff)
    - Assign group (e.g., Gruppe 1, Gruppe 2)
- Invite people:
    - by email
    - by QR link

## Registration Management
- Accept/deny registrations
- Show registration status
- “Registered” badge appears in event card
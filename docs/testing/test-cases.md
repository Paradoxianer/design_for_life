# Test Cases – DFL App

## 1. Event & Registration
| ID | Title | Description | Expected Result |
|----|-------|-------------|-----------------|
| TC-101 | Event Discovery | User opens Event Selection screen. | A list of upcoming events is shown based on locale/filters. |
| TC-102 | Registration | User clicks "Register" on an event card. | Status changes to "Pending", and registration record is created in DB. |
| TC-103 | Login Requirement | User tries to access a session without login. | App prompts for login/magic link. |

## 2. Reflection Modules (Unified Pattern)
| ID | Title | Description | Expected Result |
|----|-------|-------------|-----------------|
| TC-201 | Key Takeaway Entry | User enters 2 points in the "Key Takeaway" section of the Gifts module. | Points are saved and appear in the "Summary Collage". |
| TC-202 | Edit vs Result View | User completes a questionnaire and views the result. | App switches from Edit Mode (input) to Result Mode (visualization). |
| TC-203 | Autosave | User enters data and closes the app immediately. | Data is persisted in local SQLite and synced when back online. |

## 3. Privacy & Sharing
| ID | Title | Description | Expected Result |
|----|-------|-------------|-----------------|
| TC-301 | 4-Step Sharing | User initiates sharing of Life Tree summary. | System guides through Select Content -> Preview -> Audience -> Confirm. |
| TC-302 | Presentation Mode | User activates Presentation Mode for a session. | Clean view is shown; private notes are hidden; back button is restricted. |
| TC-303 | Prayer Note Ownership | Leader sends a prayer note to a participant. | Leader can no longer see the content after sending; recipient receives it. |

## 4. Visual Modules
| ID | Title | Description | Expected Result |
|----|-------|-------------|-----------------|
| TC-401 | Life Tree Builder | User adds a sub-branch to the "Roots". | UI updates tree structure; data is saved as JSON. |
| TC-402 | Collage Drag & Drop | User moves a "Key Takeaway" chip in the collage. | New coordinates are saved; layout is persisted. |
| TC-403 | SMART Check | User marks a goal as "Specific" and "Measurable". | Checkmarks are visually highlighted and saved. |

## 5. Offline & Sync
| ID | Title | Description | Expected Result |
|----|-------|-------------|-----------------|
| TC-501 | Offline Entry | User writes a private note in Airplane Mode. | Note is saved locally with `sync_status = PENDING`. |
| TC-502 | Sync on Recovery | User disables Airplane Mode. | App automatically pushes pending changes to the backend. |

## 6. Admin & Management
| ID | Title | Description | Expected Result |
|----|-------|-------------|-----------------|
| TC-601 | Create Event | Admin adds a new event via the "+" button. | Event appears in the discovery list for all users. |
| TC-602 | Schedule Locking | Current time is before session start. | Session card shows "Locked" status and cannot be edited. |
| TC-603 | Group Assignment | Admin assigns User A to Group 1. | User A sees Group 1 on their dashboard; Leader of Group 1 sees User A. |
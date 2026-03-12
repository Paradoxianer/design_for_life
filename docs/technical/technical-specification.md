# Technical Specification – DFL App (MVP)

**Status:** Draft v0.9  
**Scope:** MVP features per `requirements.md` with Listening‑Prayer sharing and recipient‑owned Prayer Notes  
**Audience:** Engineering, QA, Security, Product

---

# 1. Goals & Non‑Goals

## 1.1 Goals
- Deliver a **privacy‑first, offline‑capable** app for DFL weekends across iOS, Android and Web.
- Digitize **gifts/values assessments**, **Life Tree**, **Listening‑Prayer notes**, and **materials/schedule**.
- Implement **fine‑grained visibility** and **temporary sharing** (Presentation Mode).
- Support **recipient‑owned Prayer Notes** (others → participant) with strict privacy.
- Provide a highly simplified UX that hides complexity.

## 1.2 Non‑Goals (MVP)
- Payments / event ticketing.
- Social chat system.
- Full online e-learning.
- External editor integrations (Google Docs / Microsoft 365) → future release.

---

# 2. System Overview

## Frontend (Flutter)
- Flutter app on iOS, Android, Web
- Local encrypted datastore
- Offline-first UX
- Background sync queue
- Single codebase with platform adaptions (e.g., Presentation Mode)

## Backend
- Node.js (NestJS) **or** .NET 8 Web API
- REST-first, GraphQL optional in R2
- JWT authentication & token refresh
- Enforces role- and visibility checks

## Storage
- PostgreSQL relational database
- JSONB for flexible answer payloads
- Encrypted object storage (e.g., AWS S3 Frankfurt) for:
  - Life Tree images
  - Teachings/PDFs
  - Slides / Collage elements

## Authentication
- OAuth2/OIDC
- PKCE for mobile & web
- JWT Access Token (short-lived)
- Refresh Token (longer-lived)
- Device-bound session storage

---

# 3. Roles & Access Model (RBAC)

### 3.1 Participant
- Owns all personal content
- Can edit: gifts, values, life tree, notes, listening prayer, goals
- Can share: summary (default) or full content
- Can revoke shared content at any time
- Can receive Prayer Notes (recipient-owned)
- Sees group assignment & room assignments

### 3.2 Leader
- Can view only content explicitly shared by participant
- Cannot access private content
- Can create Prayer Notes for participants
- Cannot re-open what they sent
- Can edit event schedule (if assigned role)
- Can override session lock/unlock
- Can assign group membership (if allowed)

### 3.3 Admin
- Manages users, groups, events, materials
- Can create & edit events
- Cannot view personal spiritual content

### Visibility Flags
private | shared_leader | shared_group | temporary_session

### Special Rule
**Prayer Notes** (others → participant):  
- Always *recipient-owned*
- Sender loses access immediately after creation
- Cannot be shared by sender; only participant may create a summary to share

---

# 4. Data Model (summarized)

> Full schema in `data-model.md`

Main structures:
- users
- events
- schedule
- groups
- rooms
- user_group_assignments
- assessments  
  - assessment_answers (JSONB)
- life_tree
- listening_prayer_notes
- notes_private
- notes_shared_summary
- prayer_notes (recipient-owned)
- materials
- files
- temporary_share_tokens
- reference_invites
- reference_answers

---

# 5. API Design (REST)

## 5.1 General
- Base URL: `/api/v1`
- JSON only
- ISO‑8601 timestamps
- Auth header: `Authorization: Bearer <token>`
- Pagination: `?page=&pageSize=`

---

## 5.2 Authentication & Session
POST /auth/login
POST /auth/refresh
POST /auth/logout

Sample Login Response:
```json
{
  "accessToken": "...",
  "expiresIn": 3600,
  "refreshToken": "...",
  "user": {
    "id": "123",
    "role": "participant",
    "locale": "en"
  }
}

## 5.3 Events
List Events
GET /events?upcoming=true

Includes automatic region filtering.
Create Event (Leader/Admin)
POST /events

Update Event
PUT /events/:id

Register / Unregister
POST /events/:eventId/register
POST /events/:eventId/unregister

Assign Role or Group
POST /events/:eventId/assign
{
  "userId": "...",
  "role": "participant|leader|staff",
  "groupId": "..."
}

## 5.4 Groups
GET /events/:id/groups
POST /events/:id/groups
POST /groups/:id/assign

## 5.5 Rooms
GET /events/:eventId/rooms
POST /events/:eventId/rooms

## 5.6 Schedule
GET /events/:eventId/schedule
POST /events/:eventId/schedule
PUT  /schedule/:id

## 5.7 Assessments (Gifts/Values)
Create Assessment
POST /events/:eventId/assessments

Save Answers
PUT /assessments/:id/answers

Get Summary
GET /assessments/:id/summary

Leader can only read if shared.

## 5.8 Life Tree
POST /events/:eventId/life-tree
GET  /participants/:id/life-tree

##5.9 Listening Prayer
Create or Edit impressions
POST /events/:eventId/listening-prayer
PUT  /listening-prayer/:id

Share
POST /listening-prayer/:id/share
POST /listening-prayer/:id/revoke

Leader view (shared only)
GET /participants/:id/listening-prayer

## 5.10 Prayer Notes (others → participant)
Create (leader or participant to participant)
POST /prayer-notes/:recipientId

Recipient Inbox
GET /me/prayer-notes/received

## 5.11 Reference Feedback
POST /events/:eventId/reference-invites
POST /reference-answers/:token
GET  /participants/:id/reference/aggregate


## 5.12 Materials / Teachings
GET  /events/:id/materials
POST /events/:id/materials
GET  /materials/:id


## 5.13 Temporary Sharing Tokens (Presentation Mode)
POST /share-tokens
GET  /share-tokens/:token

Token returns a read-only safe representation.

# 6. Security & Privacy
## 6.1 Transport & Storage Security

TLS 1.2+ everywhere
DB volume encrypted
Field-level encryption:

private notes
listening prayer
prayer notes



## 6.2 Authentication Security

Short-lived access tokens
Long-lived refresh tokens
Device-bound refresh token storage
PKCE enforced for mobile/web

## 6.3 Authorization Security

Server enforces:

role
visibility flag
ownership



## 6.4 Logging

No spiritual or private content logged
Only metadata (user id, route, timestamp)
Access logs for shared content

## 6.5 Rate Limits

Protect Prayer Notes
Protect registration/invite endpoints


# 7. Offline & Sync
## 7.1 Local Database
Encrypted SQLite using:

sqflite
cryptography (AES-GCM)

Stores:

assessments (draft)
listening prayer drafts
life tree drafts
notes
materials (cached)
schedule

## 7.2 Sync Strategy

background queue
retry mechanism
Conflict resolution:

LWW for fields
append-only for Prayer Notes



Presentation Mode tokens require network.

# 8. Error Codes
400 bad input
401 unauthorized
403 forbidden (role/visibility)
404 not found / not shared
409 conflict
410 gone (expired)
422 invalid schema
429 too many requests
500 server error


# 9. Database Schema (DDL Excerpt)
Enum
visibility = private | shared_leader | shared_group | temporary_session

Core Tables Summary

users(id, email, role, locale)
events(id, title, date, roomsJson)
groups(id, event_id)
schedule(id, event_id, module_type, time_start, time_end, room_id)
assessments(id, user_id, event_id, type, version, status)
assessment_answers(assessment_id, answers_jsonb)
life_tree(id, user_id, event_id, summary_text, visibility)
listening_prayer_notes(id, user_id, event_id, content_encrypted, visibility)
notes_shared_summary(id, user_id, event_id, source_type, content_json)
prayer_notes(id, from_user, to_user, content_encrypted)
materials(id, file_id, title)
temporary_share_tokens(id, item_id, token_hash, expires_at)


# 10. Sequence Diagrams (Text Summary)
Listening Prayer Share

Write → local save → sync → summary created → leader reads summary.

Prayer Note

Leader writes → sends → sender loses read access → participant inbox.

Presentation Token

User → token request → backend creates read-only → viewer loads → auto-expire.


# 11. Internationalization

strings and assessments loaded from i18n tables
JSONB answering is language-neutral
material files may exist per locale


# 12. Migrations & Versioning

Flyway or Liquibase
forward-only migrations
version tags per release


# 13. Deployment

dev / staging / prod
CI/CD:

lint, test, build
db migrations
smoke tests


Secrets stored in cloud vault


# 14. Open Questions

Standardized LP Summary schema
Presentation Mode TTL default (10/20/30 min)
Allow participant full export (ZIP/PDF bundle)

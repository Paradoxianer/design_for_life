# Technical Specification – DFL App (MVP+)

**Status:** Draft v1.0  
**Scope:** MVP+ features including Event Management and Visual Collage.

---

# 1. System Architecture Details

## 1.1 Flutter Frontend
- **State Management:** Provider or BLoC (to be decided in implementation).
- **Local Storage:** `sqflite_sqlcipher` for encrypted offline data.
- **Image Handling:** `cached_network_image` for materials; custom implementation for Life Tree/Collage export.
- **Navigation:** GoRouter for deep-linking support (Event Invitations).

## 1.2 Backend API (Rest/GraphQL)
- **Event Selection Logic:** Automatic filtering based on IP-Geolocation or User Locale.
- **Magic Links:** Implementation via SendGrid or similar for passwordless login.
- **Sync Engine:** Version-based conflict resolution (Last-Write-Wins per field).

---

# 2. Module Specifications

## 2.1 Unified Module Pattern
Every module widget must implement:
- `EditView`: Form-based input.
- `ResultView`: Read-only visualization.
- `KeyTakeawayComponent`: Shared UI for capturing the 1-3 highlights.

## 2.2 Life Tree Builder
- Custom Painter or SVG-based manipulation for the tree structure.
- Logic to prevent overlapping branches.
- Export as high-resolution PNG for the Collage.

## 2.3 Visual Collage (The "Big Picture")
- **Canvas:** Drag-and-drop workspace using `Positioned` widgets.
- **Source Data:** Pulls all `KeyTakeaway` entries from other modules.
- **State:** Saved as a JSON structure of coordinates and references.

---

# 3. Event & Admin Specifications

## 3.1 Schedule Locking
- Backend-driven locking mechanism based on `session.start_time`.
- Leader Override: A boolean flag `is_manual_unlocked` in the session record.

## 3.2 Registration Flow
1. User clicks "Register".
2. Record created in `registrations` with status `PENDING`.
3. Admin receives notification/updates list.
4. On approval, User gets access to event-specific materials and schedule.

---

# 4. Presentation Mode Implementation
- Uses a `SafeRoute` wrapper that blocks the back button and drawer.
- Backend provides a 30-minute JWT via `temporary_share_tokens`.
- No sensitive data (e.g., user profile, private notes) is included in the payload of the presentation endpoint.

---

# 5. Deployment Strategy
- **Backend:** Dockerized on AWS Fargate or Hetzner Cloud.
- **CI/CD:** GitHub Actions for automated testing and deployment.
- **Environment Management:** Separate `dev`, `staging`, and `prod` environments.

---

# 6. Monitoring & Maintenance
- **Error Reporting:** Sentry or Firebase Crashlytics.
- **Analytics:** PostHog (self-hosted) for usage patterns (GDPR compliant).
- **Backups:** 24h interval for DB and Object Storage.
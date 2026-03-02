# Non-Functional Requirements – DFL App

## 1. Usability
- The app must be intuitive and easy to use, even for users with low technical experience.
- Navigational structure must be simple, with clear labels and minimal complexity.
- Important functions (notes, questionnaires, schedule) must be reachable within max. 2–3 taps.
- Provide short explanations or tooltips where needed.

## 2. Performance
- Screens must load within 2 seconds under normal network conditions.
- Offline actions (notes, questionnaires) must respond instantly.
- Sync operations should not block the UI; syncing must run in the background.

## 3. Reliability & Availability
- The app should work reliably even with unstable WiFi, as typical at retreat locations.
- Core features must be available offline (questionnaires, notes, Life Tree viewer).
- The backend service must aim for at least 99% uptime during event weekends.

## 4. Offline Capability
- Questionnaires, notes, and Life Tree content must be fully usable without internet.
- Data created offline should sync automatically once a connection is restored.
- Conflicts must be handled gracefully (e.g., user gets prompted to choose a version).

## 5. Security
- All communication must be encrypted (HTTPS/TLS).
- Sensitive data (notes, assessments, Life Tree) must be encrypted at rest.
- Role-based access control: participants, leaders, and admins see only what is intended.
- No leader may access participant notes or unshared information.
- Passwords stored using industry-standard hashing (e.g., bcrypt or Argon2).
- Regular security audits must be performed (internally or externally).

## 6. Privacy & GDPR Compliance
- All personal data processing must follow GDPR principles.
- Explicit consent must be collected for:
    - data storage,
    - sharing with leaders,
    - reference-person invitations.
- Participants must be able to:
    - request data deletion,
    - view what is stored,
    - revoke sharing.
- Reference responses must be stored separately and anonymized where appropriate.
- Data retention policy: participant data should be deleted or anonymized after the event unless user opts in.

## 7. Accessibility
- Color contrast must meet WCAG AA or better.
- Font sizes must scale with system accessibility settings.
- All interactive elements must have adequate touch size (min. 44x44px).
- Screen reader support required (labels, focus order, descriptions).

## 8. Cross-Platform Support
- The app must run on:
    - iOS (latest + previous major version)
    - Android (latest + previous major version)
    - Web (Chrome, Safari, Edge)
- Experience should be consistent across platforms.

## 9. Internationalization (i18n)
- All user interface text must be stored in translatable language files.
- Support for multiple languages from the start (e.g., English, German).
- The system must allow easy addition of new languages without code changes.
- Ensure proper support for:
    - special characters,
    - right-to-left languages (future),
    - locale-specific formatting.

## 10. Scalability
- The backend must handle growth in:
    - number of users,
    - number of events,
    - number of uploaded files.
- Architecture should support multiple DFL weekends running parallel (future expansion).

## 11. Data Storage & Backup
- Daily encrypted backups must be performed.
- Restore process must be documented and testable.
- Uploaded images (Life Trees) must be optimized for storage but retain clarity.

## 12. Maintainability
- Codebase must follow clean architecture principles.
- Features should be modular and easy to extend.
- Documentation for developers must be maintained (API, components, data structure).

## 13. Logging & Monitoring
- System errors must be logged securely on the server side.
- No sensitive personal data may appear in logs.
- Admins must have access to basic system health metrics (uptime, sync issues).

## 14. Legal & Ethical Requirements
- The system must respect spiritual sensitivity and confidentiality.
- No automated decision-making about spiritual giftedness.
- No algorithmic scoring of personal spiritual content.
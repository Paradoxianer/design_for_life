# Non-Functional Requirements – DFL App

## 1. Usability
- The app must be intuitive and easy to use, even for users with low technical experience.
- Navigational structure must be simple (Dashboard -> Module -> Result).
- Important functions (notes, questionnaires, schedule) must be reachable within max. 2–3 taps.
- **Presentation Mode:** One-tap activation for safe sharing in groups.
- Provide short explanations or tooltips for spiritual terms where needed.

## 2. Performance
- Screens must load within 2 seconds under normal network conditions.
- **Collage Rendering:** The visual summary collage must be interactive and responsive even with multiple image elements.
- Offline actions (notes, questionnaires) must respond instantly.
- Sync operations should not block the UI; syncing must run in the background.

## 3. Reliability & Availability
- The app should work reliably even with unstable WiFi, as typical at retreat locations.
- Core features must be available offline (questionnaires, notes, Life Tree viewer, Schedule).
- The backend service must aim for at least 99.9% uptime during active event weekends.

## 4. Offline Capability
- Questionnaires, notes, Life Tree, and **Event Schedule** must be fully usable without internet.
- Event discovery and registration require an active connection, but registered events must be cached.
- Data created offline should sync automatically once a connection is restored.
- Conflicts must be handled gracefully (e.g., Last-Write-Wins or user prompt).

## 5. Security
- All communication must be encrypted (HTTPS/TLS 1.3).
- Sensitive data (notes, assessments, Life Tree) must be encrypted at rest on-device and on-server.
- **Role-based access control (RBAC):** Strictly enforced for Participant, Leader, and Admin roles.
- **Privacy Partitioning:** Leaders never have access to private participant notes.
- Passwords/Auth: Use secure Magic Links or industry-standard hashing.

## 6. Privacy & GDPR Compliance
- All personal data processing follows GDPR principles (EU-based servers).
- **Explicit consent** collected for: data storage, sharing with leaders, and reference-person feedback.
- **Presentation Mode Security:** No private data (e.g., name, unshared notes) is included in the presentation stream/token.
- Data retention: Participant data deleted/anonymized after the event unless user opts-in to a long-term profile.

## 7. Accessibility
- Color contrast must meet WCAG AA or better.
- Font sizes must scale with system accessibility settings.
- All interactive elements must have adequate touch size (min. 44x44px).
- Screen reader support for all standard modules.

## 8. Cross-Platform Support
- **iOS & Android:** Native-like performance via Flutter.
- **Web:** Full functionality for Admin tools and Participant registration.
- **Presentation Support:** Support for wireless casting (AirPlay/Chromecast) or external HDMI connection for Presentation Mode.

## 9. Internationalization (i18n)
- Support for multiple languages (German, English initially).
- Content-level translation: Schedule and materials must be available in the user's selected language.
- New languages can be added via the Admin interface without code changes.

## 10. Scalability
- Backend architecture must support simultaneous DFL weekends in different locations.
- Support for thousands of concurrent users during peak weekend hours.

## 11. Maintenance & Logging
- **Clean Architecture:** Codebase follows a strict separation of concerns (UI/Logic/Data).
- **Audit Logging:** Logs for all administrative actions and leader access to shared data.
- **Monitoring:** Real-time health metrics for the sync engine and database.
# Security and Privacy – DFL App

## 1. Privacy by Design
The DFL App handles highly sensitive spiritual and personal data. Privacy is not a feature, but the core of the architecture.

### 1.1 Data Ownership
- Participants own all their data.
- Leaders and Admins have zero access to private notes, unshared life trees, or unshared questionnaire results.
- "Privacy by Default": All new entries are private unless explicitly shared.

### 1.2 Multi-Tenancy & Event Isolation
- Data is strictly partitioned by `event_id`.
- A user's role (Participant/Leader/Admin) is event-specific. A leader in Event A might be a participant in Event B.

---

## 2. Data Encryption

### 2.1 Encryption at Rest
- **Client-Side:** Local SQLite database is encrypted using AES-256 (via `sqflite_sqlcipher` or similar).
- **Server-Side:** Database volumes are encrypted.
- **Field-Level Encryption:** Sensitive fields (Prayer Notes, Private Notes) are encrypted with user-specific keys before storage, ensuring even DB admins cannot read the content.

### 2.2 Encryption in Transit
- All communication is forced over TLS 1.3.
- Certificate pinning is used in mobile apps to prevent Man-in-the-Middle (MitM) attacks.

---

## 3. Sharing & Visibility Controls

### 3.1 The 4-Step Sharing Dialog
To prevent accidental sharing, every share action follows a strict 4-step process:
1. **Select Content:** Summary vs. Full.
2. **Preview:** Show exactly what the other person will see.
3. **Select Audience:** Leader, Group, or Presentation.
4. **Confirm:** Explicit acknowledgement of the action.

### 3.2 Presentation Mode
- A dedicated "Safe View" that strips all navigation and private data.
- Generates a temporary, short-lived `ShareToken` on the backend.
- The token expires automatically after the session (default 30 min).
- No data is cached on the device used for presentation.

### 3.3 Prayer Notes (Interpersonal)
- **Asymmetric Access:** Once a note is sent, the sender loses access.
- **Recipient Ownership:** The note is moved to the recipient's encrypted partition.
- **Immutability:** Sent notes cannot be edited by either party.

---

## 4. Authentication & Authorization

### 4.1 Authentication
- Modern OAuth2 / OpenID Connect flow.
- Support for "Magic Links" to reduce password friction while maintaining security.
- Biometric lock (Optional) for the mobile app to protect local data.

### 4.2 Role-Based Access Control (RBAC)
- **Participant:** Access to own data + shared group info.
- **Leader:** Access to group member summaries (if shared).
- **Admin:** Access to event configuration and user management. No access to spiritual data.

---

## 5. Compliance (GDPR)
- **Data Locality:** All servers and backups are located within the EU (Frankfurt region).
- **Right to be Forgotten:** Automated deletion/anonymization of participant data 30 days after the event ends (unless the user opts to keep their "Life Tree" for future use).
- **Data Portability:** Feature to export all personal data as an encrypted PDF/ZIP.

---

## 6. Audit Logging
- Every access to shared content by a leader is logged (Who, When, What).
- Logs are accessible only to System Admins for compliance checks.
- No sensitive content is ever written to logs.
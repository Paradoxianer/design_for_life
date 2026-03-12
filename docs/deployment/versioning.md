# Versioning Strategy – DFL App

## 1. Semantic Versioning
The DFL App follows [Semantic Versioning 2.0.0](https://semver.org/):
- **MAJOR:** Incompatible API changes or complete UI overhauls.
- **MINOR:** New features (e.g., a new reflection module) in a backwards-compatible manner.
- **PATCH:** Backwards-compatible bug fixes or security patches.

## 2. Platform Specifics

### 2.1 Mobile (iOS/Android)
- **Version Name:** The semantic version (e.g., `1.2.3`).
- **Build Number:** Incremental integer for every store submission.
- **Update Strategy:** Critical security fixes will use "Force Update" via Firebase Remote Config.

### 2.2 Backend API
- **URL Versioning:** `/api/v1/`
- Breaking changes require a new major version (`/api/v2/`) to support older app installs during the transition period.

## 3. Pre-Release Tags
- `alpha`: Internal testing (Engineering).
- `beta`: Closed testing (Selected DFL Leaders).
- `rc`: Release Candidate for final testing before the weekend.

## 4. Documentation Versioning
- Project documentation is versioned alongside the code in the `/docs` directory.
- Major project milestones (e.g., "MVP Complete") are tagged in Git.
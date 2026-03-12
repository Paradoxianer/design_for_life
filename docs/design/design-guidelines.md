# Design Guidelines – DFL App

## 1. Visual Philosophy: "Spiritual Minimalism"
The DFL App is a tool for reflection, not a source of distraction. The design must feel calm, spacious, and welcoming.

### 1.1 Core Principles
- **Clutter-Free:** Every element on the screen must have a purpose. Remove unnecessary borders, shadows, or decorations.
- **Focus on Content:** Use whitespace (negative space) to guide the eye to the user's reflections.
- **Softness:** Use rounded corners (standard `12px` or `16px`) and soft color transitions.
- **Intentional Color:** Colors should evoke peace and growth, not urgency.

---

## 2. Color Palette

### 2.1 Primary Colors (Growth & Life)
- **Primary (Forest Green):** `#2D5A27` – Used for primary actions and the "Life Tree".
- **Secondary (Earth Brown):** `#8B5E3C` – Used for roots and grounding elements.
- **Accent (Sunlight Gold):** `#F4D03F` – Used for "Key Takeaways" and highlights.

### 2.2 Semantic Colors
- **Success:** Soft Green (not neon).
- **Warning:** Muted Orange.
- **Background:** Off-White or very light Grey (`#F9F9F9`) to reduce eye strain.
- **Surface:** Pure White for cards.

---

## 3. Typography
- **Primary Font:** A clean, legible Sans-Serif (e.g., *Inter* or *Roboto*) for maximum readability.
- **Heading Font:** A slightly more elegant Serif (e.g., *Playfair Display*) for titles to create a "journal" feel.
- **Hierarchy:**
    - `H1`: 24px Serif, Bold (Screen Titles)
    - `H2`: 18px Sans, Semi-Bold (Section Headers)
    - `Body`: 16px Sans, Regular (Inputs and Notes)
    - `Caption`: 12px Sans, Light (Metadata)

---

## 4. UI Components & Patterns

### 4.1 The "Reflection Card"
- Elevation: `1` or `2` (very subtle).
- Padding: `16px` or `20px` internal padding.
- Standardized status icons (Done, Locked, In Progress).

### 4.2 Unified Module Pattern
- **Edit Mode:** Subtle input fields with clear hint texts. Avoid heavy borders.
- **Result Mode:** High-contrast visualization (e.g., the Top 3 Gifts in a highlighted list).
- **Key Takeaway Area:** Always highlighted with the Accent color (Gold) to emphasize its importance.

### 4.3 Presentation Mode (Safe View)
- Dark mode optional for better contrast on beamers.
- Hide all UI chrome (Navigation bars, FABs).
- Increased font size for legibility at a distance.

---

## 5. Icons & Imagery
- **Icon Style:** Linear/Outlined icons with a consistent stroke weight (2px).
- **Illustrations:** Use organic, hand-drawn styles where possible (especially for the Life Tree).
- **Photos:** Displayed with rounded corners and subtle shadows.

---

## 6. Motion & Interaction
- **Transitions:** Use slow, meaningful fades and slide-ins. No fast or "bouncy" animations.
- **Feedback:** Subtle haptic feedback for important actions (e.g., saving a note).
- **State Changes:** Smoothly morph from Edit Mode to Result Mode.
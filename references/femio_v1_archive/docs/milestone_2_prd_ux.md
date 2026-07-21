# Milestone 2: PRD + UX Wireframes + Style Guide

## Table of Contents
1. [Product Requirements Document (PRD)](#prd)
2. [User Personas](#personas)
3. [Functional Requirements](#functional-requirements)
4. [Non-Functional Requirements](#non-functional-requirements)
5. [UX Wireframes](#ux-wireframes)
6. [UI Style Guide](#ui-style-guide)
7. [Data Model](#data-model)
8. [Navigation Map](#navigation-map)

---

<a name="prd"></a>
## 1. Product Requirements Document (PRD)

### 1.1 Product Overview

**Product Name**: Femio – Period & Pregnancy Tracker  
**Arabic Name**: Femio – حاسبة الدورة والحمل  
**Version**: 1.0 (MVP)  
**Platform**: Android (primary), iOS-ready architecture  
**Markets**: Egypt, KSA, UAE, Morocco, Algeria  
**Languages**: English, Arabic (MSA)  

**Vision Statement**:  
Femio is the privacy-first, lifecycle-aware reproductive health companion that empowers MENA women with transparent predictions, medical-grade content, and advanced monitoring—all while keeping their most sensitive data encrypted and local-first.

**Mission Statement**:  
To build trust through transparency, privacy, and cultural respect, guiding women through every stage of their reproductive journey with actionable insights and medically sound education.

---

<a name="personas"></a>
## 2. User Personas (MENA Focus)

### Persona 1: Nour – The Privacy-Conscious Tracker
**Demographics**:
- Age: 24
- Location: Cairo, Egypt
- Occupation: Graphic designer
- Marital status: Single
- Tech-savvy: High

**Goals**:
- Track periods accurately for health awareness
- Avoid pregnancy (not trying to conceive)
- Keep health data completely private (family/cultural concerns)
- Understand cycle patterns and hormone fluctuations

**Pain Points**:
- Distrusts apps that force cloud storage
- Lives with family, needs discreet notifications
- Previous app had poor Arabic translation
- Afraid of data leaks in conservative society

**Femio Solution**:
- ✅ Local-first encrypted storage
- ✅ Discreet mode (masked notifications)
- ✅ Professional MSA with full RTL support
- ✅ No forced account creation
- ✅ Explainable predictions build trust

**User Journey**:
1. Downloads Femio after reading about privacy-first approach
2. Completes onboarding, selects "Tracking cycles" mode
3. Logs 3 cycles → sees range-based predictions with confidence levels
4. Enables discreet mode
5. Becomes daily user, logs symptoms consistently
6. After 6 months, upgrades to Pro for advanced hormone tracking (studying PCOS symptoms)

---

### Persona 2: Layla – The TTC (Trying to Conceive) Planner
**Demographics**:
- Age: 31
- Location: Riyadh, KSA
- Occupation: Teacher
- Marital status: Married (2 years, no children yet)
- Tech-savvy: Medium

**Goals**:
- Get pregnant within 6-12 months
- Understand fertile window accurately
- Track BBT, cervical mucus, intercourse timing
- Monitor potential fertility issues (irregular cycles)
- Export data for doctor consultations

**Pain Points**:
- Previous app predictions were inaccurate (irregular cycles)
- No explanation when prediction changed suddenly
- Frustrated by generic advice ("just relax!")
- Can't afford expensive ovulation tests every month
- Needs doctor-friendly data export

**Femio Solution**:
- ✅ Explainable fertile window with confidence indicators
- ✅ "Why changed" explanations when predictions adjust
- ✅ Detailed symptom/mucus tracking
- ✅ Doctor export pack (Pro) for fertility consultation
- ✅ Respectful, educational TTC content (no false promises)

**User Journey**:
1. Downloads Femio after 6 months of unsuccessful TTC
2. Onboarding: selects "Trying to conceive"
3. Logs 4 cycles with detailed symptoms/mucus
4. Sees honest confidence level: "Medium confidence (irregular cycles detected)"
5. Learns from content cards about cycle variability
6. After 3 months, upgrades to Pro for hormone tracking and export pack
7. Brings PDF export to fertility doctor → diagnosed with hypothyroidism
8. Continues using Femio during treatment

---

### Persona 3: Amira – The Expecting Mother
**Demographics**:
- Age: 28
- Location: Dubai, UAE
- Occupation: Marketing manager
- Marital status: Married, first pregnancy (Week 14)
- Tech-savvy: High

**Goals**:
- Track pregnancy week-by-week with reliable information
- Monitor blood pressure (family history of preeclampsia)
- Log weight gain and vitals for doctor visits
- Understand baby's development milestones
- Access MENA-relevant pregnancy content (not Western-only)

**Pain Points**:
- Previous pregnancy app had poor Arabic content (machine translated)
- No BP tracking feature (buying separate app)
- Overwhelmed by alarmist articles ("10 signs of danger!")
- Can't find culturally appropriate advice (all Western sources)
- Worried about data privacy (pregnancy status is sensitive)

**Femio Solution**:
- ✅ Week-by-week pregnancy timeline with compliant content (ACOG/WHO)
- ✅ Integrated vitals tracking: BP, weight, glucose
- ✅ Pregnancy BP monitoring profile (Pro) with educational thresholds
- ✅ Professional MSA content, culturally sensitive
- ✅ Safety language (no alarmist phrasing)
- ✅ Local-first privacy (pregnancy data never leaves device unless Pro sync enabled)

**User Journey**:
1. Discovers she's pregnant, switches from period tracking app to Femio
2. Onboarding: selects "I'm pregnant", enters due date
3. Sees week 14 content: baby size, development, appointment checklist
4. Logs BP readings before each prenatal visit
5. At week 20, doctor mentions monitoring BP closely (family history)
6. Upgrades to Pro for pregnancy BP monitoring profile
7. Logs BP 2x daily, sees visual trends with educational tooltips
8. Exports comprehensive vitals chart for doctor → everything normal
9. Continues through pregnancy and postpartum (transitions to postpartum mode)

---

### Persona 4: Sara – The Postpartum & New Mom
**Demographics**:
- Age: 26
- Location: Casablanca, Morocco
- Occupation: Stay-at-home mom (formerly accountant)
- Marital status: Married, 6-week-old baby girl
- Tech-savvy: Medium

**Goals**:
- Track postpartum bleeding/recovery
- Log baby's feeding and sleep (basic)
- Understand when period will return
- Monitor postpartum depression symptoms (mood tracking)
- Access newborn care basics (safe sleep, feeding tips)

**Pain Points**:
- Previous pregnancy app stopped being useful after birth
- No postpartum recovery guidance
- Overwhelmed by conflicting newborn advice online
- Sleep-deprived, needs simple logging interface
- Privacy concerns (baby photos, feeding data)

**Femio Solution**:
- ✅ Postpartum mode: bleeding/recovery tracking, period return detection
- ✅ Newborn basics: feeding/sleep log with safe, evidence-based tips (WHO/NHS)
- ✅ Mood tracking with postpartum-specific tags
- ✅ Simple, fast logging (one-tap shortcuts)
- ✅ Local-first: no baby data uploaded without consent

**User Journey**:
1. Switches from pregnancy mode to postpartum mode at birth
2. Logs postpartum bleeding (heavy → medium → light)
3. Uses quick-log for baby feeding/sleep (in middle of night)
4. Reads educational cards: "When to call doctor", "Safe sleep basics"
5. At 8 weeks postpartum, first period returns → Femio detects and transitions back to cycle tracking
6. Becomes loyal user: plans to use Femio for future pregnancies

---

### Persona 5: Fatima – The Special Circumstances User
**Demographics**:
- Age: 33
- Location: Alexandria, Egypt
- Occupation: University professor
- Marital status: Married, undergoing IVF treatment (2nd cycle)
- Tech-savvy: High

**Goals**:
- Track IVF protocol: injections, medications, appointments
- Monitor hormone levels (E2, progesterone, LH)
- Manage complex medication schedule (10+ meds/supplements)
- Reduce stress through organized tracking
- Export comprehensive data for fertility clinic

**Pain Points**:
- No existing app supports IVF-specific tracking
- Using 3 separate apps: period tracker + med reminder + notes app
- Expensive IVF cycle ($4,000+), needs to optimize every detail
- Emotionally exhausted, needs supportive (not cutesy) interface
- Previous miscarriage (needs sensitive handling if this cycle fails)

**Femio Solution**:
- ✅ IVF mode (v1.5): protocol tracking, injection logs, med reminders
- ✅ Hormone/lab tracking with visual charts
- ✅ Appointment planner with notes
- ✅ Respectful, clinical interface (no "baby dust" language)
- ✅ Miscarriage recovery mode available if needed (supportive, educational)

**User Journey** (v1.5 feature):
1. Using Femio for cycle tracking for 1 year (loyal user)
2. Starts IVF, switches to IVF mode
3. Logs stimulation medications, injection times, side effects
4. Tracks E2, progesterone, LH levels from clinic
5. Visualizes hormone charts → notices optimal response day 8
6. Exports data for clinic → doctor praises thoroughness
7. Cycle is successful → transitions to pregnancy mode
8. *(Alternative path)* If cycle fails → optional miscarriage recovery mode with supportive content

---

<a name="functional-requirements"></a>
## 3. Functional Requirements (MVP v1.0)

### FR-1: Onboarding & Setup

#### FR-1.1: Welcome Flow
**Requirement**: Display privacy-first welcome screens with clear value propositions.  
**Acceptance Criteria**:
- Screen 1: "Your data, your device" (local-first messaging)
- Screen 2: "Explainable predictions you can trust" (range + confidence visual)
- Screen 3: "Supports your full journey" (lifecycle stages visual)
- All text available in EN and AR MSA
- Skip button available (minimum 2 screens must be viewed)

#### FR-1.2: Language Selection
**Requirement**: Allow users to select language before entering app.  
**Acceptance Criteria**:
- Options: English, العربية
- Device language auto-detected as default
- Language can be changed later in Settings
- RTL layout switches instantly when Arabic selected

#### FR-1.3: Stage Selection
**Requirement**: User selects primary tracking mode during onboarding.  
**Acceptance Criteria**:
- Options:
  1. "Just exploring" (skip setup)
  2. "Tracking cycles" (period mode)
  3. "Trying to conceive" (TTC mode)
  4. "I'm pregnant" (pregnancy mode)
  5. "Postpartum" (v1.1 - not MVP)
- Visual icons per stage (feminine, medical-grade)
- Stage can be changed later in Settings
- Each stage shows 1-sentence description

#### FR-1.4: Cycle Setup (for "Tracking cycles" / "TTC")
**Requirement**: Collect minimal data to initialize cycle predictions.  
**Acceptance Criteria**:
- Input: Last period start date (calendar picker)
- Optional: Last period end date
- Optional: Average cycle length estimate (slider: 21-40 days, default 28)
- Optional: Average period duration (slider: 2-8 days, default 5)
- "I don't know" option (app will learn from first logged cycle)
- Data saved locally, encrypted

#### FR-1.5: Pregnancy Setup (for "I'm pregnant")
**Requirement**: Calculate due date and current pregnancy week.  
**Acceptance Criteria**:
- Input method 1: Last menstrual period (LMP) date
- Input method 2: Due date (if known from doctor)
- Input method 3: Conception date estimate
- Calculate gestational age (weeks + days)
- Display current week and due date on confirmation screen
- If >40 weeks calculated, show warning ("Please verify date")

#### FR-1.6: Privacy Consent
**Requirement**: Obtain clear consent for analytics and ads.  
**Acceptance Criteria**:
- Two toggles (both off by default):
  1. "Help improve Femio (anonymous analytics)"
  2. "Show relevant ads (supports free version)"
- Clear description under each toggle (1-2 sentences)
- "Learn more" link → Privacy Policy
- Can proceed with both toggles off
- Consent can be changed later in Settings

---

### FR-2: Cycle Tracking (Period Mode)

#### FR-2.1: Period Logging
**Requirement**: Users can log period start, end, and flow details.  
**Acceptance Criteria**:
- Log period start: Date picker + time (optional)
- Flow level: Light, Medium, Heavy (visual icons)
- Symptoms: Multi-select chips (cramps, bloating, headache, acne, fatigue, nausea, mood swings, tender breasts, back pain, "other")
- Notes: Free text field (optional)
- Edit/delete past period logs
- Period auto-ends after 8 days if not manually ended (notification prompt)

#### FR-2.2: Prediction Algorithm (Range-Based)
**Requirement**: Predict next period as a range (earliest-latest) with confidence indicator.  
**Acceptance Criteria**:
- After 1 cycle logged: Low confidence, wide range (±5 days)
- After 3 cycles logged: Medium confidence, medium range (±3 days)
- After 6+ cycles logged: High confidence, narrow range (±2 days)
- Irregular cycles detected (cycle length variance >7 days) → confidence downgraded
- Display on calendar: shaded range (not single date)
- Confidence badge visible: "Low", "Medium", "High"

#### FR-2.3: "Why Changed" Explanations
**Requirement**: Explain why prediction updated after new cycle logged.  
**Acceptance Criteria**:
- Notification after logging new period: "Prediction updated"
- Tap notification → See explanation screen
- Example messages:
  - "Average cycle length changed from 28 to 30 days"
  - "Last cycle was 3 days shorter than usual (25 days)"
  - "Confidence increased: 6 cycles now logged"
- Visual: old prediction vs new prediction comparison
- Dismissible, can view later in Settings > Learn about predictions

#### FR-2.4: Cycle History
**Requirement**: Display list of past cycles with length and dates.  
**Acceptance Criteria**:
- List view: Most recent first
- Per cycle: Start date, End date, Length (days), Flow level icon
- Tap cycle → Detail view with symptoms, notes, mood
- Visual: Average cycle length badge at top (e.g., "Avg: 29 days")
- Filter: Last 12 cycles, Last 6 months, All time

---

### FR-3: Calendar View

#### FR-3.1: Visual Calendar
**Requirement**: Display interactive monthly calendar with rich visual indicators.  
**Acceptance Criteria**:
- Month grid: Sun-Sat (or Mon-Sun based on locale)
- Today: Highlighted border
- Period days: Filled with primary color (gradient: light→heavy flow)
- Predicted period: Shaded range (earliest-latest)
- Fertile window: Green tint/icon overlay
- Ovulation estimate: Egg icon (if TTC mode or ovulation tracking enabled)
- Pregnancy week overlay: "Week 14" badge on Sundays (if pregnant mode)
- Logged vitals: Small indicator dot (BP, weight logged that day)
- Appointment reminder: Calendar icon
- Tap date → Day detail view (symptoms, vitals, notes)

#### FR-3.2: Month Navigation
**Requirement**: Navigate between months easily.  
**Acceptance Criteria**:
- Swipe left/right to change month
- Month/Year header with dropdown picker
- "Today" button to jump back to current date
- Smooth transition animation

#### FR-3.3: Legend / Key
**Requirement**: Explain calendar visual indicators.  
**Acceptance Criteria**:
- Accessible via "?" icon in top corner
- Modal showing all color meanings:
  - Period (light, medium, heavy)
  - Predicted period
  - Fertile window
  - Ovulation estimate
  - Vitals logged
  - Appointments
- Dismissible, can reopen anytime

---

### FR-4: Home Dashboard (Stage-Aware)

#### FR-4.1: Cycle Stage Dashboard
**Requirement**: Display cycle-relevant information and quick actions when in period/TTC mode.  
**Acceptance Criteria**:
- Hero card: "Days until next period" (range: "In 3-5 days")
- Current cycle day: "Day 14 of cycle"
- Cycle phase visual: Follicular / Ovulation / Luteal with icon
- Quick actions:
  - "Log today" button (symptoms/mood)
  - "Start period" button (prominent if predicted period arrived)
- Today's content card: Educational tip relevant to cycle phase
- Streak indicator (optional, if gamification enabled): "7 days logged 🔥"
- Horizontal scrollable vitals summary: BP, Weight (last logged value + date)
- Bottom navigation: Home, Calendar, Log, Insights, More

#### FR-4.2: Pregnancy Stage Dashboard
**Requirement**: Display pregnancy-relevant information when in pregnancy mode.  
**Acceptance Criteria**:
- Hero card: Current week + days ("Week 14 + 3 days")
- Due date countdown: "26 weeks to go"
- Baby size visual: Illustration + "Your baby is the size of a lemon"
- Week milestone: "Your baby's eyes can move!" (key development)
- Quick actions:
  - "Log vitals" (BP, weight)
  - "Log symptoms" (nausea, fatigue, etc.)
- Next appointment: Date + days away ("In 12 days")
- Today's content card: Pregnancy week-specific tip
- Horizontal scrollable vitals: BP, Weight charts mini preview
- Bottom navigation: Home, Timeline, Log, Vitals, More

#### FR-4.3: TTC Dashboard (Enhanced Cycle View)
**Requirement**: Display fertility-focused information when in TTC mode.  
**Acceptance Criteria**:
- Hero card: "Fertile window" status
  - "High fertility today" (green)
  - "Fertile window in 3-5 days" (yellow)
  - "Low fertility" (gray)
- Ovulation estimate: "Ovulation likely in 2 days" with confidence
- Quick actions:
  - "Log intercourse" (discreet icon)
  - "Log BBT" (if enabled)
  - "Log cervical mucus"
- Intercourse timing visualization: Dots on mini calendar
- Today's content card: TTC tip (e.g., "Fertile window tips", "Understanding cervical mucus")
- Cycle day indicator
- bottom navigation: Home, Calendar, Log, Insights, More

---

### FR-5: Symptom & Mood Logging

#### FR-5.1: Quick Log Sheet
**Requirement**: Fast symptom and mood logging accessible from home or calendar.  
**Acceptance Criteria**:
- Modal sheet (bottom sheet on Android)
- Date picker at top (default: today)
- Symptoms section: Multi-select chips
  - Physical: Cramps, bloating, headache, acne, fatigue, nausea, tender breasts, back pain, dizziness
  - Digestive: Constipation, diarrhea, increased appetite
  - Other: Custom tag input
- Mood section: Single or multi-select chips
  - Happy, sad, anxious, irritable, energetic, calm, stressed, focused
- Intensity slider (optional per symptom): Mild, Moderate, Severe
- Notes: Free text (optional)
- Save button (validates date, saves locally)
- Cancel button (discards)

#### FR-5.2: Symptom History
**Requirement**: View logged symptoms over time.  
**Acceptance Criteria**:
- Accessible from Insights tab
- List view: Grouped by date (most recent first)
- Per entry: Date, symptoms chips, mood, notes preview
- Tap entry → Full detail view + edit/delete options
- Filter by symptom type (e.g., "Show only cramps")
- Search notes

---

### FR-6: Fertility / TTC Features

#### FR-6.1: Fertile Window Calculation
**Requirement**: Calculate and display 6-day fertile window based on ovulation estimate.  
**Acceptance Criteria**:
- Algorithm: 5 days before ovulation + 1 day after
- Ovulation estimate: 14 days before predicted next period start (adjusts based on luteal phase if data available)
- Display on calendar: Green tint overlay on fertile days
- Confidence indicator: Based on cycle regularity
- Educational tooltip: "Fertile window is when pregnancy is most likely"

#### FR-6.2: Cervical Mucus Tracking
**Requirement**: Log cervical mucus type to refine fertility predictions.  
**Acceptance Criteria**:
- Log types: Dry, sticky, creamy, watery, egg-white (EWCM)
- Optional notes field
- Calendar indicator: Small icon on logged days
- Educational content: "What is cervical mucus?" with images/descriptions
- Pattern recognition: App highlights EWCM days (peak fertility) on calendar

#### FR-6.3: Intercourse Logging (Discreet)
**Requirement**: Log intercourse timing for TTC planning (privacy-focused).  
**Acceptance Criteria**:
- Log date + time (optional)
- Protection used: Yes/No/Withdrawal (optional)
- Discreet icon on calendar (heart or custom icon, user-selectable)
- Can be hidden in Discreet Mode settings
- No notifications related to intercourse logs

---

### FR-7: Pregnancy Tracking

#### FR-7.1: Week-by-Week Timeline
**Requirement**: Display 40-week pregnancy timeline with week-specific content.  
**Acceptance Criteria**:
- Vertical scrollable timeline: Week 1 → Week 40
- Current week highlighted (auto-scroll to current week on open)
- Per week card:
  - Week number + gestational age
  - Baby size comparison (fruit/vegetable visual)
  - Key development milestone (1-2 sentences)
  - Tap → Full week detail page
- Trimester dividers: Week 13, Week 27
- Due date end marker with celebration icon

#### FR-7.2: Week Detail Content
**Requirement**: Educational content per pregnancy week (MVP: 10-12 key weeks).  
**Acceptance Criteria**:
- MVP weeks covered: 4, 8, 12, 16, 20, 24, 28, 32, 36, 38, 40
- Per week:
  - Baby development (size, organs, movements)
  - Mom's body changes (symptoms, physical changes)
  - Healthcare checklist (e.g., "Schedule anatomy scan at week 20")
  - Safety tip (1 evidence-based item)
  - Source badge: "Based on ACOG/WHO" (internal metadata)
- Illustration: Medical-grade, calm, neutral
- "Read more" expansion for additional details

#### FR-7.3: Appointment Tracker
**Requirement**: Log and track prenatal appointments.  
**Acceptance Criteria**:
- Add appointment: Date, time, location, doctor name, notes
- Appointment type: Routine checkup, ultrasound, lab work, specialist
- Reminder notification: 1 day before (if notifications enabled)
- Calendar integration: Show appointment icon on calendar date
- List view: Upcoming appointments, past appointments
- Edit/delete appointments

---

### FR-8: Vitals Tracking (Basic MVP)

#### FR-8.1: Blood Pressure Logging
**Requirement**: Log BP readings with date/time.  
**Acceptance Criteria**:
- Input: Systolic (60-200), Diastolic (40-140)
- Date picker (default: now)
- Time picker (optional)
- Measurement context dropdown (optional): Morning, Evening, After exercise, Stressed, Resting
- Notes field (optional)
- Save validation: Systolic > Diastolic, in acceptable ranges
- Calendar indicator: Small BP icon on logged day

#### FR-8.2: Blood Pressure Chart
**Requirement**: Visualize BP trends over time.  
**Acceptance Criteria**:
- Line chart: Systolic (one color), Diastolic (another color)
- X-axis: Time (days)
- Y-axis: mmHg (auto-scale)
- Reference bands (educational, not diagnostic):
  - Normal: <120/<80 (green zone)
  - Elevated: 120-129/<80 (yellow zone)
  - High: ≥130/≥80 (orange zone)
- Time filter: Last 7 days, 30 days, 90 days (default: 30)
- Tap data point → See full reading details (date, time, context, notes)
- Educational tooltip: "Reference ranges for non-pregnant adults. Consult your doctor."

#### FR-8.3: Weight Logging
**Requirement**: Log weight with date.  
**Acceptance Criteria**:
- Input: Weight value (kg or lbs, based on Settings unit)
- Date picker (default: today)
- Notes field (optional)
- Calendar indicator: Small scale icon

#### FR-8.4: Weight Chart
**Requirement**: Visualize weight trends.  
**Acceptance Criteria**:
- Line chart: Weight over time
- X-axis: Time (days/weeks)
- Y-axis: Weight (auto-scale, unit-aware)
- Pregnancy overlay (if in pregnancy mode): Show recommended weight gain range (educational, not prescriptive)
- Time filter: Last 30 days, 90 days, All pregnancy
- No "ideal" or "target" language (body-positive)
- Educational tooltip: "Weight gain varies. Your doctor will guide healthy range."

---

### FR-9: Settings & Privacy

#### FR-9.1: Language Settings
**Requirement**: Switch app language.  
**Acceptance Criteria**:
- Options: English, العربية
- Instant language switch (no restart required)
- RTL layout updates immediately
- All cached content cards reload in new language

#### FR-9.2: Discreet Mode
**Requirement**: Hide sensitive information in notifications and app name.  
**Acceptance Criteria**:
- Toggle on/off
- When enabled:
  - Notification text: "Femio reminder" (no details like "Period starting tomorrow")
  - App name in recent apps: "Health App" (optional, if technically feasible)
  - Home screen widget (future): Generic text
- When disabled: Full notification details

#### FR-9.3: Data Export
**Requirement**: Export user health data for backup or doctor sharing.  
**Acceptance Criteria**:
- Free tier: CSV export (cycles, symptoms, vitals)
- Export includes: Date ranges, all logged data, no predictions
- File name: "Femio_Export_YYYY-MM-DD.csv"
- Share via: Email, Google Drive, file system
- Pro tier: PDF export (doctor-ready format) - v1.5 feature

#### FR-9.4: Delete Local Data
**Requirement**: Permanently delete all user data from device.  
**Acceptance Criteria**:
- Confirmation dialog: "This will delete all your data. This cannot be undone."
- Secondary confirmation: Type "DELETE" to confirm
- Delete all: Cycles, logs, symptoms, vitals, settings (except language preference)
- Returns user to onboarding flow
- No cloud data deleted (if Pro sync enabled, user must disable separately)

#### FR-9.5: Privacy Policy / Terms
**Requirement**: Display legal documents.  
**Acceptance Criteria**:
- Links in Settings: "Privacy Policy", "Terms of Service"
- Open in-app web view (or external browser if preferred)
- Available in EN and AR
- Last updated date visible

---

### FR-10: Monetization (MVP)

#### FR-10.1: Light Ads Integration
**Requirement**: Display non-intrusive ads for free tier users.  
**Acceptance Criteria**:
- Ad types allowed: Banner (bottom), Native (in-feed)
- Ad types prohibited: Interstitial (pop-up), video ads (unless user-initiated)
- Ad placements:
  - Home dashboard: Native ad card (appears every 5 content cards)
  - Calendar: Banner ad at bottom (optional, toggle in settings)
  - Settings: Banner ad at bottom
- No ads on: Onboarding, Log sheets, Vitals entry, Week detail content (pregnancy)
- Pro users: Zero ads

#### FR-10.2: Pro Paywall Screen
**Requirement**: Display Pro subscription benefits and pricing.  
**Acceptance Criteria**:
- Accessible from: Settings > Upgrade to Pro, Home dashboard Pro prompt card
- Benefits listed:
  - ✅ No ads
  - ✅ Encrypted cloud backup (multi-device sync)
  - ✅ Doctor export pack (PDF)
  - ✅ Advanced charts (filters, annotations)
  - ✅ Advanced monitoring profiles (v1.5)
  - ✅ Premium content & insights (v1.5)
- Pricing: $7.99/year (or local equivalent)
- CTA button: "Start Free Trial" (7 days, if supported)
- Restore purchase button (for users who already subscribed)
- Terms link: "Subscription terms"

#### FR-10.3: Subscription Flow
**Requirement**: Handle Google Play Billing subscription.  
**Acceptance Criteria**:
- Integrate Google Play Billing library
- Subscription ID: "femio_pro_yearly"
- Free trial: 7 days (optional, configurable)
- Payment handled by Google Play
- On successful purchase:
  - Store Pro status locally (encrypted)
  - Immediately remove ads
  - Show success message: "Welcome to Femio Pro!"
- On purchase failure: Show error message with retry option
- Restore purchase: Verify with Google Play, restore Pro status if valid

#### FR-10.4: Manage Subscription
**Requirement**: Allow users to manage subscription (cancel, view status).  
**Acceptance Criteria**:
- In Settings > Pro Subscription (visible only for Pro users)
- Display:
  - Status: "Active", "Expired", "In trial"
  - Renewal date / Expiration date
  - "Manage subscription" button → Opens Google Play subscriptions page
- Cancel: Handled by Google Play (not in-app)
- On expiration: Gracefully downgrade to free tier (notify user, re-enable ads)

---

### FR-11: Localization & RTL Support

#### FR-11.1: String Localization
**Requirement**: All UI text must be localizable.  
**Acceptance Criteria**:
- Implementation: Flutter `intl` package or `easy_localization`
- Language files: `en.json`, `ar.json`
- No hardcoded strings in widgets
- Pluralization support (e.g., "1 day" vs "5 days")
- Date/time formatting per locale
- Number formatting (e.g., Arabic numerals vs Western numerals)

#### FR-11.2: RTL Layout
**Requirement**: Support right-to-left layout for Arabic.  
**Acceptance Criteria**:
- Automatic RTL flip when Arabic selected
- Test cases:
  - Text alignment: Right-aligned for Arabic
  - Icons: Mirrored (e.g., back arrow points right)
  - Navigation: Right-to-left drawer/tabs
  - Charts: RTL-friendly (x-axis labels, legends)
- Manual testing on 10+ key screens

#### FR-11.3: Cultural Sensitivity
**Requirement**: Ensure content is culturally appropriate for MENA audiences.  
**Acceptance Criteria**:
- Avoid: Religious references, political topics, alcohol/drug mentions
- Language tone: Formal, respectful, professional MSA (not colloquial)
- Imagery: Modest illustrations (no revealing clothing)
- Product suggestions: Halal-certified vitamins prioritized (when ecommerce enabled)
- Discreet mode default: Recommend enabling in onboarding for privacy-conscious users

---

<a name="non-functional-requirements"></a>
## 4. Non-Functional Requirements

### NFR-1: Performance
- **Cold start time**: <3 seconds on mid-range Android device (Snapdragon 665 equivalent)
- **Calendar rendering**: <500ms for month view load
- **Chart rendering**: <1 second for 90 days of data
- **Database queries**: <100ms for typical fetch (cycles, symptoms)
- **Encryption overhead**: <200ms for read/write operations

### NFR-2: Privacy & Security
- **Encryption**: AES-256 for local database (Isar encryption or Hive AES)
- **Cloud sync (Pro)**: Client-side encryption before upload (E2EE pattern)
- **Analytics**: No PII (personally identifiable info), no health data in events
- **Crashlytics**: No sensitive data in logs (filter out user inputs)
- **Permissions**: Minimal; no location, no contacts, no camera (unless user-initiated for photo attach)

### NFR-3: Reliability
- **Crash rate**: <1% crashes per session (target: 0.5%)
- **Offline-first**: All core features work without internet
- **Data integrity**: Automated backups (local) every 24 hours
- **Sync conflict resolution**: Last-write-wins (Pro sync) with user notification on conflicts

### NFR-4: Usability
- **Onboarding completion**: >80% of users complete onboarding
- **First log time**: User logs first period/symptom within 5 minutes of onboarding
- **Accessibility**: Minimum contrast ratio 4.5:1 (WCAG AA), support text scaling up to 200%
- **Learnability**: Users understand prediction confidence without tutorial (self-explanatory UI)

### NFR-5: Scalability
- **Database size**: Support 10+ years of data per user without performance degradation
- **Pro sync**: Handle 5 devices per user (v1.5)
- **Content cards**: Scalable content delivery (Remote Config ready for 500+ cards)

### NFR-6: Maintainability
- **Code coverage**: >70% unit tests for domain logic (prediction algorithm, calculations)
- **Widget tests**: Cover 20+ critical user flows
- **Lint score**: Zero errors, <10 warnings
- **Documentation**: All repositories, use cases, and complex widgets documented

### NFR-7: Compliance
- **Medical content**: All cards cite approved sources (ACOG, WHO, NICE, UpToDate, NHS)
- **Disclaimers**: Visible on first open and in Settings: "Not medical advice. Consult a doctor."
- **GDPR-ready**: Data export, data deletion, consent management (future EU expansion)
- **Age gate**: 13+ (comply with app store policies)

---

<a name="ux-wireframes"></a>
## 5. UX Wireframes (Text Descriptions)

### Design Language Overview
- **Aesthetic**: Soft, feminine, premium, medically trustworthy, graphic-rich (inspired by Flo, Ovia, but 100% original)
- **Color palette**: Pastel gradients (pink-purple, peach-coral), white backgrounds, muted accents
- **Typography**: Rounded sans-serif (e.g., Poppins, Nunito), generous line height
- **Components**: Cards with rounded corners (16px radius), soft shadows, glassmorphism accents
- **Illustrations**: Medical-grade, calm, neutral, feminine (avoid childish/cutesy)
- **Interactions**: Smooth animations (300ms), haptic feedback on key actions, bottom sheets for modals

---

### Screen 1: Onboarding - Welcome (Splash Series)

**Layout**:
- **Screen 1.1: Privacy-First**
  - Hero illustration: Shield icon with lock, soft gradient background (pink-purple)
  - Headline (H1): "Your data, your device"
  - Subheadline (H3): "All your health data stays on your phone, encrypted and private."
  - Progress dots: 3 dots (1 active)
  - CTA: "Next" button (primary, bottom)
  - Skip link (top-right, subtle)

- **Screen 1.2: Explainable Predictions**
  - Hero illustration: Calendar with range indicator (shaded window), confidence badge
  - Headline: "Predictions you can trust"
  - Subheadline: "Know when and why your cycle changes, with confidence levels."
  - Progress dots: 3 dots (2 active)
  - CTA: "Next" button

- **Screen 1.3: Full Journey Support**
  - Hero illustration: Circular lifecycle icons (period → pregnancy → baby)
  - Headline: "One app, your entire journey"
  - Subheadline: "From cycles to pregnancy and beyond, we're with you."
  - Progress dots: 3 dots (3 active)
  - CTA: "Get Started" button (primary)

**Interactions**:
- Horizontal swipe to navigate
- Auto-advance after 3 seconds (optional, can disable)
- Skip button jumps to language selection

---

### Screen 2: Language Selection

**Layout**:
- App logo (centered, top)
- Headline: "Choose your language"
- Two large cards (vertical stack):
  - Card 1: "English" with flag icon
  - Card 2: "العربية" with flag icon
- Selected card: Highlighted border (primary color)
- CTA: "Continue" button (bottom, primary)

**Interactions**:
- Tap card to select
- Instant visual highlight
- Disabled state if no selection

---

### Screen 3: Stage Selection

**Layout**:
- Headline (H2, centered): "What brings you to Femio?"
- Subheadline (H4): "We'll personalize your experience"
- 4 cards (vertical stack, scrollable):
  1. **Just exploring**: Icon (magnifying glass), description (1 sentence)
  2. **Tracking cycles**: Icon (calendar), description
  3. **Trying to conceive**: Icon (heart with +), description
  4. **I'm pregnant**: Icon (baby bump silhouette), description
  5. *(Future: Postpartum)*
- Selected card: Filled background (primary gradient)
- CTA: "Continue" button (bottom, enabled only when card selected)

**Interactions**:
- Single-select cards (radio button behavior)
- Smooth expand animation on select
- Scroll to view all options

---

### Screen 4A: Cycle Setup (if "Tracking cycles" or "TTC" selected)

**Layout**:
- Headline: "Let's start tracking"
- Subheadline: "When did your last period start?"
- Date picker (large, calendar widget):
  - Month/year header
  - Selectable dates (last 60 days)
  - "I don't remember" link (skips to estimate)
- Optional: "When did it end?" (collapsed by default, expand on tap)
- Optional: "What's your average cycle length?" (slider, 21-40 days, default 28)
- "I don't know" checkbox (if checked, defaults to 28, no slider)
- CTA: "Done" button (bottom)
- Back button (top-left)

**Interactions**:
- Calendar swipe to change month
- Slider drag updates number label
- "I don't know" disables slider

---

### Screen 4B: Pregnancy Setup (if "I'm pregnant" selected)

**Layout**:
- Headline: "Congratulations!"
- Subheadline: "Let's calculate your due date"
- Three input methods (tabbed selector at top):
  - Tab 1: "Last period" (LMP)
  - Tab 2: "Due date"
  - Tab 3: "Conception date"
- **If Tab 1 selected**:
  - Date picker: "First day of your last period"
  - Auto-calculate: Current week + due date (displayed below)
- **If Tab 2 selected**:
  - Date picker: "Your due date"
  - Auto-calculate: Current week
- **If Tab 3 selected**:
  - Date picker: "Approximate conception date"
  - Auto-calculate: Current week + due date
- Confirmation card (bottom):
  - "You are in week X"
  - "Due date: Month DD, YYYY"
- CTA: "Looks good!" button
- Back button

**Interactions**:
- Tab switch animates content
- Live calculation updates confirmation card

---

### Screen 5: Privacy Consent

**Layout**:
- Headline: "A few quick preferences"
- Subheadline: "You can change these anytime"
- Two toggle cards:
  1. **Analytics**:
     - Toggle (off by default)
     - Label: "Help improve Femio"
     - Description: "Share anonymous usage data to help us fix bugs and improve features."
     - "Learn more" link
  2. **Ads**:
     - Toggle (off by default)
     - Label: "Show ads"
     - Description: "Support the free version with light, relevant ads. You can upgrade to Pro anytime."
     - "Learn more" link
- CTA: "Continue to app" button (enabled regardless of toggle state)
- Back button

**Interactions**:
- Toggle switches animate smoothly
- "Learn more" opens bottom sheet with privacy policy excerpt

---

### Screen 6: Home Dashboard (Cycle Mode)

**Layout**:
```
┌─────────────────────────────┐
│  [Logo]    [Streak] [🔔]    │  ← Top bar
├─────────────────────────────┤
│  Good morning, [User]!      │  ← Personalized greeting (optional)
├─────────────────────────────┤
│  ╔═══════════════════════╗  │
│  ║ NEXT PERIOD           ║  │  ← Hero card (gradient)
│  ║ In 3-5 days           ║  │
│  ║ (Medium confidence)   ║  │
│  ║ Day 14 of cycle       ║  │
│  ║                       ║  │
│  ║ [Cycle phase visual]  ║  │  ← Circular progress wheel (follicular/ovulation/luteal)
│  ╚═══════════════════════╝  │
├─────────────────────────────┤
│  ╔═══════╗  ╔═══════╗       │  ← Quick actions (horizontal)
│  ║ 📝    ║  ║ 🩸    ║       │
│  ║ Log   ║  ║ Start ║       │
│  ║ today ║  ║ period║       │
│  ╚═══════╝  ╚═══════╝       │
├─────────────────────────────┤
│  Vitals Summary             │  ← Horizontal scrollable cards
│  ┌───────┐ ┌───────┐        │
│  │ BP    │ │ Weight│        │
│  │120/80 │ │ 65 kg │        │
│  │2d ago │ │Today  │        │
│  └───────┘ └───────┘        │
├─────────────────────────────┤
│  ╔═══════════════════════╗  │  ← Today's tip card
│  ║ 💡 TIP OF THE DAY     ║  │
│  ║ Understanding         ║  │
│  ║ follicular phase...   ║  │
│  ║ [Read more →]         ║  │
│  ╚═══════════════════════╝  │
├─────────────────────────────┤
│  [Ad card - Native]         │  ← Ad (free tier only)
├─────────────────────────────┤
│  Recent Symptoms            │  ← List (last 3 days)
│  ┌───────────────────────┐  │
│  │ Today: Cramps, Tired  │  │
│  │ Yesterday: Bloated    │  │
│  └───────────────────────┘  │
└─────────────────────────────┘
│ [Home][Calendar][+][Insights][More] │  ← Bottom nav
└─────────────────────────────────────┘
```

**Interactions**:
- Pull-to-refresh (updates predictions if new day)
- Tap hero card → Cycle details screen
- Tap "Log today" → Quick log sheet (bottom sheet)
- Tap "Start period" → Period log flow
- Tap vitals card → Vitals detail/chart
- Tap tip card → Full educational article
- Swipe left on symptom item → Edit/delete

---

### Screen 7: Home Dashboard (Pregnancy Mode)

**Layout**:
```
┌─────────────────────────────┐
│  [Logo]    [Week] [🔔]      │
├─────────────────────────────┤
│  Week 14 + 3 days           │  ← Current week badge (large)
├─────────────────────────────┤
│  ╔═══════════════════════╗  │
│  ║ YOUR BABY             ║  │  ← Hero card (illustration)
│  ║ [Lemon illustration]  ║  │
│  ║ Size of a lemon       ║  │
│  ║                       ║  │
│  ║ 26 weeks to go        ║  │  ← Due date countdown
│  ║ Due: Aug 15, 2026     ║  │
│  ╚═══════════════════════╝  │
├─────────────────────────────┤
│  ╔═══════════════════════╗  │  ← Milestone card
│  ║ 🎉 Your baby's eyes   ║  │
│  ║ can move & blink now! ║  │
│  ╚═══════════════════════╝  │
├─────────────────────────────┤
│  ╔═══════╗  ╔═══════╗       │  ← Quick actions
│  ║ 📊    ║  ║ 📝    ║       │
│  ║ Log   ║  ║ Log   ║       │
│  ║ vitals║  ║symptom║       │
│  ╚═══════╝  ╚═══════╝       │
├─────────────────────────────┤
│  Next Appointment           │  ← Appointment card
│  ┌───────────────────────┐  │
│  │ 📅 Anatomy scan       │  │
│  │ Feb 18, 2026 (12d)    │  │
│  │ [View details →]      │  │
│  └───────────────────────┘  │
├─────────────────────────────┤
│  Vitals Chart (mini)        │  ← BP/Weight mini charts
│  [Line graph preview]       │
│  [View full charts →]       │
├─────────────────────────────┤
│  ╔═══════════════════════╗  │  ← Weekly content card
│  ║ 📖 WEEK 14 GUIDE      ║  │
│  ║ What to expect...     ║  │
│  ║ [Read more →]         ║  │
│  ╚═══════════════════════╝  │
└─────────────────────────────┘
│ [Home][Timeline][+][Vitals][More] │
└────────────────────────────────────┘
```

**Interactions**:
- Tap hero card → Week detail page
- Tap milestone → Full week content
- Tap appointment card → Appointment details/edit
- Tap vitals chart → Full vitals screen with all charts

---

### Screen 8: Calendar View

**Layout**:
```
┌─────────────────────────────┐
│  [<] February 2026 [>] [?]  │  ← Month nav + legend icon
├─────────────────────────────┤
│  Sun Mon Tue Wed Thu Fri Sat│  ← Day headers
│   1   2   3   4   5   6   7 │
│  🔴  🔴      🟢  🟢  🥚  🟢 │  ← Period + fertile window + ovulation
│   8   9  10  11  12  13  14 │
│              ⬜ [15]⬜  ⬜ ⬜ │  ← Predicted period range (shaded)
│  15  16  17  18  19  20  21 │  ← Today (bold border)
│  ⬜  ⬜                      │
│  22  23  24  25  26  27  28 │
│                              │
│  • BP logged   📅 Appointment│  ← Small indicators
└─────────────────────────────┘
│   [Today button] [Add log]  │  ← Quick actions
└─────────────────────────────┘
│ [Home][Calendar][+][Insights][More] │
└────────────────────────────────────┘
```

**Legend Modal** (triggered by [?]):
- 🔴 Period (light/medium/heavy)
- ⬜ Predicted period (range)
- 🟢 Fertile window
- 🥚 Ovulation estimate
- • Vitals logged
- 📅 Appointment

**Interactions**:
- Swipe left/right to change month
- Tap date → Day detail page (symptoms, vitals, notes for that day)
- Long-press date → Quick add log
- "Today" button jumps to current date

---

### Screen 9: Quick Log Sheet (Bottom Sheet Modal)

**Layout**:
```
┌─────────────────────────────┐
│  ═══ (drag handle)          │
│  Log for Today              │  ← Title + date picker
│  [< Feb 15, 2026 >]         │
├─────────────────────────────┤
│  HOW DO YOU FEEL?           │  ← Mood section
│  ┌────┐┌────┐┌────┐┌────┐  │
│  │😊  ││😢  ││😰  ││😠  │  │  ← Emoji chips (multi-select)
│  └────┘└────┘└────┘└────┘  │
│  Happy  Sad  Anxious Irritable│
├─────────────────────────────┤
│  SYMPTOMS                   │  ← Symptoms section
│  ┌─────────┐┌─────────┐    │
│  │ Cramps  ││ Bloating│    │  ← Multi-select chips
│  │   ✓     ││         │    │
│  └─────────┘└─────────┘    │
│  ┌─────────┐┌─────────┐    │
│  │ Headache││ Fatigue │    │
│  └─────────┘└─────────┘    │
│  [+ Add custom symptom]     │
├─────────────────────────────┤
│  NOTES (optional)           │
│  ┌───────────────────────┐  │
│  │ Free text area...     │  │
│  └───────────────────────┘  │
├─────────────────────────────┤
│  [Cancel]      [Save]       │  ← Action buttons
└─────────────────────────────┘
```

**Interactions**:
- Drag handle to dismiss
- Tap chip to toggle selection
- Selected chips: Filled background
- Save validates and dismisses sheet
- Cancel discards changes

---

### Screen 10: Cycle Details / Insights

**Layout**:
```
┌─────────────────────────────┐
│ [< Back]  Cycle Insights    │
├─────────────────────────────┤
│  ╔═══════════════════════╗  │
│  ║ CURRENT CYCLE         ║  │  ← Current cycle card
│  ║ Day 14 of 28          ║  │
│  ║ Started: Feb 2, 2026  ║  │
│  ║                       ║  │
│  ║ Phase: Follicular     ║  │
│  ║ [Visual progress bar] ║  │
│  ╚═══════════════════════╝  │
├─────────────────────────────┤
│  ╔═══════════════════════╗  │
│  ║ NEXT PERIOD           ║  │  ← Prediction card
│  ║ Expected: Feb 23-25   ║  │
│  ║ Confidence: Medium    ║  │
│  ║ (6 cycles logged)     ║  │
│  ║                       ║  │
│  ║ [Why this prediction?]║  │  ← Expandable explanation
│  ╚═══════════════════════╝  │
├─────────────────────────────┤
│  CYCLE HISTORY              │  ← Past cycles
│  ┌───────────────────────┐  │
│  │ Cycle 6: Jan 5-9      │  │  ← List items
│  │ Length: 28 days       │  │
│  │ Flow: Medium •••      │  │
│  └───────────────────────┘  │
│  ┌───────────────────────┐  │
│  │ Cycle 5: Dec 8-12     │  │
│  │ Length: 30 days       │  │
│  │ Flow: Heavy ••••      │  │
│  └───────────────────────┘  │
│  [View all cycles →]        │
├─────────────────────────────┤
│  STATS                      │  ← Statistics cards
│  Average cycle: 29 days     │
│  Average period: 5 days     │
│  Regular: Yes ✓             │
└─────────────────────────────┘
```

**Interactions**:
- Tap "Why this prediction?" → Expands to show explanation ("Average cycle length: 29 days, Luteal phase: 14 days")
- Tap past cycle → Cycle detail (symptoms, notes for that cycle)

---

### Screen 11: Pregnancy Timeline

**Layout**:
```
┌─────────────────────────────┐
│ [< Back]  Your Pregnancy    │
├─────────────────────────────┤
│  Due: Aug 15, 2026          │  ← Header with due date
│  26 weeks to go             │
├─────────────────────────────┤
│  ╔═══════════════════════╗  │  ← Trimester tabs
│  ║ [1st] [2nd✓] [3rd]    ║  │
│  ╚═══════════════════════╝  │
├─────────────────────────────┤
│  WEEK 14                    │  ← Current week (highlighted)
│  ┌───────────────────────┐  │
│  │ [Lemon illustration]  │  │
│  │ Your baby is the size │  │
│  │ of a lemon            │  │
│  │                       │  │
│  │ Key milestone:        │  │
│  │ Eyes can move now 👀  │  │
│  │                       │  │
│  │ [Read full guide →]   │  │  ← Tap to open week detail
│  └───────────────────────┘  │
├─────────────────────────────┤
│  Week 13                    │  ← Past weeks (collapsed)
│  ┌───────────────────────┐  │
│  │ [Peach icon] ✓        │  │  ← Checkmark (completed)
│  └───────────────────────┘  │
│  Week 12                    │
│  ┌───────────────────────┐  │
│  │ [Plum icon] ✓         │  │
│  └───────────────────────┘  │
├─────────────────────────────┤
│   ... (scroll to see all    │
│   40 weeks)                 │
├─────────────────────────────┤
│  Week 15                    │  ← Future weeks (grayed out)
│  ┌───────────────────────┐  │
│  │ [Apple icon] 🔒       │  │  ← Locked until week arrives
│  └───────────────────────┘  │
└─────────────────────────────┘
```

**Interactions**:
- Auto-scroll to current week on open
- Tap current/past week card → Full week detail page
- Future weeks: Tappable but show "Unlock next week on [date]" message
- Trimester tabs filter view (optional enhancement)

---

### Screen 12: Week Detail (Pregnancy Content)

**Layout**:
```
┌─────────────────────────────┐
│ [< Back]  Week 14           │
├─────────────────────────────┤
│  ╔═══════════════════════╗  │
│  ║ [Large illustration]  ║  │  ← Hero image (lemon)
│  ║ Your baby is 3.4 in   ║  │
│  ╚═══════════════════════╝  │
├─────────────────────────────┤
│  🍼 WHAT'S HAPPENING       │  ← Section: Baby development
│  Your baby's kidneys are    │
│  producing urine. The liver │
│  and spleen are working...  │
│  [full paragraph]           │
├─────────────────────────────┤
│  💪 YOUR BODY              │  ← Section: Mom's body
│  You may feel your uterus   │
│  above your pubic bone now. │
│  Energy levels should be... │
│  [full paragraph]           │
├─────────────────────────────┤
│  ✅ HEALTHCARE CHECKLIST   │  ← Section: Appointments
│  □ Schedule anatomy scan    │
│  (weeks 18-22)              │
│  □ Discuss genetic testing  │
│  with your doctor           │
├─────────────────────────────┤
│  ⚠️ SAFETY TIP             │  ← Section: Safety
│  Avoid raw fish, deli meats,│
│  and unpasteurized cheeses. │
│  [Educational, not alarmist]│
├─────────────────────────────┤
│  📚 Based on ACOG & WHO    │  ← Source badge
│  Last reviewed: Jan 2026    │
└─────────────────────────────┘
```

**Interactions**:
- Scroll to read all sections
- Tap checklist item → Check off / add to appointments
- Tap source badge → See full source list (educational transparency)

---

### Screen 13: Vitals - Blood Pressure Chart

**Layout**:
```
┌─────────────────────────────┐
│ [< Back]  Blood Pressure    │
├─────────────────────────────┤
│  Latest: 118/76 mmHg        │  ← Latest reading badge
│  Today, 9:30 AM             │
├─────────────────────────────┤
│  [Last 7 days ▼]            │  ← Time filter dropdown
├─────────────────────────────┤
│  ╔═══════════════════════╗  │
│  ║  [Line chart]         ║  │  ← Chart
│  ║  140 ┼─────────────   ║  │  ← Y-axis: mmHg
│  ║      │  •  •   Systolic  ║  │  ← Systolic line (pink)
│  ║  120 ┼──•──•──•───   ║  │
│  ║      │         •       ║  │
│  ║  100 ┼────────•────   ║  │  
│  ║      │      Diastolic ║  │  ← Diastolic line (purple)
│  ║   80 ┼──•──•──•───   ║  │
│  ║      │                ║  │
│  ║   60 ┼─────────────   ║  │
│  ║      Feb8 Feb10 Feb12 ║  │  ← X-axis: dates
│  ║                       ║  │
│  ║  [Reference bands]    ║  │  ← Color zones (green/yellow/orange)
│  ╚═══════════════════════╝  │
├─────────────────────────────┤
│  ℹ️ Reference Ranges       │  ← Educational tooltip (expandable)
│  Normal: <120/<80           │
│  Elevated: 120-129/<80      │
│  High: ≥130/≥80             │
│  *For non-pregnant adults.  │
│  Consult your doctor.*      │
├─────────────────────────────┤
│  RECENT READINGS            │  ← List of readings
│  ┌───────────────────────┐  │
│  │ Today, 9:30 AM        │  │  ← List item (tappable)
│  │ 118/76  Resting       │  │
│  │ Note: Felt calm       │  │
│  └───────────────────────┘  │
│  ┌───────────────────────┐  │
│  │ Yesterday, 8:00 AM    │  │
│  │ 122/78  Morning       │  │
│  └───────────────────────┘  │
│  [View all readings →]      │
├─────────────────────────────┤
│  [+ Add Reading] (FAB)      │  ← Floating action button
└─────────────────────────────┘
```

**Interactions**:
- Tap data point on chart → Show reading details in tooltip
- Tap list item → Edit/delete reading
- Tap "+ Add Reading" → Open BP log form (bottom sheet)
- Time filter dropdown: 7 days / 30 days / 90 days / All time

---

### Screen 14: Settings

**Layout**:
```
┌─────────────────────────────┐
│ [< Back]  Settings          │
├─────────────────────────────┤
│  ACCOUNT                    │  ← Section header
│  ┌───────────────────────┐  │
│  │ ⚡ Upgrade to Pro     │  │  ← Pro upsell card (if free tier)
│  │ $7.99/year           │  │
│  │ [Learn more →]        │  │
│  └───────────────────────┘  │
│  [Manage Subscription]      │  ← (if Pro user)
├─────────────────────────────┤
│  PREFERENCES                │
│  Language: English [>]      │  ← List items (navigable)
│  Discreet Mode [Toggle OFF] │  ← Toggle switch
│  Units: Metric [>]          │  ← kg vs lbs, cm vs in
│  Date Format: MM/DD/YYYY [>]│
├─────────────────────────────┤
│  TRACKING                   │
│  Current Stage: Cycle [>]   │  ← Change stage
│  Period Reminders [Toggle]  │
│  Appointment Reminders [Toggle]│
│  Gamification [Toggle ON]   │  ← Enable/disable streaks
├─────────────────────────────┤
│  DATA & PRIVACY             │
│  Export Data [>]            │  ← CSV export (free)
│  Backup to Cloud [>]        │  ← Pro only, grayed out if free
│  Delete All Data [>]        │  ← Red text (destructive)
├─────────────────────────────┤
│  SUPPORT                    │
│  Privacy Policy [>]         │
│  Terms of Service [>]       │
│  Help & FAQs [>]            │
│  Contact Support [>]        │
├─────────────────────────────┤
│  ABOUT                      │
│  Version: 1.0.0             │
│  ❤️ Made for MENA women    │
└─────────────────────────────┘
```

**Interactions**:
- Tap list item → Navigate to subpage
- Toggle switches animate smoothly
- Pro-locked features show lock icon and prompt upgrade

---

### Screen 15: Pro Paywall

**Layout**:
```
┌─────────────────────────────┐
│ [X Close]                   │  ← Close button (top-right)
├─────────────────────────────┤
│  ╔═══════════════════════╗  │
│  ║ [Crown icon]          ║  │  ← Hero graphic (gradient)
│  ║ Unlock Femio Pro      ║  │
│  ╚═══════════════════════╝  │
├─────────────────────────────┤
│  ✅ Ad-free experience       │  ← Benefits list
│  ✅ Encrypted cloud backup   │
│     & multi-device sync      │
│  ✅ Doctor export pack (PDF) │
│  ✅ Advanced charts & filters│
│  ✅ Monitoring profiles       │
│     (BP, glucose, PCOS)      │
│  ✅ Premium insights          │
├─────────────────────────────┤
│  ╔═══════════════════════╗  │
│  ║ $7.99/year            ║  │  ← Pricing card
│  ║ Just $0.67/month      ║  │
│  ║                       ║  │
│  ║ 7-day free trial      ║  │  ← (if available)
│  ╚═══════════════════════╝  │
├─────────────────────────────┤
│  [Start Free Trial]         │  ← CTA button (large, primary)
│                              │
│  [Restore Purchase]         │  ← Link (subtle)
│  [Terms of subscription]    │  ← Link (subtle)
└─────────────────────────────┘
```

**Interactions**:
- Tap "Start Free Trial" → Google Play Billing flow
- Tap "Restore Purchase" → Verify with Google Play, restore Pro status
- Tap "Terms" → Opens terms in web view
- Close button dismisses paywall

---

<a name="ui-style-guide"></a>
## 6. UI Style Guide

### 6.1 Color Palette

**Primary Colors:**
- **Primary**: `#E57BA8` (Soft pink) - Main brand color
- **Primary Variant**: `#D06090` (Deeper pink) - Hover states, emphasis
- **Secondary**: `#A28BF4` (Soft purple) - Accents, secondary actions
- **Secondary Variant**: `#8B6FE0` (Deeper purple)

**Gradients:**
- **Hero Gradient**: `linear-gradient(135deg, #E57BA8 0%, #A28BF4 100%)`
- **Card Gradient**: `linear-gradient(180deg, #FFE8F0 0%, #FFFFFF 100%)`
- **Background Gradient**: `linear-gradient(180deg, #FAFBFF 0%, #FFFFFF 100%)`

**Neutrals:**
- **Background**: `#FFFFFF` (Pure white)
- **Surface**: `#F9FAFB` (Off-white, for cards)
- **Border**: `#E5E7EB` (Light gray)
- **Text Primary**: `#1F2937` (Almost black)
- **Text Secondary**: `#6B7280` (Medium gray)
- **Text Disabled**: `#9CA3AF` (Light gray)

**Semantic Colors:**
- **Success**: `#10B981` (Green) - Confirmations, positive states
- **Warning**: `#F59E0B` (Amber) - Cautions, medium confidence
- **Error**: `#EF4444` (Red) - Errors, destructive actions
- **Info**: `#3B82F6` (Blue) - Informational messages

**Cycle-Specific Colors:**
- **Period**: `#F87171` (Light red) - Period days on calendar
- **Fertile Window**: `#86EFAC` (Light green) - Fertile days
- **Ovulation**: `#FCD34D` (Golden yellow) - Ovulation estimate
- **Predicted Period**: `#FDE4E8` (Very light pink, shaded) - Predicted range

---

### 6.2 Typography

**Font Family**: Poppins (Google Fonts) - Rounded, friendly, professional

**Type Scale:**
- **H1 (Hero Title)**: 32px / 2rem, Bold (700), Line height 1.2
- **H2 (Section Title)**: 24px / 1.5rem, SemiBold (600), Line height 1.3
- **H3 (Card Title)**: 20px / 1.25rem, SemiBold (600), Line height 1.4
- **H4 (Subheading)**: 18px / 1.125rem, Medium (500), Line height 1.4
- **Body Large**: 16px / 1rem, Regular (400), Line height 1.5
- **Body**: 14px / 0.875rem, Regular (400), Line height 1.5
- **Caption**: 12px / 0.75rem, Regular (400), Line height 1.4
- **Button Text**: 16px / 1rem, SemiBold (600), Line height 1

**Arabic Font**: Cairo (Google Fonts) - High-quality Arabic font with proper hinting

---

### 6.3 Spacing System (8px Base)

- **XXS**: 4px (0.5x)
- **XS**: 8px (1x)
- **SM**: 12px (1.5x)
- **MD**: 16px (2x)
- **LG**: 24px (3x)
- **XL**: 32px (4x)
- **XXL**: 48px (6x)

**Usage:**
- Card padding: MD (16px)
- Section spacing: LG (24px)
- Screen margins: MD (16px)
- Component gap: SM (12px)
- Icon padding: XS (8px)

---

### 6.4 Component Styles

#### **Cards**
- Border radius: 16px
- Shadow: `0px 2px 8px rgba(0, 0, 0, 0.08)`
- Background: White or gradient
- Padding: MD (16px)
- Hover state: Slight scale (1.02), deeper shadow

#### **Buttons**

**Primary Button:**
- Background: Linear gradient (Primary → Secondary)
- Text: White, SemiBold
- Border radius: 24px (pill shape)
- Padding: 12px 24px (vertical, horizontal)
- Shadow: `0px 4px 12px rgba(229, 123, 168, 0.3)`
- Hover: Scale 1.05, deeper shadow
- Disabled: Opacity 0.4, no shadow

**Secondary Button:**
- Background: Transparent
- Border: 2px solid Primary
- Text: Primary color, SemiBold
- Border radius: 24px
- Padding: 10px 22px (accounting for border)
- Hover: Background tint (10% Primary)

**Text Button:**
- Background: Transparent
- Text: Primary color, SemiBold
- No border
- Padding: 8px 12px
- Hover: Underline

#### **Input Fields**
- Border: 1px solid Border color
- Border radius: 12px
- Padding: 12px 16px
- Background: White
- Focus state: Border 2px Primary, shadow `0px 0px 0px 4px rgba(229, 123, 168, 0.1)`
- Error state: Border Error color, helper text in Error color

#### **Chips (Multi-select Tags)**
- Default state:
  - Background: Surface (`#F9FAFB`)
  - Border: 1px solid Border
  - Text: Text Primary
  - Border radius: 20px (pill)
  - Padding: 6px 12px
- Selected state:
  - Background: Primary gradient
  - Text: White
  - Shadow: `0px 2px 6px rgba(229, 123, 168, 0.2)`
- Hover: Scale 1.05

#### **Toggle Switches**
- Track: 48px × 24px, Border radius: 12px
- Thumb: 20px circle
- Off state: Track background Gray, Thumb White
- On state: Track background Primary, Thumb White
- Animation: Smooth 300ms ease

#### **Bottom Navigation Bar**
- Height: 64px
- Background: White
- Border top: 1px solid Border
- Icon size: 24px
- Active icon: Primary color, filled style
- Inactive icon: Text Secondary, outlined style
- Label: Caption size, Text Secondary (inactive), Primary (active)

---

### 6.5 Iconography

**Icon Style**: Outlined, rounded corners (Material Symbols Rounded or custom set)

**Icon Sizes:**
- Small: 16px (inline with text)
- Medium: 24px (buttons, navigation)
- Large: 32px (features, cards)
- XLarge: 48px (hero elements)

**Icon Colors:**
- Default: Text Secondary
- Active: Primary
- Disabled: Text Disabled
- Semantic: Success/Warning/Error colors per context

**Custom Icons Needed:**
- Period drop (flow levels: light, medium, heavy)
- Ovulation egg
- Pregnant belly silhouette
- Baby (newborn)
- Calendar with range shading
- Vitals: BP monitor, scale, thermometer, glucose meter
- Mood faces (8 emotions)
- Fertility symbols (cervical mucus types)

---

### 6.6 Illustration Style

**Aesthetic**: Medical-grade, calm, feminine, neutral

**Characteristics:**
- Soft gradients (pink, purple, peach, mint)
- Rounded organic shapes
- Minimal linework (thick stroke: 2-3px)
- Subtle shadows for depth
- Abstract rather than photorealistic
- No identifiable faces (privacy, inclusivity)
- Inclusive skin tones (when depicting people, use diverse neutral tones)

**Illustration Types:**
- **Pregnancy baby size comparisons**: Fruits/vegetables (lemon, peach, avocado, watermelon)
- **Onboarding**: Abstract concepts (shield for privacy, calendar with confidence indicator, lifecycle journey)
- **Empty states**: Friendly, encouraging (no data yet → "Start logging to see insights")
- **Content cards**: Educational visuals (uterus diagram, hormone chart, cycle phases wheel)

**Sources for Licensing:**
- **Option 1**: Custom illustrations via Figma (hire contract illustrator for consistency)
- **Option 2**: Licensed packs (e.g., Blush, UnDraw, customized to match palette)
- **Option 3**: In-house design team (recommended for brand uniqueness)

---

### 6.7 Animation & Interactions

**Interaction Principles:**
- **Responsive**: Haptic feedback on button taps (Android HapticFeedback API)
- **Smooth**: 300ms ease-in-out for most transitions
- **Purposeful**: Animations guide user attention (e.g., prediction update card slides in)
- **Performant**: No jank, 60fps minimum

**Common Animations:**
- **Page transitions**: Fade + slide (200ms)
- **Modal appear**: Scale from 0.9 to 1.0 + fade in (250ms)
- **Bottom sheet**: Slide up from bottom (300ms ease-out)
- **Card tap**: Scale down to 0.98, then back to 1.0 (100ms)
- **Toggle switch**: Thumb slide + color change (300ms)
- **Chart appear**: Fade in + draw lines over 500ms (staggered)

**Micro-interactions:**
- Button press: Haptic light
- Log saved: Haptic medium + success toast
- Prediction updated: Notification + card pulse animation
- Streak achieved: Confetti (subtle, not over-the-top)

---

### 6.8 Accessibility

**Color Contrast:**
- Text on backgrounds: Minimum 4.5:1 (WCAG AA)
- Large text (≥18px): Minimum 3:1
- Interactive elements: Minimum 3:1 contrast with surroundings

**Text Scaling:**
- Support system font size scaling up to 200%
- Test all screens at 150% and 200% scale
- Use flexible layouts (no fixed heights where possible)

**Touch Targets:**
- Minimum: 48px × 48px (Material Design guideline)
- Spacing between targets: 8px minimum

**Screen Readers:**
- All interactive elements: Semantic labels (e.g., "Log period start button")
- Images: Alt text or semantic labels (decorative images marked as such)
- Charts: Text summary for screen readers (e.g., "Your average BP this week is 118/76")

**Focus Indicators:**
- Keyboard navigation: Visible focus ring (2px Primary, 4px offset)
- Tab order: Logical top-to-bottom, left-to-right (right-to-left for Arabic)

---

<a name="data-model"></a>
## 7. Data Model & Database Schema

### 7.1 Technology Stack
- **Database**: Isar (preferred) - Fast, encrypted, Flutter-native NoSQL
- **Encryption**: Isar built-in encryption (password-based) or Hive with AES-256
- **Schema**: Defined below in entities

---

### 7.2 Core Entities

#### **Entity: User**
**Purpose**: Store user preferences and settings.

```dart
@collection
class User {
  Id id = Isar.autoIncrement; // Local DB ID
  
  // Preferences
  String language; // 'en' or 'ar'
  String currentStage; // 'cycle', 'ttc', 'pregnancy', 'postpartum'
  bool discreetMode;
  String units; // 'metric' or 'imperial'
  String dateFormat; // 'MM/DD/YYYY', 'DD/MM/YYYY'
  
  // Tracking settings
  bool periodReminders;
  bool appointmentReminders;
  bool gamificationEnabled;
  
  // Consent
  bool analyticsConsent;
  bool adsConsent;
  
  // Pro status
  bool isProUser;
  DateTime? proExpiryDate;
  String? proSubscriptionId;
  
  // Onboarding
  bool onboardingCompleted;
  DateTime createdAt;
  DateTime updatedAt;
}
```

---

#### **Entity: Cycle**
**Purpose**: Store menstrual cycle data.

```dart
@collection
class Cycle {
  Id id = Isar.autoIncrement;
  
  // Dates
  DateTime periodStartDate;
  DateTime? periodEndDate; // Null if ongoing
  
  // Cycle properties
  int? cycleLength; // Calculated after next period starts (days)
  int? periodDuration; // periodEndDate - periodStartDate (days)
  
  // Flow level (for visualization)
  String flowLevel; // 'light', 'medium', 'heavy' (average for cycle)
  
  // Metadata
  DateTime createdAt;
  DateTime updatedAt;
  
  // Relationships (Isar links)
  final symptoms = IsarLinks<Symptom>(); // Link to symptoms logged during this cycle
  final moods = IsarLinks<Mood>(); // Link to moods
}
```

---

#### **Entity: Symptom**
**Purpose**: Store symptom logs (physical symptoms).

```dart
@collection
class Symptom {
  Id id = Isar.autoIncrement;
  
  // Date
  DateTime date; // Date symptom was experienced
  
  // Symptom data
  List<String> symptoms; // ['cramps', 'bloating', 'headache', ...]
  Map<String, String>? intensityMap; // {symptom: intensity} e.g., {'cramps': 'severe'}
  String? notes; // Free text
  
  // Metadata
  DateTime createdAt;
  DateTime updatedAt;
  
  // Indexes for faster queries
  @Index()
  DateTime get dateIndex => date;
}
```

---

#### **Entity: Mood**
**Purpose**: Store mood logs.

```dart
@collection
class Mood {
  Id id = Isar.autoIncrement;
  
  // Date
  DateTime date;
  
  // Mood data
  List<String> moods; // ['happy', 'anxious', 'tired', ...]
  String? notes;
  
  // Metadata
  DateTime createdAt;
  DateTime updatedAt;
  
  @Index()
  DateTime get dateIndex => date;
}
```

---

#### **Entity: Prediction**
**Purpose**: Store menstrual cycle predictions (calculate and persist for transparency).

```dart
@collection
class Prediction {
  Id id = Isar.autoIncrement;
  
  // Prediction window
  DateTime earliestDate; // Start of predicted period range
  DateTime latestDate; // End of predicted period range
  DateTime medianDate; // Middle of range (for simple display)
  
  // Confidence
  String confidenceLevel; // 'low', 'medium', 'high'
  int cyclesUsedForPrediction; // Number of cycles logged when prediction was made
  
  // Explanation (for "Why changed" feature)
  String? explanationText; // e.g., "Average cycle length changed from 28 to 30 days"
  
  // Status
  bool isActive; // True for current prediction, false for past predictions
  DateTime? actualPeriodStartDate; // Filled in when period actually starts
  
  // Metadata
  DateTime createdAt;
  DateTime updatedAt;
}
```

---

#### **Entity: FertilityData**
**Purpose**: Store TTC-specific tracking (cervical mucus, intercourse, BBT).

```dart
@collection
class FertilityData {
  Id id = Isar.autoIncrement;
  
  // Date
  DateTime date;
  
  // Cervical mucus
  String? cervicalMucusType; // 'dry', 'sticky', 'creamy', 'watery', 'egg_white'
  
  // Intercourse (discreet)
  bool intercourseLogged;
  bool? protectionUsed;
  
  // Basal body temperature (future enhancement)
  double? bbt; // In Celsius or Fahrenheit based on user settings
  
  // Notes
  String? notes;
  
  // Metadata
  DateTime createdAt;
  DateTime updatedAt;
  
  @Index()
  DateTime get dateIndex => date;
}
```

---

#### **Entity: Pregnancy**
**Purpose**: Store pregnancy-specific data (one active pregnancy per user).

```dart
@collection
class Pregnancy {
  Id id = Isar.autoIncrement;
  
  // Dates
  DateTime lmpDate; // Last menstrual period (for calculation)
  DateTime dueDate; // Calculated or user-provided
  DateTime? conceptionDate; // Optional
  
  // Current status
  bool isActive; // True for ongoing pregnancy
  String outcome; // 'ongoing', 'birth', 'miscarriage', 'termination' (for data integrity)
  DateTime? outcomeDate; // Date of birth or loss
  
  // Calculated fields (derived)
  int gestationalAgeWeeks; // Calculated at query time
  int gestationalAgeDays; // Calculated at query time
  
  // Metadata
  DateTime createdAt;
  DateTime updatedAt;
}
```

---

#### **Entity: PregnancyContent**
**Purpose**: Store pregnancy week-specific content cards (pre-seeded, localized).

```dart
@collection
class PregnancyContent {
  Id id = Isar.autoIncrement;
  
  // Week
  int weekNumber; // 1-40
  
  // Content (localized)
  String language; // 'en' or 'ar'
  String babySizeComparison; // e.g., "lemon"
  String babySizeImageUrl; // Asset path or URL
  String babyDevelopmentText; // Paragraph
  String momBodyChangesText; // Paragraph
  String healthcareChecklistText; // Bullet points or paragraph
  String safetyTipText; // 1-2 sentences
  
  // Compliance metadata (internal)
  List<String> sources; // ['ACOG', 'WHO']
  String lastReviewedDate; // 'YYYY-MM-DD'
  List<String> topicTags; // ['pregnancy_week_14', 'second_trimester']
  
  // Metadata
  DateTime createdAt;
  DateTime updatedAt;
  
  @Index(composite: [CompositeIndex('weekNumber'), CompositeIndex('language')])
  int get weekLanguageIndex => weekNumber;
}
```

---

#### **Entity: Vital**
**Purpose**: Store vitals tracking (BP, weight, glucose, temperature).

```dart
@collection
class Vital {
  Id id = Isar.autoIncrement;
  
  // Date and time
  DateTime dateTime;
  
  // Vital type
  String vitalType; // 'blood_pressure', 'weight', 'glucose', 'temperature'
  
  // Blood pressure (if vitalType == 'blood_pressure')
  int? systolic; // mmHg
  int? diastolic; // mmHg
  String? bpContext; // 'morning', 'evening', 'after_exercise', 'resting', 'stressed'
  
  // Weight (if vitalType == 'weight')
  double? weightValue; // kg or lbs (stored in user's preferred unit)
  
  // Glucose (if vitalType == 'glucose')
  int? glucoseValue; // mg/dL
  String? glucoseContext; // 'fasting', 'post_meal_1hr', 'post_meal_2hr', 'random'
  
  // Temperature (if vitalType == 'temperature')
  double? temperatureValue; // Celsius or Fahrenheit
  
  // Notes
  String? notes;
  
  // Metadata
  DateTime createdAt;
  DateTime updatedAt;
  
  @Index(composite: [CompositeIndex('vitalType'), CompositeIndex('dateTime')])
  String get vitalTypeIndex => vitalType;
}
```

---

#### **Entity: HormoneLab**
**Purpose**: Store hormone and lab test results (manual entry).

```dart
@collection
class HormoneLab {
  Id id = Isar.autoIncrement;
  
  // Date
  DateTime testDate;
  
  // Hormone/lab type
  String labType; // 'estradiol', 'progesterone', 'lh', 'fsh', 'prolactin', 'tsh', 'custom'
  String? customLabName; // If labType == 'custom'
  
  // Value
  double value;
  String unit; // e.g., 'pg/mL', 'ng/mL', 'mIU/mL'
  
  // Cycle context (optional, for cycle-tracking users)
  int? cycleDay; // Day of cycle when test was taken
  
  // Notes
  String? notes;
  
  // Metadata
  DateTime createdAt;
  DateTime updatedAt;
  
  @Index()
  DateTime get testDateIndex => testDate;
}
```

---

#### **Entity: Appointment**
**Purpose**: Store healthcare appointments.

```dart
@collection
class Appointment {
  Id id = Isar.autoIncrement;
  
  // Date and time
  DateTime appointmentDateTime;
  
  // Details
  String appointmentType; // 'checkup', 'ultrasound', 'lab_work', 'specialist', 'other'
  String? doctorName;
  String? location;
  String? notes;
  
  // Reminder
  bool reminderEnabled;
  int reminderDaysBefore; // e.g., 1 day before
  
  // Status
  bool isCompleted;
  
  // Metadata
  DateTime createdAt;
  DateTime updatedAt;
  
  @Index()
  DateTime get appointmentDateTimeIndex => appointmentDateTime;
}
```

---

#### **Entity: ContentCard**
**Purpose**: Store educational content cards (tips, articles) for dynamic home dashboard.

```dart
@collection
class ContentCard {
  Id id = Isar.autoIncrement;
  
  // Content
  String language; // 'en' or 'ar'
  String title;
  String bodyText;
  String? imageUrl; // Asset path or remote URL
  
  // Targeting (when to show this card)
  List<String> targetStages; // ['cycle', 'ttc', 'pregnancy', 'postpartum']
  String? cyclePhase; // 'follicular', 'ovulation', 'luteal', 'menstruation', null (any)
  int? pregnancyWeekMin; // If pregnancy stage, min week (e.g., 12)
  int? pregnancyWeekMax; // If pregnancy stage, max week (e.g., 16)
  
  // Compliance metadata
  List<String> sources; // ['ACOG', 'WHO', 'NICE', ...]
  String lastReviewedDate; // 'YYYY-MM-DD'
  List<String> topicTags; // ['cycle_education', 'ttc_tips', ...]
  
  // Metadata
  DateTime createdAt;
  DateTime updatedAt;
  
  @Index()
  String get languageIndex => language;
}
```

---

### 7.3 Relationships Summary

**One-to-One:**
- User ↔ Pregnancy (one active pregnancy per user)

**One-to-Many:**
- User → Cycles (many cycles over time)
- User → Symptoms (many symptom logs)
- User → Moods
- User → Predictions
- User → FertilityData
- User → Vitals
- User → HormoneLabs
- User → Appointments

**Many-to-Many:**
- Cycle ↔ Symptoms (via IsarLinks; a cycle has many symptoms, symptoms can be associated with a cycle)
- Cycle ↔ Moods (via IsarLinks)

---

### 7.4 Indexes & Query Optimization

**Indexed Fields:**
- Symptom.date (for fast date-range queries)
- Mood.date
- FertilityData.date
- Vital.dateTime + Vital.vitalType (composite for chart queries)
- HormoneLab.testDate
- Appointment.appointmentDateTime
- Prediction.isActive (for finding current prediction)

**Query Patterns:**
- Get all symptoms in date range: `isar.symptoms.filter().dateBetween(startDate, endDate).findAll()`
- Get latest prediction: `isar.predictions.filter().isActiveEqualTo(true).findFirst()`
- Get BP readings for last 30 days:  
  `isar.vitals.filter().vitalTypeEqualTo('blood_pressure').dateTimeBetween(start, end).sortByDateTime().findAll()`

---

<a name="navigation-map"></a>
## 8. Navigation Map & User Flows

### 8.1 App Structure (Bottom Navigation)

**Bottom Nav Tabs** (changes based on user stage):

**Cycle / TTC Mode:**
1. **Home** (Dashboard)
2. **Calendar** (Visual calendar)
3. **+ (Log)** (Quick log sheet - modal)
4. **Insights** (Cycle history, charts, stats)
5. **More** (Settings, Pro, Help)

**Pregnancy Mode:**
1. **Home** (Dashboard)
2. **Timeline** (Week-by-week pregnancy timeline)
3. **+ (Log)** (Quick log sheet - modal)
4. **Vitals** (Charts for BP, weight, glucose)
5. **More** (Settings, Pro, Help)

**Postpartum Mode** (v1.1):
1. **Home** (Dashboard)
2. **Calendar** (Period return tracking)
3. **+ (Log)** (Symptoms, baby logs)
4. **Baby** (Newborn tracking: feeding, sleep)
5. **More** (Settings, Pro, Help)

---

### 8.2 Navigation Tree

```
Root
├── Onboarding Flow (first launch)
│   ├── Welcome Splash (3 screens)
│   ├── Language Selection
│   ├── Stage Selection
│   ├── Cycle Setup OR Pregnancy Setup (conditional)
│   └── Privacy Consent → Home
│
├── Home Tab (Bottom Nav 1)
│   ├── Dashboard (stage-aware)
│   ├── Quick Log Sheet (modal, floating)
│   ├── Cycle Details (from hero card tap)
│   ├── Pregnancy Week Detail (from hero card tap)
│   └── Content Card Detail (from tip card tap)
│
├── Calendar Tab (Bottom Nav 2) [Cycle/TTC mode]
│   ├── Calendar View
│   ├── Legend Modal (from ? icon)
│   ├── Day Detail (from date tap)
│   └── Quick Log (from + button)
│
├── Timeline Tab (Bottom Nav 2) [Pregnancy mode]
│   ├── Pregnancy Timeline (40 weeks)
│   ├── Week Detail (from week card tap)
│   └── Appointment Detail (from appointment card)
│
├── Log Tab (Bottom Nav 3) [Modal]
│   └── Quick Log Sheet (symptoms, mood, vitals shortcut)
│
├── Insights Tab (Bottom Nav 4) [Cycle/TTC mode]
│   ├── Cycle History (list)
│   ├── Cycle Detail (per cycle)
│   ├── Symptom History (list + filter)
│   ├── Charts (symptoms over time)
│   └── Stats Dashboard
│
├── Vitals Tab (Bottom Nav 4) [Pregnancy mode]
│   ├── Vitals Dashboard (all vitals summary)
│   ├── Blood Pressure Chart
│   │   ├── Chart View (with filters)
│   │   ├── Reading List
│   │   └── Add Reading (modal)
│   ├── Weight Chart
│   │   ├── Chart View
│   │   └── Add Log (modal)
│   └── Glucose Chart (if monitoring profile enabled) [v1.5]
│
├── More Tab (Bottom Nav 5)
│   ├── Settings
│   │   ├── Language Settings
│   │   ├── Discreet Mode (toggle)
│   │   ├── Units Settings
│   │   ├── Current Stage (change stage)
│   │   ├── Data Export
│   │   │   └── Export Confirmation
│   │   ├── Backup to Cloud (Pro only) [v1.5]
│   │   └── Delete All Data
│   │       └── Confirmation Dialog
│   ├── Pro Paywall
│   │   ├── Benefits Screen
│   │   ├── Subscription Flow (Google Play)
│   │   └── Manage Subscription (Pro users)
│   ├── Privacy Policy (web view)
│   ├── Terms of Service (web view)
│   ├── Help & FAQs
│   ├── Contact Support
│   └── About
│
└── Deep Links / Modals (accessible from multiple places)
    ├── Period Log Flow (Start period → End period)
    ├── Appointment Manager (Add/Edit/Delete)
    ├── Vitals Log Flow (BP, Weight, Glucose, Temp)
    ├── Hormone/Lab Entry [v1.1]
    ├── Pro Paywall (triggered from locked features)
    └── Notification Center (reminders list)
```

---

### 8.3 Key User Flows

#### **Flow 1: New User Onboarding (Cycle Tracking)**
1. Launch app → Welcome splash (3 screens)
2. Select language: English
3. Select stage: "Tracking cycles"
4. Enter last period start date: Feb 1, 2026
5. Optional: Set average cycle length: 28 days
6. Privacy consent: Toggle analytics ON, ads ON
7. → Home dashboard (Cycle mode)
8. See "Low confidence" prediction (only 1 cycle logged)
9. Tap "Start logging today" → Quick log sheet → Log cramps + tired
10. Save → Home dashboard updates with logged data

**Exit criteria**: User reaches home dashboard and logs first symptom.

---

#### **Flow 2: Period Logging (Existing User)**
1. User is on Home dashboard, Day 28 of cycle
2. Period started today (notification: "Did your period start?")
3. Tap "Start period" button on dashboard
4. Period log modal:
   - Date: Today (auto-filled)
   - Flow: Select "Medium"
   - Symptoms: Select "Cramps", "Bloating"
   - Notes: (optional, skip)
5. Tap "Save"
6. → Prediction algorithm runs in background
7. → Notification: "Prediction updated" (after 2 seconds)
8. Tap notification → See "Why changed" explanation:
   - "This cycle was 28 days (your average is 29 days)"
   - Visual: Old prediction vs new prediction
9. Dismiss → Back to Home
10. Cycle history now shows new cycle, confidence level updated to "Medium" (6 cycles logged)

**Exit criteria**: User logs period, understands why prediction changed.

---

#### **Flow 3: TTC User - Fertile Window Tracking**
1. User is in TTC mode, Day 10 of cycle
2. Home dashboard hero card: "High fertility in 2-4 days" (green, prominent)
3. Tap hero card → Cycle details with fertile window explanation
4. Today: User logs cervical mucus "Egg-white" (peak fertility indicator)
5. Tomorrow (Day 11): Dashboard updates: "High fertility TODAY" (bright green)
6. User logs intercourse (discreet icon)
7. Day 14: Dashboard: "Ovulation likely today"
8. User continues logging intercourse on Days 12, 14
9. Day 18: Dashboard: "Fertile window ended. Wait for next period or test in 10 days."
10. User sets reminder to test (Pro feature prompt: "Upgrade for advanced TTC tracking")

**Exit criteria**: User understands fertile window, logs relevant data, sees TTC-specific dashboard updates.

---

#### **Flow 4: Pregnancy Tracking - Week-by-Week**
1. User discovers pregnancy (external pregnancy test), opens app
2. Home dashboard: Currently in Cycle mode
3. Tap Settings → Current Stage → Select "I'm pregnant"
4. Pregnancy setup: Enter LMP date: Dec 1, 2025
5. App calculates: Week 10, Due date: Sept 7, 2026
6. → Home dashboard transitions to Pregnancy mode
7. Hero card: "Week 10" + "Your baby is the size of a strawberry" (illustration)
8. Milestone: "Your baby's vital organs are formed!"
9. User taps "Week 10" → Full week detail page (baby development, mom's body, checklist, safety tip)
10. User scrolls to Timeline tab → Sees 40-week vertical timeline, Week 10 highlighted
11. Week 12 (future): Grayed out, locked until week arrives
12. Week 20: User taps → See appointment reminder: "Schedule anatomy scan"
13. User adds appointment: Date, location, notes
14. → Appointment appears on Home dashboard "Next appointment: In 3 days"

**Exit criteria**: User successfully transitions to pregnancy mode, views week content, adds appointment.

---

#### **Flow 5: Vitals Tracking - Blood Pressure (Pregnancy)**
1. User is in Pregnancy mode, Week 24
2. Doctor advises monitoring BP (family history of preeclampsia)
3. User taps "Log vitals" on Home dashboard → Quick log sheet
4. Tap "Blood Pressure" card → BP log modal
5. Enter: Systolic 118, Diastolic 76, Context: "Morning", Notes: "Felt rested"
6. Save → Calendar shows small BP dot on today's date
7. User logs BP 2x daily for 7 days
8. Tap "Vitals" tab (bottom nav) → See BP chart
9. Chart shows: Green zone (normal), 14 data points over 7 days
10. Educational tooltip: "Your BP is in normal range. Reference: <120/<80 for non-pregnant adults."
11. User notices slight upward trend → Exports data (Pro prompt: "Upgrade for doctor export pack")
12. User upgrades to Pro → Downloads PDF with full BP chart + pregnancy details
13. Brings PDF to next prenatal visit → Doctor reviews, advises continuing monitoring

**Exit criteria**: User logs vitals consistently, views charts, exports data for doctor.

---

#### **Flow 6: Pro Upgrade**
1. User is on Free tier, using app for 2 months
2. Wants to enable cloud backup (new phone coming soon)
3. Tap Settings → "Backup to Cloud" (shows lock icon)
4. → Pro paywall screen
5. See benefits: Ad-free, Cloud backup, Export pack, Advanced charts, Monitoring profiles
6. Pricing: $7.99/year, 7-day free trial
7. Tap "Start Free Trial" → Google Play Billing flow
8. User confirms payment method (trial, no charge for 7 days)
9. Purchase successful → Toast: "Welcome to Femio Pro!"
10. Ads disappear from Home dashboard
11. Settings → "Backup to Cloud" now enabled (unlocked)
12. User enables backup → Data encrypted and synced to Firestore
13. User installs app on new phone → Signs in (Pro) → Data syncs from cloud
14. After 30 days: Subscription charged $7.99 → User receives email receipt

**Exit criteria**: User upgrades to Pro, enjoys ad-free experience, successfully backs up and restores data.

---

### 8.4 Deep Linking Strategy (Future Enhancement)

**Use Cases:**
- **Notification deep links**: "Period reminder" → Opens Calendar view on predicted date
- **Widget deep links**: Quick log widget → Opens Quick Log sheet
- **Share cycle summary**: External link shared via social → Opens Femio in read-only mode (if public sharing feature added)

**URL Scheme**: `femio://`

**Examples (v1.5+):**
- `femio://calendar?date=2026-02-15` → Opens Calendar tab, scrolls to Feb 15
- `femio://log?type=period` → Opens period log flow
- `femio://pregnancy/week/14` → Opens Week 14 detail
- `femio://settings/pro` → Opens Pro paywall
- `femio://vitals/bp` → Opens BP chart

---

## 9. Milestone 2 Summary & Checklist

### Deliverables Completed ✅

1. **Product Requirements Document (PRD)**: ✅
   - Product overview
   - Vision & mission statements
   
2. **User Personas (5 personas)**: ✅
   - Nour (Privacy-Conscious Tracker)
   - Layla (TTC Planner)
   - Amira (Expecting Mother)
   - Sara (Postpartum & New Mom)
   - Fatima (Special Circumstances - IVF)

3. **Functional Requirements (MVP v1.0)**: ✅
   - FR-1: Onboarding & Setup
   - FR-2: Cycle Tracking
   - FR-3: Calendar View
   - FR-4: Home Dashboard (Stage-Aware)
   - FR-5: Symptom & Mood Logging
   - FR-6: Fertility / TTC Features
   - FR-7: Pregnancy Tracking
   - FR-8: Vitals Tracking (Basic)
   - FR-9: Settings & Privacy
   - FR-10: Monetization (Ads + Pro Subscription)
   - FR-11: Localization & RTL Support
   - **Total**: 11 functional requirement categories with detailed acceptance criteria

4. **Non-Functional Requirements**: ✅
   - NFR-1: Performance (cold start <3s, chart render <1s)
   - NFR-2: Privacy & Security (AES-256 encryption, no PII in analytics)
   - NFR-3: Reliability (crash rate <1%)
   - NFR-4: Usability (>80% onboarding completion)
   - NFR-5: Scalability (10+ years of data support)
   - NFR-6: Maintainability (>70% code coverage)
   - NFR-7: Compliance (ACOG/WHO sources only, disclaimers)

5. **UX Wireframes (Text Descriptions)**: ✅
   - 15 key screens wireframed:
     1. Onboarding (3 splash screens)
     2. Language Selection
     3. Stage Selection
     4. Cycle Setup / Pregnancy Setup
     5. Privacy Consent
     6. Home Dashboard (Cycle Mode)
     7. Home Dashboard (Pregnancy Mode)
     8. Calendar View
     9. Quick Log Sheet
     10. Cycle Details / Insights
     11. Pregnancy Timeline
     12. Week Detail (Pregnancy Content)
     13. Vitals - Blood Pressure Chart
     14. Settings
     15. Pro Paywall

6. **UI Style Guide**: ✅
   - Color palette (primary, secondary, gradients, semantics)
   - Typography (Poppins EN, Cairo AR)
   - Spacing system (8px base)
   - Component styles (cards, buttons, inputs, chips, toggles)
   - Iconography (outlined, rounded, 4 sizes)
   - Illustration style (medical-grade, calm, feminine)
   - Animation & interactions (300ms standard, haptic feedback)
   - Accessibility (4.5:1 contrast, 48px touch targets, screen reader support)

7. **Data Model & Database Schema**: ✅
   - **11 core entities defined**:
     1. User (preferences, Pro status)
     2. Cycle (period tracking)
     3. Symptom (symptom logs)
     4. Mood (mood logs)
     5. Prediction (cycle predictions with confidence)
     6. FertilityData (TTC: cervical mucus, intercourse, BBT)
     7. Pregnancy (pregnancy details, due date)
     8. PregnancyContent (week-by-week educational content)
     9. Vital (BP, weight, glucose, temperature)
     10. HormoneLab (hormone/lab test results)
     11. Appointment (prenatal appointments)
     12. ContentCard (dynamic educational tips)
   - Relationships, indexes, query patterns defined

8. **Navigation Map & User Flows**: ✅
   - Bottom nav structure (stage-aware)
   - Full navigation tree (all screens + modals)
   - **6 key user flows documented**:
     1. New user onboarding (cycle tracking)
     2. Period logging (existing user)
     3. TTC user - fertile window tracking
     4. Pregnancy tracking week-by-week
     5. Vitals tracking - blood pressure (pregnancy)
     6. Pro upgrade flow
   - Deep linking strategy (future)

---

### Validation Checklist

#### **Localization ✅**
- All wireframes note: "Text available in EN + AR MSA"
- Language selection in onboarding
- RTL support requirement (NFR-11)
- Cultural sensitivity guidelines in NFR-11.3

#### **Privacy ✅**
- Privacy-first messaging in onboarding (FR-1.1)
- Local-first encrypted storage (NFR-2, User entity encryption)
- Discreet mode (FR-9.2)
- Privacy consent (FR-1.6)
- Data export and delete (FR-9.3, FR-9.4)
- No PII/health data in analytics (NFR-2)

#### **Clean Architecture ✅**
- Data model separates entities (domain) from implementation (Isar annotations indicate data layer)
- Repositories interface pattern planned (implied in NFR-6 maintainability)
- Next milestone (M3) will define full clean arch structure

#### **RTL Support ✅**
- Specified in FR-11.2 with test cases
- Language toggle instant switch (FR-9.1)
- Arabic font specified: Cairo (UI Style Guide, Typography)

---

### Risks & Mitigation

**Risk 1: MVP scope too large for 8-week timeline**  
*Mitigation*: Prioritize core cycle + pregnancy basic; defer postpartum (v1.1), Pro sync (v1.5), advanced monitoring (v1.5).

**Risk 2: Prediction algorithm accuracy with irregular cycles**  
*Mitigation*: Honest confidence indicators, wide range for low confidence, educational messaging ("We need more data").

**Risk 3: Medical content pipeline bottleneck**  
*Mitigation*: MVP covers only 10-12 key pregnancy weeks; post-MVP, hire medical content contractor or partner with healthcare org.

**Risk 4: Encryption performance on low-end devices**  
*Mitigation*: Profile on Snapdragon 665 (mid-range baseline); if >200ms overhead, consider lazy decryption for non-critical data.

---

## Next Steps → Milestone 3

With PRD, personas, functional/non-functional requirements, wireframes, style guide, data model, and navigation map complete, we proceed to:

**Milestone 3 Deliverables:**
1. **Technical Architecture Document**: Clean architecture layers, folder structure, state management (Bloc/Cubit), DI (get_it), Firebase setup
2. **Full Folder Tree**: Feature-first structure (features/<feature>/{data,domain,presentation})
3. **Dependency List**: pubspec.yaml with all packages (Isar, Bloc, get_it, Firebase, AdMob, in_app_purchase, intl, charts)
4. **Localization Setup Plan**: arb files structure, translation workflow
5. **Database Schema Implementation**: Isar schema generation, encryption setup, migration strategy
6. **CI/CD Setup Plan**: GitHub Actions for build, test, lint (optional, recommended)

---

**Milestone 2 Status**: ✅ **COMPLETE**

**Ready to proceed to Milestone 3 (Technical Architecture)?**

# Content authoring (Pregnancy + Postpartum)

This app keeps weekly guidance in editable JSON files under `assets/`.

- Pregnancy weekly info: `assets/pregnancy/weeks.json`
- Postpartum weekly info: `assets/postpartum/weeks.json`
- Shared “baby case tips” library (icons + short bullets): `assets/content/baby_case_tips.json`

After editing JSON, run the app again (hot restart is usually enough). No code changes required.

## Pregnancy weeks schema

File: `assets/pregnancy/weeks.json`

Top-level shape:

```json
{ "weeks": [ /* week objects */ ] }
```

Each week object (current fields used by the app):

```json
{
  "weekNumber": 1,
  "babySizeEmoji": "🌱",
  "babySizeName": "Poppy Seed",
  "babySizeComparison": "About 0.1mm",
  "babyDevelopment": ["..."],
  "momSymptoms": ["..."],
  "momTips": ["..."],
  "medicalInfo": ["..."],
  "babyCaseTipIds": ["baby_fever", "baby_sleep_safe"]
}
```

Notes:
- `babyCaseTipIds` is optional. If omitted or empty, the app may show sensible defaults.

### Edit / add / delete a pregnancy week

- **Edit**: find the object with matching `weekNumber` and update text.
- **Add**: append a new object with a new `weekNumber` (1–40).
- **Delete**: remove the week object. (The app will show an error if a missing week is requested.)

Rules:
- `weekNumber` must be unique.
- All list fields must be arrays of strings.

## Postpartum weeks schema

File: `assets/postpartum/weeks.json`

Top-level shape:

```json
{ "weeks": [ /* week objects */ ] }
```

Each week object (fields used by the app):

```json
{
  "weekNumber": 1,
  "babyDevelopment": ["..."],
  "babyCareTips": ["..."],
  "momRecovery": ["..."],
  "momTips": ["..."],
  "medicalInfo": ["..."],
  "babyCaseTipIds": ["baby_feeding", "baby_fever"]
}
```

Notes:
- `babyCaseTipIds` is optional. If omitted or empty, the app may show sensible defaults.

### Postpartum timeline: weeks + months (V1 up to 12 months)

In V1, postpartum is represented as:
- **Weeks 1–6** → `weekNumber: 1..6`
- **Months 1–12** → stored as `weekNumber: 7..18`

So:
- `weekNumber: 7` means **Postpartum month 1**
- `weekNumber: 18` means **Postpartum month 12**

The app uses this rule to display titles (week vs month) and to calculate “current postpartum period” from a birth date.

### Extending postpartum beyond 6 weeks

Right now, the app UI lets you browse whatever weeks exist in the JSON.
To add more months:
- Add more objects up to `weekNumber: 18` (month 12)

## Baby case tips (icons)

Baby case tips are short, scenario-based reminders shown as a separate section with icons.

### Where the tips live

File: `assets/content/baby_case_tips.json`

Shape:

```json
{
  "tips": [
    {
      "id": "baby_fever",
      "icon": "thermometer",
      "title": "Fever",
      "bullets": ["...", "..."]
    }
  ]
}
```

### How to attach tips to a pregnancy week or postpartum week/month

In the week/month object, add:

```json
"babyCaseTipIds": ["baby_sleep_safe", "baby_feeding"]
```

Rules:
- Each ID must match a `tips[].id` in `assets/content/baby_case_tips.json`.
- If you omit `babyCaseTipIds`, the app may show default tips.

## Personalization (how it works today)

Personalization inputs currently come from onboarding:
- Relationship status
- Age range
- Medical conditions

Pregnancy “✨ Personalized for you” is **content-driven** and editable in JSON.

### Targeted content (JSON rules)

File: `assets/content/targeted_content.json`

Top-level shape:

```json
{ "schemaVersion": 1, "items": [ /* content items */ ] }
```

Each item:

```json
{
  "id": "unique_id",
  "placement": "pregnancy_week.personalized_notes",
  "priority": 50,
  "type": "note",
  "audience": {
    "equals": {"someKey": "someValue"},
    "anyOf": {"someListKey": ["a", "b"]},
    "allOf": {"someListKey": ["a", "b"]},
    "noneOf": {"someListKey": ["x"]},
    "intRanges": {"someIntKey": {"min": 10, "max": 40}}
  },
  "content": {"text": "Shown to the user"}
}
```

Notes:
- Higher `priority` shows first.
- `audience` fields are optional; if omitted, the item matches everyone for that placement.

#### Currently supported placements + context keys

- `pregnancy_week.personalized_notes`
  - `pregnancyWeek` (int)
  - `medicalConditions` (list of strings; values are enum names like `hypertension`, `diabetes`)

- `fertility_tracking.personalized_notes`
  - `fertilityGoal` (string; one of `justTracking`, `tryingToConceive`, `avoidPregnancy`)
  - `relationshipStatus` (string; enum name like `singleNotDating`)
  - `userStage` (string; enum name like `trackingCycles`, `tryingToConceive`)

- `dashboard.daily_tip`
  - `userStage` (string)
  - `fertilityGoal` (string)
  - `relationshipStatus` (string)
  - `medicalConditions` (list of strings)

- `settings.notifications.fertile_window.subtitle`
  - `fertilityGoal` (string)
  - `relationshipStatus` (string)

- `settings.notifications.period.subtitle`
  - `fertilityGoal` (string)
  - `relationshipStatus` (string)

Important:
- `equals` compares a single value (string/int) in the context.
- `anyOf` / `allOf` / `noneOf` expect the context key to be a **list of strings**.

---

## Engagement Features Content

### Daily Tips

Daily tips are contextual messages shown to users based on their journey mode and cycle/pregnancy timing.

#### Location
`lib/features/insights/data/daily_tips_data.dart`

#### Structure

```dart
DailyTip(
  id: 'unique_id',
  titleKey: 'tipTitle',           // Localization key or display text
  bodyKey: 'tipBody',             // Localization key or display text
  category: TipCategory.health,   // health, nutrition, fitness, emotional, wellness, lifestyle
  journeyMode: UserStage.trackingCycles,  // justExploring, trackingCycles, tryingToConceive, pregnant, postpartum
  cycleDay: 14,                   // Optional: specific cycle day (1-28)
  pregnancyWeek: 20,              // Optional: specific pregnancy week
  postpartumWeek: 4,              // Optional: specific postpartum week
  icon: '🌸',                     // Emoji icon
  isFeatured: false,              // Show featured badge
  sources: ['Mayo Clinic'],       // Citations (optional)
)
```

#### How to Add a New Tip

1. Open `lib/features/insights/data/daily_tips_data.dart`
2. Find the appropriate section based on journey mode:
   - `_cycleTips` - For cycle tracking users
   - `_ttcTips` - For TTC users
   - `_pregnancyTips` - For pregnancy users
   - `_postpartumTips` - For postpartum users
   - `_exploringTips` - For exploring users
3. Add a new `DailyTip` const to the list

#### Example

```dart
DailyTip(
  id: 'preg_week_25',
  titleKey: 'Baby is the size of a cauliflower!',
  bodyKey: 'Your baby weighs about 1.5 pounds now and their hearing is developing rapidly.',
  category: TipCategory.health,
  journeyMode: UserStage.pregnant,
  pregnancyWeek: 25,
  icon: '🥦',
  sources: ['ACOG'],
)
```

---

### Achievements

Achievements gamify the app experience and reward consistent usage.

#### Location
`lib/features/insights/data/achievements_data.dart`

#### Structure

```dart
Achievement(
  id: 'unique_id',
  titleKey: 'Achievement Title',
  descriptionKey: 'How to unlock this achievement',
  category: AchievementCategory.tracking,  // tracking, learning, milestones, consistency, pregnancy, fertility, wellness
  tier: AchievementTier.bronze,            // bronze, silver, gold, platinum
  points: 10,                              // Point value
  icon: '🏆',                              // Emoji icon
  requirement: AchievementRequirement(
    type: AchievementRequirementType.daysLogged,  // or streakDays, cyclesCompleted, articlesRead, etc.
    targetValue: 7,
  ),
)
```

#### Achievement Tiers
| Tier | Badge Color | Typical Points |
|------|-------------|----------------|
| Bronze | 🥉 | 10-20 |
| Silver | 🥈 | 25-35 |
| Gold | 🥇 | 40-60 |
| Platinum | 💎 | 75-100 |

#### Achievement Categories
- **tracking** - Logging-related achievements
- **consistency** - Streak-based achievements  
- **learning** - Article/content consumption
- **milestones** - Life events (first period, pregnancy milestones)
- **pregnancy** - Pregnancy-specific achievements
- **fertility** - TTC-related achievements
- **wellness** - Self-care achievements

#### How to Add a New Achievement

1. Open `lib/features/insights/data/achievements_data.dart`
2. Find the appropriate category list:
   - `_trackingAchievements`
   - `_consistencyAchievements`
   - `_learningAchievements`
   - `_pregnancyAchievements`
   - `_fertilityAchievements`
   - `_wellnessAchievements`
3. Add a new `Achievement` const

#### Example

```dart
Achievement(
  id: 'mood_tracker',
  titleKey: 'Mood Maven',
  descriptionKey: 'Log your mood for 14 consecutive days',
  category: AchievementCategory.tracking,
  tier: AchievementTier.silver,
  points: 25,
  icon: '😊',
  requirement: AchievementRequirement(
    type: AchievementRequirementType.moodsLogged,
    targetValue: 14,
  ),
)
```

---

### Hospital Bag Items

Default hospital bag checklist items for pregnancy mode.

#### Location
`lib/features/pregnancy/data/hospital_bag_data.dart`

#### Structure

```dart
HospitalBagItem(
  id: 'unique_id',
  nameKey: 'Item Name',           // Display text or localization key
  category: HospitalBagCategory.momLabor,  // momLabor, momPostpartum, partner, baby, documents, optional
  isEssential: true,              // Show star icon
  quantity: 2,                    // Optional: suggested quantity
  notes: 'Additional notes',      // Optional: helpful tip
)
```

#### Categories
| Category | Description |
|----------|-------------|
| momLabor | Items mom needs during labor |
| momPostpartum | Items for recovery after delivery |
| partner | Support person's essentials |
| baby | Newborn necessities |
| documents | Important paperwork |
| optional | Nice-to-have items |

#### How to Add a New Item

1. Open `lib/features/pregnancy/data/hospital_bag_data.dart`
2. Find the appropriate category section
3. Add a new `HospitalBagItem` to the list

#### Example

```dart
HospitalBagItem(
  id: 'mom_labor_essential_oil',
  nameKey: 'Essential oil for aromatherapy',
  category: HospitalBagCategory.momLabor,
  isEssential: false,
  notes: 'Lavender or peppermint can help with relaxation',
)
```

---

## Localization for New Content

### Adding Localization Keys

When adding new tips, achievements, or items that need translation:

1. Open `lib/l10n/app_en.arb` (and other language files)
2. Add your key-value pair:

```json
"tipCycleDay25Title": "Your energy is peaking!",
"tipCycleDay25Body": "Follicular phase often brings increased energy. Great time for challenging workouts!"
```

3. Run `flutter gen-l10n` to regenerate localizations

### Dynamic Content

For content stored in data files (not ARB files), the app uses the `localizeKey()` extension which returns the key as-is. This means:

- Simple content: Use the actual display text as the key
- Translated content: Store translations in JSON content files

Example for tips with actual text:
```dart
DailyTip(
  titleKey: 'Energy Boost Day!',  // This text displays directly
  bodyKey: 'Your estrogen levels are rising, bringing natural energy.',
)
```


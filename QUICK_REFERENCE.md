# 🚀 HabitTracker - Quick Reference

## ⚡ Fast Start

```bash
# 1. Open project
open HabitTracker.xcodeproj

# 2. Build (in Xcode)
Cmd + B

# 3. Run on simulator
Cmd + R

# 4. Create IPA
make ipa
```

## 📁 Project Structure at a Glance

```
HabitTracker/
├── AppDelegate.swift ............. App lifecycle
├── SceneDelegate.swift ........... Window setup
├── HabitTrackerApp.swift ......... SwiftUI entry
│
├── Models/
│   └── Habit.swift ............... Data models
│
├── Views/ (8 screens)
│   ├── CheckInView ............... Daily habits
│   ├── DataView .................. Analytics
│   ├── SettingsView .............. Export
│   ├── AddHabitView .............. Create
│   └── 4 more...
│
├── Components/ (Reusable UI)
│   ├── HeatmapViews .............. Monthly/yearly
│   ├── StatisticsView ............ Stats
│   └── EmptyStateView ............ Empty
│
├── Services/
│   └── DataExportService ......... CSV/JSON
│
├── Utils/
│   ├── HabitSuggester ............ Smart suggestions
│   ├── StreakCalculator .......... Calculations
│   ├── Colors .................... Theme
│   └── Animations ................ Effects
│
├── Widgets/
│   └── HabitWidget ............... Home screen
│
└── Assets/
    ├── AppIcon ................... Icons
    └── Colors .................... Palette
```

## 🎯 Key Files

| File | Purpose |
|------|---------|
| `Info.plist` | App config |
| `project.pbxproj` | Build settings |
| `Habit.swift` | Core data model |
| `ContentView.swift` | Main navigation |
| `AddHabitView.swift` | Habit creation |

## 🛠️ Make Commands

```bash
make help            # Show all commands
make build           # Build for simulator
make run             # Build and run
make archive         # Create .xcarchive
make ipa             # Create .ipa file
make clean           # Clean build artifacts
make open            # Open in Xcode
```

## 📱 UI Architecture (3 Tabs)

```
ContentView (TabView)
├── 打卡 (Check-in)
│   └── CheckInView
│       ├── Habit list
│       ├── Check-in button
│       └── Notes sheet
│
├── 数据 (Data)
│   └── DataView
│       ├── Combined heatmap
│       ├── Habit stats
│       └── Monthly/yearly views
│
└── 设置 (Settings)
    └── SettingsView
        ├── Version info
        ├── Export options
        └── Privacy info
```

## 💾 Data Model

```swift
Habit
├── id: String
├── name: String
├── icon: String (SF Symbol)
├── color: String (hex)
├── frequency: HabitFrequency
│   ├── type: Daily/Weekly/Monthly
│   ├── selectedDays: [Int]
│   └── targetCount: Int
├── isCounter: Bool
├── records: [HabitRecord]
│
└── HabitRecord
    ├── id: String
    ├── date: Date
    ├── count: Int
    └── notes: String
```

## 🎨 App Colors

```swift
Primary:   #FF6B6B (Red)
Secondary: #4D96FF (Blue)
Accent:    #6BCB77 (Green)
Orange:    #FFA500
Yellow:    #FFD93D
Purple:    #A78BFA
Pink:      #FF69B4
Teal:      #20B2AA
```

## 📊 Statistics Functions

```swift
// In StreakCalculator
getCurrentStreak()         // Days streaking
getLongestStreak()         // Best ever
getCompletionRate()        // Percentage
getSummaryStats()          // All stats
```

## 🏗️ Building for Release

### Step 1: Prepare
- Update version in `Info.plist`
- Review code and fix warnings
- Test on real device

### Step 2: Sign
- Set code signing in Xcode
- Select team ID
- Create provisioning profile

### Step 3: Archive
- Product → Archive (in Xcode)
- Or: `xcodebuild archive`

### Step 4: Export IPA
- Distribute App in Organizer
- Or: `make ipa`

## 🔍 Troubleshooting

| Issue | Solution |
|-------|----------|
| Build fails | Clean: `Cmd + Shift + K` |
| No signing | Enable auto sign in project |
| IPA won't install | Check bundle ID & signing |
| Widget not updating | Requires app foreground |

## 📝 Common Edits

### Change App Name
- Update `Info.plist`: `CFBundleDisplayName`
- Update `project.pbxproj`: `PRODUCT_NAME`

### Change Bundle ID
- Project Settings → Target
- General tab → Bundle ID
- Also update `project.pbxproj`

### Update Version
- In `Info.plist`:
  - `CFBundleShortVersionString`: User version (1.0)
  - `CFBundleVersion`: Build number (1)

## 🚀 Distribution Options

| Method | Audience | Review |
|--------|----------|--------|
| Ad Hoc | Internal | None |
| TestFlight | Up to 10k | Apple |
| App Store | Public | Apple |
| Enterprise | Company | None |

## 📚 Documentation Files

- `README.md` - Feature overview
- `BUILD_GUIDE.md` - Detailed build instructions
- `PROJECT_SUMMARY.md` - Complete project info
- `build.sh` - Build automation
- `Makefile` - Quick commands

## ⚙️ Build Settings

| Setting | Value |
|---------|-------|
| Swift | 5.9+ |
| iOS | 17.0+ |
| Deployment | iPhone & iPad |
| Architecture | arm64, x86_64 |

## 💡 Tips & Tricks

```bash
# View build settings
xcodebuild -showBuildSettings

# List available simulators
xcrun simctl list devices

# Check code signing
security find-identity -v -p codesigning

# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData
```

## 🎓 Architecture Pattern

**MVVM** (Model-View-ViewModel)

```
Model (Habit.swift)
  ↓
ViewModel (AppViewModel.swift)
  ↓
View (SwiftUI)
```

## 📱 Widget Sizes

- **Small**: 2×2 grid
- **Medium**: 4×2 grid
- **Large**: 4×4 grid

## 🔐 Privacy

- ✅ No tracking
- ✅ No ads
- ✅ No cloud
- ✅ Local only
- ✅ Offline works

## ✨ Features at a Glance

- ✅ 3 tab navigation
- ✅ 8+ screens
- ✅ Habit CRUD
- ✅ Daily check-ins
- ✅ Notes/journaling
- ✅ Streak tracking
- ✅ Heatmaps (monthly & yearly)
- ✅ Statistics dashboard
- ✅ CSV/JSON export
- ✅ Home screen widget
- ✅ Dark mode support
- ✅ iPad support

## 🎯 Next Steps

1. **Test**: `Cmd + R` in Xcode
2. **Build**: `make build`
3. **Archive**: `make ipa`
4. **Distribute**: Choose method (TestFlight/App Store)
5. **Monitor**: Track app performance

## 🆘 Getting Help

- Check `BUILD_GUIDE.md` for build issues
- See `README.md` for feature details
- Review code comments for implementation
- Check Apple's official documentation

---

**Happy coding! 🚀**

*Last Updated: December 11, 2025*

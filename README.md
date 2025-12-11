# 📱 Habit Tracker iOS App

A beautiful, privacy-first habit tracking application built with Swift, SwiftUI, and SwiftData.

## ✨ Features

### 🎯 Habit Management
- **Create Custom Habits**: Name, icon, color, and frequency configuration
- **Smart Suggestions**: Auto-suggest icons and colors based on habit name
- **Flexible Frequency**: Daily, Weekly (select specific days), or Monthly (with target count)
- **Counter Habits**: Track multi-per-day habits like "drink 8 cups of water"

### 📊 Progress Tracking
- **Daily Check-ins**: Quick tap to complete habits
- **Monthly Heatmap**: Visual overview of completions for the current month
- **Yearly Heatmap**: Pixel-style 365-day visualization per habit
- **Combined View**: Compare all habits side-by-side in yearly overview
- **Statistics Dashboard**: View total check-ins, streaks, and completion rates

### 📈 Analytics
- **Current Streak**: Days in current consecutive completion streak
- **Longest Streak**: Best streak ever achieved
- **Total Check-ins**: Cumulative completion count
- **Completion Rate**: Percentage of scheduled completions
- **Habit Details**: Full analytics view per habit

### 📝 Notes & Journaling
- **Optional Notes**: Add reflections to each check-in
- **Notes History**: View all notes for a habit
- **Date Tracking**: See exactly when each note was added

### 📤 Data Export
- **CSV Export**: Spreadsheet-compatible format for analysis
- **JSON Export**: Complete backup of all habits and records
- **Share Integration**: Export directly to Mail, iCloud, etc.
- **Import Ready**: JSON format allows future data import

### 🏠 Home Screen Widget
- **Small Widget**: Quick view of 3-4 today's habits
- **Medium Widget**: Show 5-6 habits with streaks
- **Large Widget**: Full daily habit list with completion status
- **Quick Check-in**: Tap to mark habits complete (limited support)

### 🔒 Privacy & Security
- **Local Storage Only**: All data stored on device
- **No Tracking**: Zero analytics or telemetry
- **No Internet**: Works completely offline
- **No Ads**: Clean, distraction-free experience

## 📁 Project Structure

```
HabitTracker/
├── Models/
│   └── Habit.swift                 # Data models (Habit, HabitFrequency, HabitRecord)
├── Views/
│   ├── ContentView.swift           # Main TabView navigation
│   ├── CheckInView.swift           # Daily check-in screen (打卡)
│   ├── DataView.swift              # Analytics screen (数据)
│   ├── SettingsView.swift          # Settings & export (设置)
│   ├── AddHabitView.swift          # Habit creation form
│   ├── HabitDetailView.swift       # Individual habit analytics
│   ├── HabitNotesView.swift        # Notes history view
│   └── OnboardingView.swift        # First-launch tutorial
├── ViewModels/
│   └── AppViewModel.swift          # App-level navigation state
├── Components/
│   ├── EmptyStateView.swift        # Empty state placeholder
│   ├── HeatmapViews.swift          # Monthly & yearly heatmaps
│   ├── CombinedHeatmapView.swift   # Multi-habit yearly view
│   └── StatisticsView.swift        # Statistics dashboard
├── Services/
│   └── DataExportService.swift     # CSV/JSON export & import
├── Utils/
│   ├── HabitSuggester.swift        # Smart icon/color suggestions
│   ├── StreakCalculator.swift      # Streak & statistics calculations
│   ├── Colors.swift                # Color system & utilities
│   └── Animations.swift            # Animation helpers
├── Widgets/
│   └── HabitWidget.swift           # Home screen widget
└── HabitTrackerApp.swift           # App entry point & SwiftData setup
```

## 🏗️ Architecture

### Technology Stack
- **Swift 5.9+**
- **SwiftUI** - Modern declarative UI framework
- **SwiftData** - Native data persistence (iOS 17+)
- **WidgetKit** - Home screen widgets
- **Observation** - Observable view models

### Design Patterns
- **MVVM**: Model-View-ViewModel architecture
- **Modular Components**: Reusable UI components
- **Separation of Concerns**: Services for data operations
- **Reactive State Management**: @State, @Query for reactive updates

## 🎨 UI/UX Features

- **Dark Mode Support**: Full light/dark mode compatibility
- **Color System**: 10-color palette with automatic selection
- **Icon Library**: 20+ curated SF Symbols for habits
- **Smooth Animations**: Spring and easing animations for interactions
- **Accessibility**: Size categories and semantic naming
- **Responsive Layout**: Adapts to all iPhone sizes and orientations

## 📋 Data Models

### Habit
Main habit entity with configuration, statistics, and records.
- UUID identifier
- Name, icon, color
- Frequency (daily/weekly/monthly)
- Counter support with daily target
- Active/inactive status
- Relationships to HabitRecords

### HabitFrequency
Flexible frequency configuration.
- Type (daily, weekly, monthly)
- Selected days for weekly habits
- Target count for monthly habits

### HabitRecord
Individual check-in entry.
- Date and time
- Count (for counter habits)
- Optional notes
- Linked to parent Habit

## 🚀 Getting Started

### Requirements
- Xcode 15+
- iOS 17.0+
- SwiftData-compatible device (iOS 17+)

### Installation
1. Clone the repository
2. Open `HabitTracker.xcodeproj` in Xcode
3. Select target device/simulator
4. Build and run (⌘R)

### First Launch
- App displays onboarding screen
- User can skip or review features
- Tap "Get Started" to begin
- Create first habit from 打卡 tab

## 🔧 Configuration

### SwiftData
SwiftData is configured in `HabitTrackerApp.swift`:
```swift
let schema = Schema([Habit.self, HabitFrequency.self, HabitRecord.self])
let modelContainer = try ModelContainer(for: schema)
```

### Widget Configuration
Widgets are configured for:
- Small (2-column)
- Medium (1-column)
- Large (full)

Update widget in `Widgets/HabitWidget.swift` to modify display.

## 📊 Statistics Calculations

### Current Streak
- Count consecutive days with completions
- For weekly habits, skip non-scheduled days
- Reset on first missed scheduled day

### Longest Streak
- Iterate through all records chronologically
- Find longest consecutive completion sequence
- Consider frequency type in calculations

### Completion Rate
- Calculate based on frequency type
- Daily: days since creation
- Weekly: weeks × selected days
- Monthly: months × target count
- Return percentage of actual vs expected

## 💾 Data Persistence

### Storage
- SwiftData manages all persistence
- Automatic background saving
- Device-encrypted storage
- No cloud synchronization

### Export Formats

#### CSV
- Header row with statistics
- One row per habit summary
- Detailed check-in history section
- Excel/Numbers compatible

#### JSON
- Hierarchical structure
- Habit objects with nested records
- ISO8601 timestamps
- Preserves all metadata

## 🎯 Next Steps & Enhancements

Potential features for future releases:
- **Notifications**: Daily reminders and streak notifications
- **Data Import**: Load exported JSON files
- **Habit Templates**: Pre-made habit suggestions
- **Sync**: iCloud sync option (optional)
- **Collaboration**: Share habits with friends
- **Statistics Charts**: Detailed graphs and trends
- **Goal Setting**: Set target streaks
- **Badges**: Achievement system
- **Dark Mode Theme**: Custom dark theme options
- **Backup**: Automatic backup scheduling

## 🐛 Known Issues & Limitations

- Widget update frequency is hourly (iOS limitation)
- Large datasets (500+ records) may impact heatmap rendering
- SwiftData requires iOS 17.0+

## 📄 License

This project is private and intended for personal use.

## 👨‍💻 Development Notes

### Key Implementation Details

1. **Icon Suggestions**: `HabitSuggester.suggestIcon()` uses keyword matching
2. **Color Suggestions**: Maps habit keywords to color palette
3. **Streak Calculation**: Handles frequency-specific logic
4. **Heatmap Generation**: Efficiently generates 365-day grids
5. **Notes Integration**: Optional add-on to check-ins with editing support

### Testing
- Use preview structs for SwiftUI testing
- In-memory ModelContainer for unit tests
- Sample data in preview providers

### Performance Optimization
- Query with predicates to filter data
- Lazy grid rendering for heatmaps
- Scroll view pagination for large lists
- ModelContext refresh for state updates

## 📚 Dependencies

- **SwiftData**: Built-in persistence framework
- **SwiftUI**: UI framework
- **WidgetKit**: Widget framework
- No external package dependencies

## 🎓 Learning Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [SwiftData Guide](https://developer.apple.com/documentation/swiftdata)
- [WidgetKit Overview](https://developer.apple.com/widgets)
- [MVVM Pattern](https://www.raywenderlich.com/books/advanced-ios-app-architecture)

---

**Created with ❤️ for iOS**

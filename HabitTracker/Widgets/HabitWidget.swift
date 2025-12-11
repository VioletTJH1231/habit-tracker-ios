import WidgetKit
import SwiftUI
import SwiftData

/// Home screen widget showing today's habits for quick check-in
struct HabitWidgetEntryView: View {
    var entry: HabitWidgetProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallHabitWidget(entry: entry)
        case .systemMedium:
            MediumHabitWidget(entry: entry)
        case .systemLarge:
            LargeHabitWidget(entry: entry)
        @unknown default:
            SmallHabitWidget(entry: entry)
        }
    }
}

/// Small widget showing 3-4 habits
struct SmallHabitWidget: View {
    let entry: HabitWidgetProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(entry.habits.prefix(3), id: \.id) { habit in
                    HStack(spacing: 6) {
                        Image(systemName: habit.iconName)
                            .font(.caption)
                            .foregroundColor(Color(hex: habit.colorHex))
                            .frame(width: 16)
                        
                        Text(habit.name)
                            .font(.caption2)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        if let record = habit.getCompletionStatus(for: Date()) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption2)
                                .foregroundColor(Color(hex: habit.colorHex))
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}

/// Medium widget showing 5-6 habits
struct MediumHabitWidget: View {
    let entry: HabitWidgetProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Today's Habits")
                        .font(.headline)
                    Text(Date().formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.bottom, 4)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(entry.habits.prefix(5), id: \.id) { habit in
                    HabitWidgetRow(habit: habit)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}

/// Large widget showing all habits with details
struct LargeHabitWidget: View {
    let entry: HabitWidgetProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Today's Habits")
                        .font(.headline)
                    Text(Date().formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(entry.habits, id: \.id) { habit in
                    VStack(alignment: .leading, spacing: 4) {
                        HabitWidgetRow(habit: habit)
                        
                        if let record = habit.getCompletionStatus(for: Date()) {
                            Text("✓ Completed")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                    
                    if habit.id != entry.habits.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}

/// Row component for habit in widget
struct HabitWidgetRow: View {
    let habit: Habit
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: habit.iconName)
                .font(.caption)
                .foregroundColor(Color(hex: habit.colorHex))
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    Text("Streak: \(habit.getCurrentStreak())")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    if habit.isCounter {
                        Text("Goal: \(habit.dailyTarget)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            
            if let record = habit.getCompletionStatus(for: Date()) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(hex: habit.colorHex))
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
            }
        }
    }
}

/// Widget provider for timeline management
struct HabitWidgetProvider: AppIntentTimelineProvider {
    typealias Entry = HabitWidgetEntry
    
    func placeholder(in context: Context) -> HabitWidgetEntry {
        HabitWidgetEntry(date: Date(), habits: [])
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> HabitWidgetEntry {
        // Return sample data for widget preview
        let sampleHabit = Habit(
            name: "Drink Water",
            iconName: "waterbottle.fill",
            colorHex: "#4D96FF"
        )
        return HabitWidgetEntry(date: Date(), habits: [sampleHabit])
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<HabitWidgetEntry> {
        // Load habits from SwiftData
        var habits: [Habit] = []
        
        do {
            let modelContext = ModelContext(ModelContainer(for: Habit.self))
            let descriptor = FetchDescriptor<Habit>(predicate: #Predicate { $0.isActive })
            habits = try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching habits: \(error)")
        }
        
        let entry = HabitWidgetEntry(date: Date(), habits: habits)
        
        // Update widget every hour
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
}

/// Widget entry containing habit data
struct HabitWidgetEntry: TimelineEntry {
    let date: Date
    let habits: [Habit]
}

/// Widget configuration intent
struct ConfigurationAppIntent: AppIntent, Equatable {
    static var title: LocalizedStringResource = "Habit Tracker"
    static var description: LocalizedStringResource = "See today's habits at a glance"
}

/// Main widget bundle
struct HabitWidget: Widget {
    let kind: String = "HabitWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: HabitWidgetProvider()
        ) { entry in
            HabitWidgetEntryView(entry: entry)
                .containerBackground(.fill, for: .widget)
        }
        .configurationDisplayName("Habit Tracker")
        .description("Track your daily habits")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    HabitWidget()
} timeline: {
    let habit1 = Habit(name: "Exercise", iconName: "dumbbell.fill", colorHex: "#FF6B6B")
    let habit2 = Habit(name: "Read", iconName: "book.fill", colorHex: "#4D96FF")
    
    HabitWidgetEntry(date: Date(), habits: [habit1, habit2])
}

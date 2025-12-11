import Foundation
import SwiftData

/// Frequency type for habit completion
enum FrequencyType: String, Codable, CaseIterable {
    /// Complete once per day
    case daily = "daily"
    /// Complete on specific days of the week
    case weekly = "weekly"
    /// Complete N times per month
    case monthly = "monthly"
    
    var displayName: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        }
    }
}

/// Habit frequency configuration
@Model
final class HabitFrequency {
    var type: FrequencyType = .daily
    /// For weekly habits: [0=Sunday, 1=Monday, ..., 6=Saturday]
    var selectedDays: [Int] = []
    /// For monthly habits: number of required completions
    var targetCount: Int = 1
    
    init(type: FrequencyType = .daily, selectedDays: [Int] = [], targetCount: Int = 1) {
        self.type = type
        self.selectedDays = selectedDays
        self.targetCount = targetCount
    }
    
    /// Get display name for this frequency configuration
    var displayConfiguration: String {
        switch type {
        case .daily:
            return "Daily"
        case .weekly:
            let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            let days = selectedDays.sorted().map { dayNames[$0] }.joined(separator: ", ")
            return "Weekly: \(days)"
        case .monthly:
            return "\(targetCount) times per month"
        }
    }
}

/// Main Habit model for tracking personal habits
@Model
final class Habit {
    /// Unique identifier
    @Attribute(.unique) var id: String = UUID().uuidString
    /// Name of the habit (e.g., "Drink 8 cups of water")
    var name: String
    /// Icon name (SF Symbol)
    var iconName: String = "star.fill"
    /// Color identifier (hex string)
    var colorHex: String = "#FF6B6B"
    /// Frequency configuration
    var frequency: HabitFrequency
    /// Whether this is a multi-per-day habit (with counter)
    var isCounter: Bool = false
    /// Target count for counter habits
    var dailyTarget: Int = 1
    /// Creation date
    var createdAt: Date = Date()
    /// Last update date
    var updatedAt: Date = Date()
    /// Whether habit is active
    var isActive: Bool = true
    /// Habit records (check-ins)
    @Relationship(deleteRule: .cascade, inverse: \HabitRecord.habit)
    var records: [HabitRecord] = []
    
    init(
        name: String,
        iconName: String = "star.fill",
        colorHex: String = "#FF6B6B",
        frequency: HabitFrequency = HabitFrequency(),
        isCounter: Bool = false,
        dailyTarget: Int = 1
    ) {
        self.name = name
        self.iconName = iconName
        self.colorHex = colorHex
        self.frequency = frequency
        self.isCounter = isCounter
        self.dailyTarget = dailyTarget
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    /// Get completion status for a specific date
    func getCompletionStatus(for date: Date) -> HabitRecord? {
        let calendar = Calendar.current
        return records.first { calendar.isDate($0.completedAt, inSameDayAs: date) }
    }
    
    /// Check if habit should be completed today based on frequency
    func shouldCompleteToday() -> Bool {
        let calendar = Calendar.current
        let today = Date()
        
        switch frequency.type {
        case .daily:
            return true
        case .weekly:
            let todayWeekday = calendar.component(.weekday, from: today) - 1 // 0-6
            return frequency.selectedDays.contains(todayWeekday)
        case .monthly:
            return true // Always available, but with target count
        }
    }
    
    /// Calculate current streak
    func getCurrentStreak() -> Int {
        let calendar = Calendar.current
        var streak = 0
        var currentDate = Date()
        
        let sortedRecords = records.sorted { $0.completedAt > $1.completedAt }
        
        for _ in 0..<365 {
            let nextDay = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            
            if let record = sortedRecords.first(where: { calendar.isDate($0.completedAt, inSameDayAs: nextDay) }) {
                streak += 1
                currentDate = nextDay
            } else if frequency.type == .weekly {
                // For weekly habits, skip days when habit isn't scheduled
                let weekday = calendar.component(.weekday, from: nextDay) - 1
                if frequency.selectedDays.contains(weekday) {
                    break
                }
                currentDate = nextDay
            } else {
                break
            }
        }
        
        return streak
    }
    
    /// Get longest streak ever achieved
    func getLongestStreak() -> Int {
        let calendar = Calendar.current
        let sortedRecords = records.sorted { $0.completedAt > $1.completedAt }
        
        var longestStreak = 0
        var currentStreak = 0
        var lastCheckedDate: Date? = nil
        
        for record in sortedRecords.reversed() {
            if let lastDate = lastCheckedDate {
                let daysBetween = calendar.dateComponents([.day], from: record.completedAt, to: lastDate).day ?? 0
                
                if daysBetween == 1 || (frequency.type == .weekly && daysBetween <= 7) {
                    currentStreak += 1
                } else {
                    longestStreak = max(longestStreak, currentStreak)
                    currentStreak = 1
                }
            } else {
                currentStreak = 1
            }
            lastCheckedDate = record.completedAt
        }
        
        return max(longestStreak, currentStreak)
    }
    
    /// Get total number of check-ins
    func getTotalCheckIns() -> Int {
        return records.count
    }
    
    /// Get completion rate (percentage)
    func getCompletionRate() -> Double {
        let daysSinceCreation = Calendar.current.dateComponents([.day], from: createdAt, to: Date()).day ?? 0
        
        if daysSinceCreation == 0 {
            return 0
        }
        
        return Double(getTotalCheckIns()) / Double(daysSinceCreation) * 100
    }
}

/// Record of a single habit completion
@Model
final class HabitRecord {
    /// Unique identifier
    @Attribute(.unique) var id: String = UUID().uuidString
    /// Reference to parent habit
    var habit: Habit?
    /// Date of completion
    var completedAt: Date = Date()
    /// Count for multi-per-day habits
    var count: Int = 1
    /// Optional notes or reflection
    var notes: String = ""
    /// Created timestamp
    var createdAt: Date = Date()
    
    init(
        habit: Habit? = nil,
        completedAt: Date = Date(),
        count: Int = 1,
        notes: String = ""
    ) {
        self.habit = habit
        self.completedAt = completedAt
        self.count = count
        self.notes = notes
        self.createdAt = Date()
    }
}

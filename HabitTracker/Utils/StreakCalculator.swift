import Foundation

/// Utility for calculating streaks and statistics
struct StreakCalculator {
    /// Calculate current consecutive day streak
    /// - Parameters:
    ///   - habit: The habit to calculate streak for
    ///   - fromDate: Starting date for calculation (default: today)
    /// - Returns: Number of consecutive days in current streak
    static func getCurrentStreak(for habit: Habit, fromDate: Date = Date()) -> Int {
        let calendar = Calendar.current
        var streak = 0
        var currentDate = calendar.startOfDay(for: fromDate)
        
        let sortedRecords = habit.records.sorted { $0.completedAt > $1.completedAt }
        
        // Start from today and work backwards
        while true {
            let nextDay = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            
            let hasCompletion = sortedRecords.contains { record in
                calendar.isDate(record.completedAt, inSameDayAs: nextDay)
            }
            
            if hasCompletion {
                streak += 1
                currentDate = nextDay
            } else if habit.frequency.type == .weekly {
                // For weekly habits, skip non-scheduled days
                let weekday = calendar.component(.weekday, from: nextDay) - 1
                if !habit.frequency.selectedDays.contains(weekday) {
                    currentDate = nextDay
                    continue
                }
                break
            } else {
                break
            }
        }
        
        return streak
    }
    
    /// Find the longest streak ever achieved
    /// - Parameter habit: The habit to analyze
    /// - Returns: Longest consecutive days streak
    static func getLongestStreak(for habit: Habit) -> Int {
        let calendar = Calendar.current
        let sortedRecords = habit.records.sorted { $0.completedAt > $1.completedAt }
        
        guard !sortedRecords.isEmpty else { return 0 }
        
        var longestStreak = 0
        var currentStreak = 1
        var previousDate = calendar.startOfDay(for: sortedRecords.first?.completedAt ?? Date())
        
        for i in 1..<sortedRecords.count {
            let currentDate = calendar.startOfDay(for: sortedRecords[i].completedAt)
            let daysDifference = calendar.dateComponents([.day], from: currentDate, to: previousDate).day ?? 0
            
            if daysDifference == 1 {
                currentStreak += 1
            } else if habit.frequency.type == .weekly {
                // For weekly habits, allow gaps on non-scheduled days
                let isScheduledDay = habit.frequency.selectedDays.contains(
                    calendar.component(.weekday, from: currentDate) - 1
                )
                if isScheduledDay {
                    longestStreak = max(longestStreak, currentStreak)
                    currentStreak = 1
                }
            } else {
                longestStreak = max(longestStreak, currentStreak)
                currentStreak = 1
            }
            
            previousDate = currentDate
        }
        
        return max(longestStreak, currentStreak)
    }
    
    /// Calculate completion percentage
    /// - Parameter habit: The habit to analyze
    /// - Returns: Percentage of days with completions (0-100)
    static func getCompletionRate(for habit: Habit) -> Double {
        let calendar = Calendar.current
        let daysSinceCreation = calendar.dateComponents([.day], from: habit.createdAt, to: Date()).day ?? 0
        
        guard daysSinceCreation > 0 else { return 0 }
        
        let expectedDays: Int
        
        switch habit.frequency.type {
        case .daily:
            expectedDays = daysSinceCreation + 1 // Include creation day
        case .weekly:
            let weeksCount = daysSinceCreation / 7 + 1
            expectedDays = weeksCount * habit.frequency.selectedDays.count
        case .monthly:
            let monthsCount = daysSinceCreation / 30 + 1
            expectedDays = monthsCount * habit.frequency.targetCount
        }
        
        let actualCompletions = habit.records.count
        return Double(actualCompletions) / Double(max(expectedDays, 1)) * 100
    }
    
    /// Get summary statistics for a habit
    /// - Parameter habit: The habit to analyze
    /// - Returns: Dictionary with key statistics
    static func getSummaryStats(for habit: Habit) -> [String: Any] {
        return [
            "totalCheckIns": habit.getTotalCheckIns(),
            "currentStreak": getCurrentStreak(for: habit),
            "longestStreak": getLongestStreak(for: habit),
            "completionRate": String(format: "%.1f%%", getCompletionRate(for: habit)),
            "daysSinceCreation": Calendar.current.dateComponents([.day], from: habit.createdAt, to: Date()).day ?? 0
        ]
    }
}

/// Statistics summary for all habits
struct AppStatistics {
    let totalHabits: Int
    let totalCheckIns: Int
    let averageStreaks: Double
    let bestStreak: Int
    let mostActiveHabit: String?
    
    init(habits: [Habit]) {
        self.totalHabits = habits.count
        self.totalCheckIns = habits.reduce(0) { $0 + $1.getTotalCheckIns() }
        
        let streaks = habits.map { StreakCalculator.getLongestStreak(for: $0) }
        self.bestStreak = streaks.max() ?? 0
        self.averageStreaks = streaks.isEmpty ? 0 : Double(streaks.reduce(0, +)) / Double(streaks.count)
        
        self.mostActiveHabit = habits.max { $0.getTotalCheckIns() < $1.getTotalCheckIns() }?.name
    }
}

import SwiftUI

/// Monthly heatmap showing habit completion for a specific month
struct MonthlyHeatmapView: View {
    let habit: Habit
    @State private var selectedMonth: Date = Date()
    
    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Month picker (compact)
            HStack(spacing: 12) {
                Button(action: { previousMonth() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
                
                Text(monthYearString)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Button(action: { nextMonth() }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Heatmap grid
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(getDaysInMonth(), id: \.self) { date in
                    HeatmapCellView(
                        date: date,
                        isCompleted: isCompleted(date),
                        isCurrentMonth: isInMonth(date),
                        accentColor: Color(hex: habit.colorHex)
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    /// Get array of dates for the calendar grid (including padding days)
    private func getDaysInMonth() -> [Date] {
        let calendar = Calendar.current
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedMonth))!
        
        let firstWeekday = calendar.component(.weekday, from: monthStart) - 1
        let daysInMonth = calendar.range(of: .day, in: .month, for: monthStart)!.count
        
        var dates: [Date] = []
        
        // Add padding for days before month starts
        for i in 0..<firstWeekday {
            let date = calendar.date(byAdding: .day, value: -i - 1, to: monthStart)!
            dates.insert(date, at: 0)
        }
        
        // Add actual month days
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                dates.append(date)
            }
        }
        
        // Add padding for remaining cells to complete grid
        while dates.count % 7 != 0 {
            let lastDate = dates.last!
            if let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: lastDate) {
                dates.append(nextDate)
            }
        }
        
        return dates
    }
    
    private func isInMonth(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.dateComponents([.month], from: selectedMonth).month ==
               calendar.dateComponents([.month], from: date).month
    }
    
    private func isCompleted(_ date: Date) -> Bool {
        return habit.getCompletionStatus(for: date) != nil
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedMonth)
    }
    
    private func previousMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
    }
    
    private func nextMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
    }
}

/// Individual cell in the heatmap
struct HeatmapCellView: View {
    let date: Date
    let isCompleted: Bool
    let isCurrentMonth: Bool
    let accentColor: Color
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 4)
                .fill(
                    isCurrentMonth
                        ? (isCompleted ? accentColor : Color.gray.opacity(0.1))
                        : Color.clear
                )
            
            // Optional: completion indicator
            if isCurrentMonth && isCompleted {
                Image(systemName: "checkmark")
                    .font(.caption2)
                    .foregroundColor(.white)
            }
        }
        .frame(height: 32)
    }
}

/// Yearly heatmap showing 365-day habit completion in pixel style
struct YearlyHeatmapView: View {
    let habit: Habit
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 53)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Year selector
            HStack(spacing: 12) {
                Button(action: { selectedYear -= 1 }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
                
                Text("\(selectedYear)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Button(action: { selectedYear += 1 }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Year heatmap grid (7 rows x 53 columns for weeks)
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(spacing: 1) {
                    ForEach(0..<7, id: \.self) { weekday in
                        HStack(spacing: 1) {
                            ForEach(0..<53, id: \.self) { week in
                                if let date = getDateForPosition(week: week, weekday: weekday) {
                                    YearlyHeatmapCellView(
                                        date: date,
                                        isCompleted: isCompleted(date),
                                        isCurrentYear: isInYear(date),
                                        accentColor: Color(hex: habit.colorHex)
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    /// Get date at specific week and weekday position
    private func getDateForPosition(week: Int, weekday: Int) -> Date? {
        let calendar = Calendar.current
        
        // Find January 1st of selected year
        var components = DateComponents()
        components.year = selectedYear
        components.month = 1
        components.day = 1
        
        guard let jan1 = calendar.date(from: components) else { return nil }
        
        // Calculate first day of week containing Jan 1
        let firstWeekday = calendar.component(.weekday, from: jan1) - 1
        let startDate = calendar.date(byAdding: .day, value: -firstWeekday, to: jan1)!
        
        // Calculate target date
        let daysOffset = week * 7 + weekday
        let date = calendar.date(byAdding: .day, value: daysOffset, to: startDate)!
        
        // Only return dates within the selected year
        return isInYear(date) ? date : nil
    }
    
    private func isInYear(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.dateComponents([.year], from: date).year == selectedYear
    }
    
    private func isCompleted(_ date: Date) -> Bool {
        return habit.getCompletionStatus(for: date) != nil
    }
}

/// Individual cell in yearly heatmap
struct YearlyHeatmapCellView: View {
    let date: Date
    let isCompleted: Bool
    let isCurrentYear: Bool
    let accentColor: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(
                isCurrentYear
                    ? (isCompleted ? accentColor : Color.gray.opacity(0.15))
                    : Color.clear
            )
            .frame(height: 12)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: 20) {
        let habit = Habit(
            name: "Exercise",
            iconName: "dumbbell.fill",
            colorHex: "#FF6B6B"
        )
        
        MonthlyHeatmapView(habit: habit)
        YearlyHeatmapView(habit: habit)
    }
}

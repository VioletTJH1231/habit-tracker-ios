import SwiftUI

/// Yearly combined heatmap showing all habits on one view
struct CombinedYearlyHeatmapView: View {
    let habits: [Habit]
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
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
            
            // Combined heatmap
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(spacing: 8) {
                    ForEach(habits, id: \.id) { habit in
                        HStack(spacing: 8) {
                            // Habit indicator
                            HStack(spacing: 4) {
                                Image(systemName: habit.iconName)
                                    .font(.caption)
                                    .foregroundColor(Color(hex: habit.colorHex))
                                    .frame(width: 24)
                            }
                            .frame(width: 40)
                            
                            // Mini heatmap row (53 weeks)
                            VStack(spacing: 1) {
                                ForEach(0..<7, id: \.self) { weekday in
                                    HStack(spacing: 1) {
                                        ForEach(0..<53, id: \.self) { week in
                                            if let date = getDateForPosition(week: week, weekday: weekday) {
                                                RoundedRectangle(cornerRadius: 1.5)
                                                    .fill(
                                                        isCompleted(for: habit, on: date)
                                                            ? Color(hex: habit.colorHex)
                                                            : Color.gray.opacity(0.1)
                                                    )
                                                    .frame(height: 8)
                                                    .frame(maxWidth: .infinity)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private func getDateForPosition(week: Int, weekday: Int) -> Date? {
        let calendar = Calendar.current
        
        var components = DateComponents()
        components.year = selectedYear
        components.month = 1
        components.day = 1
        
        guard let jan1 = calendar.date(from: components) else { return nil }
        
        let firstWeekday = calendar.component(.weekday, from: jan1) - 1
        let startDate = calendar.date(byAdding: .day, value: -firstWeekday, to: jan1)!
        
        let daysOffset = week * 7 + weekday
        let date = calendar.date(byAdding: .day, value: daysOffset, to: startDate)!
        
        return isInYear(date) ? date : nil
    }
    
    private func isInYear(_ date: Date) -> Bool {
        return Calendar.current.dateComponents([.year], from: date).year == selectedYear
    }
    
    private func isCompleted(for habit: Habit, on date: Date) -> Bool {
        return habit.getCompletionStatus(for: date) != nil
    }
}

#Preview {
    let habit1 = Habit(name: "Exercise", iconName: "dumbbell.fill", colorHex: "#FF6B6B")
    let habit2 = Habit(name: "Read", iconName: "book.fill", colorHex: "#4D96FF")
    let habit3 = Habit(name: "Meditate", iconName: "lotus.fill", colorHex: "#A78BFA")
    
    CombinedYearlyHeatmapView(habits: [habit1, habit2, habit3])
}

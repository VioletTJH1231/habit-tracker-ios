import SwiftUI

/// Comprehensive statistics and insights view
struct StatisticsView: View {
    @Query private var habits: [Habit]
    
    var statistics: AppStatistics {
        AppStatistics(habits: habits)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Overview cards
            VStack(spacing: 12) {
                StatisticCard(
                    icon: "star.fill",
                    title: "Total Habits",
                    value: String(statistics.totalHabits),
                    color: .blue
                )
                
                StatisticCard(
                    icon: "checkmark.circle.fill",
                    title: "Total Check-ins",
                    value: String(statistics.totalCheckIns),
                    color: .green
                )
                
                StatisticCard(
                    icon: "flame.fill",
                    title: "Best Streak",
                    value: "\(statistics.bestStreak) days",
                    color: .red
                )
                
                StatisticCard(
                    icon: "target",
                    title: "Average Streak",
                    value: String(format: "%.1f days", statistics.averageStreaks),
                    color: .orange
                )
            }
            
            // Most active habit
            if let mostActive = statistics.mostActiveHabit {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Most Active", systemImage: "crown.fill")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(mostActive)
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
    }
}

/// Single statistic card
struct StatisticCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, alignment: .center)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.headline)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(AppColors.surface))
        .cornerRadius(8)
    }
}

#Preview {
    StatisticsView()
        .modelContainer(for: Habit.self, inMemory: true)
}

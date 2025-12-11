import SwiftUI

/// Detail view for a single habit with full analytics
struct HabitDetailView: View {
    let habit: Habit
    @Environment(\.dismiss) var dismiss
    @State private var showNotes = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Image(systemName: habit.iconName)
                        .font(.system(size: 32))
                        .foregroundColor(Color(hex: habit.colorHex))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(habit.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(habit.frequency.displayConfiguration)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color(hex: habit.colorHex).opacity(0.1))
                .cornerRadius(12)
                
                // Statistics
                VStack(spacing: 12) {
                    StatRow(
                        label: "Current Streak",
                        value: "\(habit.getCurrentStreak()) days"
                    )
                    StatRow(
                        label: "Longest Streak",
                        value: "\(habit.getLongestStreak()) days"
                    )
                    StatRow(
                        label: "Total Check-ins",
                        value: "\(habit.getTotalCheckIns())"
                    )
                    StatRow(
                        label: "Completion Rate",
                        value: String(format: "%.1f%%", habit.getCompletionRate())
                    )
                }
                .padding()
                .background(Color(AppColors.surface))
                .cornerRadius(12)
                
                // Monthly Heatmap
                VStack(alignment: .leading, spacing: 12) {
                    Text("Monthly Progress")
                        .font(.headline)
                    MonthlyHeatmapView(habit: habit)
                }
                .padding()
                .background(Color(AppColors.surface))
                .cornerRadius(12)
                
                // Yearly Heatmap
                VStack(alignment: .leading, spacing: 12) {
                    Text("Yearly Progress")
                        .font(.headline)
                    YearlyHeatmapView(habit: habit)
                }
                .padding()
                .background(Color(AppColors.surface))
                .cornerRadius(12)
                
                // Notes button
                Button(action: { showNotes = true }) {
                    HStack {
                        Image(systemName: "note.text")
                        Text("View Notes")
                        Spacer()
                        Text("\(habit.records.filter { !$0.notes.isEmpty }.count)")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(AppColors.surface))
                    .cornerRadius(12)
                }
                .foregroundColor(.primary)
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Details")
        .sheet(isPresented: $showNotes) {
            HabitNotesView(habit: habit)
        }
    }
}

/// Row for displaying a statistic
struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    let habit = Habit(
        name: "Drink Water",
        iconName: "waterbottle.fill",
        colorHex: "#4D96FF"
    )
    
    NavigationStack {
        HabitDetailView(habit: habit)
    }
    .modelContainer(for: Habit.self, inMemory: true)
}

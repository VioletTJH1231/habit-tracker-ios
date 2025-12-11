import SwiftUI

/// Data/Analytics view for tracking progress and streaks
struct DataView: View {
    @Query private var habits: [Habit]
    @State private var showCombinedHeatmap = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if habits.isEmpty {
                    EmptyStateView(
                        icon: "chart.bar.fill",
                        title: "No Data Yet",
                        subtitle: "Complete some check-ins to see your progress"
                    )
                } else {
                    List {
                        // Combined yearly heatmap
                        Section {
                            Button(action: { showCombinedHeatmap = true }) {
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("Yearly Overview")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .foregroundColor(.primary)
                            }
                        }
                        
                        Section("Habits") {
                            ForEach(habits) { habit in
                                NavigationLink(destination: HabitDetailView(habit: habit)) {
                                    HabitDataRow(habit: habit)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("数据")
            .sheet(isPresented: $showCombinedHeatmap) {
                NavigationStack {
                    ScrollView {
                        CombinedYearlyHeatmapView(habits: habits)
                    }
                    .navigationTitle("Yearly Overview")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Done") {
                                showCombinedHeatmap = false
                            }
                        }
                    }
                }
            }
        }
    }
}

/// Row showing habit statistics
struct HabitDataRow: View {
    let habit: Habit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: habit.iconName)
                    .font(.title3)
                    .foregroundColor(Color(hex: habit.colorHex))
                
                Text(habit.name)
                    .font(.headline)
                
                Spacer()
            }
            
            HStack(spacing: 16) {
                StatItem(label: "Streak", value: "\(habit.getCurrentStreak())")
                StatItem(label: "Best", value: "\(habit.getLongestStreak())")
                StatItem(label: "Total", value: "\(habit.getTotalCheckIns())")
            }
            .font(.caption)
        }
        .padding(.vertical, 8)
    }
}

/// Single statistic display item
struct StatItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    DataView()
        .modelContainer(for: Habit.self, inMemory: true)
}

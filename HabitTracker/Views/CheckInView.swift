import SwiftUI
import SwiftData

/// Check-in screen for daily habit tracking
struct CheckInView: View {
    @Environment(AppViewModel.self) var appViewModel
    @Query private var habits: [Habit]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            VStack {
                if habits.isEmpty {
                    EmptyStateView(
                        icon: "plus.circle.fill",
                        title: "No Habits Yet",
                        subtitle: "Create your first habit to get started",
                        actionTitle: "Add Habit"
                    ) {
                        appViewModel.showAddHabitSheet = true
                    }
                } else {
                    List {
                        ForEach(habits) { habit in
                            HabitCheckInRow(habit: habit)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("打卡")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        appViewModel.showAddHabitSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
        }
    }
}

/// Row component for displaying a single habit check-in
struct HabitCheckInRow: View {
    let habit: Habit
    @Environment(\.modelContext) private var modelContext
    @State private var selectedCount: Int = 0
    @State private var showNotesSheet = false
    @State private var pendingRecord: HabitRecord?
    
    var body: some View {
        HStack(spacing: 12) {
            // Habit icon
            Image(systemName: habit.iconName)
                .font(.title)
                .foregroundColor(Color(hex: habit.colorHex))
                .frame(width: 44, height: 44)
                .background(Color(hex: habit.colorHex).opacity(0.1))
                .cornerRadius(8)
            
            // Habit info
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.headline)
                Text(habit.frequency.displayConfiguration)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Check-in controls
            if habit.isCounter {
                // Counter for multi-per-day habits
                HStack(spacing: 8) {
                    Button(action: {
                        if selectedCount > 0 {
                            selectedCount -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    
                    Text("\(selectedCount)")
                        .font(.headline)
                        .frame(minWidth: 30)
                    
                    Button(action: {
                        if selectedCount < habit.dailyTarget {
                            selectedCount += 1
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: habit.colorHex))
                    }
                }
            } else {
                // Simple check-in button
                Button(action: {
                    pendingRecord = HabitRecord(habit: habit, completedAt: Date(), count: 1)
                    showNotesSheet = true
                }) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: habit.colorHex))
                }
            }
        }
        .padding(.vertical, 8)
        .sheet(isPresented: $showNotesSheet) {
            if let record = pendingRecord {
                CheckInNotesSheet(
                    record: record,
                    isPresented: $showNotesSheet,
                    onSave: { notes in
                        pendingRecord?.notes = notes
                        if let record = pendingRecord {
                            habit.records.append(record)
                            habit.updatedAt = Date()
                            try? modelContext.save()
                        }
                        pendingRecord = nil
                        showNotesSheet = false
                    }
                )
            }
        }
    }
}

/// Sheet for adding notes to a check-in
struct CheckInNotesSheet: View {
    let record: HabitRecord
    @Binding var isPresented: Bool
    var onSave: (String) -> Void
    
    @State private var notes: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("Add a note for this check-in?")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                TextEditor(text: $notes)
                    .frame(minHeight: 120)
                    .padding(8)
                    .background(Color(AppColors.surfaceSecondary))
                    .cornerRadius(8)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button("Skip") {
                        onSave("")
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    
                    Button("Save") {
                        onSave(notes)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(notes.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .padding()
            .navigationTitle("Add Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    CheckInView()
        .modelContainer(for: Habit.self, inMemory: true)
}

import SwiftUI
import SwiftData

/// View for displaying and managing notes associated with habit check-ins
struct HabitNotesView: View {
    let habit: Habit
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    private var notesRecords: [HabitRecord] {
        habit.records.filter { !$0.notes.isEmpty }.sorted { $0.completedAt > $1.completedAt }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if notesRecords.isEmpty {
                    EmptyStateView(
                        icon: "note.text",
                        title: "No Notes Yet",
                        subtitle: "Add notes when you check in to reflect on your habits"
                    )
                } else {
                    List {
                        ForEach(notesRecords, id: \.id) { record in
                            NoteRowView(record: record)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        record.notes = ""
                                        try? modelContext.save()
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

/// Row displaying a single note from a check-in
struct NoteRowView: View {
    let record: HabitRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(record.completedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if record.count > 1 {
                    Text("×\(record.count)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            Text(record.notes)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(3)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let habit = Habit(name: "Exercise", iconName: "dumbbell.fill")
    let record = HabitRecord(
        habit: habit,
        completedAt: Date(),
        count: 1,
        notes: "Great workout today! Felt energized."
    )
    habit.records.append(record)
    
    HabitNotesView(habit: habit)
}

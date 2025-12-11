import SwiftUI
import SwiftData

/// View for creating a new habit with customization options
struct AddHabitView: View {
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var modelContext
    
    // Form state
    @State private var habitName: String = ""
    @State private var selectedIcon: String = "star.fill"
    @State private var selectedColor: String = "#FF6B6B"
    @State private var frequencyType: FrequencyType = .daily
    @State private var isCounter: Bool = false
    @State private var dailyTarget: Int = 1
    @State private var selectedDays: Set<Int> = [1, 2, 3, 4, 5] // Mon-Fri
    @State private var monthlyTarget: Int = 1
    
    // UI state
    @State private var showIconPicker = false
    @State private var showColorPicker = false
    
    var body: some View {
        NavigationStack {
            Form {
                // Habit name
                Section("Habit Name") {
                    TextField("e.g., Drink 8 cups of water", text: $habitName)
                        .onChange(of: habitName) { oldValue, newValue in
                            // Auto-suggest when user changes habit name
                            if !newValue.isEmpty && oldValue.isEmpty {
                                selectedIcon = HabitSuggester.suggestIcon(for: newValue)
                                selectedColor = HabitSuggester.suggestColor(for: newValue)
                            }
                        }
                }
                
                // Icon selection
                Section("Icon") {
                    Button(action: { showIconPicker = true }) {
                        HStack {
                            Image(systemName: selectedIcon)
                                .font(.title2)
                                .foregroundColor(Color(hex: selectedColor))
                            Spacer()
                            Text("Change Icon")
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // Color selection
                Section("Color") {
                    Button(action: { showColorPicker = true }) {
                        HStack {
                            Circle()
                                .fill(Color(hex: selectedColor))
                                .frame(width: 32, height: 32)
                            Text(selectedColor)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // Frequency type
                Section("Frequency") {
                    Picker("Type", selection: $frequencyType) {
                        ForEach(FrequencyType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    
                    // Frequency-specific options
                    frequencyOptionsSection
                }
                
                // Counter option
                Section("Tracking Type") {
                    Toggle("Track with counter", isOn: $isCounter)
                    
                    if isCounter {
                        Stepper(
                            "Daily Target: \(dailyTarget)",
                            value: $dailyTarget,
                            in: 1...100
                        )
                    }
                }
                
                // Preview
                Section("Preview") {
                    HStack {
                        Image(systemName: selectedIcon)
                            .font(.title)
                            .foregroundColor(Color(hex: selectedColor))
                            .frame(width: 44, height: 44)
                            .background(Color(hex: selectedColor).opacity(0.1))
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(habitName.isEmpty ? "Habit Name" : habitName)
                                .font(.headline)
                            Text(frequencyDescription)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Add Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createHabit()
                    }
                    .disabled(habitName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .sheet(isPresented: $showIconPicker) {
            IconPickerView(selectedIcon: $selectedIcon)
        }
        .sheet(isPresented: $showColorPicker) {
            ColorPickerView(selectedColor: $selectedColor)
        }
    }
    
    /// Frequency-specific configuration section
    @ViewBuilder
    private var frequencyOptionsSection: some View {
        switch frequencyType {
        case .daily:
            EmptyView()
        case .weekly:
            VStack(alignment: .leading, spacing: 8) {
                Text("Select Days")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack(spacing: 8) {
                    let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                    ForEach(0..<7, id: \.self) { day in
                        Button(action: {
                            if selectedDays.contains(day) {
                                selectedDays.remove(day)
                            } else {
                                selectedDays.insert(day)
                            }
                        }) {
                            Text(dayNames[day])
                                .font(.caption)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(selectedDays.contains(day) ? Color(hex: selectedColor) : Color.gray.opacity(0.2))
                                .foregroundColor(selectedDays.contains(day) ? .white : .primary)
                                .cornerRadius(6)
                        }
                    }
                }
            }
        case .monthly:
            Stepper(
                "Completions per month: \(monthlyTarget)",
                value: $monthlyTarget,
                in: 1...31
            )
        }
    }
    
    /// Generate frequency description string
    private var frequencyDescription: String {
        switch frequencyType {
        case .daily:
            return "Daily"
        case .weekly:
            let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            let days = selectedDays.sorted().map { dayNames[$0] }.joined(separator: ", ")
            return "Weekly: \(days)"
        case .monthly:
            return "\(monthlyTarget) times per month"
        }
    }
    
    /// Create habit and add to data store
    private func createHabit() {
        let frequency = HabitFrequency(
            type: frequencyType,
            selectedDays: Array(selectedDays).sorted(),
            targetCount: monthlyTarget
        )
        
        let habit = Habit(
            name: habitName.trimmingCharacters(in: .whitespaces),
            iconName: selectedIcon,
            colorHex: selectedColor,
            frequency: frequency,
            isCounter: isCounter,
            dailyTarget: dailyTarget
        )
        
        modelContext.insert(habit)
        try? modelContext.save()
        
        isPresented = false
    }
}

/// Icon picker view
struct IconPickerView: View {
    @Binding var selectedIcon: String
    @Environment(\.dismiss) var dismiss
    
    let columns = [GridItem(.adaptive(minimum: 60))]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(HabitSuggester.getIconOptions(), id: \.self) { icon in
                        Button(action: {
                            selectedIcon = icon
                            dismiss()
                        }) {
                            Image(systemName: icon)
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(selectedIcon == icon ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedIcon == icon ? Color.blue : Color.clear, lineWidth: 2)
                                )
                        }
                        .foregroundColor(.primary)
                    }
                }
                .padding()
            }
            .navigationTitle("Select Icon")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

/// Color picker view
struct ColorPickerView: View {
    @Binding var selectedColor: String
    @Environment(\.dismiss) var dismiss
    
    let columns = [GridItem(.adaptive(minimum: 60))]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(HabitSuggester.getColorOptions(), id: \.hex) { colorOption in
                        Button(action: {
                            selectedColor = colorOption.hex
                            dismiss()
                        }) {
                            Circle()
                                .fill(Color(hex: colorOption.hex))
                                .overlay(
                                    Circle()
                                        .stroke(
                                            selectedColor == colorOption.hex ? Color.black : Color.clear,
                                            lineWidth: 3
                                        )
                                )
                                .frame(height: 60)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select Color")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddHabitView(isPresented: .constant(true))
        .modelContainer(for: Habit.self, inMemory: true)
}

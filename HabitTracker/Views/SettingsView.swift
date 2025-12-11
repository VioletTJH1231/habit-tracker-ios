import SwiftUI
import SwiftData

/// Settings view for app preferences and data management
struct SettingsView: View {
    @Query private var habits: [Habit]
    @State private var showExportOptions = false
    @State private var exportedData: String = ""
    @State private var showShareSheet = false
    @State private var exportFormat: String = "json"
    
    var body: some View {
        NavigationStack {
            List {
                Section("About") {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Total Habits")
                        Spacer()
                        Text("\(habits.count)")
                            .foregroundColor(.gray)
                    }
                }
                
                Section("Data") {
                    Button(action: {
                        showExportOptions = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.up.doc.fill")
                            Text("Export Data")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .foregroundColor(.primary)
                    
                    Button(action: {
                        exportData(format: "csv")
                    }) {
                        HStack {
                            Image(systemName: "arrow.up.circle.fill")
                            Text("Export as CSV")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .foregroundColor(.primary)
                    
                    Button(action: {
                        exportData(format: "json")
                    }) {
                        HStack {
                            Image(systemName: "arrow.up.circle.fill")
                            Text("Export as JSON")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .foregroundColor(.primary)
                }
                
                Section("Privacy & Security") {
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.green)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Local Storage")
                            Text("All data is stored locally")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "hand.raised.fill")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("No Analytics")
                            Text("No tracking or telemetry")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "network.slash")
                            .foregroundColor(.orange)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Offline First")
                            Text("Works without internet")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("设置")
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [exportedData])
        }
    }
    
    private func exportData(format: String) {
        if format == "csv" {
            exportedData = DataExportService.exportToCSV(habits: habits)
        } else {
            exportedData = DataExportService.exportToJSON(habits: habits)
        }
        showShareSheet = true
    }
}

/// Wrapper for iOS share sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    SettingsView()
        .modelContainer(for: Habit.self, inMemory: true)
}


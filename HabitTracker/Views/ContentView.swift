import SwiftUI
import SwiftData

/// Main content view with tab navigation
struct ContentView: View {
    @State private var appViewModel = AppViewModel()
    @State private var hasCompletedOnboarding = true // Set to false for first launch
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]
    
    var body: some View {
        if !hasCompletedOnboarding {
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        } else {
            TabView(selection: $appViewModel.selectedTab) {
                // 打卡 (Check-in) Tab
                CheckInView()
                    .tabItem {
                        Label("打卡", systemImage: "checkmark.circle.fill")
                    }
                    .tag(TabItem.checkIn)
                
                // 数据 (Data/Analytics) Tab
                DataView()
                    .tabItem {
                        Label("数据", systemImage: "chart.bar.fill")
                    }
                    .tag(TabItem.data)
                
                // 设置 (Settings) Tab
                SettingsView()
                    .tabItem {
                        Label("设置", systemImage: "gear")
                    }
                    .tag(TabItem.settings)
            }
            .sheet(isPresented: $appViewModel.showAddHabitSheet) {
                AddHabitView(isPresented: $appViewModel.showAddHabitSheet)
            }
            .environment(appViewModel)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}

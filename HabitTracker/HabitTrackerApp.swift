import SwiftUI
import SwiftData

/// App entry point - now using AppDelegate + SceneDelegate for proper iOS app lifecycle
/// This allows the app to work with both UIKit and SwiftUI
struct HabitTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

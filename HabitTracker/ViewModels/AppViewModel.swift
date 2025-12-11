import Foundation
import Observation
import SwiftUI

/// Tab selection enum for main navigation
enum TabItem: String {
    case checkIn = "打卡"
    case data = "数据"
    case settings = "设置"
    
    var icon: String {
        switch self {
        case .checkIn:
            return "checkmark.circle"
        case .data:
            return "chart.bar"
        case .settings:
            return "gear"
        }
    }
}

/// ViewModel for managing app-level navigation and state
@Observable
class AppViewModel {
    var selectedTab: TabItem = .checkIn
    var showAddHabitSheet = false
    
    init() {
        // Initialize any app-wide state
    }
}

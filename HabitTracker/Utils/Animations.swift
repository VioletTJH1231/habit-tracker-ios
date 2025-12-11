import SwiftUI

/// Animation constants and utilities
struct AppAnimations {
    static let spring = Animation.spring(response: 0.6, dampingFraction: 0.7)
    static let easeInOut = Animation.easeInOut(duration: 0.3)
    static let smooth = Animation.easeInOut(duration: 0.2)
    
    /// Perform haptic feedback for interactions
    static func playHaptic(_ type: HapticType) {
        switch type {
        case .light:
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        case .medium:
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        case .heavy:
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
        case .success:
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
        case .warning:
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.warning)
        case .error:
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.error)
        }
    }
    
    enum HapticType {
        case light
        case medium
        case heavy
        case success
        case warning
        case error
    }
}

/// View extension for common animations
extension View {
    /// Add completion animation when action succeeds
    func withCompletionAnimation() -> some View {
        modifier(CompletionAnimationModifier())
    }
}

/// Completion animation modifier
struct CompletionAnimationModifier: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isAnimating)
    }
}

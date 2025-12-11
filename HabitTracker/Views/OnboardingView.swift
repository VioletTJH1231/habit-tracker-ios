import SwiftUI

/// Onboarding screen for new users
struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.1)
                ]),
                startPoint: .topLeadingPoint,
                endPoint: .bottomTrailingPoint
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // App icon / title
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Habit Tracker")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Build better habits, one day at a time")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 20) {
                    OnboardingFeature(
                        icon: "plus.circle.fill",
                        title: "Create Habits",
                        description: "Start by creating your first habit with custom icon and color"
                    )
                    
                    OnboardingFeature(
                        icon: "checkmark.circle.fill",
                        title: "Daily Check-ins",
                        description: "Check off habits daily and track your progress"
                    )
                    
                    OnboardingFeature(
                        icon: "chart.bar.fill",
                        title: "Track Progress",
                        description: "View streaks, completion rates, and yearly heatmaps"
                    )
                    
                    OnboardingFeature(
                        icon: "note.text",
                        title: "Add Notes",
                        description: "Reflect on each check-in with personal notes"
                    )
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    hasCompletedOnboarding = true
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
    }
}

/// Feature item in onboarding
struct OnboardingFeature: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}

import Foundation
import SwiftUI

/// Utility class for intelligent icon and color suggestions based on habit description
struct HabitSuggester {
    /// Keywords mapped to SF Symbol icons
    private static let iconKeywords: [String: [String]] = [
        // Health & Fitness
        "exercise": ["dumbbell.fill", "figure.walk", "figure.indoor.cycle", "heart.fill"],
        "running": ["figure.outdoor.cycle", "figure.walk", "shoe.fill"],
        "yoga": ["figure.yoga", "heart.fill", "leaf.fill"],
        "swim": ["water.waves", "figure.swimming"],
        "walk": ["figure.walk", "footprints.fill"],
        "gym": ["dumbbell.fill", "figure.strengthtraining"],
        "fitness": ["dumbbell.fill", "figure.strengthtraining"],
        "sport": ["sportscourt.fill", "basketball.fill"],
        
        // Eating & Drinking
        "water": ["waterbottle.fill", "drop.fill"],
        "drink": ["cup.and.saucer.fill", "waterbottle.fill"],
        "eat": ["fork.knife", "salad.2"],
        "food": ["fork.knife", "cup.and.saucer.fill"],
        "meal": ["fork.knife", "cup.and.saucer.fill"],
        "breakfast": ["fork.knife", "sun.min.fill"],
        "lunch": ["fork.knife", "sun.max.fill"],
        "dinner": ["fork.knife", "moon.fill"],
        "fruit": ["apple.fill", "strawberry.fill"],
        "vegetable": ["carrot.fill", "broccoli.fill"],
        "protein": ["leaf.fill"],
        
        // Sleep & Rest
        "sleep": ["bed.double.fill", "moon.fill", "moon.zzz.fill"],
        "rest": ["bed.double.fill", "moon.fill"],
        "bed": ["bed.double.fill"],
        "meditation": ["lotus.fill", "heart.fill"],
        "relax": ["leaf.fill", "sparkles"],
        
        // Work & Learning
        "study": ["book.fill", "pencil"],
        "read": ["book.fill", "text.book.closed.fill"],
        "writing": ["pencil", "doc.text.fill"],
        "coding": ["chevron.left.forwardslash.chevron.right", "terminal.fill"],
        "language": ["character.book.closed.fill", "globe"],
        "learn": ["book.fill", "lightbulb.fill"],
        "work": ["briefcase.fill", "laptopcomputer"],
        "focus": ["target", "ellipsis.circle.fill"],
        
        // Personal Development
        "meditation": ["lotus.fill", "sparkles"],
        "journaling": ["note.text", "book.fill"],
        "gratitude": ["heart.fill", "star.fill"],
        "mindfulness": ["lotus.fill", "sparkles"],
        "breathing": ["wind"],
        
        // Social
        "call": ["phone.fill", "person.fill"],
        "visit": ["person.2.fill", "mappin.and.ellipse"],
        "family": ["person.3.fill", "house.fill"],
        "friend": ["person.2.fill", "heart.fill"],
        
        // Cleaning & Organization
        "clean": ["sparkles", "broom.fill"],
        "organize": ["square.grid.2x2.fill", "tray.2.fill"],
        "laundry": ["washer.fill"],
        
        // Money & Finance
        "save": ["banknote.fill", "dollarsign.circle.fill"],
        "budget": ["chart.pie.fill", "banknote.fill"],
        "invest": ["chart.line.uptrend.xyaxis"],
        
        // Hobby & Fun
        "music": ["music.note.list", "guitar.fill"],
        "play": ["gamecontroller.fill", "play.fill"],
        "art": ["paintbrush.fill"],
        "craft": ["hammer.fill"],
        "draw": ["paintbrush.fill", "pencil.and.outline"],
        "game": ["gamecontroller.fill"],
        
        // Personal Care
        "shower": ["drop.fill", "water.waves"],
        "bath": ["drop.fill"],
        "skin": ["sparkles", "heart.fill"],
        "hair": ["sparkles"],
        "nails": ["hand.raised.fill"],
    ]
    
    /// Color palette for habits
    private static let colors: [String: (name: String, hex: String)] = [
        "red": ("Red", "#FF6B6B"),
        "orange": ("Orange", "#FFA500"),
        "yellow": ("Yellow", "#FFD93D"),
        "green": ("Green", "#6BCB77"),
        "blue": ("Blue", "#4D96FF"),
        "purple": ("Purple", "#A78BFA"),
        "pink": ("Pink", "#FF69B4"),
        "teal": ("Teal", "#20B2AA"),
        "indigo": ("Indigo", "#6366F1"),
        "cyan": ("Cyan", "#00BCD4"),
    ]
    
    /// Suggest an icon based on habit name
    /// - Parameter habitName: The name of the habit
    /// - Returns: An SF Symbol icon name
    static func suggestIcon(for habitName: String) -> String {
        let lowercased = habitName.lowercased()
        
        // First, try direct keyword matching
        for (keyword, icons) in iconKeywords {
            if lowercased.contains(keyword) {
                return icons.randomElement() ?? "star.fill"
            }
        }
        
        // Default icons if no match found
        return ["star.fill", "circle.fill", "heart.fill", "square.fill"].randomElement() ?? "star.fill"
    }
    
    /// Suggest a color based on habit name
    /// - Parameter habitName: The name of the habit
    /// - Returns: A hex color string
    static func suggestColor(for habitName: String) -> String {
        let lowercased = habitName.lowercased()
        
        // Map keywords to colors
        let keywordColorMap: [String: String] = [
            // Health/Fitness -> Red/Pink
            "exercise": "red", "running": "red", "yoga": "purple",
            "swim": "blue", "walk": "green", "gym": "red",
            "fitness": "red", "sport": "orange",
            
            // Food/Water -> Green/Yellow
            "water": "cyan", "drink": "blue", "eat": "green",
            "food": "green", "meal": "yellow", "breakfast": "yellow",
            "lunch": "yellow", "dinner": "orange", "fruit": "red",
            "vegetable": "green", "protein": "orange",
            
            // Sleep -> Blue/Purple
            "sleep": "blue", "rest": "blue", "bed": "purple",
            "meditation": "purple", "relax": "teal",
            
            // Work/Study -> Blue/Indigo
            "study": "indigo", "read": "indigo", "writing": "purple",
            "coding": "blue", "language": "blue", "learn": "indigo",
            "work": "blue", "focus": "indigo",
            
            // Social -> Pink
            "call": "pink", "visit": "pink", "family": "pink",
            "friend": "pink",
            
            // Clean -> Teal/Cyan
            "clean": "cyan", "organize": "cyan", "laundry": "cyan",
            
            // Money -> Green
            "save": "green", "budget": "green", "invest": "green",
            
            // Hobbies -> Various
            "music": "purple", "play": "orange", "art": "pink",
            "craft": "orange", "draw": "pink", "game": "orange",
            
            // Personal Care -> Pink
            "shower": "cyan", "bath": "cyan", "skin": "pink",
            "hair": "pink", "nails": "pink",
        ]
        
        for (keyword, colorKey) in keywordColorMap {
            if lowercased.contains(keyword) {
                return colors[colorKey]?.hex ?? "#FF6B6B"
            }
        }
        
        // Return a random color as default
        return colors.values.randomElement()?.hex ?? "#FF6B6B"
    }
    
    /// Get all available color options
    /// - Returns: Array of (name, hex) tuples
    static func getColorOptions() -> [(name: String, hex: String)] {
        return colors.values.sorted { $0.name < $1.name }
    }
    
    /// Get all available icon options
    /// - Returns: Array of SF Symbol icon names (curated list)
    static func getIconOptions() -> [String] {
        return [
            // Activities
            "star.fill", "heart.fill", "bolt.fill", "flame.fill",
            
            // Health
            "dumbbell.fill", "figure.walk", "heart.pulse", "drop.fill",
            "waterbottle.fill", "apple.fill", "leaf.fill",
            
            // Wellness
            "moon.zzz.fill", "lotus.fill", "sparkles", "wind",
            
            // Work & Learning
            "book.fill", "pencil", "lightbulb.fill", "brain.head.profile",
            "target", "briefcase.fill",
            
            // Recreation
            "music.note", "paintbrush.fill", "gamecontroller.fill",
            "person.2.fill",
            
            // Utility
            "checkmark.circle.fill", "timer.circle.fill", "calendar",
            "chart.line.uptrend.xyaxis", "building.2.fill",
        ]
    }
}

import Foundation

/// Service for exporting habit data in various formats
struct DataExportService {
    /// Export habits and records to CSV format
    /// - Parameter habits: Array of habits to export
    /// - Returns: CSV formatted string
    static func exportToCSV(habits: [Habit]) -> String {
        var csv = "Habit,Icon,Color,Frequency,Total Check-ins,Current Streak,Longest Streak,Completion Rate (%),Created Date\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        for habit in habits {
            let completionRate = String(format: "%.1f", habit.getCompletionRate())
            let row = [
                escapeCSV(habit.name),
                habit.iconName,
                habit.colorHex,
                habit.frequency.displayConfiguration,
                String(habit.getTotalCheckIns()),
                String(habit.getCurrentStreak()),
                String(habit.getLongestStreak()),
                completionRate,
                dateFormatter.string(from: habit.createdAt)
            ].joined(separator: ",")
            
            csv += row + "\n"
        }
        
        // Add detailed check-in records
        csv += "\n\nDetailed Check-in History\n"
        csv += "Habit,Date,Count,Notes\n"
        
        for habit in habits {
            for record in habit.records.sorted(by: { $0.completedAt > $1.completedAt }) {
                let row = [
                    escapeCSV(habit.name),
                    dateFormatter.string(from: record.completedAt),
                    String(record.count),
                    escapeCSV(record.notes)
                ].joined(separator: ",")
                
                csv += row + "\n"
            }
        }
        
        return csv
    }
    
    /// Export habits and records to JSON format
    /// - Parameter habits: Array of habits to export
    /// - Returns: JSON formatted string
    static func exportToJSON(habits: [Habit]) -> String {
        let dateFormatter = ISO8601DateFormatter()
        
        let habitDicts = habits.map { habit in
            [
                "id": habit.id,
                "name": habit.name,
                "icon": habit.iconName,
                "color": habit.colorHex,
                "frequency": [
                    "type": habit.frequency.type.rawValue,
                    "selectedDays": habit.frequency.selectedDays,
                    "targetCount": habit.frequency.targetCount
                ] as [String: Any],
                "isCounter": habit.isCounter,
                "dailyTarget": habit.dailyTarget,
                "createdAt": dateFormatter.string(from: habit.createdAt),
                "updatedAt": dateFormatter.string(from: habit.updatedAt),
                "statistics": [
                    "totalCheckIns": habit.getTotalCheckIns(),
                    "currentStreak": habit.getCurrentStreak(),
                    "longestStreak": habit.getLongestStreak(),
                    "completionRate": String(format: "%.2f", habit.getCompletionRate())
                ],
                "records": habit.records.map { record in
                    [
                        "id": record.id,
                        "date": dateFormatter.string(from: record.completedAt),
                        "count": record.count,
                        "notes": record.notes
                    ]
                }
            ] as [String: Any]
        }
        
        if let data = try? JSONSerialization.data(withJSONObject: habitDicts, options: .prettyPrinted),
           let json = String(data: data, encoding: .utf8) {
            return json
        }
        
        return "{}"
    }
    
    /// Escape special characters in CSV fields
    private static func escapeCSV(_ field: String) -> String {
        if field.contains(",") || field.contains("\"") || field.contains("\n") {
            return "\"\(field.replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return field
    }
    
    /// Import habits from JSON data
    /// - Parameter jsonString: JSON formatted habit data
    /// - Returns: Array of imported habits, or empty array if parsing fails
    static func importFromJSON(_ jsonString: String) -> [Habit] {
        guard let data = jsonString.data(using: .utf8),
              let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            return []
        }
        
        let dateFormatter = ISO8601DateFormatter()
        var habits: [Habit] = []
        
        for habitDict in jsonArray {
            guard let name = habitDict["name"] as? String,
                  let icon = habitDict["icon"] as? String,
                  let color = habitDict["color"] as? String,
                  let frequencyDict = habitDict["frequency"] as? [String: Any],
                  let frequencyTypeStr = frequencyDict["type"] as? String,
                  let frequencyType = FrequencyType(rawValue: frequencyTypeStr) else {
                continue
            }
            
            let selectedDays = (frequencyDict["selectedDays"] as? [Int]) ?? []
            let targetCount = (frequencyDict["targetCount"] as? Int) ?? 1
            
            let frequency = HabitFrequency(
                type: frequencyType,
                selectedDays: selectedDays,
                targetCount: targetCount
            )
            
            let isCounter = habitDict["isCounter"] as? Bool ?? false
            let dailyTarget = habitDict["dailyTarget"] as? Int ?? 1
            
            let habit = Habit(
                name: name,
                iconName: icon,
                colorHex: color,
                frequency: frequency,
                isCounter: isCounter,
                dailyTarget: dailyTarget
            )
            
            // Import records if available
            if let recordsArray = habitDict["records"] as? [[String: Any]] {
                for recordDict in recordsArray {
                    if let dateStr = recordDict["date"] as? String,
                       let date = dateFormatter.date(from: dateStr) {
                        let count = recordDict["count"] as? Int ?? 1
                        let notes = recordDict["notes"] as? String ?? ""
                        
                        let record = HabitRecord(
                            habit: habit,
                            completedAt: date,
                            count: count,
                            notes: notes
                        )
                        habit.records.append(record)
                    }
                }
            }
            
            habits.append(habit)
        }
        
        return habits
    }
}

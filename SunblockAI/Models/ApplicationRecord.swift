// ApplicationRecord.swift
import Foundation

struct ApplicationRecord: Identifiable, Codable {
    var id: UUID
    var date: Date
    var spfLevel: SPFLevel
    var uvIndex: Double
    var temperature: Double
    var notes: String?
    
    init(id: UUID = UUID(), date: Date = Date(), spfLevel: SPFLevel, uvIndex: Double, temperature: Double, notes: String? = nil) {
        self.id = id
        self.date = date
        self.spfLevel = spfLevel
        self.uvIndex = uvIndex
        self.temperature = temperature
        self.notes = notes
    }
}

enum SPFLevel: Int, Codable, CaseIterable, Identifiable {
    case spf15 = 15
    case spf30 = 30
    case spf50 = 50
    
    var id: Int { self.rawValue }
    
    var displayName: String {
        "FPS \(self.rawValue)+"
    }
}

extension ApplicationRecord {
    static var sampleRecords: [ApplicationRecord] {
        let calendar = Calendar.current
        
        return [
            ApplicationRecord(
                date: calendar.date(byAdding: .day, value: 0, to: Date()) ?? Date(),
                spfLevel: .spf30,
                uvIndex: 5.0,
                temperature: 28.0
            ),
            ApplicationRecord(
                date: calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                spfLevel: .spf50,
                uvIndex: 8.0,
                temperature: 30.0
            ),
            ApplicationRecord(
                date: calendar.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                spfLevel: .spf15,
                uvIndex: 3.0,
                temperature: 25.0
            )
        ]
    }
}

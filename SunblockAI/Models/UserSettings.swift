// UserSettings.swift
import Foundation

enum SkinType: String, Codable, CaseIterable, Identifiable {
    case type1 = "I"
    case type2 = "II"
    case type3 = "III"
    case type4 = "IV"
    case type5 = "V"
    case type6 = "VI"
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .type1: return "Muy clara, siempre se quema, nunca se broncea"
        case .type2: return "Clara, casi siempre se quema, bronceado mínimo"
        case .type3: return "Media, a veces se quema, bronceado gradual"
        case .type4: return "Morena clara, raramente se quema, siempre se broncea"
        case .type5: return "Morena, raramente se quema, bronceado intenso"
        case .type6: return "Negra, nunca se quema, bronceado profundo"
        }
    }
    
    var recommendedSPF: (normal: Int, high: Int) {
        switch self {
        case .type1: return (50, 50)
        case .type2: return (50, 50)
        case .type3: return (30, 50)
        case .type4: return (30, 50)
        case .type5: return (15, 30)
        case .type6: return (15, 30)
        }
    }
}

enum DailyEnvironment: String, Codable, CaseIterable, Identifiable {
    case indoor = "En oficina o lugar cerrado"
    case outdoor = "En exteriores"
    case home = "En casa"
    
    var id: String { self.rawValue }
}

struct UserSettings: Codable {
    var skinType: SkinType
    var dailyEnvironment: DailyEnvironment
    var commuteTime: Date
    var userName: String?
    var isVacationMode: Bool
    var isHealthKitEnabled: Bool
    var notificationsEnabled: Bool
    
    static let `default` = UserSettings(
        skinType: .type3,
        dailyEnvironment: .indoor,
        commuteTime: Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date(),
        userName: nil,
        isVacationMode: false,
        isHealthKitEnabled: false,
        notificationsEnabled: true
    )
}

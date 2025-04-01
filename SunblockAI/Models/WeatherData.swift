// WeatherData.swift
import Foundation

struct WeatherData: Codable {
    var uvIndex: Double
    var temperature: Double
    var weatherCondition: WeatherCondition
    
    var uvCategory: UVCategory {
        switch uvIndex {
        case 0..<3: return .low
        case 3..<6: return .moderate
        case 6..<8: return .high
        case 8..<11: return .veryHigh
        default: return .extreme
        }
    }
}

enum WeatherCondition: String, Codable {
    case sunny
    case partlyCloudy
    case cloudy
    case rainy
    case stormy
    
    var description: String {
        switch self {
        case .sunny: return "Soleado"
        case .partlyCloudy: return "Parcialmente nublado"
        case .cloudy: return "Nublado"
        case .rainy: return "Lluvioso"
        case .stormy: return "Tormentoso"
        }
    }
}

enum UVCategory: String, Codable {
    case low = "BAJO"
    case moderate = "MODERADO"
    case high = "ALTO"
    case veryHigh = "MUY ALTO"
    case extreme = "EXTREMO"
    
    var color: String {
        switch self {
        case .low: return "uvLow"
        case .moderate: return "uvModerate"
        case .high: return "uvHigh"
        case .veryHigh: return "uvVeryHigh"
        case .extreme: return "uvExtreme"
        }
    }
}

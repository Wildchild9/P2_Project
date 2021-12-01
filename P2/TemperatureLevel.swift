//
//  TemperatureLevel.swift
//  P2
//
//  Created by Noah Wilder on 2021-12-01.
//

import Foundation

struct TemperatureLevel {
    
    var temperature: Int {
        didSet {
            if oldValue != temperature {
                hazardLevel = HazardLevel(for: temperature)
            }
        }
    }
    
    private(set) var hazardLevel: HazardLevel
    
    init(temperature: Int) {
        self.temperature = temperature
        self.hazardLevel = HazardLevel(for: temperature)
    }
    
    var requiresNotification: Bool {
        return hazardLevel != .good
    }
    
    var notificationContent: (title: String, message: String) {
        let title, message: String
        switch hazardLevel {
        case .good:
            title = "Temperature levels are good."
            message = ""
        case .moderate:
            title = "Temperature levels are moderate."
            var percent = (temperature + 1 - 25) * 2
            percent = min(100, max(0, percent))
            message = "Prolonged exposure can lead to a \(percent)% decrease in cognitive function."
        case .poor:
            title = "Temperature levels are poor."
            var percent = (temperature + 1 - 25) * 2
            percent = min(100, max(0, percent))
            message = "Prolonged exposure can lead to a \(percent)% decrease in cognitive function and may cause dehydration."
        }
        return (title: title, message: message)
    }
    
    var caption: String {
        let (title, message) = notificationContent
        return "\(title) \(message)"
    }
    
    enum HazardLevel {
        case good
        case moderate
        case poor
        
        init(for temperature: Int) {
            switch temperature {
            case ..<25: self = .good
            case ..<35: self = .moderate
            default:    self = .poor
            }
        }
        
        var name: String {
            switch self {
            case .good: return "Good"
            case .moderate: return "Moderate"
            case .poor: return "Poor"
            }
        }
        
        
    }
    
    var symbolName: String {
        return "thermometer"
    }
}

//enum CO2HazardLevel {
//    case good
//    case moderate
//    case poor
//    case unhealthy
//    case hazardous
//
//    init(for concentration: Int) {
//        switch concentration {
//        case ..<1000: self = .good
//        case ..<1400: self = .moderate
//        case ..<2000: self = .poor
//        case ..<5000: self = .unhealthy
//        default:      self = .hazardous
//        }
//
//    }
//
//    var requiresNotification: Bool {
//        return self != .good
//    }
//
//    var notificationContent: (title: String, message: String) {
//        let title, message: String
//        switch self {
//        case .good:
//            title = "CO₂ levels are healthy."
//            message = ""
//        case .moderate:
//            title = "CO₂ levels are moderate."
//            message = "Prolonged exposure can lead to a 15% decrease in cognitive function."
//        case .poor:
//            title = "CO₂ levels are poor."
//            message = "Prolonged exposure can lead to a 50% decrease in cognitive function and may cause drowsiness."
//        case .unhealthy:
//            title = "CO₂ levels are unhealthy."
//            message = "Exposure can lead to a significant decrease in cognitive function and may induce headaches, sleepiness, increase heart rate, and slight nausea."
//        case .hazardous:
//            title = "CO₂ levels are hazardous."
//            message = "Prolonged exposure may lead to toxicity or oxygen deprivation."
//        }
//        return (title: title, message: message)
//    }
//
//    var caption: String {
//        let (title, message) = notificationContent
//        return "\(title) \(message)"
//    }
//    }

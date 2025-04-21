//
//  UnitSystem.swift
//  WeatherAppOpenWeatherMap
//
//  Created by Александр Печинкин on 21.04.2025.
//


enum UnitSystem: String, CaseIterable {
    case metric
    case imperial
    
    var title: String {
        switch self {
            case .metric:   return "Метрическая"
            case .imperial: return "Империальная"
        }
    }

    var symbol: String {
        switch self {
            case .metric:   return "ºC"
            case .imperial: return "ºF"
        }
    }
}

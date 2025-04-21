//
//  WeatherViewModel.swift
//  WeatherAppOpenWeatherMap
//
//  Created by Александр Печинкин on 21.04.2025.
//


import Foundation
import SwiftUI
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var errorMessage: String?
    @AppStorage("selectedUnitStorage") var selectedUnit: UnitSystem = .metric

    private let weatherService = WeatherService()
    private let cache = CacheManager()
    
    @Published var isLoading: Bool = false

    init() {
        loadCachedWeather()
    }

    func loadCachedWeather() {
        self.weather = cache.load()
    }

    func fetchWeather(lat: Double, lon: Double) {
        isLoading = true
        weatherService.fetchWeather(lat: lat, lon: lon, unit: selectedUnit) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.weather = data
                    self?.cache.save(data)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
                
                self?.isLoading = false
            }
        }
    }

    func fetchWeather(for city: String) {
        isLoading = true
        weatherService.fetchWeather(for: city, unit: selectedUnit) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.weather = data
                    self?.cache.save(data)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
                
                self?.isLoading = false
            }
        }
    }
    
    func updateWeather() {
        if let weather = weather {
            fetchWeather(lat: weather.coord.lat, lon: weather.coord.lon)
        }
    }
}

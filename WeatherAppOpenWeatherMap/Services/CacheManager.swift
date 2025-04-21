//
//  CacheManager.swift
//  WeatherAppOpenWeatherMap
//
//  Created by Александр Печинкин on 21.04.2025.
//


import Foundation

class CacheManager {
    private let fileName = "cached_weather.json"

    func save(_ response: WeatherResponse) {
        if let data = try? JSONEncoder().encode(response) {
            let url = getFileURL()
            try? data.write(to: url)
        }
    }

    func load() -> WeatherResponse? {
        let url = getFileURL()
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(WeatherResponse.self, from: data)
    }

    private func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }
}

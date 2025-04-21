//
//  WeatherService.swift
//  WeatherAppOpenWeatherMap
//
//  Created by Александр Печинкин on 21.04.2025.
//


import Foundation
import CoreLocation

class WeatherService {
    private let apiKey = "6bc09e9cbca3b7a04c57d5d9c5d18de8"
    
    func fetchWeather(lat: Double, lon: Double, unit: UnitSystem, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let unitParam = unit.rawValue
        guard let url = URL(string:
            "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=\(unitParam)&appid=\(apiKey)&lang=ru")
        else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    completion(.success(weather))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchWeather(for city: String, unit: UnitSystem, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let unitParam = unit.rawValue
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=\(unitParam)&appid=\(apiKey)&lang=ru".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            print("----")
            print(String(data: data!, encoding: .utf8)!)
            print("----")
            
            if let data = data {
                do {
                    let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    completion(.success(weather))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

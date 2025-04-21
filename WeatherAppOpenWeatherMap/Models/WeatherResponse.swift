//
//  WeatherResponse.swift
//  WeatherAppOpenWeatherMap
//
//  Created by Александр Печинкин on 21.04.2025.
//


import Foundation

struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let name: String

    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }

    struct Weather: Codable {
        let main: String
        let description: String
        let icon: String
    }

    struct Main: Codable {
        let temp: Double
    }
}

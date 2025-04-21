//
//  WeatherAppTests.swift
//  WeatherAppOpenWeatherMapTests
//
//  Created by Александр Печинкин on 21.04.2025.
//

import XCTest
@testable import WeatherAppOpenWeatherMap

final class WeatherAppTests: XCTestCase {

    var weatherService: WeatherService!
    var viewModel: WeatherViewModel!

    override func setUp() {
        super.setUp()
        weatherService = WeatherService()
        viewModel = WeatherViewModel()
    }

    override func tearDown() {
        weatherService = nil
        viewModel = nil
        super.tearDown()
    }
    

    func testUnitToggle() {
        let original = viewModel.selectedUnit
        viewModel.selectedUnit = .imperial
        XCTAssertNotEqual(viewModel.selectedUnit, original)
    }

    func testCacheSavingAndLoading() {
        viewModel.fetchWeather(lat: 30, lon: 50)
        viewModel.loadCachedWeather()

        XCTAssertEqual(viewModel.weather?.coord.lat, 30)
    }
}


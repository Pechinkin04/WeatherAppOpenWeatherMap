//
//  LocationManager.swift
//  WeatherAppOpenWeatherMap
//
//  Created by Александр Печинкин on 21.04.2025.
//


import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var permissionDenied = false
    @Published var showAlertSettingsLocation = false

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        if CLLocationManager.locationServicesEnabled() {
            manager.requestWhenInUseAuthorization()
            manager.requestLocation()
        } else {
            permissionDenied = true
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error:", error.localizedDescription)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            permissionDenied = true
        }
    }
}

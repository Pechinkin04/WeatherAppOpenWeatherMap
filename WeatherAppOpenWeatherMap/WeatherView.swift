//
//  WeatherView.swift
//  WeatherAppOpenWeatherMap
//
//  Created by Александр Печинкин on 21.04.2025.
//


import SwiftUI
import MapKit

struct WeatherView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = WeatherViewModel()
    @State private var city: String = ""
    
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var showNetworkAlert = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.8),
                                            .yellow.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // Основная карточка погоды
                if let weather = viewModel.weather {
                    WeatherCard(weather: weather, unit: viewModel.selectedUnit)
                }

                // Ввод города
                TextField("Введите город", text: $city)
                    .foregroundStyle(.foreground)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Показать погоду по городу") {
                    viewModel.fetchWeather(for: city)
                }
                .buttonStyle(.borderedProminent)

                Button("Показать погоду по местоположению") {
                    locationManager.requestLocation()
                    
                    guard !locationManager.permissionDenied else  {
                        locationManager.showAlertSettingsLocation = true
                        return
                    }
                    
                    if let loc = locationManager.location {
                        viewModel.fetchWeather(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude)
                    }
                }
                .buttonStyle(.bordered)

                Picker("Единицы измерения", selection: $viewModel.selectedUnit) {
                    ForEach(UnitSystem.allCases, id: \.self) { unit in
                        Text(unit.title.capitalized).tag(unit)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Ошибки и доступ
                if locationManager.permissionDenied {
                    Text("Доступ к геолокации запрещён. Разрешите в настройках.")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                if let error = viewModel.errorMessage {
                    Text("Ошибка: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                Spacer()
            }
            .padding()
            .foregroundColor(.white)
            .onChange(of: viewModel.selectedUnit) { newValue in
                viewModel.isLoading = true
                viewModel.updateWeather()
            }
            
            
            if viewModel.isLoading {
                load
            }
        }
        .animation(.default, value: viewModel.isLoading)
        
        .alert("Доступ к геолокации запрещён.", isPresented: $locationManager.showAlertSettingsLocation) {
            Button("Открыть") {
                if let url = URL(string: UIApplication.openSettingsURLString),
                      UIApplication.shared.canOpenURL(url) {
                       UIApplication.shared.open(url)
                   }
            }
        } message: {
            Text("Разрешите в настройках.")
        }
        
        .alert(isPresented: $showNetworkAlert) {
            Alert(
                title: Text("Нет подключения к интернету"),
                message: Text("Пожалуйста, проверьте соединение."),
                dismissButton: .default(Text("Ок"))
            )
        }
        .onAppear {
            if !networkMonitor.isConnected {
                showNetworkAlert = true
            }
        }
        .onReceive(networkMonitor.$isConnected) { isConnected in
            if !isConnected {
                showNetworkAlert = true
            }
        }

    }
    
    var load: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(1.4)
        }
    }
}


#Preview {
    WeatherView()
}

struct WeatherCard: View {
    var weather: WeatherResponse
    var unit: UnitSystem
    
    var body: some View {
        VStack(spacing: 12) {
            Text(weather.name)
                .font(.largeTitle)
                .bold()
            
            if let icon = weather.weather.first?.icon {
                let iconURL = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
                AsyncImage(url: iconURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
            }
            
            Text("\(Int(weather.main.temp)) \(unit.symbol)")
                .font(.system(size: 64))
                .bold()
            
            Text(weather.weather.first?.description.capitalized ?? "")
                .font(.title3)
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

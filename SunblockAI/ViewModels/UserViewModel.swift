// UserViewModel.swift
import Foundation
import Combine
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var userSettings: UserSettings
    @Published var currentWeather: WeatherData
    @Published var nextApplicationTime: Date?
    @Published var hasCompletedOnboarding: Bool
    
    private let userDefaultsKey = "userSettings"
    private let onboardingKey = "hasCompletedOnboarding"
    private var cancellables = Set<AnyCancellable>()
    private let weatherUpdateInterval: TimeInterval = 900 // 15 minutos
    private var weatherTimer: Timer?
    
    init() {
        // Cargar configuración de usuario
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedSettings = try? JSONDecoder().decode(UserSettings.self, from: savedData) {
            self.userSettings = decodedSettings
        } else {
            self.userSettings = UserSettings.default
        }
        
        // Verificar onboarding
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
        
        // Inicializar con datos de clima de muestra
        self.currentWeather = WeatherData(
            uvIndex: 6.5,
            temperature: 28.0,
            weatherCondition: .sunny
        )
        
        // Calcular próxima aplicación
        calculateNextApplication()
        
        // Observar cambios en userSettings
        $userSettings
            .sink { [weak self] settings in
                if let encodedData = try? JSONEncoder().encode(settings) {
                    UserDefaults.standard.set(encodedData, forKey: self?.userDefaultsKey ?? "")
                }
                self?.calculateNextApplication()
            }
            .store(in: &cancellables)
        
        // Iniciar actualizaciones de clima
        startWeatherUpdates()
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }
    
    func calculateNextApplication() {
        // Lógica para determinar cuándo se necesita la próxima aplicación
        // Basado en última aplicación registrada y nivel UV
        // Por ahora, simplemente establecemos 2 horas después de la hora actual
        nextApplicationTime = Calendar.current.date(byAdding: .hour, value: 2, to: Date())
    }
    
    func startWeatherUpdates() {
        // Iniciar actualizaciones periódicas del clima
        fetchWeatherData()
        
        weatherTimer = Timer.scheduledTimer(withTimeInterval: weatherUpdateInterval, repeats: true) { [weak self] _ in
            self?.fetchWeatherData()
        }
    }
    
    func fetchWeatherData() {
        // En una app real, aquí llamaríamos a una API de clima
        // Por ahora, simulamos datos
        
        // Variar un poco el índice UV basado en la hora del día
        let hour = Calendar.current.component(.hour, from: Date())
        var baseUV = 2.0
        
        if hour >= 10 && hour <= 16 {
            baseUV = Double.random(in: 6.0...9.0)
        } else if hour >= 8 && hour <= 18 {
            baseUV = Double.random(in: 3.0...6.0)
        }
        
        // Simular temperatura
        let baseTemp = Double.random(in: 22.0...32.0)
        
        // Actualizar datos de clima
        DispatchQueue.main.async {
            self.currentWeather = WeatherData(
                uvIndex: baseUV,
                temperature: baseTemp,
                weatherCondition: .sunny
            )
            
            // Recalcular próxima aplicación con nuevos datos
            self.calculateNextApplication()
        }
    }
    
    func recommendedSPF() -> SPFLevel {
        let uvIndex = currentWeather.uvIndex
        let (normal, high) = userSettings.skinType.recommendedSPF
        
        if uvIndex >= 6 {
            return SPFLevel(rawValue: high) ?? .spf50
        } else {
            return SPFLevel(rawValue: normal) ?? .spf30
        }
    }
    
    deinit {
        weatherTimer?.invalidate()
    }
}

// ConfigurationView.swift
import SwiftUI

struct ConfigurationView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State private var userName = ""
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                // Información de perfil
                Section(header: Text("Perfil")) {
                    TextField("Nombre", text: $userName)
                        .onAppear {
                            userName = userViewModel.userSettings.userName ?? ""
                        }
                        .onDisappear {
                            userViewModel.userSettings.userName = userName.isEmpty ? nil : userName
                        }
                    
                    Picker("Fototipo de piel", selection: $userViewModel.userSettings.skinType) {
                        ForEach(SkinType.allCases) { skinType in
                            Text("Tipo \(skinType.rawValue): \(skinType.description)")
                                .tag(skinType)
                        }
                    }
                }
                
                // Configuración diaria
                Section(header: Text("Configuración diaria")) {
                    Picker("Entorno diario", selection: $userViewModel.userSettings.dailyEnvironment) {
                        ForEach(DailyEnvironment.allCases) { environment in
                            Text(environment.rawValue).tag(environment)
                        }
                    }
                    
                    DatePicker("Hora de traslado", selection: $userViewModel.userSettings.commuteTime, displayedComponents: .hourAndMinute)
                }
                
                // Modos especiales
                Section(header: Text("Configuración adicional")) {
                    Toggle("Modo vacaciones", isOn: $userViewModel.userSettings.isVacationMode)
                        .onChange(of: userViewModel.userSettings.isVacationMode) { newValue in
                            if newValue {
                                // Si activa el modo vacaciones, podríamos mostrar una alerta o ajustar configuraciones
                                userViewModel.fetchWeatherData() // Actualizar datos inmediatamente
                            }
                        }
                    
                    Toggle("Sincronizar con Apple Health", isOn: $userViewModel.userSettings.isHealthKitEnabled)
                    
                    Toggle("Activar notificaciones", isOn: $userViewModel.userSettings.notificationsEnabled)
                }
                
                // Opciones avanzadas
                Section {
                    Button(action: {
                        showResetAlert = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Restablecer configuración")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Configuración")
            .alert(isPresented: $showResetAlert) {
                Alert(
                    title: Text("Restablecer configuración"),
                    message: Text("¿Estás seguro de que deseas restablecer todas las configuraciones a sus valores predeterminados?"),
                    primaryButton: .destructive(Text("Restablecer")) {
                        // Restablecer configuración
                        userViewModel.userSettings = UserSettings.default
                        userName = userViewModel.userSettings.userName ?? ""
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

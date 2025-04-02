// Onboarding3.swift
import SwiftUI

struct Onboarding3: View {
    @Binding var currentPage: Int
    @ObservedObject var userViewModel: UserViewModel
    @State private var skipTimeSelection = false
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                VStack(spacing: 20) {
                    // Título
                    Text("Cuéntanos sobre tus hábitos")
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                    
                    // Descripción
                    Text("Estos datos nos ayudarán a personalizar tus alertas y recomendaciones.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    
                    // Grupo de entorno diario
                    VStack(alignment: .leading, spacing: 12) {
                        Text("¿Dónde pasas la mayor parte del día?")
                            .font(.headline)
                        
                        ForEach(DailyEnvironment.allCases) { environment in
                            EnvironmentButton(
                                environment: environment,
                                isSelected: userViewModel.userSettings.dailyEnvironment == environment,
                                action: {
                                    userViewModel.userSettings.dailyEnvironment = environment
                                    // Actualizar skipTimeSelection automáticamente si selecciona "En casa"
                                    skipTimeSelection = environment == .home
                                }
                            )
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.gray.opacity(0.1), radius: 5)
                    )
                    .padding(.horizontal)
                    
                    // SECCIÓN DE HORA DE EXPOSICIÓN - Adaptada según el entorno seleccionado
                    if !skipTimeSelection {
                        // Título adaptado según el contexto
                        HStack {
                            let titleText = userViewModel.userSettings.dailyEnvironment == .outdoor
                                ? "¿A qué hora sueles estar al aire libre?"
                                : "¿A qué hora te expones más al sol?"
                            
                            Text(titleText)
                                .font(.headline)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
                        
                        // DATEPICKER
                        VStack {
                            DatePicker("", selection: $userViewModel.userSettings.commuteTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(WheelDatePickerStyle())
                                .frame(height: 180)
                                .padding(.horizontal)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.gray.opacity(0.1), radius: 5)
                        )
                        .padding(.horizontal)
                        
                        // Botón para omitir esta sección
                        Button(action: {
                            skipTimeSelection = true
                        }) {
                            Text("No aplica a mi rutina")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 5)
                    } else {
                        // Mensaje cuando se omite la sección de tiempo
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Horario de exposición solar")
                                    .font(.headline)
                                Spacer()
                            }
                            
                            Text("Has indicado que pasas la mayor parte del día en casa o que este horario no aplica a tu rutina. Calcularemos tus recomendaciones basadas en otros factores.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // Botón para mostrar la sección si el usuario cambia de opinión
                            Button(action: {
                                skipTimeSelection = false
                            }) {
                                Text("Definir un horario de todas formas")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            .padding(.top, 5)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.gray.opacity(0.1), radius: 5)
                        )
                        .padding(.horizontal)
                    }
                    
                    // Espacio ajustable
                    Spacer(minLength: 10)
                }
                .padding(.vertical, 10)
            }
            
            // Botones de navegación colocados fuera del ScrollView
            HStack(spacing: 16) {
                // Botón atrás
                Button(action: {
                    withAnimation {
                        currentPage -= 1
                    }
                }) {
                    Text("Atrás")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                }
                .frame(maxWidth: .infinity)
                
                // Botón terminar
                Button(action: {
                    // Marcar onboarding como completado
                    userViewModel.completeOnboarding()
                }) {
                    Text("Comenzar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}

// Componente para botón de entorno diario
struct EnvironmentButton: View {
    let environment: DailyEnvironment
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                // Icono
                Image(systemName: iconForEnvironment(environment))
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? .blue : .gray)
                
                // Texto
                Text(environment.rawValue)
                    .font(.body)
                
                Spacer()
                
                // Indicador de selección
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Función para obtener el icono según el entorno
    private func iconForEnvironment(_ environment: DailyEnvironment) -> String {
        switch environment {
        case .indoor: return "building.2.fill"
        case .outdoor: return "tree.fill"
        case .home: return "house.fill"
        }
    }
}

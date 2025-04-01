// Onboarding3.swift
import SwiftUI

struct Onboarding3: View {
    @Binding var currentPage: Int
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Título
            Text("Cuéntanos sobre tus hábitos")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Explicación
            Text("Estos datos nos ayudarán a personalizar tus alertas y recomendaciones.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)
                .padding(.bottom, 10)
            
            // Grupo de entorno diario
            VStack(alignment: .leading, spacing: 16) {
                Text("¿Dónde pasas la mayor parte del día?")
                    .font(.headline)
                
                ForEach(DailyEnvironment.allCases) { environment in
                    EnvironmentButton(
                        environment: environment,
                        isSelected: userViewModel.userSettings.dailyEnvironment == environment,
                        action: {
                            userViewModel.userSettings.dailyEnvironment = environment
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
            
            // Selector de hora de traslado
            VStack(alignment: .leading, spacing: 16) {
                Text("¿A qué hora te trasladas?")
                    .font(.headline)
                
                DatePicker("Hora de traslado", selection: $userViewModel.userSettings.commuteTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                    .frame(maxHeight: 120)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.gray.opacity(0.1), radius: 5)
            )
            .padding(.horizontal)
            
            Spacer()
            
            // Botones de navegación
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
        .padding()
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

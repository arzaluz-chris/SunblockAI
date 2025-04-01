// Onboarding2.swift
import SwiftUI

struct Onboarding2: View {
    @Binding var currentPage: Int
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Título
            Text("Selecciona tu fototipo de piel")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Subtítulo
            Text("(Escala Fitzpatrick)")
                .font(.headline)
                .foregroundColor(.secondary)
            
            // Explicación
            Text("El tipo de piel determina tu sensibilidad al sol y el nivel de protección que necesitas.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
            
            // Opciones de fototipo
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(SkinType.allCases) { skinType in
                        SkinTypeButton(
                            skinType: skinType,
                            isSelected: userViewModel.userSettings.skinType == skinType,
                            action: {
                                userViewModel.userSettings.skinType = skinType
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
            
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
                
                // Botón siguiente
                Button(action: {
                    withAnimation {
                        currentPage += 1
                    }
                }) {
                    Text("Siguiente")
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

// Componente para botón del tipo de piel
struct SkinTypeButton: View {
    let skinType: SkinType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Muestra del fototipo
                Circle()
                    .fill(skinTypeColor(skinType))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.blue : Color.gray, lineWidth: isSelected ? 3 : 1)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    // Tipo
                    Text("Tipo \(skinType.rawValue)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    // Descripción
                    Text(skinType.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Indicador de selección
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1), radius: 5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Función para determinar el color del fototipo
    private func skinTypeColor(_ type: SkinType) -> Color {
        switch type {
        case .type1: return Color(red: 0.96, green: 0.91, blue: 0.85)
        case .type2: return Color(red: 0.94, green: 0.85, blue: 0.74)
        case .type3: return Color(red: 0.91, green: 0.76, blue: 0.62)
        case .type4: return Color(red: 0.77, green: 0.60, blue: 0.42)
        case .type5: return Color(red: 0.61, green: 0.42, blue: 0.29)
        case .type6: return Color(red: 0.40, green: 0.27, blue: 0.19)
        }
    }
}


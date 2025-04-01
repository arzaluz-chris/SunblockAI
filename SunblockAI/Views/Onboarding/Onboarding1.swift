// Onboarding1.swift
import SwiftUI

struct Onboarding1: View {
    @Binding var currentPage: Int
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Imagen ilustrativa
            Image(systemName: "sun.max.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .foregroundColor(.orange)
                .padding(.bottom, 20)
            
            // Título
            Text("Bienvenido a SunblockAI")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Descripción
            Text("Te ayudaremos a proteger tu piel del sol con recomendaciones personalizadas basadas en tu tipo de piel, ubicación y el índice UV.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)
            
            Spacer()
            
            // Botón de siguiente
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
            .padding(.horizontal, 32)
            .padding(.bottom, 16)
        }
        .padding()
    }
}


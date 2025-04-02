// Onboarding1.swift
import SwiftUI

struct Onboarding1: View {
    @Binding var currentPage: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Imagen ilustrativa
            Image(systemName: "sun.max.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.orange)
                .padding(.bottom, 10)
            
            // Título
            Text("Bienvenido a SunblockAI")
                .font(.title.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Descripción con texto actualizado y mejor ajuste
            Text("Te ayudaremos a proteger tu piel del sol con recomendaciones personalizadas, basadas en tu tipo de piel, así como tus actividades y tu ubicación geográfica.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true) // Fuerza a que el texto se muestre completo
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
            
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

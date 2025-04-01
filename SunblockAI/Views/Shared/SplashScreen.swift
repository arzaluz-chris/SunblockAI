
// SplashScreen.swift
import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        ZStack {
            Color("primaryBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Logo
                Image("sunblockai_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                
                // Título animado
                Text("SunblockAI")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.primary)
                
                // Subtítulo
                Text("Tu protección solar inteligente")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
            }
            .scaleEffect(isActive ? 1.0 : 0.95)
            .opacity(isActive ? 1.0 : 0.8)
            .animation(.easeIn(duration: 1.0), value: isActive)
        }
        .onAppear {
            // Activar animación
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isActive = true
            }
            
            // Navegar a la siguiente pantalla después de un breve retraso
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                // Si el usuario ya completó el onboarding, ir al contenido principal
                if userViewModel.hasCompletedOnboarding {
                    // La navegación se maneja en ContentView
                } else {
                    // La navegación se maneja en ContentView
                }
            }
        }
    }
}

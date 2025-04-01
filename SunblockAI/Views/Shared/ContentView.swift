// ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var historyViewModel = HistoryViewModel()
    @State private var currentOnboardingPage = 1
    
    var body: some View {
        Group {
            if !userViewModel.hasCompletedOnboarding {
                // Flujo de onboarding
                if currentOnboardingPage == 0 {
                    SplashScreen(userViewModel: userViewModel)
                        .transition(.opacity)
                } else if currentOnboardingPage == 1 {
                    Onboarding1(currentPage: $currentOnboardingPage)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                } else if currentOnboardingPage == 2 {
                    Onboarding2(currentPage: $currentOnboardingPage, userViewModel: userViewModel)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                } else if currentOnboardingPage == 3 {
                    Onboarding3(currentPage: $currentOnboardingPage, userViewModel: userViewModel)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            } else {
                // TabView principal
                TabView {
                    // Pantalla principal
                    HomeView(userViewModel: userViewModel, historyViewModel: historyViewModel)
                        .tabItem {
                            Label("Inicio", systemImage: "sun.max.fill")
                        }
                    
                    // Historial
                    HistoryView(historyViewModel: historyViewModel)
                        .tabItem {
                            Label("Historial", systemImage: "clock.fill")
                        }
                    
                    // Educación
                    EducationView()
                        .tabItem {
                            Label("Consejos", systemImage: "book.fill")
                        }
                    
                    // Configuración
                    ConfigurationView(userViewModel: userViewModel)
                        .tabItem {
                            Label("Ajustes", systemImage: "gear")
                        }
                }
                .accentColor(.blue)
                .onAppear {
                    // Configurar apariencia de la TabBar
                    let appearance = UITabBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    UITabBar.appearance().standardAppearance = appearance
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
            }
        }
        .accentColor(.blue)
        .onAppear {
            // Iniciar en la pantalla de splash
            if !userViewModel.hasCompletedOnboarding {
                currentOnboardingPage = 0
                
                // Avanzar automáticamente al primer paso del onboarding después de un momento
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        currentOnboardingPage = 1
                    }
                }
            }
        }
    }
}

// HomeView.swift
import SwiftUI

struct HomeView: View {
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var historyViewModel: HistoryViewModel
    @State private var showApplicationSheet = false
    @State private var selectedSPF: SPFLevel = .spf30
    @State private var applicationNotes = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Saludo
                    greeting
                    
                    // Indicadores principales
                    weatherIndicators
                    
                    // Recomendación y próxima aplicación
                    recommendation
                    
                    // Botón de registro
                    applicationButton
                    
                    // Resumen de historial
                    historySummary
                }
                .padding()
            }
            .navigationTitle("SunblockAI")
            .sheet(isPresented: $showApplicationSheet) {
                applicationForm
            }
            .onAppear {
                // Obtener datos actualizados del clima
                userViewModel.fetchWeatherData()
                // Preseleccionar SPF recomendado
                selectedSPF = userViewModel.recommendedSPF()
            }
        }
    }
    
    // Vista de saludo
    private var greeting: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                let greeting = getGreeting()
                Text(greeting)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                if let userName = userViewModel.userSettings.userName, !userName.isEmpty {
                    Text(userName)
                        .font(.title.bold())
                } else {
                    Text("¡Te protegemos del sol!")
                        .font(.title2.bold())
                }
            }
            
            Spacer()
            
            // Icono de modo vacaciones si está activado
            if userViewModel.userSettings.isVacationMode {
                Image(systemName: "beach.umbrella.fill")
                    .font(.title)
                    .foregroundColor(.orange)
            }
        }
        .padding(.vertical, 8)
    }
    
    // Indicadores de clima
    private var weatherIndicators: some View {
        HStack(spacing: 20) {
            // Índice UV
            VStack {
                ZStack {
                    Circle()
                        .stroke(colorForUVIndex(userViewModel.currentWeather.uvIndex), lineWidth: 6)
                        .frame(width: 110, height: 110)
                    
                    VStack(spacing: 4) {
                        Text("ÍNDICE UV")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        Text(String(format: "%.1f", userViewModel.currentWeather.uvIndex))
                            .font(.system(size: 36, weight: .bold))
                        
                        Text(userViewModel.currentWeather.uvCategory.rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(colorForUVIndex(userViewModel.currentWeather.uvIndex))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            // Temperatura
            VStack {
                ZStack {
                    Circle()
                        .stroke(Color.blue, lineWidth: 6)
                        .frame(width: 110, height: 110)
                    
                    VStack(spacing: 4) {
                        Text("TEMP")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        Text(String(format: "%.0f°", userViewModel.currentWeather.temperature))
                            .font(.system(size: 36, weight: .bold))
                        
                        Text(userViewModel.currentWeather.weatherCondition.description)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 10)
    }
    
    // Recomendación
    private var recommendation: some View {
        VStack(spacing: 12) {
            // FPS recomendado
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("PROTECCIÓN RECOMENDADA")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    Text(userViewModel.recommendedSPF().displayName)
                        .font(.title3.bold())
                }
                
                Spacer()
                
                Image(systemName: "shield.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
            )
            
            // Próxima aplicación
            if let nextTime = userViewModel.nextApplicationTime {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("PRÓXIMA APLICACIÓN")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        Text(formatTime(nextTime))
                            .font(.title3.bold())
                    }
                    
                    Spacer()
                    
                    Image(systemName: "clock.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.1))
                )
            }
        }
    }
    
    // Botón de registrar aplicación
    private var applicationButton: some View {
        Button(action: {
            // Preseleccionar SPF recomendado
            selectedSPF = userViewModel.recommendedSPF()
            // Mostrar hoja de registro
            showApplicationSheet = true
        }) {
            HStack {
                Spacer()
                Text("Registrar aplicación")
                    .font(.headline)
                    .foregroundColor(.white)
                Image(systemName: "plus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
            )
        }
        .padding(.vertical, 8)
    }
    
    // Resumen de historial
    private var historySummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Título
            Text("ÚLTIMAS APLICACIONES")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            if historyViewModel.applicationRecords.isEmpty {
                Text("Aún no has registrado aplicaciones.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                // Mostrar últimas 3 aplicaciones
                ForEach(Array(historyViewModel.applicationRecords.prefix(3))) { record in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(formatDateShort(record.date))
                                .font(.subheadline.bold())
                            
                            Text(record.spfLevel.displayName)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Label(String(format: "UV: %.1f", record.uvIndex), systemImage: "sun.max.fill")
                                .font(.caption)
                                .foregroundColor(.orange)
                            
                            Label(String(format: "%.0f°", record.temperature), systemImage: "thermometer")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                }
            }
            
            // Ver todas
            NavigationLink(destination: HistoryView(historyViewModel: historyViewModel)) {
                HStack {
                    Spacer()
                    Text("Ver historial completo")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                    Spacer()
                }
                .padding()
                .foregroundColor(.blue)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 1)
                )
            }
        }
    }
    
    // Formulario de registro de aplicación
    private var applicationForm: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalles de aplicación")) {
                    Picker("FPS aplicado", selection: $selectedSPF) {
                        ForEach(SPFLevel.allCases) { spf in
                            Text(spf.displayName).tag(spf)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        Text("Índice UV actual")
                        Spacer()
                        Text(String(format: "%.1f", userViewModel.currentWeather.uvIndex))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Temperatura")
                        Spacer()
                        Text(String(format: "%.1f °C", userViewModel.currentWeather.temperature))
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Notas (opcional)")) {
                    TextField("Agregar notas...", text: $applicationNotes)
                }
                
                Section {
                    Button(action: {
                        // Guardar registro
                        historyViewModel.addApplicationRecord(
                            spfLevel: selectedSPF,
                            uvIndex: userViewModel.currentWeather.uvIndex,
                            temperature: userViewModel.currentWeather.temperature,
                            notes: applicationNotes.isEmpty ? nil : applicationNotes
                        )
                        
                        // Recalcular próxima aplicación
                        userViewModel.calculateNextApplication()
                        
                        // Cerrar hoja
                        showApplicationSheet = false
                        applicationNotes = ""
                    }) {
                        Text("Guardar aplicación")
                    }
                }
            }
            .navigationTitle("Registrar aplicación")
            .navigationBarItems(trailing: Button("Cancelar") {
                showApplicationSheet = false
                applicationNotes = ""
            })
        }
    }
    
    // MARK: - Funciones de utilidad
    
    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            return "Buenos días"
        } else if hour < 19 {
            return "Buenas tardes"
        } else {
            return "Buenas noches"
        }
    }
    
    private func colorForUVIndex(_ index: Double) -> Color {
        switch index {
        case 0..<3: return .green
        case 3..<6: return .yellow
        case 6..<8: return .orange
        case 8..<11: return .red
        default: return .purple
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    private func formatDateShort(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, h:mm a"
        return formatter.string(from: date)
    }
}

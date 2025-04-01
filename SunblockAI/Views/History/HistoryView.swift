// HistoryView.swift
import SwiftUI
import Charts

struct HistoryView: View {
    @ObservedObject var historyViewModel: HistoryViewModel
    @State private var isShowingStats = false
    
    var body: some View {
        NavigationView {
            List {
                if isShowingStats {
                    statisticsSection
                }
                
                if historyViewModel.applicationRecords.isEmpty {
                    Section {
                        Text("No hay registros de aplicaciones.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                } else {
                    // Agrupar registros por fecha
                    ForEach(groupedRecordsSorted, id: \.0) { date, records in
                        Section(header: Text(formatDate(date))) {
                            ForEach(records) { record in
                                ApplicationRecordRow(record: record)
                            }
                            .onDelete { indices in
                                deleteRecords(for: date, at: indices)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Historial")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            isShowingStats.toggle()
                        }
                    }) {
                        Label(isShowingStats ? "Ocultar estadísticas" : "Ver estadísticas", systemImage: isShowingStats ? "chart.bar.xaxis" : "chart.bar.fill")
                    }
                }
            }
        }
    }
    
    // Sección de estadísticas
    private var statisticsSection: some View {
        Section(header: Text("Estadísticas")) {
            VStack(spacing: 20) {
                // Gráfico de aplicaciones por día
                if !historyViewModel.applicationRecords.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Aplicaciones por día")
                            .font(.headline)
                        
                        chartView
                    }
                    .padding(.vertical, 10)
                }
                
                // Estadísticas de cumplimiento
                let stats = historyViewModel.getReapplicationStats()
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cumplimiento")
                        .font(.headline)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            if let avg = stats.average {
                                Text("Intervalo promedio:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(formatInterval(avg))
                                    .font(.title3.bold())
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Adherencia:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.0f%%", stats.compliance * 100))
                                .font(.title3.bold())
                                .foregroundColor(stats.compliance >= 0.7 ? .green : (stats.compliance >= 0.4 ? .orange : .red))
                        }
                    }
                }
                .padding(.vertical, 10)
            }
            .padding(.vertical, 10)
        }
    }
    
    // Gráfico de aplicaciones
    private var chartView: some View {
        let data = prepareDailyData()
        
        return Chart(data) { item in
            BarMark(
                x: .value("Día", item.day),
                y: .value("Aplicaciones", item.count)
            )
            .foregroundStyle(Color.blue.gradient)
        }
        .frame(height: 200)
        .padding(.vertical, 10)
    }
    
    // MARK: - Utilidades
    
    // Obtener registros agrupados y ordenados
    private var groupedRecordsSorted: [(Date, [ApplicationRecord])] {
        let groupedRecords = historyViewModel.recordsGroupedByDate()
        return groupedRecords.sorted { $0.key > $1.key }
    }
    
    // Eliminar registros
    private func deleteRecords(for date: Date, at indices: IndexSet) {
        let records = historyViewModel.recordsGroupedByDate()[date] ?? []
        let idsToRemove = indices.map { records[$0].id }
        
        // Encontrar índices en la lista principal
        let recordIndexes = historyViewModel.applicationRecords.indices.filter { idx in
            idsToRemove.contains(historyViewModel.applicationRecords[idx].id)
        }
        
        let indexSet = IndexSet(recordIndexes)
        historyViewModel.deleteRecord(at: indexSet)
    }
    
    // Preparar datos para el gráfico
    private func prepareDailyData() -> [DailyCount] {
        let calendar = Calendar.current
        let groupedRecords = historyViewModel.recordsGroupedByDate()
        
        // Obtener fechas para los últimos 7 días
        let today = calendar.startOfDay(for: Date())
        let dateRange = (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: -dayOffset, to: today)
        }
        
        // Crear datos para el gráfico
        return dateRange.map { date in
            let count = groupedRecords[date]?.count ?? 0
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "dd/MM"
            return DailyCount(day: dayFormatter.string(from: date), count: count)
        }
    }
    
    // Formatear fecha
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    // Formatear intervalo de tiempo
    private func formatInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)min"
        } else {
            return "\(minutes) minutos"
        }
    }
}

// Estructura para datos del gráfico
struct DailyCount: Identifiable {
    let id = UUID()
    let day: String
    let count: Int
}

// Fila de registro de aplicación
struct ApplicationRecordRow: View {
    let record: ApplicationRecord
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(formatTime(record.date))
                    .font(.headline)
                
                Text(record.spfLevel.displayName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let notes = record.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Label(String(format: "UV: %.1f", record.uvIndex), systemImage: "sun.max.fill")
                    .font(.caption)
                    .foregroundColor(.orange)
                
                Label(String(format: "%.0f°C", record.temperature), systemImage: "thermometer")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

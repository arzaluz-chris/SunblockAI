// HistoryViewModel.swift
import Foundation
import Combine

class HistoryViewModel: ObservableObject {
    @Published var applicationRecords: [ApplicationRecord] = []
    private let storageKey = "applicationRecords"
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadRecords()
        
        // Observar cambios en registros para guardarlos
        $applicationRecords
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] records in
                self?.saveRecords(records)
            }
            .store(in: &cancellables)
    }
    
    private func loadRecords() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decodedRecords = try? JSONDecoder().decode([ApplicationRecord].self, from: savedData) {
            applicationRecords = decodedRecords
        } else {
            // Cargar datos de muestra solo la primera vez
            applicationRecords = ApplicationRecord.sampleRecords
            saveRecords(applicationRecords)
        }
    }
    
    private func saveRecords(_ records: [ApplicationRecord]) {
        if let encodedData = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encodedData, forKey: storageKey)
        }
    }
    
    func addApplicationRecord(spfLevel: SPFLevel, uvIndex: Double, temperature: Double, notes: String? = nil) {
        let newRecord = ApplicationRecord(
            date: Date(),
            spfLevel: spfLevel,
            uvIndex: uvIndex,
            temperature: temperature,
            notes: notes
        )
        
        applicationRecords.insert(newRecord, at: 0)
    }
    
    func deleteRecord(at indexSet: IndexSet) {
        applicationRecords.remove(atOffsets: indexSet)
    }
    
    func recordsGroupedByDate() -> [Date: [ApplicationRecord]] {
        let calendar = Calendar.current
        var groupedRecords: [Date: [ApplicationRecord]] = [:]
        
        for record in applicationRecords {
            // Normalizar la fecha a las 00:00
            let components = calendar.dateComponents([.year, .month, .day], from: record.date)
            if let normalizedDate = calendar.date(from: components) {
                if groupedRecords[normalizedDate] == nil {
                    groupedRecords[normalizedDate] = []
                }
                groupedRecords[normalizedDate]?.append(record)
            }
        }
        
        return groupedRecords
    }
    
    func getReapplicationStats() -> (average: TimeInterval?, compliance: Double) {
        guard applicationRecords.count > 1 else { return (nil, 0) }
        
        // Ordenar registros por fecha
        let sortedRecords = applicationRecords.sorted { $0.date < $1.date }
        var totalInterval: TimeInterval = 0
        var totalIntervals = 0
        
        // Calcular intervalos entre aplicaciones en el mismo día
        for i in 0..<(sortedRecords.count - 1) {
            let current = sortedRecords[i]
            let next = sortedRecords[i + 1]
            
            // Verificar si es el mismo día
            if Calendar.current.isDate(current.date, inSameDayAs: next.date) {
                let interval = next.date.timeIntervalSince(current.date)
                if interval > 0 && interval < 6 * 3600 { // Menos de 6 horas
                    totalInterval += interval
                    totalIntervals += 1
                }
            }
        }
        
        // Calcular promedio
        let average = totalIntervals > 0 ? totalInterval / Double(totalIntervals) : nil
        
        // Calcular tasa de cumplimiento (porcentaje de días con al menos 2 aplicaciones)
        let recordsByDate = recordsGroupedByDate()
        var daysWithMultipleApplications = 0
        
        for (_, records) in recordsByDate {
            if records.count >= 2 {
                daysWithMultipleApplications += 1
            }
        }
        
        let compliance = recordsByDate.isEmpty ? 0 : Double(daysWithMultipleApplications) / Double(recordsByDate.count)
        
        return (average, compliance)
    }
}

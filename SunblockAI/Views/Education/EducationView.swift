// EducationView.swift
import SwiftUI

struct EducationView: View {
    private let topics = EducationTopic.allTopics
    @State private var selectedTopic: EducationTopic?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(topics) { topic in
                    TopicRow(topic: topic)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedTopic = topic
                        }
                }
            }
            .navigationTitle("Educación")
            .sheet(item: $selectedTopic) { topic in
                TopicDetailView(topic: topic)
            }
        }
    }
}

// Fila para temas educativos
struct TopicRow: View {
    let topic: EducationTopic
    
    var body: some View {
        HStack {
            Image(systemName: topic.iconName)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title)
                    .font(.headline)
                
                Text(topic.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

// Vista detallada del tema educativo
struct TopicDetailView: View {
    let topic: EducationTopic
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Encabezado
                    HStack {
                        Image(systemName: topic.iconName)
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                            .frame(width: 60, height: 60)
                            .background(
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(topic.title)
                                .font(.title2.bold())
                            
                            Text(topic.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // Contenido
                    Text(topic.content)
                        .font(.body)
                        .lineSpacing(6)
                    
                    // Consejos adicionales (simulados)
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Consejos importantes")
                            .font(.headline)
                            .padding(.top, 20)
                        
                        tipRow(icon: "checkmark.circle.fill", text: tipsForTopic(topic.title)[0])
                        tipRow(icon: "checkmark.circle.fill", text: tipsForTopic(topic.title)[1])
                        tipRow(icon: "checkmark.circle.fill", text: tipsForTopic(topic.title)[2])
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cerrar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func tipRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .font(.system(size: 20))
            
            Text(text)
                .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
    
    // Función para obtener consejos según el tema
    private func tipsForTopic(_ topicTitle: String) -> [String] {
        switch topicTitle {
        case "¿Qué es el índice UV?":
            return [
                "Un índice UV de 3 o más requiere protección solar.",
                "El UV puede ser alto incluso en días nublados.",
                "El índice UV es más alto entre las 10AM y las 4PM."
            ]
        case "¿Por qué usar protector solar?":
            return [
                "Aplicar 30 minutos antes de exponerse al sol.",
                "Reaplicar cada 2 horas y después de nadar o sudar.",
                "Usar suficiente cantidad (una cucharada para la cara y cuello)."
            ]
        case "Riesgos de exposición solar":
            return [
                "El 90% de los cánceres de piel se relacionan con la exposición solar.",
                "Las quemaduras solares en la infancia aumentan el riesgo de cáncer de piel.",
                "Los daños solares son acumulativos a lo largo de la vida."
            ]
        default:
            return [
                "Las personas de piel más clara necesitan mayor protección.",
                "El SPF indica cuánto tiempo puedes exponerte antes de quemarte.",
                "Elegir protector según tu fototipo y actividad."
            ]
        }
    }
}

// EducationTopic.swift
import Foundation

struct EducationTopic: Identifiable {
    var id: UUID = UUID()
    var title: String
    var subtitle: String
    var content: String
    var iconName: String
    
    static let allTopics: [EducationTopic] = [
        EducationTopic(
            title: "¿Qué es el índice UV?",
            subtitle: "Aprende a interpretarlo",
            content: "El índice UV es una medida de la intensidad de la radiación ultravioleta que llega a la superficie de la Tierra. Varía de 0 a 11+ y cuanto más alto sea el valor, mayor será el riesgo de daño solar. Por encima de 3 se recomienda protección solar.",
            iconName: "sun.max.fill"
        ),
        EducationTopic(
            title: "¿Por qué usar protector solar?",
            subtitle: "Beneficios y recomendaciones",
            content: "El protector solar actúa como una barrera que filtra los rayos UV nocivos. El uso diario reduce el riesgo de cáncer de piel, previene el envejecimiento prematuro y mantiene la piel saludable a largo plazo. Es esencial aplicarlo 30 minutos antes de la exposición y reaplicarlo cada 2 horas.",
            iconName: "shield.fill"
        ),
        EducationTopic(
            title: "Riesgos de exposición solar",
            subtitle: "Prevención y cuidados",
            content: "La exposición excesiva al sol puede causar quemaduras inmediatas, envejecimiento prematuro, daño ocular y aumentar significativamente el riesgo de melanoma. Las horas de mayor peligro son entre las 10AM y las 4PM. Además del protector solar, sombreros y ropa protectora son esenciales.",
            iconName: "exclamationmark.triangle.fill"
        ),
        EducationTopic(
            title: "Fototipos de piel",
            subtitle: "Conoce tu tipo de piel",
            content: "La escala Fitzpatrick clasifica la piel en seis tipos según su respuesta a la exposición solar. Conocer tu fototipo es clave para determinar tu riesgo solar y elegir la protección adecuada. Las pieles más claras necesitan mayor protección.",
            iconName: "person.fill"
        )
    ]
}

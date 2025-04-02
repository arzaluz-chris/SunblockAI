# SunblockAI

SunblockAI es una aplicación iOS que ayuda a los usuarios a proteger su piel del sol mediante recomendaciones personalizadas basadas en su tipo de piel, condiciones climáticas y hábitos diarios.

![SunblockAI Logo](./Assets/sunblockai_logo.png)

## Características

- 📊 **Monitoreo de índice UV en tiempo real**: Visualización clara del índice UV actual y su categoría
- 👤 **Personalización según fototipo**: Recomendaciones específicas basadas en la escala Fitzpatrick
- 🕒 **Recordatorios de aplicación**: Notificaciones para recordar cuándo aplicar y reaplicar protector solar
- 📱 **Widget de iOS**: Accede rápidamente al índice UV y próxima aplicación desde tu pantalla de inicio
- 📈 **Estadísticas de uso**: Análisis de tus hábitos de protección solar y cumplimiento
- 📚 **Contenido educativo**: Información valiosa sobre protección solar y exposición a rayos UV
- 🏝️ **Modo vacaciones**: Ajustes automáticos para cuando cambias de rutina

## Capturas de Pantalla

<!-- Añadir capturas de pantalla cuando estén disponibles -->

## Requisitos

- iOS 15.0 o posterior
- Xcode 13.0 o posterior
- Swift 5.5 o posterior

## Instalación

1. Clona este repositorio:
```bash
git clone https://github.com/tu-usuario/SunblockAI.git
```

2. Abre `SunblockAI.xcodeproj` en Xcode

3. Compila y ejecuta la aplicación en el simulador o dispositivo físico

## Arquitectura

SunblockAI está construido siguiendo el patrón de arquitectura MVVM (Model-View-ViewModel):

- **Modelos**: Estructuras de datos que representan la información de usuario, registros de aplicación, datos climáticos y contenido educativo
- **ViewModels**: Clases que contienen la lógica de negocio y procesan los datos para las vistas
- **Vistas**: Componentes de interfaz de usuario construidos con SwiftUI

### Estructura del Proyecto

```
SunblockAI/
├── Models/
│   ├── UserSettings.swift
│   ├── ApplicationRecord.swift
│   ├── WeatherData.swift
│   ├── EducationTopic.swift
├── Views/
│   ├── Onboarding/
│   │   ├── SplashScreen.swift
│   │   ├── Onboarding1.swift
│   │   ├── Onboarding2.swift
│   │   ├── Onboarding3.swift
│   ├── Home/
│   │   ├── HomeView.swift
│   ├── History/
│   │   ├── HistoryView.swift
│   ├── Education/
│   │   ├── EducationView.swift
│   ├── Configuration/
│   │   ├── ConfigurationView.swift
│   ├── Shared/
│   │   ├── ContentView.swift
├── ViewModels/
│   ├── UserViewModel.swift
│   ├── HistoryViewModel.swift
├── Resources/
│   ├── Assets.xcassets
├── SunblockAIApp.swift
├── Widgets/
│   ├── UV_Widget.swift
```

## Características Pendientes

- [ ] Integración con API meteorológica real
- [ ] Implementación completa de notificaciones locales
- [ ] Integración con HealthKit
- [ ] Localización a múltiples idiomas
- [ ] Soporte para diferentes unidades de temperatura (Celsius/Fahrenheit)

## Contribuciones

Las contribuciones son bienvenidas. Para cambios importantes, por favor, abre primero un issue para discutir lo que te gustaría cambiar.

## Licencia

[MIT](https://choosealicense.com/licenses/mit/)

## Contacto

Si tienes alguna pregunta o sugerencia, no dudes en contactarme:

<!-- Añadir información de contacto -->

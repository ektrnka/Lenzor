# Linsor

Linsor is a cross-platform Flutter application for tracking contact lens usage, replacement cycles, symptoms, lens stock, vision checks, and reminders.

The application helps users monitor how long they have been wearing their lenses, receive timely notifications, keep a history of lens cycles, and synchronize data across devices through Firebase.

## Features

- Contact lens wearing cycle tracking
- Support for daily, weekly, bi-weekly, monthly, quarterly, and semi-annual lenses
- Replacement and removal reminders
- Daily care tips
- Low lens stock reminders
- Solution purchase reminders
- Lens stock management
- Wearing history
- Calendar view with lens events
- Symptom tracking
- Vision check records for left and right eye
- Google Sign-In
- Firebase synchronization
- Local offline-first data storage
- Light and dark themes
- Russian and English localization
- Android home widget

## Platforms

The project is built with Flutter and contains platform support for:

- Android
- iOS
- Web
- Windows
- macOS
- Linux

Some features are platform-specific. For example, the Android home widget and Android notification actions are implemented for Android.

## Tech Stack

- Flutter
- Dart
- SharedPreferences
- Firebase Auth
- Google Sign-In
- Cloud Firestore
- Flutter Local Notifications
- Permission Handler
- Timezone
- Home Widget
- Flutter Localization
- Material 3

## Architecture

The application uses a service-oriented Flutter architecture with partial Clean Architecture principles in the calendar module.

Main layers:

- Presentation: screens, widgets, navigation
- Service/Application: data service, notification service, sync service, auth service
- Domain: lens models, cycles, symptoms, vision checks, calendar entities
- Data: SharedPreferences and Firestore
- Platform: Android widget and notification integrations

```mermaid
flowchart TD
    User["User"] --> UI["Flutter UI"]

    UI --> Home["Home Screen"]
    UI --> History["History Screen"]
    UI --> Profile["Profile Screen"]
    UI --> Settings["Settings Screen"]
    UI --> Calendar["Calendar Screen"]

    Home --> DataService["LensDataService"]
    History --> DataService
    Profile --> DataService
    Settings --> DataService

    Calendar --> CalendarController["CalendarController"]
    CalendarController --> CalendarRepository["CalendarRepository"]
    CalendarRepository --> DataService

    DataService --> LocalStorage["SharedPreferences"]

    DataService --> SyncService["SyncService"]
    SyncService --> Firestore["Cloud Firestore"]

    UI --> AuthService["AuthService"]
    AuthService --> FirebaseAuth["Firebase Auth"]
    FirebaseAuth --> GoogleSignIn["Google Sign-In"]

    UI --> NotificationService["NotificationService"]
    NotificationService --> SystemNotifications["Local Notifications"]

    DataService --> HomeWidgetService["HomeWidgetService"]
    HomeWidgetService --> AndroidWidget["Android Home Widget"]



Что стоит добавить в GitHub визуально:

1. **Логотип приложения**  
   Можно использовать:
   - `assets/branding/icon_square.png`
   - `assets/branding/icon_square_safe.png`

2. **Скриншоты интерфейса**  
   Лучше создать папку:
   ```text
   docs/screenshots/

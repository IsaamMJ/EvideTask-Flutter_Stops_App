# StopSpot

A Flutter app for managing transit stops with favorites and search functionality.

## Features
- View list of transit stops
- Search and filter stops
- Add/remove favorites (persisted locally)
- View detailed stop information with ETA

## Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK

### Installation
1. Clone the repository
2. Navigate to project directory
3. Run `flutter pub get`
4. Run `flutter run`

### Project Structure
- Clean Architecture with Domain/Data/Presentation layers
- BLoC for state management
- SharedPreferences for local persistence
- Asset-based data loading

## Dependencies
- flutter_bloc: State management
- shared_preferences: Local storage
- equatable: Value comparison
- get_it: Dependency injection
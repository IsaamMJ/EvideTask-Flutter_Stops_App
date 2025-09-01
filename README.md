# StopSpot 🚌

A modern Flutter application for managing transit stops with favorites, search functionality, and detailed stop information. Built with Clean Architecture principles and BLoC state management.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 🌟 Features

### Core Functionality
- **📍 Stop Management**: View comprehensive list of transit stops
- **🔍 Real-time Search**: Filter stops by name or description with instant results
- **❤️ Favorites System**: Add/remove favorites with persistent storage
- **📱 Detailed Views**: Complete stop information including coordinates and ETA
- **🌙 Theme Toggle**: Light and dark mode support
- **🔄 Pull to Refresh**: Update stop data with smooth animations

### Advanced Features
- **🎯 Smart Categorization**: Automatic stop type detection (Terminal, University, Shopping, etc.)
- **⏱️ ETA Calculation**: Intelligent arrival time estimation
- **🎨 Modern UI**: Material Design 3 with custom color palette
- **📊 Performance Optimized**: Efficient caching and state management

## 📸 Screenshots

*Add screenshots here showing:*
- Main stops list view
- Search functionality
- Stop detail page
- Dark/light theme comparison

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: 3.0.0 or higher
- **Dart SDK**: 3.0.0 or higher
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- **Device/Emulator**: iOS 11+ or Android API 21+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/stopspot.git
   cd stopspot
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 🏗️ Project Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/
│   ├── theme/           # App themes and colors
│   └── di/              # Dependency injection setup
├── data/
│   ├── datasources/     # Local data sources (JSON, SharedPreferences)
│   ├── models/          # Data models and DTOs
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository contracts
│   └── usecases/        # Business logic use cases
└── presentation/
    ├── bloc/            # BLoC state management
    ├── pages/           # UI screens
    └── widgets/         # Reusable UI components
```

### Architecture Layers

#### 🎯 **Domain Layer (Business Logic)**
- **Entities**: Core business objects (`Stop`)
- **Use Cases**: Business operations (`GetStops`, `SearchStops`, `ToggleFavorite`)
- **Repository Contracts**: Abstractions for data access

#### 📦 **Data Layer (Data Management)**
- **Models**: Data transfer objects extending domain entities
- **Data Sources**: Local JSON file reader and SharedPreferences handler
- **Repository Implementation**: Concrete implementation of domain contracts

#### 🎨 **Presentation Layer (UI)**
- **BLoC Pattern**: State management with events and states
- **Pages**: Screen-level components
- **Widgets**: Reusable UI components

## 🔧 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter_bloc: ^8.1.3          # State management
  equatable: ^2.0.5             # Value equality
  shared_preferences: ^2.2.2    # Local storage
  get_it: ^7.6.4                # Dependency injection

dev_dependencies:
  flutter_test: ^1.0.0
  bloc_test: ^9.1.4             # BLoC testing utilities
```

### Key Features Implementation

#### 🔍 **Search Functionality**
- Real-time filtering as user types
- Case-insensitive search across name and description
- Debounced input to optimize performance
- Clear search with single tap

#### ❤️ **Favorites Persistence**
- Uses SharedPreferences for local storage
- Survives app restarts and updates
- Efficient toggle mechanism with visual feedback
- Sync across list and detail views

#### 📊 **State Management**
- BLoC pattern for predictable state changes
- Proper error handling with user feedback
- Loading states with progress indicators
- Optimistic updates for better UX

## 🎨 Design System

### Color Palette
- **Primary Blue**: `#2563EB` - App bars, buttons, accents
- **Success Green**: `#10B981` - Favorites, positive actions
- **Neutral Gray**: `#64748B` - Text, secondary elements
- **Background**: `#F8FAFC` - Clean, modern background

### Typography
- **Material Design 3** typography scale
- **Consistent hierarchy** across all screens
- **Accessibility optimized** contrast ratios

### Components
- **Cards**: Rounded corners (12px radius) with subtle elevation
- **Buttons**: Consistent styling with primary color scheme
- **Input Fields**: Rounded design with proper focus states

## 📱 User Experience

### Navigation Flow
1. **Home Screen**: List of all stops with search bar
2. **Search**: Real-time filtering of stops
3. **Detail View**: Comprehensive stop information
4. **Favorites**: Toggle and persist favorite stops

### Interactions
- **Tap to Navigate**: Tap any stop to view details
- **Heart to Favorite**: Tap heart icon to add/remove favorites
- **Pull to Refresh**: Swipe down to refresh stop data
- **Search to Filter**: Type in search bar for instant filtering

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/presentation/bloc/stops_bloc_test.dart
```

## 📂 Data Structure

### Stop Entity
```dart
class Stop {
  final int id;
  final String name;
  final String description;
  final double lat;
  final double lng;
  final bool isFavorite;
}
```

### Sample Data
The app uses a local JSON file with 30 sample stops including:
- Transit stations and terminals
- Educational institutions
- Shopping districts
- Medical facilities
- Residential areas
- Business districts

## 🔄 State Management Flow

### BLoC Events & States

#### Stops BLoC
**Events:**
- `LoadStops` - Initial data loading
- `SearchStops` - Filter stops by query
- `ToggleFavoriteStop` - Add/remove favorite
- `ClearSearch` - Reset to all stops

**States:**
- `StopsInitial` - Initial state
- `StopsLoading` - Data loading
- `StopsLoaded` - Data successfully loaded
- `StopsError` - Error occurred

#### Stop Detail BLoC
**Events:**
- `LoadStopDetail` - Load specific stop
- `ToggleFavoriteDetail` - Toggle favorite from detail view

**States:**
- `StopDetailLoading` - Loading specific stop
- `StopDetailLoaded` - Stop data loaded
- `StopDetailError` - Error loading stop

## 🚀 Performance Optimizations

- **Efficient Caching**: In-memory cache for loaded stops
- **Lazy Loading**: Data loaded only when needed
- **Optimized Search**: In-memory filtering for instant results
- **Minimal Rebuilds**: BLoC pattern prevents unnecessary UI updates
- **Asset Optimization**: Compressed JSON data structure

## 🔮 Future Enhancements

### Potential Features
- **🗺️ Map Integration**: Visual map with stop locations
- **🚌 Real-time Updates**: Live arrival times from API
- **📍 Location Services**: Distance calculation from user location
- **🔔 Notifications**: Arrival alerts for favorited stops
- **📱 Platform Features**: Deep linking, share functionality
- **🌐 Offline Support**: Enhanced offline data management

### Technical Improvements
- **📊 Analytics Integration**: User behavior tracking
- **🧪 Integration Tests**: End-to-end testing
- **🔄 CI/CD Pipeline**: Automated testing and deployment
- **📈 Performance Monitoring**: Crash reporting and performance metrics


## 📧 Contact

**Developer**: Mohamed Isaam M J
**Email**: isaam.mj@gmail.com
**GitHub**: https://github.com/IsaamMJ
**LinkedIn**: https://www.linkedin.com/in/isaammj/

---

**Built with ❤️ using Flutter**
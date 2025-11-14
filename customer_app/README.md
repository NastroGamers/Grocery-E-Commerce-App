# FreshCart - Customer App

A feature-rich grocery e-commerce customer application built with Flutter.

## Features

### Implemented ✅
1. **User Registration & Authentication**
   - Email/Password authentication
   - Phone number + OTP authentication
   - Google Sign-In integration
   - Forgot password flow
   - Session management with JWT tokens

2. **Clean Architecture**
   - Feature-based folder structure
   - Separation of concerns (Data, Domain, Presentation layers)
   - Dependency injection with GetIt
   - State management with Bloc pattern

3. **Core Infrastructure**
   - Network layer with Dio
   - API interceptors for auth tokens
   - Error handling
   - Input validators
   - Routing system

### In Progress 🚧
2. Location Access - Auto-detect & Manual Selection
3. Product Catalog & Category Browsing
4. Real-time Search & Auto-Suggestions
5. Product Details Page
6. Cart & Wishlist
7. Schedule Delivery & Time Slots
8. Checkout & Payment Integration
9. Apply Coupons & Promotions
10. Live Order Tracking (Real-time)
11. Order History & Reorder
12. Push Notifications
13. In-App Chat/Support/FAQs
14. Rating & Review System

## Project Structure

```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart         # App configuration & API endpoints
│   │   └── theme_config.dart       # Theme & styling configuration
│   ├── di/
│   │   └── injection.dart          # Dependency injection setup
│   ├── network/
│   │   ├── dio_client.dart         # Dio HTTP client wrapper
│   │   └── api_interceptor.dart    # Auth token interceptor
│   ├── routes/
│   │   └── app_router.dart         # App navigation & routing
│   └── utils/
│       └── validators.dart         # Form validation utilities
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/        # Remote & local data sources
│   │   │   ├── models/             # Data models & DTOs
│   │   │   └── repositories/       # Repository implementations
│   │   ├── domain/
│   │   │   ├── repositories/       # Repository interfaces
│   │   │   └── usecases/           # Business logic use cases
│   │   └── presentation/
│   │       ├── bloc/               # State management
│   │       ├── pages/              # UI screens
│   │       └── widgets/            # Reusable widgets
│   ├── cart/
│   ├── location/
│   ├── products/
│   └── ...
└── main.dart
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode for platform-specific development
- Firebase project setup

### Installation

1. Clone the repository
```bash
git clone https://github.com/NastroGamers/Grocery-E-Commerce-App.git
cd Grocery-E-Commerce-App/customer_app
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate code (for json_serializable, etc.)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Configure Firebase
   - Add `google-services.json` (Android) to `android/app/`
   - Add `GoogleService-Info.plist` (iOS) to `ios/Runner/`

5. Update API configuration
   - Edit `lib/core/config/app_config.dart`
   - Set your backend API base URL
   - Add Google Maps API key
   - Add payment gateway keys

6. Run the app
```bash
flutter run
```

## Configuration

### API Endpoints
Configure your backend API endpoints in `lib/core/config/app_config.dart`:
```dart
static const String baseUrl = 'https://your-api.com/v1';
```

### Theme Customization
Modify app colors and styles in `lib/core/config/theme_config.dart`

## Dependencies

### State Management
- `flutter_bloc` - Business logic component pattern
- `equatable` - Value equality

### Networking
- `dio` - HTTP client
- `retrofit` - Type-safe HTTP client
- `json_annotation` - JSON serialization

### Firebase
- `firebase_core` - Firebase core functionality
- `firebase_auth` - Authentication
- `firebase_messaging` - Push notifications

### UI/UX
- `google_fonts` - Custom fonts
- `cached_network_image` - Image caching
- `shimmer` - Loading placeholders
- `carousel_slider` - Image carousels

### Location
- `geolocator` - GPS location
- `geocoding` - Address lookup
- `google_maps_flutter` - Maps integration

### Storage
- `shared_preferences` - Key-value storage
- `hive` - NoSQL database

### Utilities
- `get_it` - Dependency injection
- `permission_handler` - Runtime permissions
- `connectivity_plus` - Network connectivity

## Build & Release

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Testing

Run tests:
```bash
flutter test
```

## Code Generation

When you modify model files with @JsonSerializable:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Contributing

This project follows clean architecture principles. When adding new features:
1. Create feature folder under `lib/features/`
2. Follow the three-layer architecture (data, domain, presentation)
3. Use Bloc for state management
4. Write unit tests for business logic

## License

This project is licensed under the MIT License.

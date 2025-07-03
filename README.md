# MarketCoop

MarketCoop is a cross-platform marketplace application built with Flutter, supporting Android, iOS, web, and desktop platforms. The app allows users to browse products, manage carts, place orders, and interact with cooperatives and producers.

## Features
- User authentication (login/register)
- Product browsing and search
- Cart management
- Order placement and order history
- Wishlist functionality
- Profile management
- Producer dashboard
- Multi-language support (English, French, Arabic)
- Push notifications (Firebase)

## Project Structure
```
MarketCoop/
├── android/        # Native Android code and configuration
├── ios/            # Native iOS code and configuration
├── lib/            # Main Flutter/Dart source code
│   ├── models/     # Data models (Product, User, Order, etc.)
│   ├── providers/  # State management providers
│   ├── screens/    # UI screens
│   ├── utils/      # Utility functions and themes
│   └── widgets/    # Reusable UI components
├── web/            # Web-specific assets
├── macos/          # macOS desktop support
├── windows/        # Windows desktop support
├── test/           # Unit and widget tests
├── pubspec.yaml    # Flutter dependencies and assets
└── README.md       # Project documentation
```

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart SDK (comes with Flutter)
- Android Studio/Xcode for mobile builds
- Firebase account (for push notifications)

### Setup
1. **Clone the repository:**
   ```bash
   git clone <repo-url>
   cd MarketCoop
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Configure Firebase:**
   - Place your `google-services.json` (Android) in `android/app/` and `app/`.
   - For iOS, add your `GoogleService-Info.plist` to `ios/Runner/`.
4. **Run the app:**
   ```bash
   flutter run
   ```
   - To run on a specific platform: `flutter run -d <device>`

### Building for Release
- **Android:**
  ```bash
  flutter build apk
  ```
- **iOS:**
  ```bash
  flutter build ios
  ```
- **Web:**
  ```bash
  flutter build web
  ```

## Contribution Guidelines
1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a Pull Request

## License
This project is licensed under the MIT License.

## Contact
For questions or support, please open an issue or contact the maintainer. 
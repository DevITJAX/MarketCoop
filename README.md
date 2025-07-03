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

### Firebase/Google Service Configuration
**Important:** _You must set up your own Firebase project and download your own configuration files. Do not use any API keys or configuration files from this repository._

1. Go to [Firebase Console](https://console.firebase.google.com/) and create a new project.
2. Add an Android and/or iOS app to your Firebase project.
3. Download the `google-services.json` (for Android) and/or `GoogleService-Info.plist` (for iOS) from the Firebase Console.
4. Place `google-services.json` in `android/app/` and `app/` directories.
5. Place `GoogleService-Info.plist` in `ios/Runner/` directory.
6. **Do not commit these files to version control.**

> **Warning:** Never share your API keys or Firebase configuration files publicly. Add `google-services.json` and `GoogleService-Info.plist` to your `.gitignore` file.

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
   - Follow the steps above to add your own configuration files.
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
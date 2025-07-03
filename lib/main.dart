import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:marketcoop/providers/auth_provider.dart';
import 'package:marketcoop/providers/cart_provider.dart';
import 'package:marketcoop/providers/product_provider.dart';
import 'package:marketcoop/providers/wishlist_provider.dart';
import 'package:marketcoop/providers/review_provider.dart';
import 'package:marketcoop/providers/comment_provider.dart';
import 'package:marketcoop/providers/order_provider.dart';
import 'package:marketcoop/screens/splash_screen.dart';
import 'package:marketcoop/screens/wishlist_screen.dart';
import 'package:marketcoop/utils/theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  // Set up FCM background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MarketCoopApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // You can handle background messages here if needed
}

class MarketCoopApp extends StatelessWidget {
  const MarketCoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: Builder(
        builder: (context) {
          // Save FCM token to Firestore for the logged-in user
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          FirebaseMessaging.instance.getToken().then((token) async {
            if (token != null && authProvider.user != null) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(authProvider.user!.id)
                  .update({'fcmToken': token});
            }
          });

          // Listen for foreground messages
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {
            if (message.notification != null) {
              final notification = message.notification!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(notification.title != null
                      ? '${notification.title}: ${notification.body ?? ''}':
                      notification.body ?? ''),
                ),
              );
            }
          });

          return MaterialApp(
            title: 'MarketCoop',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
            routes: {
              '/wishlist': (context) => const WishlistScreen(),
            },
          );
        },
      ),
    );
  }
}

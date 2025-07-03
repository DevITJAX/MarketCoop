import 'package:flutter/material.dart';
import 'package:marketcoop/screens/home_screen.dart';
import 'package:marketcoop/screens/products_screen.dart';
import 'package:marketcoop/screens/cart_screen.dart';
import 'package:marketcoop/screens/profile_screen.dart';
import 'package:marketcoop/screens/wishlist_screen.dart';
import 'package:marketcoop/screens/my_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:marketcoop/providers/auth_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userRole = authProvider.user?.role ?? 'customer';

    // Customer navigation
    final customerScreens = [
      const HomeScreen(),
      const ProductsScreen(),
      const CartScreen(),
      const WishlistScreen(),
      const ProfileScreen(),
    ];
    final customerDestinations = const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.shopping_bag_outlined),
        selectedIcon: Icon(Icons.shopping_bag),
        label: 'Products',
      ),
      NavigationDestination(
        icon: Icon(Icons.shopping_cart_outlined),
        selectedIcon: Icon(Icons.shopping_cart),
        label: 'Cart',
      ),
      NavigationDestination(
        icon: Icon(Icons.favorite_border),
        selectedIcon: Icon(Icons.favorite),
        label: 'Wishlist',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    // Producer navigation
    final producerScreens = [
      const MyProductsScreen(),
      const ProfileScreen(),
    ];
    final producerDestinations = const [
      NavigationDestination(
        icon: Icon(Icons.list_alt_outlined),
        selectedIcon: Icon(Icons.list_alt),
        label: 'My Products',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    final isCustomer = userRole == 'customer';
    final screens = isCustomer ? customerScreens : producerScreens;
    final destinations =
        isCustomer ? customerDestinations : producerDestinations;

    // Clamp _currentIndex to valid range
    final maxIndex = screens.length - 1;
    if (_currentIndex > maxIndex) {
      _currentIndex = maxIndex;
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: destinations,
      ),
    );
  }
}

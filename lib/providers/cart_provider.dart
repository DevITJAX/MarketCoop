import 'package:flutter/foundation.dart';
import 'package:marketcoop/models/cart_item.dart';
import 'package:marketcoop/models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void addItem(Product product, {int quantity = 1}) {
    final existingIndex =
        _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      // Update existing item quantity
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      // Add new item
      _items.add(CartItem(product: product, quantity: quantity));
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  void incrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
      notifyListeners();
    }
  }

  void decrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final newQuantity = _items[index].quantity - 1;
      if (newQuantity <= 0) {
        removeItem(productId);
      } else {
        _items[index] = _items[index].copyWith(quantity: newQuantity);
        notifyListeners();
      }
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  int getQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
          product: Product(
              id: '',
              title: '',
              description: '',
              price: 0,
              category: '',
              imageUrl: '',
              producerId: ''),
          quantity: 0),
    );
    return item.quantity;
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}

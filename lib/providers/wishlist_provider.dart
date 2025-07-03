import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _wishlist = [];

  List<Product> get wishlist => List.unmodifiable(_wishlist);

  void addToWishlist(Product product) {
    if (!_wishlist.contains(product)) {
      _wishlist.add(product);
      notifyListeners();
    }
  }

  void removeFromWishlist(Product product) {
    if (_wishlist.contains(product)) {
      _wishlist.remove(product);
      notifyListeners();
    }
  }

  bool isInWishlist(Product product) {
    return _wishlist.contains(product);
  }

  void clearWishlist() {
    _wishlist.clear();
    notifyListeners();
  }
}

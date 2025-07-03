import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketcoop/models/product.dart';
import 'dart:math';

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';

  List<String> _categories = [
    'Fruits',
    'Vegetables',
    'Dairy',
    'Bakery',
    'Beverages',
    'Snacks',
  ];

  List<Product> get products => List.unmodifiable(_products);
  List<Product> get filteredProducts => List.unmodifiable(_filteredProducts);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    final categories = _products.map((p) => p.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  Future<void> loadProducts() async {
    _setLoading(true);
    _clearError();

    try {
      final snapshot = await _firestore.collection('products').get();
      _products = snapshot.docs.map((doc) {
        final data = doc.data();
        return Product.fromJson({...data, 'id': doc.id});
      }).toList();

      _applyFilters();
    } catch (e) {
      _setError('Failed to load products: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addProduct(Product product) async {
    _setLoading(true);
    _clearError();

    try {
      final docRef =
          await _firestore.collection('products').add(product.toJson());
      final newProduct = product.copyWith(id: docRef.id);
      _products.add(newProduct);
      _applyFilters();
    } catch (e) {
      _setError('Failed to add product: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProduct(Product product) async {
    _setLoading(true);
    _clearError();

    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toJson());
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index >= 0) {
        _products[index] = product;
        _applyFilters();
      }
    } catch (e) {
      _setError('Failed to update product: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteProduct(String productId) async {
    _setLoading(true);
    _clearError();

    try {
      await _firestore.collection('products').doc(productId).delete();
      _products.removeWhere((p) => p.id == productId);
      _applyFilters();
    } catch (e) {
      _setError('Failed to delete product: $e');
    } finally {
      _setLoading(false);
    }
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      _applyFilters();
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    _filteredProducts = _products.where((product) {
      return product.title.toLowerCase().contains(lowercaseQuery) ||
          product.description.toLowerCase().contains(lowercaseQuery) ||
          product.category.toLowerCase().contains(lowercaseQuery);
    }).toList();

    notifyListeners();
  }

  void _applyFilters() {
    if (_selectedCategory == 'All') {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products
          .where((product) => product.category == _selectedCategory)
          .toList();
    }
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  List<Product> getAvailableProducts() {
    return _products
        .where((product) => product.isAvailable && product.stockQuantity > 0)
        .toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void loadExampleProducts() {
    _products = [
      Product(
        id: '1',
        title: 'Organic Apples',
        description: 'Fresh and juicy organic apples from local farms.',
        price: 3.99,
        category: 'Fruits',
        imageUrl:
            'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce',
        stockQuantity: 50,
        isAvailable: true,
        producerId: '',
      ),
      Product(
        id: '2',
        title: 'Whole Wheat Bread',
        description: 'Healthy whole wheat bread, baked daily.',
        price: 2.49,
        category: 'Bakery',
        imageUrl:
            'https://images.unsplash.com/photo-1519864600265-abb23847ef2c',
        stockQuantity: 30,
        isAvailable: true,
        producerId: '',
      ),
      Product(
        id: '3',
        title: 'Free-Range Eggs',
        description: 'A dozen free-range eggs from happy hens.',
        price: 4.25,
        category: 'Dairy',
        imageUrl:
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
        stockQuantity: 100,
        isAvailable: true,
        producerId: '',
      ),
      Product(
        id: '4',
        title: 'Fresh Carrots',
        description: 'Crunchy and sweet carrots, perfect for salads.',
        price: 1.99,
        category: 'Vegetables',
        imageUrl:
            'https://images.unsplash.com/photo-1464226184884-fa280b87c399',
        stockQuantity: 80,
        isAvailable: true,
        producerId: '',
      ),
      Product(
        id: '5',
        title: 'Almond Milk',
        description: 'Unsweetened almond milk, lactose-free.',
        price: 3.50,
        category: 'Beverages',
        imageUrl:
            'https://images.unsplash.com/photo-1519864600265-abb23847ef2c',
        stockQuantity: 40,
        isAvailable: true,
        producerId: '',
      ),
    ];
    _applyFilters();
  }

  Future<void> generateRandomProducts(int count) async {
    final categories = [
      'Fruits',
      'Vegetables',
      'Dairy',
      'Bakery',
      'Beverages',
      'Snacks'
    ];
    final random = Random();
    for (int i = 0; i < count; i++) {
      final category = categories[random.nextInt(categories.length)];
      final product = Product(
        id: '', // Firestore will generate the ID
        title: 'Product ${random.nextInt(10000)}',
        description: 'This is a random $category product.',
        price: double.parse((random.nextDouble() * 20 + 1).toStringAsFixed(2)),
        category: category,
        imageUrl: '',
        stockQuantity: random.nextInt(100) + 1,
        isAvailable: random.nextBool(),
        producerId: '',
      );
      await _firestore.collection('products').add(product.toJson());
    }
    await loadProducts();
  }
}

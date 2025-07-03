import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as app_model;

class OrderProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<app_model.Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<app_model.Order> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchOrdersForUser(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('orderDate', descending: true)
          .get();
      _orders = snapshot.docs
          .map((doc) => app_model.Order.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      _error = 'Failed to load orders: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _orders = [];
    notifyListeners();
  }
} 
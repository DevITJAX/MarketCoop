import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment.dart';

class CommentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, List<Comment>> _productComments = {};

  List<Comment> getCommentsForProduct(String productId) {
    return _productComments[productId] ?? [];
  }

  Future<void> fetchComments(String productId) async {
    final snapshot = await _firestore
        .collection('comments')
        .where('productId', isEqualTo: productId)
        .orderBy('timestamp', descending: true)
        .get();
    _productComments[productId] = snapshot.docs
        .map((doc) => Comment.fromJson(doc.data(), doc.id))
        .toList();
    notifyListeners();
  }

  Future<void> addComment(Comment comment) async {
    await _firestore.collection('comments').add(comment.toJson());
  }

  void listenToComments(String productId) {
    _firestore
        .collection('comments')
        .where('productId', isEqualTo: productId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      _productComments[productId] = snapshot.docs
          .map((doc) => Comment.fromJson(doc.data(), doc.id))
          .toList();
      notifyListeners();
    });
  }

  // Fetch all comments for a list of productIds (for a producer)
  Future<void> fetchCommentsForProducts(List<String> productIds) async {
    if (productIds.isEmpty) return;
    // Firestore whereIn supports max 10 elements, so batch if needed
    List<Comment> allComments = [];
    for (var i = 0; i < productIds.length; i += 10) {
      final batch = productIds.skip(i).take(10).toList();
      final snap = await _firestore
          .collection('comments')
          .where('productId', whereIn: batch)
          .orderBy('timestamp', descending: true)
          .get();
      allComments.addAll(snap.docs.map((doc) => Comment.fromJson(doc.data(), doc.id)));
    }
    // Group by productId
    for (var comment in allComments) {
      _productComments.putIfAbsent(comment.productId, () => []);
      _productComments[comment.productId]!.add(comment);
    }
    notifyListeners();
  }

  // Get all comments for a list of productIds
  List<Comment> getCommentsForProducts(List<String> productIds) {
    List<Comment> result = [];
    for (var id in productIds) {
      result.addAll(getCommentsForProduct(id));
    }
    return result;
  }
} 
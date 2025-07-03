import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';

class ReviewProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, List<Review>> _productReviews = {};

  List<Review> getReviewsForProduct(String productId) {
    return _productReviews[productId] ?? [];
  }

  double getAverageScore(String productId) {
    final reviews = getReviewsForProduct(productId);
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold<int>(0, (sum, r) => sum + r.rating);
    return total / reviews.length;
  }

  Future<void> fetchReviews(String productId) async {
    debugPrint('Fetching reviews for product: ' + productId);
    final snapshot = await _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('timestamp', descending: true)
        .get();
    debugPrint('Fetched \'${snapshot.docs.length}\' reviews for product: ' + productId);
    _productReviews[productId] = snapshot.docs
        .map((doc) => Review.fromJson(doc.data(), doc.id))
        .toList();
    notifyListeners();
  }

  Future<void> addReview(Review review) async {
    debugPrint('Adding review for product: ' + review.productId + ', rating: ' + review.rating.toString());
    await _firestore.collection('reviews').add(review.toJson());
    debugPrint('Review added for product: ' + review.productId);
  }

  Future<void> listenToReviews(String productId) async {
    debugPrint('Listening to reviews for product: ' + productId);
    _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      debugPrint('Received snapshot with \'${snapshot.docs.length}\' reviews for product: ' + productId);
      _productReviews[productId] = snapshot.docs
          .map((doc) => Review.fromJson(doc.data(), doc.id))
          .toList();
      notifyListeners();
    });
  }

  // Fetch all reviews for a list of productIds (for a producer)
  Future<void> fetchReviewsForProducts(List<String> productIds) async {
    debugPrint('Fetching reviews for products: ' + productIds.join(", "));
    if (productIds.isEmpty) return;
    final snapshot = await _firestore
        .collection('reviews')
        .where('productId', whereIn: productIds.length > 10 ? productIds.sublist(0, 10) : productIds)
        .orderBy('timestamp', descending: true)
        .get();
    // Firestore whereIn supports max 10 elements, so batch if needed
    List<Review> allReviews = [];
    for (var i = 0; i < productIds.length; i += 10) {
      final batch = productIds.skip(i).take(10).toList();
      final snap = await _firestore
          .collection('reviews')
          .where('productId', whereIn: batch)
          .orderBy('timestamp', descending: true)
          .get();
      allReviews.addAll(snap.docs.map((doc) => Review.fromJson(doc.data(), doc.id)));
    }
    // Group by productId
    for (var review in allReviews) {
      _productReviews.putIfAbsent(review.productId, () => []);
      _productReviews[review.productId]!.add(review);
    }
    notifyListeners();
  }

  // Get all reviews for a list of productIds
  List<Review> getReviewsForProducts(List<String> productIds) {
    List<Review> result = [];
    for (var id in productIds) {
      result.addAll(getReviewsForProduct(id));
    }
    return result;
  }
}

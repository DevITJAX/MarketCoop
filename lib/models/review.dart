import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final int rating;
  final String comment;
  final DateTime timestamp;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.timestamp,
  }) : assert(rating >= 1 && rating <= 10, 'Rating must be between 1 and 10');

  factory Review.fromJson(Map<String, dynamic> json, String id) {
    return Review(
      id: id,
      productId: json['productId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp,
    };
  }

  Review copyWith({
    String? id,
    String? productId,
    String? userId,
    String? userName,
    int? rating,
    String? comment,
    DateTime? timestamp,
  }) {
    return Review(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

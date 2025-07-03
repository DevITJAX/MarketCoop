import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String comment;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.timestamp,
  });

  factory Comment.fromJson(Map<String, dynamic> json, String id) {
    return Comment(
      id: id,
      productId: json['productId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      comment: json['comment'] ?? '',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'comment': comment,
      'timestamp': timestamp,
    };
  }
} 
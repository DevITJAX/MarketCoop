import 'package:marketcoop/models/cart_item.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime orderDate;
  final String? shippingAddress;
  final String? paymentMethod;
  final String? trackingNumber;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    this.status = OrderStatus.pending,
    DateTime? orderDate,
    this.shippingAddress,
    this.paymentMethod,
    this.trackingNumber,
  }) : orderDate = orderDate ?? DateTime.now();

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartItem.fromJson(item))
          .toList() ?? [],
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.pending,
      ),
      orderDate: json['orderDate'] != null 
          ? DateTime.parse(json['orderDate']) 
          : DateTime.now(),
      shippingAddress: json['shippingAddress'],
      paymentMethod: json['paymentMethod'],
      trackingNumber: json['trackingNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'orderDate': orderDate.toIso8601String(),
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'trackingNumber': trackingNumber,
    };
  }

  Order copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    double? totalAmount,
    OrderStatus? status,
    DateTime? orderDate,
    String? shippingAddress,
    String? paymentMethod,
    String? trackingNumber,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      trackingNumber: trackingNumber ?? this.trackingNumber,
    );
  }

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  String toString() {
    return 'Order(id: $id, status: $statusText, total: \$${totalAmount.toStringAsFixed(2)})';
  }
} 
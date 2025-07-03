class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final String producerId;
  final int stockQuantity;
  final bool isAvailable;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.producerId,
    this.stockQuantity = 0,
    this.isAvailable = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      producerId: json['producerId'] ?? '',
      stockQuantity: json['stockQuantity'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'producerId': producerId,
      'stockQuantity': stockQuantity,
      'isAvailable': isAvailable,
    };
  }

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
    String? producerId,
    int? stockQuantity,
    bool? isAvailable,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      producerId: producerId ?? this.producerId,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $price, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

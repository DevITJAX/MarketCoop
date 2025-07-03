class User {
  final String id;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? address;
  final String? profileImageUrl;
  final String role;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  User({
    required this.id,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.address,
    this.profileImageUrl,
    this.role = 'customer',
    DateTime? createdAt,
    DateTime? lastLoginAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastLoginAt = lastLoginAt ?? DateTime.now();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      profileImageUrl: json['profileImageUrl'],
      role: json['role'] ?? 'customer',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'address': address,
      'profileImageUrl': profileImageUrl,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? address,
    String? profileImageUrl,
    String? role,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

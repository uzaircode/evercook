import 'package:evercook/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.updatedAt,
    required super.name,
    required super.bio,
    required super.avatar,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      updatedAt: map['updated_at'] == null ? DateTime.now() : DateTime.parse(map['updated_at'] as String),
      name: map['name'] ?? '',
      bio: map['bio'] ?? '',
      avatar: map['avatar_url'] ?? '',
      email: map['email'] ?? '',
    );
  }

  UserModel copyWith({
    String? id,
    DateTime? updatedAt,
    String? name,
    String? bio,
    String? avatar,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updated_at': updatedAt.toIso8601String(),
      'name': name,
      'bio': bio,
      'avatar_url': avatar,
      'email': email,
    };
  }

  @override
  String toString() {
    return 'UserModel{id: $id, updated_at: $updatedAt, name: $name, bio: $bio, avatar: $avatar, email: $email}';
  }
}

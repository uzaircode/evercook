import 'package:evercook/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.bio,
    required super.avatar,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      bio: map['bio'] ?? '',
      avatar: map['avatar_url'] ?? '',
      email: map['email'] ?? '',
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? bio,
    String? avatar,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
    );
  }
}

import 'package:evercook/features/cookbook/domain/entities/cookbook.dart';

class CookbookModel extends Cookbook {
  CookbookModel({
    required super.id,
    required super.title,
    required super.public,
  });

  CookbookModel copyWith({
    String? id,
    String? title,
    bool? public,
  }) {
    return CookbookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      public: public ?? this.public,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'public': public,
    };
  }

  factory CookbookModel.fromJson(Map<String, dynamic> map) {
    return CookbookModel(
      id: map['id'] as String?,
      title: map['title'] as String?,
      public: map['public'] as bool?,
    );
  }

  @override
  String toString() {
    return 'CookbookMode(id: $id, name: $title, public: $public)';
  }
}

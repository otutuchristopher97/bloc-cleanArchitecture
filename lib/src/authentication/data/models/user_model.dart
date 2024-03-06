import 'dart:convert';

import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.avatar,
    required super.id,
    required super.createdAt,
    required super.name,
  });

  const UserModel.empty()
      : this(
            id: '1',
            createdAt: '_empty.createdAt',
            name: '_empty.name',
            avatar: '_empty.avatar');

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel.fromMap(DataMap map)
      : this(
            avatar: map['avatar'] as String,
            id: map['id'] as String,
            createdAt: map['createdAt'] as String,
            name: map['name'] as String);

  UserModel copyWith({
    String? avatar,
    String? id,
    String? createdAt,
    String? name,
  }) {
    return UserModel(
      avatar: avatar ?? this.avatar, 
      id: id ?? this.id, 
      createdAt: createdAt ?? this.createdAt, 
      name: name ?? this.name
    );
  }

  DataMap toMap() => {
        'id': id,
        'avatar': avatar,
        'createdAt': createdAt,
        'name': name,
      };

  String toJson() => jsonEncode(toMap());
}

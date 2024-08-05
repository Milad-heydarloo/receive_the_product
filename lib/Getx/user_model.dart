import 'dart:convert';

class User {
  String id;
  String username;
  bool verified;
  String email;
  String name;
  String avatar;
  String family;
  List<String> availability;

  User({
    required this.id,
    required this.username,
    required this.verified,
    required this.email,
    required this.name,
    required this.avatar,
    required this.family,
    required this.availability,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] ?? '',
    username: json['username'] ?? '',
    verified: json['verified'] ?? false,
    email: json['email'] ?? '',
    name: json['name'] ?? '',
    avatar: json['avatar'] ?? '',
    family: json['family'] ?? '',
    availability: List<String>.from(json['availability'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'verified': verified,
    'email': email,
    'name': name,
    'avatar': avatar,
    'family': family,
    'availability': availability,
  };

  @override
  String toString() => jsonEncode(toJson());
}

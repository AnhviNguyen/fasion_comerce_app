// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
    String id;
    String password;
    String email;
    String username;

    User({
        required this.id,
        required this.password,
        required this.email,
        required this.username,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        password: json["password"],
        email: json["email"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "password": password,
        "email": email,
        "username": username,
    };
}

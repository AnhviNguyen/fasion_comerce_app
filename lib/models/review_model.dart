// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

import 'package:shop/models/user_model.dart';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    String id;
    String productId;
    int rating;
    String comment;
    String title;
    String userId;
    DateTime timestamp;
    User user;

    Review({
        required this.id,
        required this.productId,
        required this.rating,
        required this.comment,
        required this.title,
        required this.userId,
        required this.timestamp,
        required this.user,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        productId: json["productId"],
        rating: json['rating'],
        comment: json["comment"],
        title: json["title"],
        userId: json["userId"],
        timestamp: DateTime.parse(json["timestamp"]),
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "rating": rating,
        "comment": comment,
        "title": title,
        "userId": userId,
        "timestamp": timestamp.toIso8601String(),
        "user": user.toJson(),
    };
}



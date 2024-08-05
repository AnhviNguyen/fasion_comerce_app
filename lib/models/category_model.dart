// class CategoryModel {
//   final String title;
//   final String? image, svgSrc;
//   final List<CategoryModel>? subCategories;

//   CategoryModel({
//     required this.title,
//     this.image,
//     this.svgSrc,
//     this.subCategories,
//   });
// }

// final List<CategoryModel> demoCategoriesWithImage = [
//   CategoryModel(title: "Woman’s", image: "https://i.imgur.com/5M89G2P.png"),
//   CategoryModel(title: "Man’s", image: "https://i.imgur.com/UM3GdWg.png"),
//   CategoryModel(title: "Kid’s", image: "https://i.imgur.com/Lp0D6k5.png"),
//   CategoryModel(title: "Accessories", image: "https://i.imgur.com/3mSE5sN.png"),
// ];

// final List<CategoryModel> demoCategories = [
//   CategoryModel(
//     title: "On sale",
//     svgSrc: "assets/icons/Sale.svg",
//     subCategories: [
//       CategoryModel(title: "All Clothing"),
//       CategoryModel(title: "New In"),
//       CategoryModel(title: "Coats & Jackets"),
//       CategoryModel(title: "Dresses"),
//       CategoryModel(title: "Jeans"),
//     ],
//   ),
//   CategoryModel(
//     title: "Man’s & Woman’s",
//     svgSrc: "assets/icons/Man&Woman.svg",
//     subCategories: [
//       CategoryModel(title: "All Clothing"),
//       CategoryModel(title: "New In"),
//       CategoryModel(title: "Coats & Jackets"),
//     ],
//   ),
//   CategoryModel(
//     title: "Kids",
//     svgSrc: "assets/icons/Child.svg",
//     subCategories: [
//       CategoryModel(title: "All Clothing"),
//       CategoryModel(title: "New In"),
//       CategoryModel(title: "Coats & Jackets"),
//     ],
//   ),
//   CategoryModel(
//     title: "Accessories",
//     svgSrc: "assets/icons/Accessories.svg",
//     subCategories: [
//       CategoryModel(title: "All Clothing"),
//       CategoryModel(title: "New In"),
//     ],
//   ),
// ];

// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

List<Category> categoryFromJson(String str) => List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
    String id;
    String name;
    String description;
    String imagePath;

    Category({
        required this.id,
        required this.name,
        required this.description,
        required this.imagePath,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        imagePath: json["image_path"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image_path": imagePath,
    };
}


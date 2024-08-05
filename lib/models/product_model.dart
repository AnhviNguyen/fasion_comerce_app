// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    String id;
    bool availableSize;
    List<String> sizes;
    double price;
    double raking;
    String name;
    String productDescription;
    bool availableColors;
    double salePrice;
    List<String> colors;
    String idCate;
    String brandId;
    String imagePath;
    String brandName;
    double discount;

    Product({
        required this.id,
        required this.availableSize,
        required this.sizes,
        required this.price,
        required this.raking,
        required this.name,
        required this.productDescription,
        required this.availableColors,
        required this.salePrice,
        required this.colors,
        required this.idCate,
        required this.brandId,
        required this.imagePath,
        required this.brandName,
        required this.discount,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        availableSize: json["available_size"],
        sizes: List<String>.from(json["sizes"].map((x) => x)),
        price: json["price"]?.toDouble(),
        raking: json["raking"]?.toDouble(),
        name: json["name"],
        productDescription: json["product_description"],
        availableColors: json["available_colors"],
        salePrice: json["sale_price"]?.toDouble(),
        colors: List<String>.from(json["colors"].map((x) => x)),
        idCate: json["id_cate"],
        brandId: json["brand_id"],
        imagePath: json["image_path"],
        brandName: json["brand_name"],
        discount: json["discount"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "available_size": availableSize,
        "sizes": List<dynamic>.from(sizes.map((x) => x)),
        "price": price,
        "raking": raking,
        "name": name,
        "product_description": productDescription,
        "available_colors": availableColors,
        "sale_price": salePrice,
        "colors": List<dynamic>.from(colors.map((x) => x)),
        "id_cate": idCate,
        "brand_id": brandId,
        "image_path": imagePath,
        "brand_name": brandName,
        "discount": discount,
    };
}

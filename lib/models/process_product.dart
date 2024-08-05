// To parse this JSON data, do
//
//     final processProduct = processProductFromJson(jsonString);

import 'dart:convert';

List<ProcessProduct> processProductFromJson(String str) => List<ProcessProduct>.from(json.decode(str).map((x) => ProcessProduct.fromJson(x)));

String processProductToJson(List<ProcessProduct> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProcessProduct {
    String id;
    bool availableSize;
    bool availableColors;
    double salePrice;
    List<String> colors;
    String idCate;
    String brandId;
    List<String> sizes;
    String imagePath;
    double price;
    double raking;
    String name;
    String productDescription;
    String idUser;

    ProcessProduct({
        required this.id,
        required this.availableSize,
        required this.availableColors,
        required this.salePrice,
        required this.colors,
        required this.idCate,
        required this.brandId,
        required this.sizes,
        required this.imagePath,
        required this.price,
        required this.raking,
        required this.name,
        required this.productDescription,
        required this.idUser,
    });

    factory ProcessProduct.fromJson(Map<String, dynamic> json) => ProcessProduct(
        id: json["id"],
        availableSize: json["available_size"],
        availableColors: json["available_colors"],
        salePrice: json["sale_price"]?.toDouble(),
        colors: List<String>.from(json["colors"].map((x) => x)),
        idCate: json["id_cate"],
        brandId: json["brand_id"],
        sizes: List<String>.from(json["sizes"].map((x) => x)),
        imagePath: json["image_path"],
        price: json["price"]?.toDouble(),
        raking: json["raking"]?.toDouble(),
        name: json["name"],
        productDescription: json["product_description"],
        idUser: json["id_user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "available_size": availableSize,
        "available_colors": availableColors,
        "sale_price": salePrice,
        "colors": List<dynamic>.from(colors.map((x) => x)),
        "id_cate": idCate,
        "brand_id": brandId,
        "sizes": List<dynamic>.from(sizes.map((x) => x)),
        "image_path": imagePath,
        "price": price,
        "raking": raking,
        "name": name,
        "product_description": productDescription,
        "id_user": idUser,
    };
}

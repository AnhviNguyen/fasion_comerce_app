

import 'dart:convert';

import 'package:shop/models/product_model.dart';

List<Cart> cartFromJson(String str) => List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));

String cartToJson(List<Cart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cart {
    Product product;
    int quantity;

    Cart({
        required this.product,
        required this.quantity,
    });

    factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        product: Product.fromJson(json["product"]),
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "product": product.toJson(),
        "quantity": quantity,
    };
}

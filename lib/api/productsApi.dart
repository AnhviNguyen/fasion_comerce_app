import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/api/constantLink.dart';
import 'package:shop/models/process_product.dart';
import 'package:shop/models/product_model.dart';

fetchProductPopular() async {
  Uri url = Uri.parse(Constantlink.baseUrl + "product/popular");
  var response = await http.get(url);
  try {
    if (response.statusCode == 200) {
      var data = productFromJson(response.body);
      debugPrint(data.toString());
      return data;
    } else {
      print("Bug something");
    }
  } catch (error) {
    print(error.toString());
  }
}

fetchProductByCate(String idCate) async {
  Uri url = Uri.parse(Constantlink.baseUrl + "product/productByCate/" + idCate);
  var response = await http.get(url);
  try {
    if (response.statusCode == 200) {
      var data = productFromJson(response.body);
      print(data.toString());
      return data;
    } else {
      print("Bug something");
    }
  } catch (error) {
    print(error.toString());
  }
}

Future<dynamic> fetchProductByFilter(
    String size, String priceRange, String sort) async {
  Uri url = Uri.parse(Constantlink.baseUrl + "product/productsWithFilter")
      .replace(queryParameters: {
    'size': size,
    'priceRange': priceRange,
    'sort': sort,
  });

  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = productFromJson(response.body);
      print(data.toString());
      return data;
    } else {
      print("Error: ${response.statusCode}");
    }
  } catch (error) {
    print("Error: $error");
  }
}

fetchProcessProduct(String userId) async {
  Uri url = Uri.parse(Constantlink.baseUrl + "process_product/read/" + userId);
  var response = await http.get(url);
  try {
    if (response.statusCode == 200) {
      var data = processProductFromJson(response.body);
      print(url.toString());
      print(data.toString());
      return data;
    } else {
      print("Bug something");
    }
  } catch (error) {
    print(error.toString());
  }
}

fetchCancelProduct(String userId) async {
  Uri url = Uri.parse(Constantlink.baseUrl + "cancel_product/read/" + userId);
  var response = await http.get(url);
  try {
    if (response.statusCode == 200) {
      var data = processProductFromJson(response.body);
      debugPrint(data.toString());
      return data;
    } else {
      print("Bug something");
    }
  } catch (error) {
    print(error.toString());
  }
}

fetchDeliveredProduct(String userId) async {
  Uri url =
      Uri.parse(Constantlink.baseUrl + "delivered_product/read/" + userId);
  var response = await http.get(url);
  try {
    if (response.statusCode == 200) {
      var data = processProductFromJson(response.body);
      debugPrint(data.toString());
      return data;
    } else {
      print("Bug something");
    }
  } catch (error) {
    print(error.toString());
  }
}

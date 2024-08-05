import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/api/constantLink.dart';
import 'package:shop/models/cart_model.dart';
import 'package:shop/models/category_model.dart';

fetchBookmark(String idUser) async {
  Uri url = Uri.parse(Constantlink.baseUrl.toString() + "bookmark/read/" + idUser);
  var response = await http.get(url);
  try {
    if (response.statusCode == 200) {
      print(url.toString());
      var data = cartFromJson(response.body);
      print(data.toString());
      return data;
    } else {
      print(url.toString());
      print("Bug something");
    }
  } catch (error) {
    print(error.toString());
  }
}

fetchCart(String idUser) async {
  Uri url = Uri.parse(Constantlink.baseUrl.toString() + "cart/read/" + idUser);
  var response = await http.get(url);
  try {
    if (response.statusCode == 200) {
      print(url.toString());
      var data = cartFromJson(response.body);
      print(data.toString());
      return data;
    } else {
      print(url.toString());
      print("Bug something");
    }
  } catch (error) {
    print(error.toString());
  }
}

Future<bool> deleteBookmark(String userId, String productId) async {
  Uri url = Uri.parse('${Constantlink.baseUrl}bookmark/delete/$userId/$productId');

  try {
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Product removed from cart successfully.');
      return true;
    } else {
      print('Failed to remove product from cart: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error removing product from cart: $e');
     return false;
  }
}

Future<void> deleteCart(String userId, String productId) async {
  Uri url = Uri.parse('${Constantlink.baseUrl}cart/delete/$userId/$productId');

  try {
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Product removed from cart successfully.');
    } else {
      print('Failed to remove product from cart: ${response.statusCode}');
    }
  } catch (e) {
    print('Error removing product from cart: $e');
  }
}

Future<bool> addToBookmark(String userId, String productId) async {
  Uri url = Uri.parse('${Constantlink.baseUrl}bookmark/create/');

  Map<String, dynamic> body = {
    'userId': userId,
    'productId': productId,
    'quantity': 1,
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Product added to bookmark successfully.');
      return true;
    } else {
      print('Failed to add product to bookmark: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error adding product to bookmark: $e');
    return false;
  }
}

Future<void> updateCart(String userId, String productId, int quantity) async {
  Uri url = Uri.parse('${Constantlink.baseUrl}cart/update/$userId/$productId');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Specify the content type
      },
      body: jsonEncode({
        'quantity': quantity, // Send the updated quantity
      }),
    );

    if (response.statusCode == 200) {
      print('Quantity updated successfully');
    } else {
      print('Failed to update quantity: ${response.body}');
    }
  } catch (e) {
    print('Error updating cart: $e');
  }
}

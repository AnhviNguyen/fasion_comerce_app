import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/api/constantLink.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/models/review_model.dart';

fetchReview(String idProduct) async {
  Uri url = Uri.parse(Constantlink.baseUrl + "review/by-product/" + idProduct);
  var response = await http.get(url);
  try {
    if (response.statusCode == 200) {
      var data = reviewFromJson(response.body);
      print("url: " + url.toString());
      print(data.toString());
      return data;
    } else {
      print("Bug something");
    }
  } catch (error) {
    print(error.toString());
  }
}

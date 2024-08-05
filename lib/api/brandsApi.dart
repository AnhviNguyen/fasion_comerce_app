

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/api/constantLink.dart';
import 'package:shop/models/category_model.dart';


fetchBrand() async {
  Uri url = Uri.parse(Constantlink.baseUrl + "brand/read/all");
  var response = await http.get(url);
  try {
    if (response.statusCode == 200) {
      var data = categoryFromJson(response.body);
      debugPrint(data.toString());
      return data;
    } else {
      print("Bug something");
    }
  } catch (error) {
    print(error.toString());
  }
}

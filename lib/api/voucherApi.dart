import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/api/constantLink.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/models/voucher_model.dart';


fetchVouchers() async {
  Uri url = Uri.parse(Constantlink.baseUrl + "voucher/read/all");
  var response = await http.get(url);
  try {
    if (response.statusCode == 200) {
      var data = voucherFromJson(response.body);
      debugPrint(data.toString());
      return data;
    } else {
      print("Bug something");
    }
  } catch (error) {
    print(error.toString());
  }
}

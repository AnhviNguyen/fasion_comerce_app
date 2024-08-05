import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop/api/constantLink.dart';
import 'package:shop/models/product_model.dart';

class SearchProvider with ChangeNotifier {
  List<Product> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';
  TextEditingController queryController = TextEditingController();

  List<Product> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(Constantlink.baseUrl+'product/search?query=$query'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _searchResults = (data['products'] as List)
            .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
            .toList();
      } else {
        _errorMessage = 'Failed to load results';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void _toogleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toogleFavorite(String token, String userId) async {
    try {
      _toogleFavorite();

      final response = await http.put(
        Uri.parse(
            '${Constants.BASE_URL}/userFavorite/$userId/$id.json?auth=$token'),
        body: jsonEncode(isFavorite),
      );
      if (response.statusCode >= 400) {
        _toogleFavorite();
      }
    } catch (_) {
      _toogleFavorite();
    }
  }
}

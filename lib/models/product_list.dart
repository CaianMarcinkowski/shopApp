import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/product.dart';
import 'package:shop/utils/constants.dart';

import '../exceptions/http_exception.dart';

class ProductList with ChangeNotifier {
  String _token;
  String _userId;
  List<Product> _items = [];

  List<Product> get items => [..._items];
  List<Product> get favoritesItems =>
      _items.where((product) => product.isFavorite).toList();

  ProductList([this._token = '', this._items = const [], this._userId = '']);

  Future<void> loadingProducts() async {
    _items.clear();

    final response = await http
        .get(Uri.parse('${Constants.BASE_URL}/products.json?auth=$_token'));

    if (response.body == 'null') return;

    final favoritesResponse = await http.get(
      Uri.parse(
          '${Constants.BASE_URL}/userFavorite/$_userId.json?auth=$_token'),
    );

    Map<String, dynamic> favoriteData = favoritesResponse.body == 'null'
        ? {}
        : jsonDecode(favoritesResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      final isFavorite = favoriteData[productId] ?? false;
      _items.add(Product(
        id: productId,
        name: productData['name'],
        description: productData['description'],
        price: productData['price'],
        imageUrl: productData['image'],
        isFavorite: isFavorite,
      ));
    });
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}/products.json?auth=$_token'),
      body: jsonEncode({
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "image": product.imageUrl,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final newProduct = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );
    if (hasId) {
      return updateProduct(newProduct);
    } else {
      return addProduct(newProduct);
    }
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    String productId = product.id;

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.BASE_URL}/products/$productId.json?auth=$_token'),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "image": product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    String productId = product.id;

    if (index >= 0) {
      final product = _items[index];

      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.BASE_URL}/products/$productId.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possivel excluir o produto',
          statusCode: response.statusCode,
        );
      }
    }
  }

  int get itemsCount {
    return _items.length;
  }

  // bool _showFavoriteOnly = false;

  // List<Product> get items {
  //   if (_showFavoriteOnly) {
  //     return _items.where((product) => product.isFavorite).toList();
  //   }
  //   return [..._items];
  // }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }
}

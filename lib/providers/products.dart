import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  String? _token;
  Products(this._token, this._items);

  Future<void> fetchAndSetProduct() async {
    try {
      final url = Uri.parse(
        'https://flutter-begineer-18e51-default-rtdb.asia-southeast1.firebasedatabase.app/items.json?auth=$_token',
      );
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      if (extractedData == null) return;
      final List<Product> loadedProducts = [];
      (extractedData as Map<String, dynamic>).forEach(
        (prodId, prodValue) {
          final item = new Product(
            id: prodId,
            description: prodValue['description'],
            imageUrl: prodValue['imageUrl'],
            price: prodValue['price'],
            title: prodValue['title'],
            isFavourite: prodValue['isFavourite'],
          );
          loadedProducts.add(item);
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw HttpException("Failed to load Products");
    }
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  Product findById(itemId) {
    return _items.firstWhere((item) => item.id == itemId);
  }

  Future<void> editProduct(productId, Product updatedProduct) async {
    int itemIndex = _items.indexWhere((item) => item.id == productId);
    if (itemIndex < 0) return;
    try {
      final url = Uri.parse(
        'https://flutter-begineer-18e51-default-rtdb.asia-southeast1.firebasedatabase.app/items/$productId.json?auth=$_token',
      );
      await http.patch(
        url,
        body: json.encode({
          'title': updatedProduct.title,
          'description': updatedProduct.description,
          'price': updatedProduct.price,
          'isFavourite': updatedProduct.isFavourite,
          'imageUrl': updatedProduct.imageUrl
        }),
      );
      _items[itemIndex] = updatedProduct;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product item) async {
    final url = Uri.parse(
      'https://flutter-begineer-18e51-default-rtdb.asia-southeast1.firebasedatabase.app/items.json?auth=$_token',
    );
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': item.title,
            'description': item.description,
            'price': item.price,
            'isFavourite': item.isFavourite,
            'imageUrl': item.imageUrl,
          },
        ),
      );
      final Product newItem = new Product(
        id: json.decode(response.body)['name'],
        description: item.description,
        imageUrl: item.imageUrl,
        price: item.price,
        title: item.title,
      );

      _items.add(newItem);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> deleteProduct(productId) async {
    final productIndex = _items.indexWhere((item) => item.id == productId);
    var item = _items[productIndex];
    final url = Uri.parse(
      'https://flutter-begineer-18e51-default-rtdb.asia-southeast1.firebasedatabase.app/items/$productId.json?auth=$_token',
    );
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productIndex, item);
      notifyListeners();
      throw HttpException('Could not delete product!');
    }
  }
}

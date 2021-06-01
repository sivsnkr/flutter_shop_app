import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  Future<void> fetchAndSetProduct() async {
    try {
      final url = Uri.parse(
        'https://flutter-begineer-18e51-default-rtdb.asia-southeast1.firebasedatabase.app/items.json',
      );
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach(
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
      print(error);
      throw error;
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
        'https://flutter-begineer-18e51-default-rtdb.asia-southeast1.firebasedatabase.app/items/$productId.json',
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
      'https://flutter-begineer-18e51-default-rtdb.asia-southeast1.firebasedatabase.app/items.json',
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
      'https://flutter-begineer-18e51-default-rtdb.asia-southeast1.firebasedatabase.app/items/$productId.json',
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

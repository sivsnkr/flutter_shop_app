import 'package:flutter/material.dart';

import 'product.dart';

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
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  Product findById(itemId) {
    return _items.firstWhere((item) => item.id == itemId);
  }

  void editProduct(productId, updatedProduct) {
    int itemIndex = _items.indexWhere((item) => item.id == productId);
    if (itemIndex < 0) return;
    _items[itemIndex] = updatedProduct;
    notifyListeners();
  }

  void addProduct(Product item) {
    item = new Product(
        id: item.id.length == 0 ? DateTime.now().toString() : item.id,
        description: item.description,
        imageUrl: item.imageUrl,
        price: item.price,
        title: item.title);
    _items.add(item);
    notifyListeners();
  }

  void deleteProduct(productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }
}

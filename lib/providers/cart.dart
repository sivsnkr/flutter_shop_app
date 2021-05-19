import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final price;
  final quantity;
  CartItem({
    required this.id,
    required this.price,
    required this.title,
    required this.quantity,
  });

  double get totalPrice {
    return price * quantity;
  }
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItems(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingValue) => CartItem(
          id: existingValue.id,
          price: existingValue.price,
          quantity: existingValue.quantity + 1,
          title: existingValue.title,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: _items.length.toString(),
          price: price,
          title: title,
          quantity: 1,
        ),
      );
    }
  }
}

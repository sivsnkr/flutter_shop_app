import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> orderItem, double amount) {
    final url = Uri.parse(
      'https://flutter-begineer-18e51-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json',
    );
    final timeStamp = DateTime.now();
    http.post(
      url,
      body: json.encode({
        'amount': amount,
        'products': orderItem
            .map(
              (item) => {
                'id': item.id,
                'title': item.title,
                'price': item.price,
                'quantity': item.quantity,
              },
            )
            .toList(),
        'dateTime': timeStamp.toIso8601String(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: timeStamp.toString(),
        amount: amount,
        products: orderItem,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }

  int count() {
    return _orders.length;
  }
}

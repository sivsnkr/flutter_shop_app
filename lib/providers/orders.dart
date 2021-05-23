import 'package:flutter/foundation.dart';

import './cart.dart';

class OrderItems {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTiime;
  OrderItems({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTiime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItems> _orders = [];

  List<OrderItems> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> orderItem, double amount) {
    _orders.insert(
      0,
      OrderItems(
        id: DateTime.now().toString(),
        amount: amount,
        products: orderItem,
        dateTiime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

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
  String? _token;
  String? _userId;

  Orders(this._token, this._orders, this._userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrder() async {
    final url = Uri.parse(
        'https://flutter-begineer-18e51-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$_userId.json?auth=$_token');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      if (extractedData == null) return;
      List<OrderItem> fetchedOrders = [];
      (extractedData as Map<String, dynamic>).forEach((orderId, orderValue) {
        final orderItem = new OrderItem(
          amount: orderValue['amount'],
          dateTime: DateTime.parse(orderValue['dateTime']),
          id: orderId,
          products: (orderValue['products'] as List<dynamic>).map(
            (cartItem) {
              return new CartItem(
                id: cartItem['id'],
                price: cartItem['price'],
                quantity: cartItem['quantity'],
                title: cartItem['title'],
              );
            },
          ).toList(),
        );
        fetchedOrders.add(orderItem);
      });
      _orders = fetchedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw HttpException("Cannot fetch orders");
    }
  }

  Future<void> addOrder(List<CartItem> orderItem, double amount) async {
    final url = Uri.parse(
      'https://flutter-begineer-18e51-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$_userId.json?auth=$_token',
    );
    final timeStamp = DateTime.now();
    try {
      var response = await http.post(
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
          id: json.decode(response.body)['name'],
          amount: amount,
          products: orderItem,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw HttpException("Unable to add order");
    }
  }

  int count() {
    return _orders.length;
  }
}

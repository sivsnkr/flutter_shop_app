import 'package:flutter/widgets.dart';

class CartItem {
  final String id;
  final String title;
  final price;
  final quantity;
  CartItem({
    @required required this.id,
    @required required this.price,
    @required required this.title,
    @required required this.quantity,
  });

  double get totalPrice {
    return price * quantity;
  }
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  String? _token;

  Cart(this._token, this._items);
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
    notifyListeners();
  }

  void removeSingleItem(productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]?.quantity > 1) {
      _items.update(
        productId,
        (existingItem) => CartItem(
            id: existingItem.id,
            price: existingItem.price,
            title: existingItem.title,
            quantity: existingItem.quantity - 1),
      );
      notifyListeners();
      return;
    }

    removeItem(productId);
  }

  void removeItem(productId) {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
      notifyListeners();
    }
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((productId, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';
import './orders_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();
    final cartKeys = cart.items.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: const TextStyle(fontSize: 20),
                  ),
                  // Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      'Rs ${cart.totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).primaryTextTheme.headline6,
                    ),
                  ),
                  TextButton(
                    child: const Text(
                      'Order Now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      if (cartItems.length > 0)
                        Provider.of<Orders>(context, listen: false).addOrder(
                          cartItems,
                          cart.totalAmount,
                        );
                      cart.clearCart();
                      Navigator.of(context).pushNamed(OrdersScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return CartItem(
                  productId: cartKeys[index],
                  id: cartItems[index].id,
                  title: cartItems[index].title,
                  price: cartItems[index].price,
                  quantity: cartItems[index].quantity,
                  removeItem: cart.removeItem,
                );
              },
              itemCount: cartItems.length,
            ),
          ),
        ],
      ),
    );
  }
}

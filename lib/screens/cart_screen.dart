import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cart_items = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  // Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      'Rs ${cart.totalAmount}',
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
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return CartItem(
                  id: cart_items[index].id,
                  title: cart_items[index].title,
                  price: cart_items[index].price,
                  quantity: cart_items[index].quantity,
                );
              },
              itemCount: cart_items.length,
            ),
          ),
        ],
      ),
    );
  }
}

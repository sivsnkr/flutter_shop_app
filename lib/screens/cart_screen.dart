import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';
import './orders_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();
    final cartKeys = cart.items.keys.toList();

    void placeOrder() async {
      try {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Orders>(context, listen: false).addOrder(
          cartItems,
          cart.totalAmount,
        );
        cart.clearCart();
        Navigator.of(context).pushNamed(OrdersScreen.routeName);
      } catch (error) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something went wrong"),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    "We are adding your order",
                    style: Theme.of(context).textTheme.headline6,
                  )
                ],
              ),
            )
          : Column(
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
                          onPressed: cartItems.length <= 0 ? null : placeOrder,
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

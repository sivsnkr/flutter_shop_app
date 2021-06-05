import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
        builder: (ctx, dataSnapsot) {
          if (dataSnapsot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (dataSnapsot.hasError) {
            return Center(child: Text("Failed to load orders"));
          }
          return Consumer<Orders>(builder: (ctx, ordersData, child) {
            final orders = ordersData.orders;
            return ListView.builder(
              itemBuilder: (ctx, index) {
                return OrderItem(
                  order: orders[index],
                );
              },
              itemCount: ordersData.count(),
            );
          });
        },
      ),
    );
  }
}

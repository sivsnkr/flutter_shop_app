import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';

  Future<void> _handleRefresh(context) async {
    try {
      await Provider.of<Products>(context, listen: false)
          .fetchAndSetProduct(true);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load your products"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: "",
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _handleRefresh(context),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (dataSnapshot.hasError) {
            return Center(
              child: Text(
                "Cannot load your product",
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () {
              return _handleRefresh(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Consumer<Products>(
                builder: (ctx, product, child) {
                  final productItems = product.items;
                  return ListView.builder(
                    itemBuilder: (ctx, index) {
                      return UserProduct(
                        productItems[index].title,
                        productItems[index].imageUrl,
                        productItems[index].id,
                      );
                    },
                    itemCount: product.items.length,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

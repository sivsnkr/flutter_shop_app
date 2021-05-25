import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_grid.dart';
import './cart_screen.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/app_drawer.dart';

enum showProduct {
  showFavoriteOnly,
  showAll,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavoritesOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          Consumer<Cart>(
            builder: (ctx, cart, child) => Badge(
              child: child == null ? const Text('cart') : child,
              // key: ,
              value: cart.itemCount.toString(),
              color: Colors.red,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (showProduct selectedValue) {
              if (selectedValue == showProduct.showFavoriteOnly)
                setState(() {
                  _showFavoritesOnly = true;
                });
              else
                setState(() {
                  _showFavoritesOnly = false;
                });
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: const Text('Favorite Only'),
                value: showProduct.showFavoriteOnly,
              ),
              PopupMenuItem(
                child: const Text('Show All'),
                value: showProduct.showAll,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: GridViewProduct(_showFavoritesOnly),
    );
  }
}

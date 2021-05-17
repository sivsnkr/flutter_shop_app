import 'package:flutter/material.dart';

import '../widgets/product_grid.dart';

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
      body: GridViewProduct(_showFavoritesOnly),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item_widget.dart';
import '../providers/products.dart';

class GridViewProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final loadedProduct = productData.items;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider(
        create: (ctx) => loadedProduct[index],
        child: ProductItemWidget(
            // loadedProduct[index],
            ),
      ),
      itemCount: loadedProduct.length,
      padding: const EdgeInsets.all(10),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details';
  Product getItem(ctx) {
    final routeSetting = ModalRoute.of(ctx);
    final itemId;
    if (routeSetting != null)
      itemId = routeSetting.settings.arguments as String;
    else
      itemId = null;

    return Provider.of<Products>(ctx, listen: false).findById(itemId);
  }

  @override
  Widget build(BuildContext context) {
    final item = getItem(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: Container(),
    );
  }
}

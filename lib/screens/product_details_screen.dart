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
    final product = getItem(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  product.imageUrl,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Rs ${product.price}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Text(
                  '${product.description}',
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

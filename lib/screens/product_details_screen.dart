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
      // appBar: AppBar(
      //   title: Text(product.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(product.title),
                background: Hero(
                  tag: product.id,
                  child: Image.network(
                    product.imageUrl,
                  ),
                ),
              )),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 20),
              Text(
                'Rs ${product.price}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
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
            ]),
          )
        ],
      ),
    );
  }
}

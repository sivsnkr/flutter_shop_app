import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './providers/products.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, [], null),
          update: (ctx, auth, previousProduct) {
            return Products(
              auth.token,
              previousProduct != null ? previousProduct.items : [],
              auth.userId,
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          create: (ctx) => Cart(null, {}),
          update: (ctx, authData, previousCart) {
            return Cart(
              authData.token,
              previousCart != null ? previousCart.items : {},
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(null, [], null),
          update: (ctx, authData, previousOrders) {
            return Orders(
              authData.token,
              previousOrders != null ? previousOrders.orders : [],
              authData.userId,
            );
          },
        )
      ],
      child: Consumer<Auth>(builder: (ctx, authData, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home:
              authData.isAutenticated ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        );
      }),
    );
  }
}

import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required required this.id,
    @required required this.title,
    @required required this.description,
    @required required this.price,
    @required required this.imageUrl,
    this.isFavourite = false,
  });
}

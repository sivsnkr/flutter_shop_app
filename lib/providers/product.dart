import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Product with ChangeNotifier {
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

  Future<void> toggleFavourite(String? token, String userId) async {
    isFavourite = !isFavourite;
    if (token == null) throw HttpException("Authorization Failed!");
    notifyListeners();
    try {
      final url = Uri.parse(
        'https://flutter-begineer-18e51-default-rtdb.asia-southeast1.firebasedatabase.app/userFavourites/$userId/$id.json?auth=$token',
      );
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Something went wrong!');
      }
    } catch (error) {
      isFavourite = !isFavourite;
      notifyListeners();
      throw error;
    }
  }
}

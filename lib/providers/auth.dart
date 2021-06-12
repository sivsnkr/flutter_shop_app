import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAutenticated {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) return _token;
    return null;
  }

  String get userId {
    return _userId.toString();
  }

  Future<void> _authenticate(String email, String password, Uri url) async {
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final body = json.decode(response.body);

      if (body['error'] != null) {
        throw HttpException(body['error']['message']);
      }

      _token = body['idToken'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            body['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    print("authenticating....");
    final url = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyArz5Ox7iIZaOhEozZK4mky80dxlQOWvbM",
    );

    return _authenticate(email, password, url);
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyArz5Ox7iIZaOhEozZK4mky80dxlQOWvbM",
    );

    return _authenticate(email, password, url);
  }
}

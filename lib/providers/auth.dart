import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

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
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': _userId,
        'token': _token,
        'expiryDate': _expiryDate?.toIso8601String(),
      });

      prefs.setString('userData', userData);
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

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpire = _expiryDate?.difference(DateTime.now()).inSeconds;
    if (timeToExpire != null) {
      _authTimer = Timer(Duration(seconds: timeToExpire), logout);
    }
  }

  Future<bool> autologin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData') && prefs.getString('userData') != null) {
      final userData = json.decode(prefs.getString('userData').toString())
          as Map<String, dynamic>;
      _userId = userData['userId'];
      _token = userData['token'];
      _expiryDate = DateTime.parse(userData['expiryDate']);
      if (_expiryDate!.isBefore(DateTime.now())) {
        logout();
        return false;
      }
      notifyListeners();
      _autoLogout();
      return true;
    }
    return false;
  }
}

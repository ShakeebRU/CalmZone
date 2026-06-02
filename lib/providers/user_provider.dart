import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _name;
  int? _age;
  String? _gender;
  double? _weight;
  double? _height;
  bool _isFirstTime = true;
  bool _isLoggedIn = false;

  String? get name => _name;
  int? get age => _age;
  String? get gender => _gender;
  double? get weight => _weight;
  double? get height => _height;
  bool get isFirstTime => _isFirstTime;
  bool get isLoggedIn => _isLoggedIn;

  UserProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('user_name');
    _age = prefs.getInt('user_age');
    _gender = prefs.getString('user_gender');
    _weight = prefs.getDouble('user_weight');
    _height = prefs.getDouble('user_height');
    _isFirstTime = prefs.getBool('is_first_time') ?? true;
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    notifyListeners();
  }

  Future<void> savePersonalData({
    required String name,
    required int age,
    required String gender,
    required double weight,
    required double height,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setInt('user_age', age);
    await prefs.setString('user_gender', gender);
    await prefs.setDouble('user_weight', weight);
    await prefs.setDouble('user_height', height);
    await prefs.setBool('is_first_time', false);

    _name = name;
    _age = age;
    _gender = gender;
    _weight = weight;
    _height = height;
    _isFirstTime = false;
    notifyListeners();
  }

  Future<void> setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', value);
    _isLoggedIn = value;
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    _isLoggedIn = false;
    notifyListeners();
  }
}

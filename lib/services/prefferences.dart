import 'dart:convert';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  final SharedPreferences shared;
  Preferences(this.shared);
  List<String> get whitePackages =>
      shared.getStringList("white_packages") ?? [];

  Locale? get locale => shared.getString("lang_code") == null
      ? null
      : Locale(
          shared.getString("lang_code") ?? "en",
          shared.getString("country_code"),
        );

  Future saveLocale(Locale locale) async {
    shared.setString("lang_code", locale.languageCode);
    if (locale.countryCode != null) {
      shared.setString("country_code", locale.countryCode!);
    }
  }

  // User? getAuth() {
  //   if (shared.getString("auth") != null) {
  //     var str = shared.getString("auth");
  //     User user = User.fromJson(jsonDecode(str!));
  //     return user;
  //   }
  //   return null;
  // }

  // Future saveCridentials(User user) async {
  //   shared.setString("auth", jsonEncode(user.toString()));
  // }

  // Future deleteCridentials() async {
  //   shared.remove('auth');
  // }

  static Future<Preferences> init() =>
      SharedPreferences.getInstance().then((value) => Preferences(value));
}

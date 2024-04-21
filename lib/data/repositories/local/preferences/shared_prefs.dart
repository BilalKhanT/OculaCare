import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  bool get isLoggedIn => _sharedPrefs?.getBool('isLoggedIn') ?? false;
  set isLoggedIn(bool value) {
    _sharedPrefs?.setBool('isLoggedIn', value);
  }
}

final sharedPrefs = SharedPrefs();
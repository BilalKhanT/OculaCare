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

  bool get isProfileSetup => _sharedPrefs?.getBool('isProfileSetup') ?? false;
  set isProfileSetup(bool value) {
    _sharedPrefs?.setBool('isProfileSetup', value);
  }

  String get otp => _sharedPrefs?.getString('otp') ?? '';
  set otp(String value) {
    _sharedPrefs?.setString('otp', value);
  }

  String get username => _sharedPrefs?.getString('username') ?? '';
  set username(String value) {
    _sharedPrefs?.setString('username', value);
  }

  String get email => _sharedPrefs?.getString('email') ?? '';
  set email(String value) {
    _sharedPrefs?.setString('email', value);
  }
}

final sharedPrefs = SharedPrefs();

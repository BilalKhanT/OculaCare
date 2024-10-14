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

  bool get historyFetched => _sharedPrefs?.getBool('historyFetched') ?? false;
  set historyFetched(bool value) {
    _sharedPrefs?.setBool('historyFetched', value);
  }

  bool get therapyFetched => _sharedPrefs?.getBool('therapyFetched') ?? false;
  set therapyFetched(bool value) {
    _sharedPrefs?.setBool('therapyFetched', value);
  }

  bool get bottomFirst => _sharedPrefs?.getBool('bottomFirst') ?? true;
  set bottomFirst(bool value) {
    _sharedPrefs?.setBool('bottomFirst', value);
  }

  bool get resultsFetched => _sharedPrefs?.getBool('resultsFetched') ?? false;
  set resultsFetched(bool value) {
    _sharedPrefs?.setBool('resultsFetched', value);
  }

  bool get isProfileSetup => _sharedPrefs?.getBool('isProfileSetup') ?? false;
  set isProfileSetup(bool value) {
    _sharedPrefs?.setBool('isProfileSetup', value);
  }

  String get otp => _sharedPrefs?.getString('otp') ?? '';
  set otp(String value) {
    _sharedPrefs?.setString('otp', value);
  }

  String get password => _sharedPrefs?.getString('password') ?? '';
  set password(String value) {
    _sharedPrefs?.setString('password', value);
  }

  String get userName => _sharedPrefs?.getString('userName') ?? '';
  set userName(String value) {
    _sharedPrefs?.setString('userName', value);
  }

  String get email => _sharedPrefs?.getString('email') ?? '';
  set email(String value) {
    _sharedPrefs?.setString('email', value);
  }

  String get patientData => _sharedPrefs?.getString('patientData') ?? '';
  set patientData(String value) {
    _sharedPrefs?.setString('patientData', value);
  }

  List<String>? getStringList(String key) {
    return _sharedPrefs?.getStringList(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _sharedPrefs?.setStringList(key, value) ?? false;
  }

  List<String>? getTherapyStringList(String key) {
    return _sharedPrefs?.getStringList(key);
  }

  Future<bool> setTherapyStringList(String key, List<String> value) async {
    return await _sharedPrefs?.setStringList(key, value) ?? false;
  }
}

final sharedPrefs = SharedPrefs();

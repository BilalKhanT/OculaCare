import 'package:flutter_dotenv/flutter_dotenv.dart';

EnvConfigs envConfigs = EnvConfigs.getInstanceSync();

class EnvConfigs {
  static EnvConfigs? _instance;
  DotEnv _dotenv = dotenv;

  static Future<EnvConfigs> getInstance({DotEnv? loadedEnv}) async {
    if (_instance == null) {
      _instance = EnvConfigs._internal();
      if (loadedEnv != null) {
        _instance?._dotenv = loadedEnv;
      } else {
        await _instance?._dotenv.load();
      }
    }
    return _instance!;
  }

  static EnvConfigs getInstanceSync() {
    if (_instance == null) throw Exception("ERROR: EnvConfigs not initialized");
    return _instance!;
  }

  EnvConfigs._internal();

  String get ipAddress => fill('IP_ADDRESS');

  String fill(String env, {String? fallback}) {
    try {
      String val = _dotenv.get(env, fallback: fallback);
      if (val.isEmpty) {
        throw Exception("ERROR: Value for env: $env is required!");
      }

      return val;
    } catch (err) {
      throw Exception("ERROR: Can't get env: $env");
    }
  }
}

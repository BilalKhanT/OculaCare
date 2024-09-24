import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import '../../../configs/app/app_globals.dart';
import '../local/preferences/shared_prefs.dart';

class PasswordRepo {
  final String passUpdateUrl = '$ipServer/api/patients/update-password';

  Future<bool> updatePassword(String password) async {
    try {
      var url = Uri.parse(passUpdateUrl);
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': sharedPrefs.email,
          'newPassword': password,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        log('${response.statusCode}');
        return false;
      }
    } catch (e) {
      log(e);
      return false;
    }
  }
}

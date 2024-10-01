import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../../configs/global/app_globals.dart';


class LoginRepository {
  Future<http.Response> login(String email, String password) async {
    var url = Uri.parse('$ipServer/api/patients/login');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'password': password.trim(),
      }),
    );
    return response;
  }

  Future<bool> updatePassword(String email, String newPassword) async {
    try {
      var url = Uri.parse('$ipServer/api/patients/update-password');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'newPassword': newPassword.trim(),
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      log('$e');
      return false;
    }
  }
}

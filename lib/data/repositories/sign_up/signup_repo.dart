import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../configs/global/app_globals.dart';

class SignUpRepository {
  Future<http.Response> registerGoogleUser(String email, String userName) async {
    try {
      var url = Uri.parse('$ipServer/api/patients/register-google');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': userName,
          'password': '******',
        }),
      );
      return response;
    } catch (e) {
      log('Network error: $e');
      rethrow;
    }
  }

  Future<http.Response> registerFacebookUser(String userName) async {
    try {
      var url = Uri.parse('$ipServer/api/patients/register-google');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': "awaisjarral37@gmail.com",
          'username': userName,
          'password': '******',
        }),
      );
      return response;
    } catch (e) {
      log('Network error: $e');
      rethrow;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../data/models/api_response/response_model.dart';

class MlModel {
  static const String baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=";
  static const String apkiKey = 'AIzaSyAGZ3yz1YGR5_x_8M0z6HPoisUWL9nHp8A';

  final url = baseUrl + apkiKey;
  final header = {'Content-Type': 'application/json'};

  Future<ResponseModel> getData(String msg) async {
    var data = {
      "contents": [
        {
          "parts": [
            {"text": msg}
          ]
        }
      ]
    };
    final resp = await http.post(Uri.parse(url),
        headers: header, body: jsonEncode(data));

    if (resp.statusCode == 200) {
      return ResponseModel.fromJson(jsonDecode(resp.body));
    } else {
      return ResponseModel(text: '');
    }
  }
}

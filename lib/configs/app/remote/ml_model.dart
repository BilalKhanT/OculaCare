import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/api_response/response_model.dart';

class MlModel {
  static String baseUrl = dotenv.env['BASE_URL_MODEL'] ?? '';
  static String apkiKey = dotenv.env['API_KEY_MODEL'] ?? '';

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

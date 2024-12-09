import 'dart:convert';
import 'package:cculacare/data/models/disease_result/qa_model.dart';
import 'package:http/http.dart' as http;
import 'package:cculacare/configs/global/app_globals.dart';
import 'package:nb_utils/nb_utils.dart';

class SymptomCheckerRepo {

  Future<QaResponse?> startConversation(String response) async {
    final url = '$flask/qa/start';
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'response': response});

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (res.statusCode == 200) {
        final responseData = json.decode(res.body);
        return QaResponse.fromJson(responseData);
      } else {
        log('Failed to get response from server ${res.statusCode}.');
        return null;
      }
    } catch (error) {
      log('Error occurred: $error');
      return null;
    }
  }

  Future<QaResponse?> continueConversation(String response) async {
    final url = '$flask/qa/next';
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'response': response});

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (res.statusCode == 200) {
        final responseData = json.decode(res.body);
        return QaResponse.fromJson(responseData);
      } else {
        log('Failed to get response from server ${res.body}.');
        return null;
      }
    } catch (error) {
      log('Error occurred: $error');
      return null;
    }
  }
}

import 'dart:convert';

import 'package:cculacare/configs/global/app_globals.dart';
import 'package:cculacare/data/models/disease_result/disease_result_model.dart';
import 'package:cculacare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

import '../../../configs/app/notification/notification_service.dart';

class DetectionRepo {
  final String detectionUrl = '$ipServer/api/predictions/email';

  Future<void> predictDisease(Map<String, dynamic> payload) async {
    try {
      var response = await http.post(
        Uri.parse('$flask/predict'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        DiseaseResultModel result = DiseaseResultModel.fromJson(data);
        globalResults.add(result);
        NotificationService.resultReadyNotification('Disease Analysis', 'Analysis report is ready', DateTime.now().add(const Duration(seconds: 2)));
      } else {
        log("Nothing ${response.body}");
      }
    } catch (e) {
      log('error $e');
    }
  }

  Future<List<DiseaseResultModel>> getPatientDiseaseResults() async {
    final url = Uri.parse('$detectionUrl/${sharedPrefs.email}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((json) => DiseaseResultModel.fromJson(json))
            .toList();
      } else {
        log(response.statusCode);
        return [];
      }
    } catch (e) {
      log(e);
      return [];
    }
  }
}

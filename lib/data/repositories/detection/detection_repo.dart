import 'dart:convert';

import 'package:cculacare/configs/global/app_globals.dart';
import 'package:cculacare/data/models/disease_result/disease_result_model.dart';
import 'package:cculacare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

class DetectionRepo {
  final String detectionUrl = '${ipServer}hhdhd';

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

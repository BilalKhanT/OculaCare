import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../../../configs/global/app_globals.dart';
import '../../models/therapy/therapy_results_model.dart';

class TherapyRepository {
  final String addTherapyUrl = '$ipServer/api/therapy/save';
  final String getTherapyUrl = '$ipServer/api/therapy/find';

  Future<bool> addTherapyRecord(Map<String, dynamic> therapyData) async {
    final url = Uri.parse(addTherapyUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(therapyData),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        log('Failed to save therapy: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Error saving therapy: $e');
      return false;
    }
  }

  Future<void> getTherapyRecord(String patientName) async {
    try {
      final response = await http.get(Uri.parse('$getTherapyUrl/$patientName'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<TherapyModel> therapies = jsonResponse.map((data) {
          return TherapyModel.fromJson(data);
        }).toList();

        globalTherapies = therapies;
      } else {
        log('Failed to load therapy records: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching therapy records: $e');
    }
  }


}

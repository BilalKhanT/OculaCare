import 'dart:convert';
import 'package:OculaCare/data/models/therapy/therapy_results_model.dart';
import 'package:http/http.dart' as http;
import 'package:OculaCare/configs/app/app_globals.dart';

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
        print('Failed to save therapy: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error saving therapy: $e');
      return false;
    }
  }

  Future<List<TherapyModel>> getTherapyRecord(String patientName) async {
    try {
      final response = await http.get(Uri.parse('$getTherapyUrl/$patientName'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<TherapyModel> therapies = jsonResponse.map((data) {
          return TherapyModel.fromJson(data);
        }).toList();
        print(therapies);
        return therapies;
      } else {
        throw Exception('Failed to load therapy records');
      }
    } catch (e) {
      throw Exception('Error fetching therapy records: $e');
    }
  }

}

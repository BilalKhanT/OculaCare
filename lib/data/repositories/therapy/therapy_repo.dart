import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:OculaCare/configs/app/app_globals.dart';

class TherapyRepository {
  final String addTherapyUrl = '$ipServer/api/therapy/save';
  final String getTherapyUrl = '$ipServer/api/therapy/find';

  Future<bool> addTherapyRecord(Map<String, dynamic> therapyData) async {
    final url = Uri.parse(getTherapyUrl);

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

  List<Map<String, dynamic>> therapyRecords = [];

  Future<List<Map<String, dynamic>>> getTherapyRecords(String patientName) async {
    final url = Uri.parse('$getTherapyUrl/$patientName');
    print(url);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        print("Successfully fetched therapy records for $patientName");

        // Convert and store the fetched data in the class-level list
        therapyRecords = jsonData.map((json) => json as Map<String, dynamic>).toList();

        return therapyRecords;
      } else {
        print('Failed to fetch therapies for $patientName: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching therapies for $patientName: $e');
      return [];
    }
  }

}

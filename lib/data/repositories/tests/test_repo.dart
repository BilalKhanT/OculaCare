import 'package:OculaCare/configs/app/app_globals.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import '../../models/tests/test_result_model.dart';

class TestRepository {
  final String testUrl = '$ipServer/api/tests/add-test';
  final String getTestUrl = '$ipServer/api/tests/get-tests';

  Future<bool> addTestRecord(TestResultModel testResult) async {
    final url = Uri.parse(testUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(testResult.toJson()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        log(response.body);
        return false;
      }
    } catch (e) {
      log(e);
      return false;
    }
  }

  Future<List<TestResultModel>> getTestRecords(String patientName) async {
    final url = Uri.parse('$getTestUrl/Bilal Khan');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => TestResultModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        log('No tests found for this patient.');
        return [];
      } else {
        log('Failed to fetch test records: ${response.body}');
        return [];
      }
    } catch (e) {
      log('Error fetching test records: $e');
      return [];
    }
  }
}

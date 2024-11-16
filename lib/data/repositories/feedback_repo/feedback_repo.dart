import 'dart:convert';
import 'package:cculacare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:http/http.dart' as http;
import '../../../configs/global/app_globals.dart';

class FeedbackRepository {
  final String apiUrl = '$ipServer/api/feedback/submit';

  Future<bool> submitTherapyFeedback(String email, String category, List<String> data, String customFeedback, String date) async {
    try {
      final Map<String, dynamic> feedbackData = {
        'email': email,
        'patient_name': sharedPrefs.userName,
        'category': category,
        'defaults': data,
        'customMessage': customFeedback,
        'date': date,
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(feedbackData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/therapy/therapy_feedback_model.dart';

class TherapyFeedbackRepository {
  final String apiUrl = 'https://oculacare-backend.onrender.com/api/therapyFeedback/submit';

  Future<bool> submitTherapyFeedback(TherapyFeedbackModel feedback) async {
    try {
      final Map<String, dynamic> feedbackData = feedback.toJson();
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(feedbackData),
      );
      if (response.statusCode == 201) {
       return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error submitting feedback: $e');
      throw Exception('Error submitting feedback');
    }
  }
}

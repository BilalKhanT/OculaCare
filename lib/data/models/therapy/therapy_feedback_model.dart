import 'package:cculacare/data/models/therapy/therapy_results_model.dart';

class TherapyFeedbackModel {
  final String email;
  final TherapyModel therapy;
  final String category;
  final List<String> defaults;
  final String? customMessage;

  TherapyFeedbackModel({
    required this.email,
    required this.therapy,
    required this.category,
    required this.defaults,
    this.customMessage,
  });


  factory TherapyFeedbackModel.fromJson(Map<String, dynamic> json) {
    return TherapyFeedbackModel(
      email: json['email'] ?? '',
      therapy: TherapyModel.fromJson(json['therapy'] ?? {}),
      category: json['category'] ?? '',
      defaults: List<String>.from(json['defaults'] ?? []),
      customMessage: json['customMessage'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'therapy': therapy.toJson(),
      'category': category,
      'defaults': defaults,
      'customMessage': customMessage,
    };
  }
}

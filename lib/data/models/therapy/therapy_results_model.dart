class TherapyModel {
  final String patientName;
  final String date;
  final String therapyType;
  final String therapyName;
  final int duration;

  TherapyModel({
    required this.patientName,
    required this.date,
    required this.therapyType,
    required this.therapyName,
    required this.duration,
  });

  /// Factory constructor to create a `TherapyModel` from a JSON object.
  factory TherapyModel.fromJson(Map<String, dynamic> json) {
    return TherapyModel(
      patientName: json['patient_name'] ?? '',
      date: json['date'] ?? '',
      therapyType: json['therapy_type'] ?? '',
      therapyName: json['therapy_name'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }

  /// Convert a `TherapyModel` object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'patient_name': patientName,
      'date': date,
      'therapy_type': therapyType,
      'therapy_name': therapyName,
      'duration': duration,
    };
  }
}

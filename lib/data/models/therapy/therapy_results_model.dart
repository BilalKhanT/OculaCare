class TherapyModel {
  final String email;
  final String patientName;
  final String date;
  final String therapyType;
  final String therapyName;
  final int duration;

  TherapyModel({
    required this.email,
    required this.patientName,
    required this.date,
    required this.therapyType,
    required this.therapyName,
    required this.duration,
  });

  factory TherapyModel.fromJson(Map<String, dynamic> json) {
    return TherapyModel(
      email: json['email'] ?? '',
      patientName: json['patient_name'] ?? '',
      date: json['date'] ?? '',
      therapyType: json['therapy_type'] ?? '',
      therapyName: json['therapy_name'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'patient_name': patientName,
      'date': date,
      'therapy_type': therapyType,
      'therapy_name': therapyName,
      'duration': duration,
    };
  }
}

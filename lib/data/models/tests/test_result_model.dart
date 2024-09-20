class TestResultModel {
  final String email;
  final String patientName;
  final String date;
  final String testType;
  final String testName;
  final int testScore;
  final String resultDescription;
  final String recommendation;
  final String precautions;

  TestResultModel({
    required this.email,
    required this.patientName,
    required this.date,
    required this.testType,
    required this.testName,
    required this.testScore,
    required this.resultDescription,
    required this.recommendation,
    required this.precautions,
  });

  factory TestResultModel.fromJson(Map<String, dynamic> json) {
    return TestResultModel(
      email: json['email'] ?? '',
      patientName: json['patient_name'] ?? '',
      date: json['date'] ?? '',
      testType: json['test_type'] ?? '',
      testName: json['test_name'] ?? '',
      testScore: json['test_score'] ?? 0,
      resultDescription: json['result_description'] ?? '',
      recommendation: json['test_recommendations'] ?? '',
      precautions: json['test_impact'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'patient_name': patientName,
      'date': date,
      'test_type': testType,
      'test_name': testName,
      'test_score': testScore,
      'result_description': resultDescription,
      'test_recommendations': recommendation,
      'test_impact': precautions,
    };
  }
}

class TestResultModel {
  final String patientName;
  final String date;
  final String testType;
  final String testName;
  final double testScore;
  final String resultDescription;
  final String recommendation;
  final String precautions;

  TestResultModel({
    required this.patientName,
    required this.date,
    required this.testType,
    required this.testName,
    required this.testScore,
    required this.resultDescription,
    required this.recommendation,
    required this.precautions,
  });
}

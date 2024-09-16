class DiseaseResultModel {
  final String patientName;
  final String date;
  final String treatment;
  final String causes;
  final String medicineRecommendations;
  final String impacts;
  final String precautions;
  final EyePrediction leftEye;
  final EyePrediction rightEye;

  DiseaseResultModel(
      {required this.patientName,
      required this.date,
      required this.treatment,
      required this.causes,
      required this.medicineRecommendations,
      required this.impacts,
      required this.precautions,
      required this.leftEye,
      required this.rightEye});

  factory DiseaseResultModel.fromJson(Map<String, dynamic> json) {
    return DiseaseResultModel(
      leftEye: EyePrediction.fromJson(json['left_eye']),
      rightEye: EyePrediction.fromJson(json['right_eye']),
      patientName: json['patient_name'],
      date: json['date'],
      treatment: json['treatment'],
      causes: json['causes'],
      medicineRecommendations: json['medicine_recommendations'],
      impacts: json['impacts'],
      precautions: json['precautions'],
    );
  }
}

class EyePrediction {
  final String message;
  final String prediction;

  EyePrediction({required this.message, required this.prediction});

  factory EyePrediction.fromJson(Map<String, dynamic> json) {
    return EyePrediction(
      message: json['prediction'],
      prediction: json['probability'],
    );
  }
}

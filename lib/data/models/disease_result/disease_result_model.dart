class DiseaseResultModel {
  final String? patientName;
  final String? date;
  final String? treatment;
  final String? causes;
  final String? medicineRecommendations;
  final String? impacts;
  final String? precautions;
  final EyePrediction? leftEye;
  final EyePrediction? rightEye;

  DiseaseResultModel({
    this.patientName,
    this.date,
    this.treatment,
    this.causes,
    this.medicineRecommendations,
    this.impacts,
    this.precautions,
    this.leftEye,
    this.rightEye,
  });

  factory DiseaseResultModel.fromJson(Map<String, dynamic> json) {
    return DiseaseResultModel(
      patientName: json['patient_name'] ?? '',
      date: json['date'] ?? '',
      treatment: json['treatment'] ?? '',
      causes: json['causes'] ?? '',
      medicineRecommendations: json['medicine_recommendations'] ?? '',
      impacts: json['impacts'] ?? '',
      precautions: json['precautions'] ?? '',
      leftEye: json['left_eye'] != null
          ? EyePrediction.fromJson(json['left_eye'])
          : null,
      rightEye: json['right_eye'] != null
          ? EyePrediction.fromJson(json['right_eye'])
          : null,
    );
  }
}

class EyePrediction {
  final String? prediction;
  final String? probability;

  EyePrediction({this.prediction, this.probability});

  factory EyePrediction.fromJson(Map<String, dynamic> json) {
    return EyePrediction(
      prediction: json['prediction'] ?? '',
      probability: json['probability'] ?? '',
    );
  }
}


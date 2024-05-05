class DiseaseResultModel {
  final EyePrediction leftEye;
  final EyePrediction rightEye;

  DiseaseResultModel({required this.leftEye, required this.rightEye});

  factory DiseaseResultModel.fromJson(Map<String, dynamic> json) {
    return DiseaseResultModel(
      leftEye: EyePrediction.fromJson(json['left_eye']),
      rightEye: EyePrediction.fromJson(json['right_eye']),
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
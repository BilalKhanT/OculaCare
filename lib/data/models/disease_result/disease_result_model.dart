class DiseaseResultModel {
  final String? patientName;
  final String? email;
  final String? date;
  final String? treatment1;
  final String? treatment2;
  final String? precaution1;
  final String? precaution2;
  final EyePrediction? leftEye;
  final EyePrediction? rightEye;
  final EyePrediction? bulgy;

  DiseaseResultModel({
    this.patientName,
    this.email,
    this.date,
    this.treatment1,
    this.precaution1,
    this.treatment2,
    this.precaution2,
    this.leftEye,
    this.rightEye,
    this.bulgy,
  });

  factory DiseaseResultModel.fromJson(Map<String, dynamic> json) {
    return DiseaseResultModel(
      patientName: json['patient_name'] ?? '',
      email: json['email'] ?? '',
      date: json['date'] ?? '',
      treatment1: json['treatment1'] ?? '',
      precaution1: json['precaution1'] ?? '',
      treatment2: json['treatment2'] ?? '',
      precaution2: json['precaution2'] ?? '',
      leftEye: json['left_eye'] != null
          ? EyePrediction.fromJson(json['left_eye'])
          : null,
      rightEye: json['right_eye'] != null
          ? EyePrediction.fromJson(json['right_eye'])
          : null,
      bulgy:
          json['bulgy'] != null ? EyePrediction.fromJson(json['bulgy']) : null,
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

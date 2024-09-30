import 'package:cculacare/data/models/disease_result/disease_result_model.dart';

class DiagnosisResultModel {
  final DiseaseResultModel result;
  final String flag;

  const DiagnosisResultModel({
    required this.result,
    required this.flag,
  });
}

class QaResponse {
  String? nextQuestion;
  Diagnosis? diagnosis;

  QaResponse({
    this.nextQuestion,
    this.diagnosis,
  });

  factory QaResponse.fromJson(Map<String, dynamic> json) {
    return QaResponse(
      nextQuestion: json['next_question'] ?? '',
      diagnosis: json['diagnosis'] != null
          ? Diagnosis.fromJson(json['diagnosis'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'next_question': nextQuestion,
      'diagnosis': diagnosis?.toJson(),
    };
  }
}

class Diagnosis {
  String? disease;
  String? analysis;

  Diagnosis({
    this.disease,
    this.analysis,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      disease: json['disease'] ?? '',
      analysis: json['analysis'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disease': disease,
      'analysis': analysis,
    };
  }
}

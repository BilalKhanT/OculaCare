class ResponseModel {
  final String text;

  ResponseModel({required this.text});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      text: json['candidates'][0]['content']['parts'][0]['text'],
    );
  }
}

import 'hospital_model.dart';

class Bookmark {
  final String email;
  final List<Hospital> hospitals;

  Bookmark({
    required this.email,
    required this.hospitals,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      email: json['email'] as String,
      hospitals: (json['hospitals'] as List<dynamic>?)
          ?.map((hospitalJson) => Hospital.fromJson(hospitalJson))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'hospitals': hospitals.map((hospital) => hospital.toJson()).toList(),
    };
  }
}

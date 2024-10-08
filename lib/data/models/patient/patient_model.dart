import '../address/address_model.dart';

class PatientModel {
  final Patient patient;

  PatientModel({
    required this.patient,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
        patient: Patient.fromJson(json["patient"]),
      );

  Map<String, dynamic> toJson() => {
        "patient": patient.toJson(),
      };
}

class Patient {
  final String? email;
  final String? username;
  final String? profileImage;
  final int? age;
  final String? gender;
  final String? contactNumber;
  final Address? address;

  Patient({
    required this.email,
    required this.username,
    required this.profileImage,
    required this.age,
    required this.gender,
    required this.contactNumber,
    required this.address,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        email: json["email"],
        username: json["username"],
        profileImage: json["profileImage"],
        age: json["age"],
        gender: json["gender"],
        contactNumber: json["contactNumber"],
        address:
            json["address"] != null ? Address.fromJson(json["address"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "profileImage": profileImage,
        "age": age,
        "gender": gender,
        "contactNumber": contactNumber,
        "address": address?.toJson(),
      };
}

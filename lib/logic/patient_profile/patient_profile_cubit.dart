import 'dart:convert';
import 'dart:developer';
import 'package:OculaCare/data/models/address/address_model.dart';
import 'package:OculaCare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:OculaCare/logic/patient_profile/patient_profile_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../configs/app/app_globals.dart';
import '../../data/models/patient/patient_model.dart';

class PatientProfileCubit extends Cubit<PatientProfileState> {
  PatientProfileCubit() : super(PatientProfileStateInitial());

  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  late double lat;
  late double long;
  late String gender;
  late String imageBase64;

  void setImage(String image) {
    imageBase64 = image;
  }

  void setGender(String userGender) {
    gender = userGender;
  }

  Future<void> setCoordinates(double latitude, double longitude) async {
    lat = latitude;
    long = longitude;
  }

  Future<void> loadPatientProfile(String email) async {
    emit(PatientProfileStateLoading());
    try {
      if (!sharedPrefs.isProfileSetup) {
        emit(PatientProfileStateSetUp());
        return;
      } else {
        //http call to fetch profile data
        //emit Loaded state
      }
    } catch (e) {
      log('$e');
      emit(PatientProfileStateFailure('Ops, something went wrong'));
    }
  }

  Future<void> savePatientProfile() async {
    emit(PatientProfileStateLoading());
    String phone = '+92${phoneController.text}';
    String address = addressController.text;
    String age = ageController.text;
    try {
      var url = Uri.parse('http://$ipAddress:3000/api/patients/update-profile');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': sharedPrefs.email,
          'profileImage': imageBase64,
          'age': age,
          'gender': gender,
          'contactNumber': phone,
          'lat': lat.toString(),
          'long': long.toString(),
          'locationName': address,
        }),
      );
      if (response.statusCode == 200) {
        final patientAddress = Address(
          lat: lat,
          long: long,
          locationName: address,
        );
        final patient = Patient(
          email: sharedPrefs.email,
          username: sharedPrefs.userName,
          profileImage: imageBase64,
          age: int.parse(age),
          gender: gender,
          contactNumber: phone,
          address: patientAddress,
        );
        emit(PatientProfileStateLoaded(patient));
      } else {
        emit(PatientProfileStateFailure(
            'Ops, something went wrong ${response.statusCode}'));
      }
    } catch (e) {
      log('$e');
      emit(PatientProfileStateFailure('Ops, something went wrong'));
    }
  }
}

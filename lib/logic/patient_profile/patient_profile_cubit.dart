import 'dart:convert';
import 'dart:developer';
import 'package:OculaCare/configs/utils/utils.dart';
import 'package:OculaCare/data/models/address/address_model.dart';
import 'package:OculaCare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:OculaCare/logic/patient_profile/patient_profile_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../configs/app/app_globals.dart';
import '../../data/models/patient/patient_model.dart';

class PatientProfileCubit extends Cubit<PatientProfileState> {
  PatientProfileCubit() : super(PatientProfileStateInitial());

  final updatePasswordController = TextEditingController();
  final updateAgeController = TextEditingController();
  final updateGenderController = TextEditingController();
  final updateContactController = TextEditingController();
  final updateAddressController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();

  final passwordFocusNode = FocusNode();
  final contactFocusNode = FocusNode();
  final ageFocusNode = FocusNode();
  final addressFocusNode = FocusNode();
  late double lat;
  late double long;
  String gender = '';
  String imageBase64 = '';

  disposeEdit() {
    updatePasswordController.clear();
    updateAgeController.clear();
    updateAddressController.clear();
    updateGenderController.clear();
    updateContactController.clear();
  }

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
        try {
          var url = Uri.parse('$ipServer/api/patients/send-info');
          var response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
            }),
          );
          if (response.statusCode == 200) {
            final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
            final PatientModel patientModel = PatientModel.fromJson(jsonResponse);
            emit(PatientProfileStateLoaded(patientModel.patient));
          }
          else {
            log('Server error with status code: ${response.statusCode}');
          }
        } catch (e) {
          log('Network error: $e');
        }
      }
    } catch (e) {
      log('$e');
      emit(PatientProfileStateFailure('Ops, something went wrong'));
    }
  }

  void emitEditProfile(BuildContext context, String age, gender, String address, String contact, String img) {
    updatePasswordController.text = sharedPrefs.password;
    updateContactController.text = contact;
    updateAddressController.text = address;
    updateAgeController.text = age;
    emit(PatientProfileStateEdit(img));
  }

  Future<void> editProfile(BuildContext context, String pass, String img, String age, String phone, String address) async {
    try {
      var url = Uri.parse('$ipServer/api/patients/edit-profile');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': sharedPrefs.email,
          'password': pass,
          'profileImage': img,
          'age': age,
          'gender': gender,
          'contactNumber': phone,
          'lat': lat.toString(),
          'long': long.toString(),
          'locationName': address,
        }),
      );
      if (response.statusCode == 200) {
        sharedPrefs.isProfileSetup = true;
        final patientAddress = Address(
          lat: lat,
          long: long,
          locationName: address,
        );
        final patient = Patient(
          email: sharedPrefs.email,
          username: sharedPrefs.userName,
          profileImage: img,
          age: int.parse(age),
          gender: gender,
          contactNumber: phone,
          address: patientAddress,
        );
        AppUtils.showToast(context, 'Profile Updated Successfully', 'Your profile data has been updated.', false);
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

  Future<void> savePatientProfile(BuildContext context) async {
    emit(PatientProfileStateLoading());
    String phone = phoneController.text;
    String address = addressController.text;
    String age = ageController.text;
    if (phone.isNotEmpty && phone.length == 11  && address.isNotEmpty && age.isNotEmpty && imageBase64 != ''
    && gender != '' && lat.toString().isNotEmpty && long.toString().isNotEmpty) {
      try {
        var url = Uri.parse('$ipServer/api/patients/update-profile');
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
          sharedPrefs.isProfileSetup = true;
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
    else {
      AppUtils.showToast(context, 'Incomplete Form', 'Please provide complete details to proceed.', true);
      emit(PatientProfileStateSetUp());
    }
  }
}

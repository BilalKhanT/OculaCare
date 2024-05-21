import 'dart:developer';
import 'package:OculaCare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:OculaCare/logic/patient_profile/patient_profile_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

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

  Future<void> setCoordinates(double latitude, double longitude) async{
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

  Future<void> savePatientProfile() async{
    emit(PatientProfileStateLoading());
    String phone = '+92${phoneController.text}';
    String address = addressController.text;
    String age = ageController.text;
     print(phone + address + lat.toString() + long.toString() + gender + age + imageBase64);
    try {
      //http call to store profile data
      //emit loaded state
    } catch (e) {
      log('$e');
      emit(PatientProfileStateFailure('Ops, something went wrong'));
    }
  }
}

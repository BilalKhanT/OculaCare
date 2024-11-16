import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cculacare/configs/global/app_globals.dart';
import 'package:cculacare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/models/address/address_model.dart';
import '../../data/models/hospital_locator_model/hospital_bookmark_model.dart';
import '../../data/models/hospital_locator_model/hospital_model.dart';
import '../../data/repositories/hospital_locator_repo/hospital_locator_repo.dart';
import 'hospital_locator_states.dart';

class HospitalCubit extends Cubit<HospitalState> {
  HospitalCubit() : super(HospitalLoading());

  final List<Hospital> hospitals = [];
  final List<Bookmark> bookmarks = [];
  final HospitalRepository hospitalRepository = HospitalRepository();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  late GoogleMapController _mapController;

  void loadHospitals() async {
    emit(HospitalLoading());
    try {
      if (hospital.isEmpty){
        final hospital = await hospitalRepository.fetchHospitals();
      }
      emit(HospitalLoaded(hospital));
    } on SocketException {
      emit(HospitalError("Network error: Unable to connect to the hospital service."));
    } catch (e) {
      emit(HospitalError("An unexpected error occurred: ${e.toString()}"));
    }
  }

  void onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    final String style = await rootBundle.loadString('assets/map_styles/map_style.json');
    _mapController.setMapStyle(style);
  }

  void addBookmark(Hospital hospital) async {
    emit(HospitalLoading());
    try {
      print("Adding bookmark");
      final email = sharedPrefs.email;
      final bookmarkToAdd = Bookmark(email: email, hospitals: [hospital]);

      final isSuccess = await hospitalRepository.addBookmark(bookmarkToAdd);

      if (isSuccess) {
        this.hospitals.add(hospital);
        emit(HospitalBookmarkLoaded(bookmark));
      } else {
        emit(HospitalError('Failed to add bookmark: Server did not confirm addition.'));
      }
    } catch (e) {
      emit(HospitalError('Failed to add bookmark: $e'));
    }
  }





  void initializeSourceWithUserLocation() {
    final address = sharedPrefs.getAddress();
    if (address != null) {
      sourceController.text = "${address.lat}, ${address.long}";
    }
  }

  void setDestination(String location) {
    emit(HospitalLoading());
    destinationController.text = location;
  }

  Address? getUserAddress() {
    final double? lat = sharedPrefs.getAddress()?.lat;
    final double? long = sharedPrefs.getAddress()?.long;
    final String? locationName = sharedPrefs.getAddress()?.locationName;
    return Address(lat: lat, long: long, locationName: locationName);
  }

  void startNavigation(double sourceLat, double sourceLong, double destinationLat, double destinationLong, String mode) async {
    emit(HospitalLoading());
    try {
      List<LatLng> polylineCoordinates = await hospitalRepository.getDirections(
          sourceLat, sourceLong, destinationLat, destinationLong, mode
      );

      emit(HospitalNavigationStarted(polylineCoordinates));
    } catch (e) {
      emit(HospitalError("Failed to load directions"));
    }
  }

  void clearControllers() {
    destinationController.clear();
    sourceController.clear();
  }
}

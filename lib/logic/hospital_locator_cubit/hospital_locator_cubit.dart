import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cculacare/configs/global/app_globals.dart';
import 'package:cculacare/data/repositories/bookmark/bookmark_repo.dart';
import 'package:cculacare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/models/address/address_model.dart';
import '../../data/repositories/hospital_locator_repo/hospital_locator_repo.dart';
import 'hospital_locator_states.dart';

class HospitalCubit extends Cubit<HospitalState> {
  HospitalCubit() : super(HospitalLoading());

  final HospitalRepository hospitalRepository = HospitalRepository();
  final BookmarkRepository bookmarkRepository = BookmarkRepository();

  final TextEditingController destinationController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  late GoogleMapController _mapController;

  void loadHospitals() async {
    emit(HospitalLoading());
    try {
      if (hospital.isEmpty){
        await hospitalRepository.fetchHospitals();
      }
      if(bookmarks.isEmpty){
        await bookmarkRepository.fetchBookmarks();
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

  void endNavigation() {
    emit(HospitalLoading());
    try{
      clearControllers();
      emit(HospitalLoaded(hospital));
    }catch (e){
      emit(HospitalError("Oops! Something went Wrong"));
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

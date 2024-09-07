import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:nb_utils/nb_utils.dart';
import 'location_state.dart';
import 'package:flutter/material.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  GoogleMapController? mapController;
  Set<Marker> markers = {};
  bool toHome = true;

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<String> fetchAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> places = await placemarkFromCoordinates(lat, lng);
      Placemark place = places[0];
      String address =
          '${place.street?.replaceAll(RegExp(r'^[\d\s\-]+'), '')}, ${place.subLocality}, ${place.locality}';
      return address;
    } catch (e) {
      log('Failed to get address: $e');
      return '';
    }
  }

  Future<void> getCurrentLocation() async {
    emit(LocationLoading());
    var permissionStatus = await Permission.location.request();
    if (!permissionStatus.isGranted) {
      emit(LocationError('Location permission denied'));
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String address =
      await fetchAddressFromLatLng(position.latitude, position.longitude);
      emit(
        LocationLoaded(LatLng(position.latitude, position.longitude), address),
      );
    } catch (e) {
      emit(LocationError("Error obtaining location"));
    }
  }

  Future<void> getCurrentPositionCoordinates(BuildContext context) async {
    emit(LocationLoading());
    var permissionStatus = await Permission.location.request();
    if (!permissionStatus.isGranted) {
      emit(LocationError('Location permission denied'));
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String address =
      await fetchAddressFromLatLng(position.latitude, position.longitude);
      // Address addressObj = Address(
      //     userId: sharedPrefs.userId,
      //     latitude: position.latitude,
      //     longitude: position.longitude,
      //     address: address);

      if (context.mounted) {
        // context
        //     .read<AddressBookCubit>()
        //     .updateAddress(addressObj, updateLocal: true);
      }
      emit(
        LocationLoaded(LatLng(position.latitude, position.longitude), address),
      );
    } catch (e) {
      emit(LocationError("Error obtaining location"));
    }
  }

  CameraPosition? currentMarkerPosition;

  Timer? timer;

  Future<void> setLocation() async {
    emit(LocationLoading());
    var permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      emit(LocationLoading());
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String address =
      await fetchAddressFromLatLng(position.latitude, position.longitude);
      toHome = false;
      emit(LocationSet(
          LatLng(position.latitude, position.longitude), markers, address, position.latitude, position.longitude));
    } else {
      var permissionStatus = await Permission.location.request();
      if (permissionStatus.isGranted) {
        setLocation();
      } else {
        emit(LocationError('Location permission denied'));
      }
    }
  }

  void updateMapState() async {
    if (currentMarkerPosition == null) return;

    final LatLng center = currentMarkerPosition!.target;
    markers.clear();
    markers
        .add(Marker(markerId: MarkerId(center.toString()), position: center));

    String address =
    await fetchAddressFromLatLng(center.latitude, center.longitude);

    emit(LocationSet(center, markers, address, center.latitude, center.longitude));
  }

  // void initializeMapForEdit(Address address) {
  //   emit(LocationLoading());
  //   LatLng position = LatLng(address.latitude!, address.longitude!);
  //
  //   markers.clear();
  //   markers.add(
  //     Marker(
  //       markerId: MarkerId(position.toString()),
  //       position: position,
  //     ),
  //   );
  //   toHome = false;
  //   emit(LocationSet(
  //     position,
  //     markers,
  //     address.address!,
  //   ));
  // }
}
import 'package:bloc/bloc.dart';
import 'package:cculacare/data/models/address/address_model.dart';
import 'package:cculacare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:cculacare/logic/location_cubit/current_loc_state.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class CurrentLocationCubit extends Cubit<CurrentLocationState> {
  CurrentLocationCubit() : super(CurrentLocationInitial());

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
    print('HEHEHEH');
    emit(CurrentLocationLoading());
    var permissionStatus = await Permission.location.request();
    if (!permissionStatus.isGranted) {
      emit(CurrentLocationError());
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String address =
          await fetchAddressFromLatLng(position.latitude, position.longitude);
      Address add = Address(
          lat: position.latitude,
          long: position.longitude,
          locationName: address);
      sharedPrefs.setAddress(add);
      emit(
        CurrentLocationSet(),
      );
    } catch (e) {
      emit(CurrentLocationError());
    }
  }
}

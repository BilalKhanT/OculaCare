import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cculacare/configs/global/app_globals.dart';
import 'package:cculacare/data/repositories/bookmark/bookmark_repo.dart';
import 'package:cculacare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/address/address_model.dart';
import '../../data/repositories/hospital_locator_repo/hospital_locator_repo.dart';
import 'hospital_locator_states.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

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
      Address? address = await getUserAddress();
      if (hospital.isEmpty){
        await hospitalRepository.fetchHospitals(address!.lat!, address.long!);
      }
      if(bookmarks.isEmpty){
        await bookmarkRepository.fetchBookmarks();
      }
      emit(HospitalLoaded(hospital, address!.lat!, address.long!));
    } on SocketException {
      emit(HospitalError("Network error: Unable to connect to the hospital service."));
    } catch (e) {
      emit(HospitalError("An unexpected error occurred: ${e.toString()}"));
    }
  }

  void onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
  }

  Future<void> endNavigation() async {
    emit(HospitalLoading());
    try{
      clearControllers();
      Address? address = await getUserAddress();
      emit(HospitalLoaded(hospital, address!.lat!, address.long!));
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

  Future<String> fetchAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> places = await placemarkFromCoordinates(lat, lng);
      Placemark place = places[0];
      String address =
          '${place.street?.replaceAll(RegExp(r'^[\d\s\-]+'), '')}, ${place.subLocality}, ${place.locality}';
      return address;
    } catch (e) {
      return '';
    }
  }

  Future<Address?> getUserAddress() async{
    final double? lat = sharedPrefs.getAddress()?.lat;
    final double? long = sharedPrefs.getAddress()?.long;
    final String? locationName = sharedPrefs.getAddress()?.locationName;
    if(lat==null && long==null){
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String address = await fetchAddressFromLatLng(position.latitude, position.longitude);
      return Address(lat: position.latitude, long: position.longitude, locationName: address);
    }
    else{
      return Address(lat: lat, long: long, locationName: locationName);
    }
  }

  void startNavigation(double sourceLat, double sourceLong, double destinationLat, double destinationLong, String mode) async {
    emit(HospitalLoading());
    try {
      Address? address = await getUserAddress();
      List<LatLng> polylineCoordinates = await hospitalRepository.getDirections(
          sourceLat, sourceLong, destinationLat, destinationLong, mode
      );
      emit(HospitalLoaded(hospital, address!.lat!, address.long!));
      emit(HospitalNavigationStarted(polylineCoordinates, address!.lat!, address!.long!));
    } catch (e) {
      emit(HospitalError("Failed to load directions"));
    }
  }

  Future<List<double>> getCurrentLocation() async{
    var permissionStatus = await Permission.location.request();
    if (!permissionStatus.isGranted) {
      return [];
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return [position.latitude, position.longitude];
    } catch (e) {
      return [];
    }
  }


  void clearControllers() {
    destinationController.clear();
    sourceController.clear();
  }


  Future<BitmapDescriptor> createImageMarker(String base64Image) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double size = 120; // Marker size
    final Paint paint = Paint()..color = Colors.blue;

    // Draw a circular background
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      paint,
    );

    try {
      // Decode the Base64 image
      final Uint8List bytes = base64Decode(base64Image);
      final ui.Image image = await decodeImageFromList(bytes);

      // Draw the image inside the circle
      paint.isAntiAlias = true;
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(10, 10, size - 20, size - 20), // Adjust image padding
        paint,
      );
    } catch (e) {
      debugPrint("Error loading Base64 image: $e");
    }

    // Convert to BitmapDescriptor
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.toInt(), size.toInt());
    final ByteData? byteData =
    await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List markerBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(markerBytes);
  }


  Future<BitmapDescriptor> getUserLocationMarker() async {
    try {
      String? patientData = sharedPrefs.patientData;
      if (patientData == null) {
        throw Exception("Patient data is null");
      }

      Map<String, dynamic> decodedData = jsonDecode(patientData);
      String? base64Image = decodedData['profileImage'];

      if (base64Image == null || base64Image.isEmpty) {
        throw Exception("Base64 image data is null or empty");
      }

      return await createImageMarker(base64Image);
    } catch (e) {
      debugPrint("Error generating user location marker: $e");
      return BitmapDescriptor.defaultMarker;
    }
  }

  Future<void> navigateToLocation(double latitude, double longitude) async {
    final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
    } else {
      emit(HospitalError('Could not launch Google Maps'));
    }
  }

}

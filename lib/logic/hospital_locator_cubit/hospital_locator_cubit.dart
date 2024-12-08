import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cculacare/configs/global/app_globals.dart';
import 'package:cculacare/data/repositories/bookmark/bookmark_repo.dart';
import 'package:cculacare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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


}

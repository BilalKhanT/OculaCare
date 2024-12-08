import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../configs/global/app_globals.dart';
import '../../models/address/address_model.dart';
import '../../models/hospital_locator_model/hospital_model.dart';
import '../local/preferences/shared_prefs.dart';

class HospitalRepository {
  Address? address = sharedPrefs.getAddress();
  final List<Address> Listaddress = sharedPrefs.getAddressList();

  Future<void> fetchHospitals() async {
    final double? lat = address?.lat;
    final double? long = address?.long;

    if (lat == null || long == null) {
      return;
    }
    final String apiUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$long&radius=5000&type=hospital&keyword=eye%20hospital&key=AIzaSyDHNB_Azk_lm5DKrrtWxO5xlZ5jPPClisI';

    try {
      print("Fetching hospital data...");
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['results'] != null) {
          hospital.clear();
          List<dynamic> results = jsonResponse['results'];
          hospital = results.map((hospitalJson) {
            return Hospital.fromJson(hospitalJson);
          }).toList();

          print("Loaded ${hospital.length} hospitals.");
        } else {
          print("No hospital data found.");
        }
      } else {
        print(
            "Error: Failed to fetch hospital data. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching hospital data: $error");
    }
  }

  Future<List<LatLng>> getDirections(double sourceLat, double sourceLong, double destinationLat, double destinationLong, String mode) async {
    const String accessToken = 'pk.eyJ1IjoiYXdhaXN1cnJlaG1hbiIsImEiOiJjbTJoamtkbXcwYm9lMmtzYWduYXk2N3RqIn0.ctzTZGNR4piVoiCGNb-lew';
    final String url =
        'https://api.mapbox.com/directions/v5/mapbox/$mode/$sourceLong,$sourceLat;$destinationLong,$destinationLat?geometries=geojson&access_token=$accessToken';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];

      List<LatLng> polylineCoordinates = coordinates
          .map((point) => LatLng(point[1], point[0]))
          .toList();

      return polylineCoordinates;
    } else {
      throw Exception("Failed to load directions");
    }
  }
}

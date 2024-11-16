import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../configs/global/app_globals.dart';
import '../../models/address/address_model.dart';
import '../../models/hospital_locator_model/helper_model/hospital_helper_model.dart';
import '../../models/hospital_locator_model/hospital_bookmark_model.dart';
import '../../models/hospital_locator_model/hospital_model.dart';
import '../local/preferences/shared_prefs.dart';

class HospitalRepository {
  Address? address = sharedPrefs.getAddress();
  final String apiUrl = '$ipServer/api/bookmark';
  final String email = sharedPrefs.email;

  Future<void> fetchHospitals() async {
    final double? lat = address?.lat;
    final double? long = address?.long;

    if (lat == null || long == null) {
      return;
    }

    final String apiUrl =
        'https://us1.locationiq.com/v1/nearby.php?key=pk.fb821087f33ba23b0d4c001665006bc0&lat=$lat&lon=$long&tag=hospital&radius=9000&format=json';

    try {
      print("hospital api call");
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        hospital = jsonData.map((hospitalData) => Hospital.fromJson(hospitalData)).toList();
        print('Hospitals loaded: ${hospital.length}');
      } else {
        print('Error: Failed to fetch hospitals, status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching hospitals: $error');
    }
  }

  Future<void> fetchBookmarks() async {
      try {
        final response = await http.get(Uri.parse('$apiUrl/$email'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          bookmarks = data.map((hospitalData) => HospitalHelper.fromJson(hospitalData)).toList();
          print('Bookmarks loaded: ${bookmark.length}');
        } else {
          print('Failed to fetch bookmarks. Status code: ${response.statusCode}');
          bookmark = [];
        }
      } catch (e) {
        print('Error occurred while fetching bookmarks: $e');
        bookmark = [];
      }

  }

  Future<bool> addBookmark(Bookmark bookmark) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/add"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bookmark.toJson()),
      );

      print(response.statusCode);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        return false;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }


  Future<bool> deleteBookmark(String placeId) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/delete/$email/$placeId'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete bookmark: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      throw Exception('Error occurred while deleting bookmark: $e');
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

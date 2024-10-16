import 'dart:convert';
import 'package:nb_utils/nb_utils.dart';
import '../../../configs/global/app_globals.dart';
import '../../models/address/address_model.dart';
import 'package:http/http.dart' as http;

class AddressBookRepo {
  Future<bool> addAddress({
    required String email,
    required Address address,
  }) async {
    final String apiUrl = '$ipServer/api/addressBook/add-address';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
          'lat': address.lat,
          'long': address.long,
          'locationName': address.locationName,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        log('Failed to add address: ${response.body}');
        return false;
      }
    } catch (error) {
      log('Error adding address: $error');
      return false;
    }
  }

  Future<bool> deleteAddress({
    required String email,
    required Address address,
  }) async {
    final String apiUrl = '$ipServer/api/addressBook/delete-address';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
          'lat': address.lat,
          'long': address.long,
          'locationName': address.locationName,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        log('Failed to delete address: ${response.body}');
        return false;
      } else {
        log('Failed to delete address: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      log('Error deleting address: $error');
      return false;
    }
  }
}

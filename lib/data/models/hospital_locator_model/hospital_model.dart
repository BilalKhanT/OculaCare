import 'package:google_maps_flutter/google_maps_flutter.dart';

class Hospital {
  final String name;
  final String placeId;
  final LatLng location;
  final String address;
  final double? rating;
  final int? userRatingsTotal;
  final String iconUrl;
  final String businessStatus;

  Hospital({
    required this.name,
    required this.placeId,
    required this.location,
    required this.address,
    this.rating,
    this.userRatingsTotal,
    required this.iconUrl,
    required this.businessStatus,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      name: json['name'],
      placeId: json['place_id'],
      location: LatLng(
        json['geometry']['location']['lat'],
        json['geometry']['location']['lng'],
      ),
      address: json['vicinity'],
      rating: json['rating']?.toDouble(),
      userRatingsTotal: json['user_ratings_total'],
      iconUrl: json['icon'],
      businessStatus: json['business_status'] ?? 'UNKNOWN',
    );
  }
}

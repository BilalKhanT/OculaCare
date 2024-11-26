import 'package:google_maps_flutter/google_maps_flutter.dart';

class Bookmark {
  final String email;
  final String name;
  final String placeId;
  final LatLng location;
  final String address;
  final double? rating;
  final int? userRatingsTotal;
  final String iconUrl;

  Bookmark({
    required this.email,
    required this.name,
    required this.placeId,
    required this.location,
    required this.address,
    this.rating,
    this.userRatingsTotal,
    required this.iconUrl,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      email: json['email'],
      name: json['name'],
      placeId: json['placeId'],
      location: LatLng(
        json['location']['lat'],
        json['location']['lng'],
      ),
      address: json['address'],
      rating: json['rating']?.toDouble(),
      userRatingsTotal: json['userRatingsTotal'],
      iconUrl: json['iconUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'placeId': placeId,
      'location': {
        'lat': location.latitude,
        'lng': location.longitude,
      },
      'address': address,
      'rating': rating,
      'userRatingsTotal': userRatingsTotal,
      'iconUrl': iconUrl,
    };
  }
}

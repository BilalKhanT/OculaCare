import 'hospital_address_model.dart';

class Hospital {
  final String placeId;
  final String osmId;
  final String osmType;
  final String licence;
  final double lat;
  final double lon;
  final List<double> boundingBox;
  final String type;
  final String name;
  final String displayName;
  final HospitalAddress address;
  final int distance;

  Hospital({
    required this.placeId,
    required this.osmId,
    required this.osmType,
    required this.licence,
    required this.lat,
    required this.lon,
    required this.boundingBox,
    required this.type,
    required this.name,
    required this.displayName,
    required this.address,
    required this.distance,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      placeId: json['place_id'] as String,
      osmId: json['osm_id'] as String,
      osmType: json['osm_type'] as String,
      licence: json['licence'] as String,
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
      boundingBox: List<double>.from(json['boundingbox'].map((item) => double.parse(item))),
      type: json['type'] as String,
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      address: HospitalAddress.fromJson(json['address']),
      distance: json['distance'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'osm_id': osmId,
      'osm_type': osmType,
      'licence': licence,
      'lat': lat.toString(),
      'lon': lon.toString(),
      'boundingbox': boundingBox.map((e) => e.toString()).toList(),
      'type': type,
      'name': name,
      'display_name': displayName,
      'address': address.toJson(),
      'distance': distance,
    };
  }
}

class AddressHelper {
  final String name;
  final String? road;
  final String? suburb;
  final String? city;
  final String? state;
  final String? postcode;
  final String? country;
  final String? countryCode;

  AddressHelper({
    required this.name,
    this.road,
    this.suburb,
    this.city,
    this.state,
    this.postcode,
    this.country,
    this.countryCode,
  });

  factory AddressHelper.fromJson(Map<String, dynamic> json) {
    return AddressHelper(
      name: json['name'] as String,
      road: json['road'] as String?,
      suburb: json['suburb'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postcode: json['postcode'] as String?,
      country: json['country'] as String?,
      countryCode: json['country_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'road': road,
      'suburb': suburb,
      'city': city,
      'state': state,
      'postcode': postcode,
      'country': country,
      'country_code': countryCode,
    };
  }
}

class HospitalHelper {
  final String placeId;
  final String osmId;
  final String osmType;
  final String licence;
  final String lat;
  final String lon;
  final String type;
  final String name;
  final String displayName;
  final AddressHelper address;
  final int distance;
  final String id;

  HospitalHelper({
    required this.placeId,
    required this.osmId,
    required this.osmType,
    required this.licence,
    required this.lat,
    required this.lon,
    required this.type,
    required this.name,
    required this.displayName,
    required this.address,
    required this.distance,
    required this.id,
  });

  factory HospitalHelper.fromJson(Map<String, dynamic> json) {
    return HospitalHelper(
      placeId: json['place_id'] as String,
      osmId: json['osm_id'] as String,
      osmType: json['osm_type'] as String,
      licence: json['licence'] as String,
      lat: json['lat'] as String,
      lon: json['lon'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      address: AddressHelper.fromJson(json['address'] as Map<String, dynamic>),
      distance: json['distance'] as int,
      id: json['_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'osm_id': osmId,
      'osm_type': osmType,
      'licence': licence,
      'lat': lat,
      'lon': lon,
      'type': type,
      'name': name,
      'display_name': displayName,
      'address': address.toJson(),
      'distance': distance,
      '_id': id,
    };
  }
}

class HospitalAddress {
  final String name;
  final String? road;
  final String? suburb;
  final String? city;
  final String? state;
  final String? postcode;
  final String? country;
  final String? countryCode;

  HospitalAddress({
    required this.name,
    this.road,
    this.suburb,
    this.city,
    this.state,
    this.postcode,
    this.country,
    this.countryCode,
  });

  factory HospitalAddress.fromJson(Map<String, dynamic> json) {
    return HospitalAddress(
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
class Address {
  final double? lat;
  final double? long;
  final String? locationName;

  Address({
    required this.lat,
    required this.long,
    required this.locationName,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    lat: (json["lat"] is int) ? (json["lat"] as int).toDouble() : json["lat"] as double?,
    long: (json["long"] is int) ? (json["long"] as int).toDouble() : json["long"] as double?,
    locationName: json["locationName"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "long": long,
    "locationName": locationName,
  };
}

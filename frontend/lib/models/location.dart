class Location {
  final String address;
  final double lat;
  final double lng;
  final String? notes;

  Location({
    required this.address,
    required this.lat,
    required this.lng,
    this.notes,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'lat': lat,
      'lng': lng,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  String toString() => 'Location(address: $address, lat: $lat, lng: $lng)';
}

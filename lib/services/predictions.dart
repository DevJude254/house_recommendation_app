class RecommendedLocation {
  final String location;
  final double rentPrice;
  final double distance;

  RecommendedLocation({
    required this.location,
    required this.rentPrice,
    required this.distance,
  });

  factory RecommendedLocation.fromJson(Map<String,dynamic> json) {
    return RecommendedLocation(
      location: json['location'] ?? 'Unknown',
      rentPrice: (json['rent_price'] as num).toDouble(),
      distance: (json['distance_from_campus_km'] as num).toDouble(),
    );
  }
}
class RentPredictionRequest {
  final String? roomType;
  final double distanceFromCampusKm;
  final int securityScore;
  final int infrastructureScore;
  final int waterElectricityReliability;
  final int internetAvailability;

  RentPredictionRequest({
    required this.roomType,
    required this.distanceFromCampusKm,
    required this.securityScore,
    required this.infrastructureScore,
    required this.waterElectricityReliability,
    required this.internetAvailability,
  });

  Map<String, dynamic> toJson() => {
    if (roomType != null) 'room_type': roomType,
    "distance_from_campus_km": distanceFromCampusKm,
    "security_score": securityScore,
    "infrastructure_score": infrastructureScore,
    "water_electricity_reliability": waterElectricityReliability,
    "internet_availability": internetAvailability,
  };
}

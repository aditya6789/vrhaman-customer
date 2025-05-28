class Vehicle {
  final String id;
  final String? vendorId;
  final dynamic vehicleId;  // Can be String or Map
  final String name;
  final List<String> images;
  final double dailyRate;
  final String? availableDelivery;
  final String? availabilityStatus;
  final Map<String, dynamic>? vehicleDetails;
  final double? averageRating;
  final int? seats;
  final String? fuelType;
  final int? enginecc;


  Vehicle({
    required this.id,
    this.vendorId,
    this.vehicleId,
    required this.name,
    required this.images,
    required this.dailyRate,
    this.availableDelivery,
    this.availabilityStatus,
    this.vehicleDetails,
    this.averageRating,
    this.seats,
    this.fuelType,
    this.enginecc,
  });
}



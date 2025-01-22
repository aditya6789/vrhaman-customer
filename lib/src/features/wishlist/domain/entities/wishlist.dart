class Wishlist {
  final String id;
  final String vehicleId;
  final String vehicleName;
  final List<dynamic> vehicleImage;

  final int vehicleDailyRate;
  final int vehicleTopSpeed;
  final int vehicleMileage;
  final int vehicleEngineCc;
  final String vehicleAvailabilityStatus;
Wishlist({
  required this.id,
  required this.vehicleId,
  required this.vehicleName,
  required this.vehicleImage,

  required this.vehicleDailyRate,
  required this.vehicleTopSpeed,
  required this.vehicleMileage,
  required this.vehicleEngineCc,
  required this.vehicleAvailabilityStatus,
});
}
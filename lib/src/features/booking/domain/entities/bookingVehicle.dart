class BookingVehicle {
  final String id;
  final String customerId;
  final String vehicleId;
  final String vehicleName;
  final List<dynamic> vehicleImages;
  final String vendorId;
  final String vendorBusinessName;
  final String vendorBusinessAddress;
  final String vendorPhone;
  final String vendorAlternativePhone;
  final String payment_type;

  final DateTime startDate;
  final String startTime;
  final DateTime endDate;
  final String status;
  final int totalPrice;
  final String rentalPeriod;
 

  BookingVehicle({
    required this.id,
    required this.customerId,
    required this.vehicleId,
    required this.vehicleName,
    required this.vehicleImages,
    required this.vendorId,
    required this.vendorBusinessName,
    required this.vendorBusinessAddress,
    required this.vendorPhone,
    required this.vendorAlternativePhone,
    required this.startDate,
    required this.startTime,
    required this.payment_type,
    required this.endDate,
    required this.status,
    required this.totalPrice,
    required this.rentalPeriod,
   
  });
}

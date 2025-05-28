class ConfirmBookingData {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String vehicleName;
  final List<dynamic> vehicleImages;
  final bool isDeliveryAtHome;
  final String vendorBusinessName;
  // final String vendorBusinessEmail;
  final String vendorBusinessAddress;
  final DateTime startDate;
  final String startTime;
  final DateTime endDate;
  final String duration;
  final int totalPrice;
  final String paymentType;

  ConfirmBookingData({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.vehicleName,
    required this.vehicleImages,
    required this.isDeliveryAtHome,
    required this.vendorBusinessName,
    // required this.vendorBusinessEmail,
    required this.vendorBusinessAddress,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.duration,
    required this.totalPrice,
    required this.paymentType,
  });
}

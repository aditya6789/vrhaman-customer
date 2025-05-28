class BookingData {
      final String startDate;
      final String duration;
      final String startTime;
      final String customerId;
      final String vehicleId;
      final String vendorId;
      final String paymentType;
      final bool isDeliveryAtHome;
      final String? addressId;

      BookingData({
        required this.startDate,
        required this.duration,
        required this.startTime,
        required this.customerId,
        required this.vehicleId,
        required this.paymentType,
        required this.vendorId, 
        required this.isDeliveryAtHome,
        this.addressId,
      });

}
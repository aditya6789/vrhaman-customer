class VehicleDetails {
  final String id ;
  final String name;
  final String vendorId;
  final String bussinessName;
  final String bussinessAddress;
  final int dailyPrice;
  final int twoDayPrice;
  final int threeDayPrice;
  final int fourDayPrice;
  final int fiveDayPrice;
  final int sixDayPrice;
  final int weeklyPrice;
  final int twoWeekPrice;
  final int threeWeekPrice;
final int monthlyPrice;
final int twoMonthPrice;
final int threeMonthPrice;
final int deliveryFees; 


  final String availableDelivery;
  final String availabilityStatus;
  final List<dynamic> images;
  final int year;
  final String variant;

  final int engineCc;
  final String fuelType;
  final String bodyType;
  final int mileage;
  final int topSpeed;
  final int horsepower;
  final int torque;
  final int weight;
  final List<dynamic> features;
  

  VehicleDetails({required this.id , required this.name , required this.vendorId , required this.bussinessName , required this.bussinessAddress , required this.dailyPrice , required this.twoDayPrice , required this.threeDayPrice , required this.fourDayPrice , required this.fiveDayPrice , required this.sixDayPrice , required this.weeklyPrice , required this.twoWeekPrice , required this.threeWeekPrice , required this.monthlyPrice , required this.twoMonthPrice , required this.threeMonthPrice , required this.deliveryFees , required this.availableDelivery , required this.availabilityStatus , required this.images , required this.year , required this.variant ,  required this.engineCc , required this.fuelType , required this.bodyType , required this.mileage , required this.topSpeed , required this.horsepower , required this.torque , required this.weight , required this.features});
}
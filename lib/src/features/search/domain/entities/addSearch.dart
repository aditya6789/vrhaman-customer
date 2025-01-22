class AddSearch {
  final String startDate;
  final String duration;
  final String vehicleType;
  final LocationSearch location;

  AddSearch({required this.startDate, required this.duration, required this.vehicleType, required this.location});
}

class LocationSearch {
  final double latitude;
  final double longitude ;

  LocationSearch({required this.latitude, required this.longitude});
}

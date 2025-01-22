import 'package:vrhaman/src/features/search/domain/entities/addSearch.dart';

class AddSearchModel extends AddSearch {
  AddSearchModel({
    required String startDate,
    required String duration,
    required String vehicleType,
    required LocationSearch location,
  }) : super(
          startDate: startDate,
          duration: duration,
          vehicleType: vehicleType,
          location: location,
        );

  // factory AddSearchModel.fromJson(Map<String, dynamic> json) {
  //   return AddSearchModel(
  //     startDate: DateTime.parse(json['startDate']),
  //     duration: json['duration'],
  //     vehicleType: json['vehicleType'],
  //     location: LocationSearchModel.fromJson(json['location']),
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'startDate': startDate.toIso8601String(),
  //     'duration': duration,
  //     'vehicleType': vehicleType,
  //     'location': (location as LocationSearchModel).toJson(),
  //   };
  // }
}

class LocationSearchModel extends LocationSearch {
  LocationSearchModel({
    required double latitude,
    required double longitude,
  }) : super(latitude: latitude, longitude: longitude);

  // factory LocationSearchModel.fromJson(Map<String, dynamic> json) {
  //   return LocationSearchModel(
  //     latitude: json['latitude'],
  //     longitude: json['longitude'],
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'latitude': latitude,
  //     'longitude': longitude,
  //   };
  // }
}

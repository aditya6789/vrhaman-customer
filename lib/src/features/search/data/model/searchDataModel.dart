import 'package:vrhaman/src/features/search/domain/entities/searchdata.dart';

class SearchDataModel extends SearchData {
  final String makeName;
  // final String modelName;
  // final List<String> images;

  SearchDataModel({
    required super.id,
    required super.price,
    required super.vehicleType,
    required super.vehicleImage,
    required super.vehicleName,
    required this.makeName,
    // required this.modelName,
  });

  factory SearchDataModel.fromJson(Map<String, dynamic> json) {
    return SearchDataModel(
      id: json['_id'],
      price: json['daily_rate'],
      vehicleType: json['vehicle_id']['type'],
      vehicleImage: List<String>.from(json['images']),
      vehicleName: json['vehicle_id']['name'],
      makeName: json['vehicle_id']['make']['name'],
      // modelName: json['vehicle_id']['model'],
    );
  }
}
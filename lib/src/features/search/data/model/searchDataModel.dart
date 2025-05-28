import 'package:vrhaman/src/features/search/domain/entities/searchdata.dart';

class SearchDataModel extends SearchData {
 
  // final String modelName;
  // final List<String> images;

  SearchDataModel({
    required super.id,
    required super.dailyPrice,
    required super.weeklyPrice,
    required super.monthlyPrice,
    required super.vehicleType,
    required super.vehicleImage,
    required super.vehicleName,
    required super.averageRating,
    required super.distance,
    required super.meters,
  
    // required this.modelName,
  });

  factory SearchDataModel.fromJson(Map<String, dynamic> json) {
    return SearchDataModel(
      id: json['_id'],
      dailyPrice: json['daily_rate'],
      weeklyPrice: json['weekly_rate'],
      monthlyPrice: json['monthly_rate'],
      vehicleType: json['vehicle_id']['type'],
      vehicleImage: List<String>.from(json['images']),
      vehicleName: json['vehicle_id']['name'],
      averageRating: json['average_rating'].toDouble() ?? 0.0,
      meters: json['distance']['distance']['meters'].toDouble() ?? 0.0,
      distance: json['distance']['distance']['text'],




      // modelName: json['vehicle_id']['model'],
    );
  }
}
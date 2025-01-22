import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const kGoogleApiKey = 'AIzaSyCdXyAkWjkhUlWXBbpkieWRi2OV47AbVFE';

Future<LatLng> getLatLng(String placeId) async {
  if (placeId.contains(',')) {
    var parts = placeId.split(',');
    var lat = double.parse(parts[0]);
    var lng = double.parse(parts[1]);
    return LatLng(lat, lng);
  }

  final url =
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$kGoogleApiKey';

  try {
    final response = await http.get(Uri.parse(url));
    final responseBody = json.decode(response.body);

    if (response.statusCode == 200 && responseBody['status'] == 'OK') {
      final result = responseBody['result'];
      if (result != null &&
          result['geometry'] != null &&
          result['geometry']['location'] != null) {
        final location = result['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        return LatLng(lat, lng);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      final errorMessage = responseBody['error_message'] ?? 'Unknown error';
      throw Exception('API Error: $errorMessage');
    }
  } catch (e) {
    print('Error fetching location details: $e');
    throw Exception('Failed to fetch location details: $e');
  }
}

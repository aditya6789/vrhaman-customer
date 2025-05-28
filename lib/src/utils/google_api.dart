import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:vrhaman/constants.dart';



Future<LatLng> getLatLng(String placeId) async {
  if (placeId.contains(',')) {
    var parts = placeId.split(',');
    var lat = double.parse(parts[0]);
    var lng = double.parse(parts[1]);
    return LatLng(lat, lng);
  }

  final url =
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${kgoogleApiKey}';

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

Future<Map<String, String>> getStateAndCity(String pincode, String apiKey) async {
  final url =
      'https://maps.googleapis.com/maps/api/geocode/json?address=$pincode&key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['results'].isNotEmpty) {
      final addressComponents = data['results'][0]['address_components'];

      String? state;
      String? city;

      for (var component in addressComponents) {
        if (component['types'].contains('administrative_area_level_1')) {
          state = component['long_name']; // State
        } else if (component['types'].contains('locality')) {
          city = component['long_name']; // City
        }
      }

      return {
        'state': state ?? 'Unknown State',
        'city': city ?? 'Unknown City',
      };
    } else {
      throw Exception('No results found for the provided pincode.');
    }
  } else {
    throw Exception('Failed to fetch location data.');
  }
}

Future<Map<String, String>> getAddressFromLatLng(
  double latitude,
  double longitude,
  String apiKey,
) async {
  final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';
  
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['results'].isNotEmpty) {
      return {
        'formatted_address': data['results'][0]['formatted_address'],
      };
    }
  }
  throw Exception('Failed to get address');
}

Future<List<dynamic>> searchPlaces(String query, String apiKey) async {
  if (query.isEmpty) return [];

  final url = Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json'
      '?input=$query'
      '&key=$apiKey'
      '&components=country:in'
      '&types=geocode|establishment'
      '&location=20.5937,78.9629' // Center of India
      '&radius=2000000'); // 2000km radius

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return data['predictions'] ?? [];
      }
      print('Place API Error: ${data['status']}');
      return [];
    }
  } catch (e) {
    print('Search places error: $e');
  }
  return [];
}

Future<Map<String, dynamic>> getPlaceDetails(String placeId, String apiKey) async {
  final url = Uri.parse('https://maps.googleapis.com/maps/api/place/details/json'
      '?place_id=$placeId'
      '&key=$apiKey'
      '&fields=formatted_address,address_components,geometry');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['result'] ?? {};
  }
  throw Exception('Failed to get place details');
}

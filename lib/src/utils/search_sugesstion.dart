import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/models/prediction.dart';





Future<List<Prediction>> fetchSuggestions(String input) async {
  final sessionToken = UniqueKey().toString();
  final request =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=geocode|establishment&components=country:in&key=${kgoogleApiKey}&sessiontoken=$sessionToken';

  final response = await http.get(Uri.parse(request));

  if (response.statusCode == 200) {
    final result = json.decode(response.body);
    if (result['status'] == 'OK') {
      return (result['predictions'] as List)
          .map((p) => Prediction.fromJson(p))
          .toList();
    } else if (result['status'] == 'ZERO_RESULTS') {
      return [];
    } else {
      throw Exception(result['error_message']);
    }
  } else {
    throw Exception('Failed to fetch suggestions');
  }
}

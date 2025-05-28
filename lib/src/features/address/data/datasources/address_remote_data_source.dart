import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vrhaman/src/core/error/exceptions.dart';
import 'package:vrhaman/src/utils/api_response.dart';
import '../../data/model/addressModel.dart';

abstract class AddressRemoteDataSource {
  Future<AddressModel> getAddresses();
  Future<void> addAddress(String address, String city, String state, String postalCode);
  Future<void> updateAddress(String id, String address, String city, String state, String postalCode);
  Future<String> deleteAddress(String id);
  Future<void> setDefaultAddress(String id);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {


  AddressRemoteDataSourceImpl();

  @override
  Future<AddressModel> getAddresses() async {
    try {
      final response = await getRequest('users/address');
      print('Address response status code: ${response.statusCode}');
      print('Address response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data != null && response.data['data'] != null) {
          return AddressModel.fromJson(response.data['data']);
        } else {
          // Return an empty AddressModel if no data is present
          return AddressModel(
            id: '',
            userId: '',
            addresses: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
      } else {
        throw ServerException('Failed to load addresses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAddresses: $e');
      // Return an empty AddressModel on error
      return AddressModel(
        id: '',
        userId: '',
        addresses: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }


  @override
  Future<void> addAddress(String address, String city, String state, String postalCode) async {
    final response = await postRequest('users/address',
      {
        'address': address,
        'city': city,
        'state': state,
        'postalCode': postalCode,
      }
    );
    
      if (response.statusCode != 200) {
        throw Exception('Failed to add address');
      }


    if (response.statusCode != 200) {
      throw Exception('Failed to add address');
    }
  }

  @override
  Future<void> updateAddress(String id, String address, String city, String state, String postalCode) async {
    final response = await putRequest('users/address/$id',
      {
        'address': address,
        'city': city,
        'state': state,
        'postalCode': postalCode,
      }
    );


    if (response.statusCode != 200) {
      throw Exception('Failed to update address');
    }
  }

  @override
  Future<String> deleteAddress(String id) async {
    final response = await deleteRequest('users/address/$id');
    print('Delete address response: ${response.statusCode}');
    print('Delete address response: ${response.data}');
    


    if (response.statusCode != 200) {
      throw Exception('Failed to delete address');
    }else{
      return 'Address deleted successfully';
      print('Address deleted successfully');
    }
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    final response = await patchRequest('users/address/$id/default',{});


    if (response.statusCode != 200) {
      throw Exception('Failed to set default address');
    }
  }
}

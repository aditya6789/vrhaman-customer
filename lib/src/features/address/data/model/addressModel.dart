class AddressModel {
  final String id;
  final String userId;
  final List<Address> addresses;
  final DateTime createdAt;
  final DateTime updatedAt;

  AddressModel({
    required this.id,
    required this.userId,
    required this.addresses,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    try {
      // Handle case where addresses might be directly in the data field
      var addressesList = json['addresses'];
      if (addressesList == null && json is Map) {
        // If addresses is not found, the entire json might be the address list
        addressesList = [json];
      }

      return AddressModel(
        id: json['_id'] ?? '',
        userId: json['user_id'] ?? '',
        addresses: addressesList != null 
            ? (addressesList as List).map((address) => Address.fromJson(address)).toList()
            : [],
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      );
    } catch (e, stackTrace) {
      print('Error parsing AddressModel: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }
}

class Address {
  final String id;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final bool isDefault;

  Address({
    required this.id,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    try {
      return Address(
        id: json['_id'] ?? '',
        address: json['address'] ?? '',
        city: json['city'] ?? '',
        state: json['state'] ?? '',
        postalCode: json['postalCode'] ?? '',
        isDefault: json['isDefault'] ?? false,
      );
    } catch (e) {
      print('Error parsing Address: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
}

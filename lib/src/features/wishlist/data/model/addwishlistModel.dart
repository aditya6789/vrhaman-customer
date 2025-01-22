import 'package:vrhaman/src/features/wishlist/domain/entities/addWishlist.dart';

class AddWishlistModel extends AddWishlist {
  AddWishlistModel({required super.vehicleId});

  factory AddWishlistModel.fromJson(Map<String, dynamic> json) {
    return AddWishlistModel(vehicleId: json['vehicleId']);
  }
}
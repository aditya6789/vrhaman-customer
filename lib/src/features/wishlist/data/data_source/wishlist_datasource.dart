import 'package:vrhaman/src/core/error/exceptions.dart';
import 'package:vrhaman/src/features/wishlist/data/model/addwishlistModel.dart';
import 'package:vrhaman/src/features/wishlist/data/model/wishlistModel.dart';
import 'package:vrhaman/src/features/wishlist/domain/entities/addWishlist.dart';
import 'package:vrhaman/src/utils/api_response.dart';

abstract interface class WishlistDataSource {
  Future<void> addWishlist(AddWishlistModel addWishlist);
  Future<List<WishlistModel>> getWishlist();
}

class WishlistDataSourceImpl implements WishlistDataSource {
  WishlistDataSourceImpl();

  @override
  Future<void> addWishlist(AddWishlistModel addWishlist) async {
    print('wishlist: ${addWishlist.vehicleId}');
    try {
      final response = await postRequest('wishlist/', {
        'vehicleId': addWishlist.vehicleId,
      });
      print('wishlist: ${response}');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<WishlistModel>> getWishlist() async {
    try {
      final response = await getRequest('wishlist');
      if (response.statusCode == 200) {
        final List<dynamic> vehicles = response.data['wishlist']['vehicles'];
        return vehicles
            .map((vehicle) => WishlistModel.fromJson(vehicle))
            .toList();
      }
      throw ServerException('Failed to load wishlist');
    } catch (e) {
      print('Wishlist Error: $e');
      throw ServerException(e.toString());
    }
  }

}

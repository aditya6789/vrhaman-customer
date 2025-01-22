import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/wishlist/data/data_source/wishlist_datasource.dart';
import 'package:vrhaman/src/features/wishlist/data/model/addwishlistModel.dart';
import 'package:vrhaman/src/features/wishlist/domain/entities/addWishlist.dart';
import 'package:vrhaman/src/features/wishlist/domain/entities/wishlist.dart';
import 'package:vrhaman/src/features/wishlist/domain/repositories/wishlist_repositories.dart';


class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistDataSource wishlistDataSource;

  WishlistRepositoryImpl({required this.wishlistDataSource});

  @override
  Future<Either<Failure, AddWishlist>> addWishlist(AddWishlist addWishlist) async {
    try {
      await wishlistDataSource.addWishlist(AddWishlistModel(vehicleId: addWishlist.vehicleId));
      return Right(addWishlist); // Return the successful result
    } catch (e) {
      return Left(Failure(e.toString())); // Return a failure in case of an error
    }
  }
  @override
  Future<Either<Failure, List<Wishlist>>> getWishlist() async {
    try {
      final wishlistModels = await wishlistDataSource.getWishlist();
      return Right(wishlistModels);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

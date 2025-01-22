import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/wishlist/domain/entities/addWishlist.dart';
import 'package:vrhaman/src/features/wishlist/domain/entities/wishlist.dart';

abstract interface class WishlistRepository {
  Future<Either<Failure , AddWishlist>> addWishlist(AddWishlist addWishlist);
  Future<Either<Failure , List<Wishlist>>> getWishlist();
}

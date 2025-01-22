import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/wishlist/domain/entities/addWishlist.dart';
import 'package:vrhaman/src/features/wishlist/domain/entities/wishlist.dart';
import 'package:vrhaman/src/features/wishlist/domain/repositories/wishlist_repositories.dart';


class AddWishlistUseCase {
  final WishlistRepository repository;

  AddWishlistUseCase(this.repository);

  Future<Either<Failure, AddWishlist>> call(AddWishlist addWishlist) async {
    return await repository.addWishlist(addWishlist);
  }
  Future<Either<Failure, List<Wishlist>>> getWishlist() async {
    return await repository.getWishlist();
  }
}

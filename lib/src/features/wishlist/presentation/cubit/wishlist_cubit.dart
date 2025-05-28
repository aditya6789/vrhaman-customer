import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/wishlist/domain/entities/addWishlist.dart';
import 'package:vrhaman/src/features/wishlist/domain/entities/wishlist.dart';
import 'package:vrhaman/src/features/wishlist/domain/usecases/wishlist_usecases.dart';

part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final AddWishlistUseCase addWishlistUseCase;

  WishlistCubit({required this.addWishlistUseCase}) : super(WishlistInitial());

  Future<void> addWishlist(AddWishlist addWishlist) async {
    try {
      emit(WishlistLoading());
      await addWishlistUseCase.call(addWishlist);
      emit(WishlistSuccess());
    } catch (e) {
      emit(WishlistFailure(error: e.toString()));
    }
  }

  Future<void> getWishlist() async {
    print('getWishlist');
    try {
      emit(WishlistLoading());
      final result = await addWishlistUseCase.getWishlist();
      result.fold(
        (failure) => emit(WishlistFailure(error: failure.toString())),
        (wishlist) => emit(WishlistLoaded(wishlist: wishlist)),
      );
    } catch (e) {
      emit(WishlistFailure(error: e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteWishlist(String vehicleId) async {
    try {
      emit(WishlistLoading());
      final result = await addWishlistUseCase.deleteWishlist(vehicleId);
      await result.fold(
        (failure) async {
          emit(WishlistFailure(error: failure.toString()));
          return Left(failure);
        },
        (success) async {
          // After successful deletion, fetch the updated wishlist
          final updatedWishlist = await addWishlistUseCase.getWishlist();
          updatedWishlist.fold(
            (failure) => emit(WishlistFailure(error: failure.toString())),
            (wishlist) => emit(WishlistLoaded(wishlist: wishlist)),
          );
          return Right(success);
        },
      );
      return result;
    } catch (e) {
      emit(WishlistFailure(error: e.toString()));
      return Left(Failure(e.toString()));
    }
  }
}

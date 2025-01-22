part of 'wishlist_cubit.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
    final List<Wishlist> wishlist;

  const WishlistLoaded({required this.wishlist});
  
  @override
  List<Object> get props => [wishlist];
}

class WishlistSuccess extends WishlistState {


}

class WishlistFailure extends WishlistState {
  final String error;

  const WishlistFailure({required this.error});

  @override
  List<Object> get props => [error];
}

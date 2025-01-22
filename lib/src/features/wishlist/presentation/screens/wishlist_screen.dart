import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/src/common/loading.dart';
import 'package:vrhaman/src/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrhaman/src/features/wishlist/presentation/widget/wishlist_card_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<WishlistCubit, WishlistState>(
              builder: (context, state) {
                if (state is WishlistLoading) {
                  return const Loading();
                } else if (state is WishlistLoaded) {
                  return Column(
                    children: state.wishlist.map((vehicle) {
                      return WishlistCardWidget(vehicle: vehicle);
                    }).toList(),
                  );
                } else if (state is WishlistFailure) {
                  return  Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    SizedBox(height: 100.h,),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child:  Icon(Icons.favorite, size: 60.sp, color: Colors.white,)),
                      SizedBox(height: 16.h,),
                      Text('No wishlist available', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),),
                    ],
                  ));
                } else {
                  return const Center(child: Text('No wishlist available'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

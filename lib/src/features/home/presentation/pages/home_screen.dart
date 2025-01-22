import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/common/loading.dart';
import 'package:vrhaman/src/features/home/presentation/widget/feature_card.dart';
import 'package:vrhaman/src/features/home/presentation/widget/location_widget.dart';
import 'package:vrhaman/src/features/home/presentation/widget/search_home_widget.dart';
import 'package:vrhaman/src/features/profile/presentation/screens/account_information&edit_screen.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/pages/vehicle_details_screen.dart';
import 'package:vrhaman/src/features/home/domain/entities/vehicle.dart';
import 'package:vrhaman/src/features/home/presentation/bloc/home_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vrhaman/src/features/home/presentation/widget/vehicle_small_card.dart';
import 'package:google_fonts/google_fonts.dart';

class Category {
  final String name;
  final IconData icon;
  bool isSelected;

  Category({required this.name, required this.icon, this.isSelected = false});
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Vehicle> vehicleModels = [];
  String cityName = '';
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Category> categories = [
    Category(name: 'All', icon: Icons.grid_view_rounded, isSelected: true),
    Category(name: 'Bikes', icon: Icons.motorcycle),
    Category(name: 'Cars', icon: Icons.directions_car),
    Category(name: 'E-Bikes', icon: Icons.electric_bike),
    Category(name: 'CNG', icon: Icons.local_gas_station),
    Category(name: 'Petrol', icon: Icons.local_gas_station),
  ];

  Future<void> _getCurrentLocation() async {
    var permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied.');
        } else if (permission == LocationPermission.deniedForever) {
          return Future.error('Location permissions are permanently denied.');
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (mounted) {
        setState(() {
          cityName = placemarks[0].locality ?? 'Unknown location';
          print('City Name: $cityName');
        });
      }
    } else {
      return Future.error('Location permissions denied.');
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeCubit>(context).fetchHomeData();
    _getCurrentLocation();
    print('City Name: $cityName');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildVehicleList(List<Vehicle> vehicles, String title, String subtitle) {
    if (vehicles.isEmpty) return SizedBox.shrink();
    
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                ),
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.arrow_forward, size: 16.sp),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 250.h,
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(width: 16.w),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return Hero(
                  tag: 'vehicle_${vehicle.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehicleDetailsScreen(
                              vehicleId: vehicle.id,
                            ),
                          ),
                        );
                      },
                      child: VehicleSmallCard(
                        vehicleId: vehicle.id,
                        image: vehicle.images.isNotEmpty
                            ? '$IMAGE_URL${vehicle.images[0]}'
                            : 'https://images.pexels.com/photos/819805/pexels-photo-819805.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                        name: vehicle.name,
                        price: vehicle.dailyRate.toString(),
                        description: vehicle.availableDelivery.toString(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: () async {
            BlocProvider.of<HomeCubit>(context).fetchHomeData();
            await _getCurrentLocation();
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Top Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Colors.black87),
                          SizedBox(width: 8.w),
                          Text(
                            cityName.isEmpty ? 'Location' : cityName,
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountInformationEditScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                          child: Icon(Icons.person_outline),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Title and Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search any vehicle...',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[400],
                              fontSize: 14.sp,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: Colors.grey[600],
                              size: 22.sp,
                            ),
                            suffixIcon: Container(
                              margin: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.tune_rounded,
                                color: primaryColor,
                                size: 20.sp,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Top Brands
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child:
                          Text(
                            'Top Brands',
                           style: mediumTextStyle.copyWith(fontWeight: FontWeight.w600),
                          ),
                        
                       
                    ),
                    SizedBox(
                      height: 90.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        children: [
                          _buildBrandCircle('All', Icons.grid_view_rounded),
                          ...BlocProvider.of<HomeCubit>(context).state is HomeSuccess
                              ? (BlocProvider.of<HomeCubit>(context).state as HomeSuccess)
                              
                                  .brands
                                  .map((brand) => _buildBrandCircle(brand.name, brand.image, isImage: true))
                              : [],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Vehicle Lists
              SliverToBoxAdapter(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is HomeSuccess) {
                      return Column(
                        children: [
                          if(state.popularCars.isNotEmpty)
                          _buildVehicleSection('Top Rated ', state.popularCars),
                          if(state.userPreferred.isNotEmpty)
                          _buildVehicleSection('Near Popular', state.userPreferred),
                        ],
                      );
                    }
                    return SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandCircle(String name, dynamic icon, {bool isImage = false}) {
    return Container(
      margin: EdgeInsets.only(right: 20.w),
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
            ),
            child: Center(
              child: isImage
                  ? (icon != null && icon.isNotEmpty
                      ? Image.network('$IMAGE_URL2${icon}', width: 30.w)
                      : Icon(Icons.directions_car, size: 24.sp))
                  : Icon(icon as IconData, size: 24.sp),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            style: GoogleFonts.poppins(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleSection(String title, List<Vehicle> vehicles) {
    // Filter vehicles based on search query
    final filteredVehicles = _searchQuery.isEmpty
        ? vehicles
        : vehicles.where((vehicle) => 
            vehicle.name.toLowerCase().contains(_searchQuery) ||
            (vehicle.vehicleDetails?['body_type']?.toString().toLowerCase() ?? '').contains(_searchQuery) ||
            (vehicle.vehicleDetails?['fuel_type']?.toString().toLowerCase() ?? '').contains(_searchQuery)
          ).toList();

    if (filteredVehicles.isEmpty && _searchQuery.isNotEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            title,
            style: mediumTextStyle.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 280.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: filteredVehicles.length,
            itemBuilder: (context, index) {
              final vehicle = filteredVehicles[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: VehicleSmallCard(
                  vehicleId: vehicle.id,
                  image: vehicle.images.isNotEmpty
                      ? '$IMAGE_URL${vehicle.images[0]}'
                      : 'https://images.pexels.com/photos/819805/pexels-photo-819805.jpeg',
                  name: vehicle.name,
                  price: vehicle.dailyRate.toString(),
                  description: vehicle.availableDelivery.toString(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

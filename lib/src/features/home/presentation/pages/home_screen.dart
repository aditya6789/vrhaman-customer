import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/common/loading.dart';
import 'package:vrhaman/src/features/home/presentation/widget/feature_card.dart';
import 'package:vrhaman/src/features/home/presentation/widget/location_widget.dart';
import 'package:vrhaman/src/features/home/presentation/widget/search_home_widget.dart';
import 'package:vrhaman/src/features/notification/presentation/screens/notification_screen.dart';
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
  String latitude = '';
  String longitude = '';
  bool _isLocationFetching = false;
  List<String> _selectedVehicleTypes = [];
  List<String> _selectedFuelTypes = [];

  final List<Category> categories = [
    Category(name: 'All', icon: Icons.grid_view_rounded, isSelected: true),
    Category(name: 'Bikes', icon: Icons.motorcycle),
    Category(name: 'Cars', icon: Icons.directions_car),
    Category(name: 'E-Bikes', icon: Icons.electric_bike),
    Category(name: 'CNG', icon: Icons.local_gas_station),
    Category(name: 'Petrol', icon: Icons.local_gas_station),
  ];

  @override
  void initState() {
    super.initState();
    _checkLocationSettings();
  }

  Future<void> _checkLocationSettings() async {
    // First check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog();
      return;
    }

    // Then check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || 
        permission == LocationPermission.deniedForever) {
      _showLocationPermissionDialog();
      return;
    }

    // If both checks pass, get location
    setState(() {
      _isLocationFetching = true;
    });
    
    await _getCurrentLocation();
    
    if (mounted) {
      setState(() {
        _isLocationFetching = false;
      });
      
      BlocProvider.of<HomeCubit>(context).fetchHomeData(latitude!, longitude!);
    }
  }

  Future<void> _showLocationServiceDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(Icons.location_off, color: Colors.red),
              SizedBox(width: 8.w),
              Text(
                'Location is Off',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Please enable location services to use this app. We need your location to show you nearby vehicles.',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                SystemNavigator.pop();
              },
              child: Text(
                'Exit',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
                // Recheck settings after user returns
                _checkLocationSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Enable Location',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLocationPermissionDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(Icons.location_disabled, color: Colors.orange),
              SizedBox(width: 8.w),
              Text(
                'Location Permission',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'This app needs location permission to show you nearby vehicles. Please grant location permission to continue.',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
          ),
          actions: [
           
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                LocationPermission permission = await Geolocator.requestPermission();
                if (permission == LocationPermission.deniedForever) {
                  await Geolocator.openAppSettings();
                }
                // Recheck settings after user returns
                _checkLocationSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Grant Permission',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, 
        position.longitude
      );

      if (mounted) {
        setState(() {
          cityName = placemarks[0].locality ?? 'Unknown location';
          latitude = position.latitude.toString();
          longitude = position.longitude.toString();
        });
      }
    } catch (e) {
      print('Error getting location: $e');
    }
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
                        vehicle: vehicle,
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
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (_isLocationFetching) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: primaryColor,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Fetching current location...',
                        style: mediumTextStyle.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              } else if (state is HomeLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: primaryColor,
                      ),
                      SizedBox(height: 16.h),
                      Text('Not just Rides we offer Memories 🏍🚘 ', style: mediumTextStyle.copyWith(fontWeight: FontWeight.w600),),
                    ],
                  ),
                );
              } else if (state is HomeSuccess) {
                return RefreshIndicator(
                  color: primaryColor,
                  onRefresh: () async {
                    setState(() {
                      _isLocationFetching = true;
                    });
                    await _getCurrentLocation();
                    setState(() {
                      _isLocationFetching = false;
                    });
                    BlocProvider.of<HomeCubit>(context).fetchHomeData(latitude!, longitude!);
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
                                      builder: (context) => NotificationScreen(),
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
                                  child: Icon(HugeIcons.strokeRoundedNotification02),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              
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
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        _showFilterBottomSheet();
                                      },
                                      child: Container(
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
                              print('User Preferred length: ${state.userPreferred.length}');
                              return Column(
                                children: [
                                  if (state.popularCars.isNotEmpty) ...[
                                    _buildVehicleSection(
                                      'Top Cars ',
                                      state.popularCars,
                                    ),
                                  ],
                                  if (state.popularBikes.isNotEmpty) ...[
                                    _buildVehicleSection(
                                      'Top Bikes',
                                      state.popularBikes,
                                    ),
                                  ],
                                  if (state.userPreferred.isNotEmpty) ...[
                                    _buildVehicleSection(
                                      'Near Available',

                                      state.userPreferred,
                                    ),
                                  ],
                                  if (state.popularCars.isEmpty && state.userPreferred.isEmpty)
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.directions_car_outlined,
                                              size: 64,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'No vehicles available at the moment',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            } else if (state is HomeError) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 48,
                                      color: Colors.red,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Error loading vehicles',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return SizedBox();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            },
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
                      ? Image.network('${icon}', width: 30.w)
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
    // Filter vehicles based on search query and selected filters
    final filteredVehicles = vehicles.where((vehicle) {
      // Search query filter
      bool matchesSearch = _searchQuery.isEmpty || 
          vehicle.name.toLowerCase().contains(_searchQuery) ||
          (vehicle.vehicleDetails?['body_type']?.toString().toLowerCase() ?? '').contains(_searchQuery) ||
          (vehicle.vehicleDetails?['fuel_type']?.toString().toLowerCase() ?? '').contains(_searchQuery);
      
      // Vehicle type filter
      bool matchesVehicleType = _selectedVehicleTypes.isEmpty || 
          (_selectedVehicleTypes.contains('Cars') && vehicle.vehicleDetails?['type'] == 'Car') ||
          (_selectedVehicleTypes.contains('Bikes') && (vehicle.vehicleDetails?['type'] == 'Bike' || vehicle.vehicleDetails?['type'] == 'Motorcycle')) ||
          (_selectedVehicleTypes.contains('E-Bikes') && vehicle.vehicleDetails?['type'] == 'E-Bike');
      
      // Fuel type filter
      bool matchesFuelType = _selectedFuelTypes.isEmpty ||
          (_selectedFuelTypes.contains('Petrol') && vehicle.vehicleDetails?['fuel_type'] == 'Petrol') ||
          (_selectedFuelTypes.contains('Diesel') && vehicle.vehicleDetails?['fuel_type'] == 'Diesel') ||
          (_selectedFuelTypes.contains('CNG') && vehicle.vehicleDetails?['fuel_type'] == 'CNG') ||
          (_selectedFuelTypes.contains('EV') && (vehicle.vehicleDetails?['fuel_type'] == 'Electric' || vehicle.vehicleDetails?['fuel_type'] == 'EV'));
      
      return matchesSearch && matchesVehicleType && matchesFuelType;
    }).toList();

    if (filteredVehicles.isEmpty) {
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
                  vehicle: vehicle,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet() {
    // Use class variables for filter storage
    List<String> tempVehicleTypes = List.from(_selectedVehicleTypes);
    List<String> tempFuelTypes = List.from(_selectedFuelTypes);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(top: 16.h),
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar at top
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  
                  // Header with title and close button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter Vehicles',
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close, color: Colors.black54),
                            iconSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Filter sections in a scrollable container
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Vehicle Type Section
                          _buildFilterSectionHeader('Vehicle Type', Icons.directions_car_outlined),
                          SizedBox(height: 16.h),
                          Wrap(
                            spacing: 12.w,
                            runSpacing: 12.h,
                            children: [
                              _buildStylishFilterChip(
                                'Cars', 
                                Icons.directions_car,
                                tempVehicleTypes.contains('Cars'),
                                (selected) {
                                  setModalState(() {
                                    if (selected) {
                                      tempVehicleTypes.add('Cars');
                                    } else {
                                      tempVehicleTypes.remove('Cars');
                                    }
                                  });
                                }
                              ),
                              _buildStylishFilterChip(
                                'Bikes', 
                                Icons.motorcycle,
                                tempVehicleTypes.contains('Bikes'),
                                (selected) {
                                  setModalState(() {
                                    if (selected) {
                                      tempVehicleTypes.add('Bikes');
                                    } else {
                                      tempVehicleTypes.remove('Bikes');
                                    }
                                  });
                                }
                              ),
                              _buildStylishFilterChip(
                                'E-Bikes', 
                                Icons.electric_bike,
                                tempVehicleTypes.contains('E-Bikes'),
                                (selected) {
                                  setModalState(() {
                                    if (selected) {
                                      tempVehicleTypes.add('E-Bikes');
                                    } else {
                                      tempVehicleTypes.remove('E-Bikes');
                                    }
                                  });
                                }
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 32.h),
                          
                          // Fuel Type Section
                          _buildFilterSectionHeader('Fuel Type', Icons.local_gas_station_outlined),
                          SizedBox(height: 16.h),
                          Wrap(
                            spacing: 12.w,
                            runSpacing: 12.h,
                            children: [
                              _buildStylishFilterChip(
                                'Petrol', 
                                Icons.local_gas_station,
                                tempFuelTypes.contains('Petrol'),
                                (selected) {
                                  setModalState(() {
                                    if (selected) {
                                      tempFuelTypes.add('Petrol');
                                    } else {
                                      tempFuelTypes.remove('Petrol');
                                    }
                                  });
                                }
                              ),
                              _buildStylishFilterChip(
                                'Diesel', 
                                Icons.local_gas_station,
                                tempFuelTypes.contains('Diesel'),
                                (selected) {
                                  setModalState(() {
                                    if (selected) {
                                      tempFuelTypes.add('Diesel');
                                    } else {
                                      tempFuelTypes.remove('Diesel');
                                    }
                                  });
                                }
                              ),
                              _buildStylishFilterChip(
                                'CNG', 
                                Icons.local_gas_station,
                                tempFuelTypes.contains('CNG'),
                                (selected) {
                                  setModalState(() {
                                    if (selected) {
                                      tempFuelTypes.add('CNG');
                                    } else {
                                      tempFuelTypes.remove('CNG');
                                    }
                                  });
                                }
                              ),
                              _buildStylishFilterChip(
                                'EV', 
                                Icons.ev_station,
                                tempFuelTypes.contains('EV'),
                                (selected) {
                                  setModalState(() {
                                    if (selected) {
                                      tempFuelTypes.add('EV');
                                    } else {
                                      tempFuelTypes.remove('EV');
                                    }
                                  });
                                }
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                  
                  // Action buttons with gradient background
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextButton(
                            onPressed: () {
                              setModalState(() {
                                tempVehicleTypes.clear();
                                tempFuelTypes.clear();
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                side: BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                            child: Text(
                              'Reset',
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            onPressed: () {
                              // Apply filters and close bottom sheet
                              Navigator.pop(context);
                              
                              if (mounted) {
                                setState(() {
                                  _selectedVehicleTypes = List.from(tempVehicleTypes);
                                  _selectedFuelTypes = List.from(tempFuelTypes);
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Apply Filters',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(Icons.check_circle_outline, size: 18.sp)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }
  
  Widget _buildFilterSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: primaryColor,
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStylishFilterChip(String label, IconData icon, bool isSelected, Function(bool) onSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOutQuart,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onSelected(!isSelected),
          splashColor: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? primaryColor : Colors.grey[300]!,
                width: 1.5,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.25),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                )
              ] : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 18.sp,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                if (isSelected) ...[
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}


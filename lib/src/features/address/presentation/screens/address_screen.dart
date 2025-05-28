import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/address/data/model/addressModel.dart';
import 'package:vrhaman/src/features/address/presentation/cubit/address_cubit.dart';
import 'package:vrhaman/src/utils/api_response.dart';

import 'package:vrhaman/src/utils/google_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vrhaman/src/utils/toast.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  final _searchController = TextEditingController();
  bool _isSaving = false;
  List<Map<String, dynamic>> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    context.read<AddressCubit>().getAddresses();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAddresses() async {
    try {
      final response = await getRequest('users/address');
      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          addresses = List<Map<String, dynamic>>.from(response.data['data']);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading addresses: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isSearching = true);
    try {
      final results = await searchPlaces(query, kgoogleApiKey);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
      showToast('Error searching places: $e');
    }
  }

  Future<Map<String, dynamic>> getPlaceDetails(String placeId, String apiKey) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json'
      '?place_id=$placeId'
      '&key=$apiKey'
      '&fields=formatted_address,address_component'
    );
    
    final response = await http.get(url);
    final data = json.decode(response.body);
    
    if (data['status'] == 'OK') {
      return data['result'];
    }
    throw Exception('Failed to get place details');
  }

  Future<void> _selectSearchResult(String placeId) async {
    try {
      final details = await getPlaceDetails(placeId, kgoogleApiKey);
      setState(() {
        _addressController.text = details['formatted_address'] ?? '';
        _searchResults.clear();
      });
    } catch (e) {
      print('Error getting place details: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // First check if location permission is granted
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showToast('Location permission is required' , isSuccess: false);
          return;
        }
      }

      // Check if location is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showToast('Please enable location services' , isSuccess: false);
        return;
      }

      setState(() => _isSearching = true);

      // Get precise location with high accuracy and reduced distance filter
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: Duration(seconds: 30),
      );
      
      // Get detailed address with more components
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json'
        '?latlng=${position.latitude},${position.longitude}'
        '&key=$kgoogleApiKey'
        '&result_type=street_address|route|sublocality|locality|administrative_area_level_1|postal_code'
        '&location_type=ROOFTOP|RANGE_INTERPOLATED'
      );

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final result = data['results'][0];
        final components = result['address_components'];

        setState(() {
          _addressController.text = result['formatted_address'] ?? '';
          
          // Extract detailed components
          for (var component in components) {
            final types = component['types'];
            if (types.contains('postal_code')) {
              _pincodeController.text = component['long_name'];
            } else if (types.contains('administrative_area_level_1')) {
              _stateController.text = component['long_name'];
            } else if (types.contains('locality')) {
              _cityController.text = component['long_name'];
            }
          }
        });
      }

    } catch (e) {
      print('Location error: $e');
      showToast('Error getting precise location: $e' , isSuccess: false);
     
    } finally {
      setState(() => _isSearching = false);
    }
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      try {
        final response = await postRequest('users/address',  {
          'address': _addressController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'postalCode': _pincodeController.text,
        });
        if(response.statusCode == 200){
          Navigator.pop(context);
          showToast('Address saved successfully');
        } else {
          showToast('Failed to save address' , isSuccess: false);
        }
      } catch (e) {
        showToast('Error: ${e.toString()}' , isSuccess: false);
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Addresses',
          style: bigTextStyle.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          print(state);
          if (state is AddressLoading) {
            return Center(child: CircularProgressIndicator(color: primaryColor));
          } else if (state is AddressLoaded) {
            return state.addressModel.addresses.isEmpty
                ? _buildEmptyState()
                : _buildAddressList(
                  state.addressModel
                );

          } else if (state is AddressError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('Something went wrong'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAddressSheet(context),
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 80.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No Addresses Found',
              style: mediumTextStyle.copyWith(
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Add your first delivery address',
              style: smallTextStyle.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => _showAddAddressSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text('Add Address'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressList(AddressModel addressModel) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemCount: addressModel.addresses.length,
      itemBuilder: (context, index) {
        final address = addressModel.addresses[index];
        return TweenAnimationBuilder(
          duration: Duration(milliseconds: 400),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 25,
                          offset: Offset(0, 10),
                          spreadRadius: -5
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Handle address selection
                        },
                        borderRadius: BorderRadius.circular(28.r),
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(24.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(16.w),
                                        decoration: BoxDecoration(
                                          gradient: SweepGradient(
                                            colors: [
                                              primaryColor,
                                              primaryColor.withOpacity(0.8),
                                              primaryColor.withOpacity(0.6),
                                              primaryColor,
                                            ],
                                            stops: [0.0, 0.3, 0.7, 1.0],
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: primaryColor.withOpacity(0.3),
                                              blurRadius: 15,
                                              offset: Offset(0, 8),
                                              spreadRadius: -4,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.white,
                                          size: 30.sp,
                                        ),
                                      ),
                                      SizedBox(width: 20.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              address.address,
                                              style: mediumTextStyle.copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18.sp,
                                                letterSpacing: 0.3,
                                                height: 1.4,
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    primaryColor.withOpacity(0.15),
                                                    primaryColor.withOpacity(0.08),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(30.r),
                                              ),
                                              child: Text(
                                                '${address.city}, ${address.state}',
                                                style: smallTextStyle.copyWith(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.4,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 66.w, top: 16.h),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(20.r),
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.pin_drop_outlined,
                                            size: 16.sp,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(width: 6.w),
                                          Text(
                                            address.postalCode,
                                            style: smallTextStyle.copyWith(
                                              color: Colors.grey[700],
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert_rounded,
                                  color: Colors.grey[600],
                                  size: 24.sp,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                elevation: 3,
                                position: PopupMenuPosition.under,
                                itemBuilder: (context) => [
                               
                                  PopupMenuItem(
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_outline_rounded, size: 20.sp, color: Colors.red[400]),
                                        SizedBox(width: 12.w),
                                        Text(
                                          'Delete',
                                          style: mediumTextStyle.copyWith(
                                            color: Colors.red[400],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      context.read<AddressCubit>().deleteAddress(address.id);
                                      // Handle delete
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddAddressSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: AddAddressBottomSheet(),
      ),
    );
  }
}

class AddAddressBottomSheet extends StatefulWidget {
  @override
  _AddAddressBottomSheetState createState() => _AddAddressBottomSheetState();
}

class _AddAddressBottomSheetState extends State<AddAddressBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  bool _isSaving = false;

  Future<Map<String, dynamic>> getPlaceDetails(String placeId, String apiKey) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json'
      '?place_id=$placeId'
      '&key=$apiKey'
      '&fields=formatted_address,address_component'
    );
    
    final response = await http.get(url);
    final data = json.decode(response.body);
    
    if (data['status'] == 'OK') {
      return data['result'];
    }
    throw Exception('Failed to get place details');
  }

  Future<void> _selectSearchResult(String placeId) async {
    try {
      final details = await getPlaceDetails(placeId, kgoogleApiKey);
      setState(() {
        _addressController.text = details['formatted_address'] ?? '';
        _searchResults.clear();
      });
    } catch (e) {
      print('Error getting place details: $e');
    }
  }

  // Add pincode to city functionality
  Future<void> _getCityAndStateFromPincode(String pincode) async {
    if (pincode.length != 6) return;
    
    setState(() => _isSearching = true);
    try {
      final url = Uri.parse('https://api.postalpincode.in/pincode/$pincode');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data[0]['Status'] == 'Success') {
          final postOffice = data[0]['PostOffice'][0];
          setState(() {
            _cityController.text = postOffice['District'];
            _stateController.text = postOffice['State'];
          });
        }
      }
    } catch (e) {
      print('Error fetching pincode details: $e');
    } finally {
      setState(() => _isSearching = false);
    }
  }

  // Current location functionality
  Future<void> _getCurrentLocation() async {
    try {
      // First check if location permission is granted
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showToast('Location permission is required' , isSuccess: false);
          return;
        }
      }

      // Check if location is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enable location services'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      setState(() => _isSearching = true);

      // Get precise location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: Duration(seconds: 30),
      );
      
      // Get detailed address
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json'
        '?latlng=${position.latitude},${position.longitude}'
        '&key=$kgoogleApiKey'
        '&result_type=street_address|route|sublocality|locality|administrative_area_level_1|postal_code'
        '&location_type=ROOFTOP|RANGE_INTERPOLATED'
      );

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final result = data['results'][0];
        final components = result['address_components'];

        setState(() {
          _addressController.text = result['formatted_address'] ?? '';
          
          // Extract detailed components
          for (var component in components) {
            final types = component['types'];
            if (types.contains('postal_code')) {
              _pincodeController.text = component['long_name'];
            } else if (types.contains('administrative_area_level_1')) {
              _stateController.text = component['long_name'];
            } else if (types.contains('locality')) {
              _cityController.text = component['long_name'];
            }
          }
        });
      }
    } catch (e) {
      print('Location error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isSearching = false);
    }
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      try {
        final response = await postRequest('users/address',  {
          'address': _addressController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'postalCode': _pincodeController.text,
        });
        if(response.statusCode == 200){
          context.read<AddressCubit>().getAddresses();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Address saved successfully'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save address'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: primaryColor, size: 24.sp),
                SizedBox(width: 12.w),
                Text(
                  'Add New Address',
                  style: mediumTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[600]),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Current Location Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: InkWell(
              onTap: _getCurrentLocation,
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.my_location, color: primaryColor),
                    SizedBox(width: 12.w),
                    Text(
                      'Use Current Location',
                      style: mediumTextStyle.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    if (_isSearching)
                      SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _addressController,
                      label: 'Full Address',
                      hint: 'Enter your street address',
                      icon: Icons.location_on_outlined,
                      maxLines: 3,
                      isAddress: true,
                    ),
                    SizedBox(height: 20.h),

                    _buildTextField(
                      controller: _pincodeController,
                      label: 'Pincode',
                      hint: 'Enter 6-digit pincode',
                      icon: Icons.pin_drop_outlined,
                      keyboardType: TextInputType.number,
                      onChanged: _getCityAndStateFromPincode,
                    ),
                    SizedBox(height: 20.h),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _cityController,
                            label: 'City',
                            hint: 'Your city',
                            icon: Icons.location_city_outlined,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildTextField(
                            controller: _stateController,
                            label: 'State',
                            hint: 'Your state',
                            icon: Icons.map_outlined,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    // Save Button
                    Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        gradient: LinearGradient(
                          colors: [primaryColor, primaryColor.withOpacity(0.8)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: _isSaving
                            ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Save Address',
                                style: mediumTextStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isAddress = false,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: mediumTextStyle.copyWith(
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              TextFormField(
                controller: controller,
                maxLines: maxLines,
                keyboardType: keyboardType,
                style: mediumTextStyle.copyWith(color: Colors.grey[800]),
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: mediumTextStyle.copyWith(color: Colors.grey[400]),
                  prefixIcon: Icon(icon, color: Colors.grey[600], size: 20.sp),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  suffixIcon: isAddress && _isSearching
                      ? Padding(
                          padding: EdgeInsets.all(12.w),
                          child: SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                            ),
                          ),
                        )
                      : null,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  if (label == 'Pincode' && value.length != 6) {
                    return 'Enter valid 6-digit pincode';
                  }
                  return null;
                },
              ),
              if (isAddress && _searchResults.isNotEmpty)
                Container(
                  constraints: BoxConstraints(maxHeight: 200.h),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      return InkWell(
                        onTap: () => _selectSearchResult(result['place_id']),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[200]!,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey[600],
                                size: 20.sp,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  result['description'],
                                  style: mediumTextStyle.copyWith(
                                    color: Colors.grey[800],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

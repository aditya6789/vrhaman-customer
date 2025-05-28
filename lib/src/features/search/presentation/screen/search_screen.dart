import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/search/data/model/addSearchModel.dart';
import 'package:vrhaman/src/features/search/domain/entities/addSearch.dart';
import 'package:vrhaman/src/features/search/presentation/cubit/search_cubit.dart';
import 'package:vrhaman/src/features/search/presentation/screen/search_result_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrhaman/src/features/search/presentation/widget/custom_auto_complete_textfield.dart';
import 'package:vrhaman/src/features/search/presentation/widget/duration_widget.dart';
import 'package:vrhaman/src/features/search/presentation/widget/predicition_widget.dart';
import 'package:vrhaman/src/features/search/presentation/widget/select_vehicle_type_widget.dart';
import 'package:vrhaman/src/models/prediction.dart';
import 'package:vrhaman/src/utils/google_api.dart';
// import 'package:vrhaman/src/utils/google_api.dart';
import 'package:vrhaman/src/utils/search_sugesstion.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vrhaman/src/utils/toast.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? selectedVehicleType;
  String? selectedDuration;
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();

  List<Prediction> _locationPredictions =
      []; // Add this line to define _pickupPredictions
  Timer? _locationDebounce;
  TextEditingController _locationController = TextEditingController();
  String? _location; // Add this line to define _pickupLocation
  String? _locationPlaceId; // Add this line to define _pickupPlaceId
  // TextEditingController pickupController = TextEditingController(); // Add this line to define pickupController
double?latitude;
double?longitude;
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('MM/dd/yyyy').format(pickedDate);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }


void _getlocationlatlong() async {
  final location = await getLatLng(_locationPlaceId!);
  latitude = location.latitude;
  longitude = location.longitude;
}



  Future<void> _selectTime(
      BuildContext context,
      TextEditingController controller,
      TimeOfDay startTime,
      TimeOfDay endTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (pickedTime != null) {
      if (pickedTime.hour >= 9 && pickedTime.hour <= 22) {
        setState(() {
          controller.text = pickedTime.format(context);
        });
      } else {
        showToast('Please select a time between 9 AM and 10 PM' , isSuccess: false);
      }
    }
  }

  void _onPickupTextChanged(String value) {
    if (_locationDebounce?.isActive ?? false) _locationDebounce?.cancel();
    print('onPickupTextChanged');
    _locationDebounce = Timer(const Duration(milliseconds: 500), () async {
      print('onPickupTextChanged 2');
      if (value.isNotEmpty) {
        print('onPickupTextChanged 3');
        final predictions = await fetchSuggestions(value);
        print('onPickupTextChanged 4');
        print(predictions);
        setState(() {
          _locationPredictions = predictions;
        });
      } else {
        print('onPickupTextChanged 5');
        setState(() {
          _locationPredictions = [];
        });
      }
    });
  }

  // Add new text styles
  final TextStyle sectionHeaderStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    letterSpacing: 0.5,
  );

  final TextStyle subHeaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    Color? iconColor,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
      ),
      prefixIcon: Icon(icon, color: iconColor ?? Colors.black87),
      filled: true,
      fillColor: Colors.grey[100],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Map<String, bool> _expandedFaqs = {};

  Widget _buildFaqItem({
    required String question,
    required String answer,
  }) {
    bool isExpanded = _expandedFaqs[question] ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _expandedFaqs[question] = !isExpanded;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isExpanded
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade200,
                width: 1.w,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      duration: Duration(milliseconds: 200),
                      turns: isExpanded ? 0.5 : 0,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: isExpanded
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                ClipRect(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    height: isExpanded ? null : 0,
                    margin: EdgeInsets.only(top: isExpanded ? 12 : 0),
                    child: Text(
                      answer,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFaqSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: sectionHeaderStyle,
          ),
          SizedBox(height: 16.h),
          _buildFaqItem(
            question: 'What documents do I need?',
            answer: 'You\'ll need:\n'
                '• A valid driver\'s license\n'
                '• Government-issued ID\n'
                '• Credit card for security deposit\n'
                '• Proof of insurance (for some vehicles)',
          ),
          _buildFaqItem(
            question: 'Is insurance included?',
            answer:
                'Yes, basic insurance is included with all rentals. This covers:'
                '\n• Third-party liability'
                '\n• Collision damage waiver'
                '\n• Theft protection'
                '\n\nAdditional coverage options are available at pickup.',
          ),
          _buildFaqItem(
            question: 'What\'s your cancellation policy?',
            answer: 'Free cancellation up to 24 hours before pickup. '
                'Cancellations within 24 hours may incur a fee of one day\'s rental charge.',
          ),
          _buildFaqItem(
            question: 'Do you offer delivery?',
            answer:
                'Yes! We offer vehicle delivery within city limits for a small fee. '
                'Airport pickup and drop-off services are also available.',
          ),
          _buildFaqItem(
            question: 'What happens if I return late?',
            answer:
                'Grace period is 30 minutes. After that, late returns are charged at:'
                '\n• Hourly rate for first 3 hours'
                '\n• Full day rate after 3 hours'
                '\nPlease contact us if you expect to be late.',
          ),
          _buildFaqItem(
            question: 'Do you check credit scores?',
            answer: 'We perform a soft credit check for new customers. '
                'This doesn\'t affect your credit score. Alternative security deposits '
                'may be available for those with lower credit scores.',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchCubit, SearchState>(
      listener: (context, state) {
        if (state is SearchLoadedData) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultScreen(
                search: state.search,
                location: _locationController.text,
                date: _fromDateController.text,
                time: _startTimeController.text,
                duration: selectedDuration ?? '',
              ),
            ),
          );
        } else if (state is SearchError) {
          showToast(state.message , isSuccess: false);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        extendBodyBehindAppBar: true,
      
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated Header
                  Container(
                    margin: EdgeInsets.only(top: 20.h, bottom: 32.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Find Your Perfect",
                          style: bigTextStyle.copyWith(
                            color: Colors.grey[800],
                            fontSize: 32.sp,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Ride Today",
                          style: bigTextStyle.copyWith(
                            color: primaryColor,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Main Search Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 24,
                          offset: Offset(0, 8),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Location Section
                          _buildSectionHeader("Where to?", Icons.place),
                          SizedBox(height: 16.h),
                          CustomAutoCompleteTextField(
                            icon: Icons.location_on,
                            iconColor: primaryColor,
                            textEditingController: _locationController,
                            hintText: 'Enter your location',
                            fillColor: Colors.grey[50]!,
                            textColor: Colors.black87,
                            hintTextColor: Colors.grey[400]!,
                            borderColor: Colors.transparent,
                            onChanged: _onPickupTextChanged,
                            currentlocation: () async {
                              try {
                                Position position = await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high
                                );
                                
                                List<Placemark> placemarks = await placemarkFromCoordinates(
                                  position.latitude, 
                                  position.longitude
                                );
                                
                                if (placemarks.isNotEmpty) {
                                  Placemark place = placemarks[0];
                                  String address = '${place.street}, ${place.subLocality}, ${place.locality}';
                                  
                                  setState(() {
                                    _locationController.text = address;
                                    latitude = position.latitude;
                                    longitude = position.longitude;
                                    _location = address;
                                  });

                                  final suggestions = await fetchSuggestions(address);
                                  if (suggestions.isNotEmpty) {
                                    _locationPlaceId = suggestions.first.placeId;
                                    _getlocationlatlong();
                                  }
                                }
                              } catch (e) {
                                showToast('Could not get current location' , isSuccess: false);
                              }
                            },
                          ),
                          
                          if (_locationPredictions.isNotEmpty)
                            Container(
                              margin: EdgeInsets.only(top: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: PredictionListView(
                                predictions: _locationPredictions,
                                onPredictionTap: (prediction) {
                                  setState(() {
                                    _location = prediction.description;
                                    _locationPlaceId = prediction.placeId;
                                    _locationController.text = _location ?? '';
                                    _locationPredictions = [];
                                    _getlocationlatlong();
                                  });
                                },
                                onFavoriteTap: (prediction) {
                                  setState(() {});
                                },
                              ),
                            ),
                          SizedBox(height: 32.h),
                          
                          // Date and Time Section
                          _buildSectionHeader("When do you need it?", Icons.access_time),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(child: _buildDateField()),
                              SizedBox(width: 12.w),
                              Expanded(child: _buildTimeDropdown()),
                            ],
                          ),
                          SizedBox(height: 32.h),
                          
                          // Duration Section
                          _buildSectionHeader("How long do you need it?", Icons.timer),
                          SizedBox(height: 16.h),
                          _buildDurationList(),
                          SizedBox(height: 32.h),
                          
                          // Vehicle Type Section
                          _buildSectionHeader("Select Vehicle Type", Icons.directions_car),
                          SizedBox(height: 16.h),
                          _buildVehicleTypeSelection(),
                          SizedBox(height: 32.h),
                          
                          // Search Button
                          ElevatedButton(
                            onPressed: () => _handleSearch(context),
                          
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search, color: Colors.white, size: 20.sp),
                                SizedBox(width: 8.w),
                                Text(
                                  'SEARCH VEHICLES',
                                  style: mediumTextStyle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: primaryColor, size: 18.sp),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: mediumTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDurationList() {
    return Container(
      height: 48.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: [
         'Day',
         'Week',
         'Month',
        ].map((duration) => _buildDurationChip(duration)).toList(),
      ),
    );

  }

  Widget _buildDurationChip(String duration) {
    final isSelected = selectedDuration == duration;
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedDuration = isSelected ? null : duration;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey[200]!,
              width: 1.5,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: primaryColor.withOpacity(0.2),
                blurRadius: 12,
                offset: Offset(0, 6),
                spreadRadius: 0,
              )
            ] : [],
          ),
          child: Text(
            duration,
            style: mediumTextStyle.copyWith(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleTypeOption(String type, IconData icon) {
    final isSelected = selectedVehicleType == type;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedVehicleType = isSelected ? null : type;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 5.h),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey[200]!,
              width: 1.5,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: primaryColor.withOpacity(0.2),
                blurRadius: 12,
                offset: Offset(0, 6),
                spreadRadius: 0,
              )
            ] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.2) : primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : primaryColor,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                type,
                style: mediumTextStyle.copyWith(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color.withOpacity(0.8)),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required String step,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            step,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildDestinationCard({
    required String image,
    required String title,
    required String subtitle,
    required List<Color> gradient,
  }) {
    return Container(
      width: 280,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Add other helper methods (_buildVehicleCard, _buildReviewCard, _buildFaqItem)...

  bool isLoadingLocation = true;
  String? currentLocation;
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() => isLoadingLocation = true);

      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permission denied';
        }
      }

      // // Get current position
      // Position position = await Geolocator.getCurrentPosition(
      //   desiredAccuracy: LocationAccuracy.high,
      // );
      // currentPosition = position;

      // // Get address from coordinates
      // List<Placemark> placemarks = await placemarkFromCoordinates(
      //   position.latitude,
      //   position.longitude,
      // );

      // if (placemarks.isNotEmpty) {
      //   Placemark place = placemarks[0];
      //   String address = '${place.street}, ${place.locality}';
      //   setState(() {
      //     currentLocation = address;
      //     _locationController.text = address;
      //     isLoadingLocation = false;
      //   });
      // }
    } catch (e) {
      setState(() {
        isLoadingLocation = false;
        currentLocation = null;
      });
      showToast('Could not get current location' , isSuccess: false);
    }
  }

  // Modify the location input section
  Widget _buildLocationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Where to?",
          style: subHeaderStyle,
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: CustomAutoCompleteTextField(
            icon: Icons.location_on,
            iconColor: Theme.of(context).primaryColor,
            textEditingController: _locationController,
            hintText: 'Enter your location',
            fillColor: Colors.white,
            textColor: Colors.black87,
            hintTextColor: Colors.grey[600]!,
            borderColor: Colors.grey,
            onChanged: _onPickupTextChanged,
          ),
        ),
      ],
    );
  }

  void _handleSearch(BuildContext context) {
    if (_fromDateController.text.isEmpty ||
        _startTimeController.text.isEmpty ||
        selectedDuration == null ||
        selectedVehicleType == null ||
        latitude == null ||
        longitude == null ||
        _locationController.text.isEmpty) {
      showToast('Please fill in all fields' , isSuccess: false);
      return;
    }

    final searchCubit = context.read<SearchCubit>();
    searchCubit.addSearch(
      AddSearch(
        startDate: _fromDateController.text,
        duration: selectedDuration!,
        vehicleType: selectedVehicleType!,
        location: LocationSearch(
          latitude: latitude!,
          longitude: longitude!,
        ),
      ),
    );

    // Listen to state changes using BlocListener in the build method instead
    final searchState = searchCubit.state;
    if (searchState is SearchLoadedData) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(
            search: searchState.search,
            location: _locationController.text,
            date: _fromDateController.text,
            time: _startTimeController.text,
            duration: selectedDuration ?? '',
          ),
        ),
      );
    } else if (searchState is SearchError) {
      showToast(searchState.message , isSuccess: false);
    }
  }

  List<DropdownMenuItem<String>> _generateTimeItems() {
    List<DropdownMenuItem<String>> items = [];
    for (int hour = 9; hour <= 22; hour++) {
      String time = '${hour.toString().padLeft(2, '0')}:00';
      items.add(DropdownMenuItem(value: time, child: Text(time)));
    }
    return items;
  }

  Widget _buildDateField() {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!, width: 1.5),
      ),
      child: TextField(
        controller: _fromDateController,
        readOnly: true,
        style: mediumTextStyle.copyWith(color: Colors.black87),
        decoration: InputDecoration(
          // filled: false,
          hintText: 'Date',
          hintStyle: mediumTextStyle.copyWith(color: Colors.grey[400]),
          prefixIcon: Container(
            padding: EdgeInsets.all(12.w),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.calendar_today, color: primaryColor, size: 20.sp),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
        onTap: () => _selectDate(context, _fromDateController),
      ),
    );
  }

  Widget _buildTimeDropdown() {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!, width: 1.5),
      ),
      child: DropdownButtonFormField<String>(
        value: _startTimeController.text.isNotEmpty ? _startTimeController.text : null,
        icon: const SizedBox.shrink(), // Hide dropdown icon
        style: smallTextStyle.copyWith(color: Colors.black87),
        isExpanded: true, // Prevent overflow
        decoration: InputDecoration(
          filled: false,
          hintText: 'Time',
          hintStyle: smallTextStyle.copyWith(color: Colors.grey[400]),
          prefixIcon: Container(
            padding: EdgeInsets.all(12.w),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.access_time, color: primaryColor, size: 20.sp),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
        
        items: _generateTimeItems(),
        onChanged: (value) {
          setState(() {
            _startTimeController.text = value!;
          });
        },
      ),
    );
  }

  Widget _buildVehicleTypeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildVehicleTypeOption('Bike', Icons.motorcycle),
        SizedBox(width: 16.w),
        _buildVehicleTypeOption('Car', Icons.directions_car),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/app.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrhaman/src/features/address/presentation/cubit/address_cubit.dart';
import 'package:vrhaman/src/features/address/presentation/screens/address_screen.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingAvailable.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingdata.dart';
import 'package:vrhaman/src/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:vrhaman/src/features/booking/presentation/screens/booking_failure_screen.dart';
import 'package:vrhaman/src/features/booking/presentation/screens/booking_success_screen.dart';
import 'package:vrhaman/src/features/booking/presentation/widget/show_address_bottom_sheet.dart';
import 'package:vrhaman/src/features/home/presentation/pages/bottom_navigation_bar.dart';
import 'package:vrhaman/src/features/home/presentation/pages/home_screen.dart';
import 'package:vrhaman/src/features/vehicle_details/domain/entities/vehicleDetails.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vrhaman/src/utils/api_response.dart';
import 'package:vrhaman/src/utils/toast.dart';

import 'package:vrhaman/src/utils/user_prefences.dart';

class BookingScreen extends StatefulWidget {
  final String vehicleId;
  final VehicleDetails vehicleDetails;
  const BookingScreen(
      {super.key, required this.vehicleId, required this.vehicleDetails});
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _startDateController = TextEditingController();
  String? selectedTime = '9:00 AM';
  String? selectedDaysDuration;
  String? selectedWeeksDuration;
  String? selectedMonthsDuration = '0';
  String selectedDuration = '1 day';
  bool isDeliveryAtHome = false;
  String? paymentType = 'full';
  double totalPrice = 0;
    double basePrice = 0;
  BookingAvailable? bookingAvailable;

  TextEditingController _startTimeController = TextEditingController();

  String? selectedVehicleType;

  bool isPaymentComplete = false;
  Razorpay _razorpay = Razorpay();
  List<DateTime> bookedDates = [];

  String? selectedAddressId;

  void _getVehilesDate() async {
    final response =
        await getRequest('booking/vehicle-bookings-dates/${widget.vehicleId}');
    if (response.statusCode == 200) {
      print('vehicle dates: ${response.data}');
      setState(() {
        bookedDates =
            (response.data['data']['bookings'] as List).expand((booking) {
          DateTime startDate = DateTime.parse(booking['start_date']);
          DateTime endDate = DateTime.parse(booking['end_date']);
          return List.generate(endDate.difference(startDate).inDays + 1,
              (index) => startDate.add(Duration(days: index)));
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getVehilesDate();
  
    
    selectedDaysDuration = null;
    selectedWeeksDuration = null;
    selectedMonthsDuration = null;
    selectedDuration = '1 day';
    context.read<AddressCubit>().getAddresses();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }






  bool _isDateBooked(DateTime date) {
    return bookedDates.any((bookedDate) =>
        bookedDate.year == date.year &&
        bookedDate.month == date.month &&
        bookedDate.day == date.day);
  }

  void _onDateSelected(DateTime selectedDate, DateTime focusedDate) {
    if (!_isDateBooked(selectedDate)) {
      setState(() {
        _startDateController.text =
            DateFormat('MM/dd/yyyy').format(selectedDate);
      });
      Navigator.pop(context);
    } 
  }
  void _showCalendar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: Offset(0, -5),
                spreadRadius: 5
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Container(
                  width: 48.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
              
              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    Icon(
                      HugeIcons.strokeRoundedCalendar01,
                      color: primaryColor,
                      size: 24.sp,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Calendar
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime(2029),
                focusedDay: DateTime.now(),
                selectedDayPredicate: (day) =>
                    _startDateController.text == DateFormat('MM/dd/yyyy').format(day),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, _) {
                    if (_isDateBooked(date)) {
                      return Container(
                        margin: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: Colors.red[700],
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                  todayBuilder: (context, date, _) => Container(
                    margin: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  selectedBuilder: (context, date, _) => Container(
                    margin: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, primaryColor.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                onDaySelected: (selectedDate, focusedDate) {
                  if (_isDateBooked(selectedDate)) {
                    // Show a custom dialog instead of a bottom sheet
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: lightGreyColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          content: Padding(
                            padding: EdgeInsets.all(24.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: errorColor,
                                  size: 50.sp,
                                ),
                                SizedBox(height: 20.h),
                                Text(
                                  'Oops!',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'The selected date is already booked.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: greyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  'Okay',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    
                    );
                  } else {
                    _onDateSelected(selectedDate, focusedDate);
                  }
                },
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: TextStyle(color: Colors.red[400]),
                  holidayTextStyle: TextStyle(color: Colors.blue[400]),
                  todayDecoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  selectedDecoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  markerDecoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  tableBorder: TableBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left, color: primaryColor),
                  rightChevronIcon: Icon(Icons.chevron_right, color: primaryColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        controller.text = pickedTime.format(context);
      });
    }
  }

  void _onpartialbookingPressed ()async{

     if (_startDateController.text.isEmpty) {
      _showValidationError('Please select a start date');
      return;
    }

    if (_startTimeController.text.isEmpty) {
      _showValidationError('Please select a start time');
      return;
    }

    if (selectedDuration == null) {
      _showValidationError('Please select a duration');
      return;
    }

    // Validate date is not in the past
    DateTime selectedDate = DateFormat('MM/dd/yyyy').parse(_startDateController.text);
    if (selectedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      _showValidationError('Please select a future date');
      return;
    }

    // Validate time is not in the past if date is today
    if (selectedDate.year == DateTime.now().year &&
        selectedDate.month == DateTime.now().month &&
        selectedDate.day == DateTime.now().day) {
      TimeOfDay selectedTime = _parseTimeString(_startTimeController.text);
      TimeOfDay currentTime = TimeOfDay.now();
      
      if (_compareTimeOfDay(selectedTime, currentTime) <= 0) {
        _showValidationError('Please select a future time');
        return;
      }
    }

    // Validate against booked dates
    if (_isDateBooked(selectedDate)) {
      _showValidationError('Selected date is already booked');
      return;
    }

    // Calculate total price
    _calculateTotalPrice();
    if (totalPrice <= 0) {
      _showValidationError('Invalid price calculation');
      return;
    }

    // If all validations pass, proceed with booking
    final bookingCubit = BlocProvider.of<BookingCubit>(context);
    bookingCubit.postBooking(BookingData(
      startDate: _startDateController.text,
      startTime: _startTimeController.text,
      duration: selectedDuration ?? '',
      paymentType: 'partial',
      customerId: await UserPreferences().getUserId() ?? '',
      vehicleId: widget.vehicleId,
      vendorId: widget.vehicleDetails.vendorId,
      isDeliveryAtHome: isDeliveryAtHome,
      addressId: selectedAddressId,
    ));

      
    

  }

  void _onBookingPressed(BuildContext context) async {
    // Validate required fields
    if (_startDateController.text.isEmpty) {
      _showValidationError('Please select a start date');
      return;
    }

    if (_startTimeController.text.isEmpty) {
      _showValidationError('Please select a start time');
      return;
    }

    if (selectedDuration == null) {
      _showValidationError('Please select a duration');
      return;
    }

    // Validate date is not in the past
    DateTime selectedDate = DateFormat('MM/dd/yyyy').parse(_startDateController.text);
    if (selectedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      _showValidationError('Please select a future date');
      return;
    }

    // Validate time is not in the past if date is today
    if (selectedDate.year == DateTime.now().year &&
        selectedDate.month == DateTime.now().month &&
        selectedDate.day == DateTime.now().day) {
      TimeOfDay selectedTime = _parseTimeString(_startTimeController.text);
      TimeOfDay currentTime = TimeOfDay.now();
      
      if (_compareTimeOfDay(selectedTime, currentTime) <= 0) {
        _showValidationError('Please select a future time');
        return;
      }
    }

    // Validate against booked dates
    if (_isDateBooked(selectedDate)) {
      _showValidationError('Selected date is already booked');
      return;
    }

    // Calculate total price
    _calculateTotalPrice();
    if (totalPrice <= 0) {
      _showValidationError('Invalid price calculation');
      return;
    }

    // If all validations pass, proceed with booking
    final bookingCubit = BlocProvider.of<BookingCubit>(context);
    bookingCubit.postBooking(BookingData(
      startDate: _startDateController.text,
      startTime: _startTimeController.text,
      duration: selectedDuration ?? '',
      paymentType: 'full',
      customerId: await UserPreferences().getUserId() ?? '',
      vehicleId: widget.vehicleId,
      vendorId: widget.vehicleDetails.vendorId,
      isDeliveryAtHome: isDeliveryAtHome,
      addressId: selectedAddressId,
    ));

      
    
  }

  void _showValidationError(String message) {
    showToast(message , isSuccess: false);
  }

  TimeOfDay _parseTimeString(String timeString) {
    final parts = timeString.split(':');
    String hourPart = parts[0];
    String minutePart = parts[1].split(' ')[0];
    String period = parts[1].split(' ')[1];

    int hour = int.parse(hourPart);
    int minute = int.parse(minutePart);

    if (period.toUpperCase() == 'PM' && hour != 12) {
      hour += 12;
    } else if (period.toUpperCase() == 'AM' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  int _compareTimeOfDay(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour < time2.hour) return -1;
    if (time1.hour > time2.hour) return 1;
    if (time1.minute < time2.minute) return -1;
    if (time1.minute > time2.minute) return 1;
    return 0;
  }

  void _checkAvailability() async {
    // Validate required fields first
    if (_startDateController.text.isEmpty) {
      _showValidationError('Please select a start date');
      return;
    }

    if (_startTimeController.text.isEmpty) {
      _showValidationError('Please select a start time');
      return;
    }

    if (selectedDuration == null) {
      _showValidationError('Please select a duration');
      return;
    }

    // Validate date and time
    DateTime selectedDate = DateFormat('MM/dd/yyyy').parse(_startDateController.text);
    if (selectedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      _showValidationError('Please select a future date');
      return;
    }

    if (selectedDate.year == DateTime.now().year &&
        selectedDate.month == DateTime.now().month &&
        selectedDate.day == DateTime.now().day) {
      TimeOfDay selectedTime = _parseTimeString(_startTimeController.text);
      TimeOfDay currentTime = TimeOfDay.now();
      
      if (_compareTimeOfDay(selectedTime, currentTime) <= 0) {
        _showValidationError('Please select a future time');
        return;
      }
    }

    // Calculate total price
    _calculateTotalPrice();
    if (totalPrice <= 0) {
      _showValidationError('Invalid price calculation');
      return;
    }

    // If all validations pass, check availability
    final bookingCubit = BlocProvider.of<BookingCubit>(context);
    await bookingCubit.checkAvailability(BookingData(
      startDate: _startDateController.text,
      startTime: _startTimeController.text,
      duration: selectedDuration ?? '',
      paymentType: 'full',
      customerId: await UserPreferences().getUserId() ?? '',
      vehicleId: widget.vehicleDetails.vendorId,
      vendorId: widget.vehicleDetails.vendorId,
      isDeliveryAtHome: isDeliveryAtHome,
      
    ));
  }

  void _calculateTotalPrice() {
    int days = int.parse(selectedDaysDuration ?? '0');
    int weeks = int.parse(selectedWeeksDuration ?? '0');
    int months = int.parse(selectedMonthsDuration ?? '0');
    print("Days: $days");
    print("Weeks: $weeks");
    print("Months: $months");

    double price = 0;
    
  
    if (days > 0) {
      // Calculate daily price based on number of days selected
      if(days == 1){
        setState(() {
          basePrice = widget.vehicleDetails.dailyPrice.toDouble();
        });
      } else if (days == 2) {
        setState(() {
          basePrice = widget.vehicleDetails.twoDayPrice.toDouble();
        });

       
      } else if (days == 3) {
        print("Days = 3");

        double dailyRate = widget.vehicleDetails.threeDayPrice.toDouble();
        setState(() {
          basePrice = dailyRate;
        });
       
      } else if (days == 4) {
        print("Days = 4");
        double dailyRate = widget.vehicleDetails.fourDayPrice.toDouble();
        setState(() {
          basePrice = dailyRate;
        });
    
      } else if (days == 5) {
        print("Days = 5");
        double dailyRate = widget.vehicleDetails.fiveDayPrice.toDouble();
        setState(() {
          basePrice = dailyRate;
        });
       
      } else if (days == 6) {
        print("Days = 6");
        double dailyRate = widget.vehicleDetails.sixDayPrice.toDouble();
        setState(() {
          basePrice = dailyRate;
        });
              

      } else {
        print("Days > 6");
      
        setState(() {
          basePrice = widget.vehicleDetails.dailyPrice.toDouble();
        });
      }
    }
    if (weeks > 0) {
      // Calculate weekly price based on number of weeks selected
      if(weeks == 1){
         double weeklyRate = widget.vehicleDetails.twoWeekPrice.toDouble();
       
        setState(() {
        basePrice = widget.vehicleDetails.weeklyPrice.toDouble();
       });
      
      }else if (weeks == 2) {
        print("Weeks >= 2");
        // Apply 10% discount for 2 or more weeks
        double weeklyRate = widget.vehicleDetails.twoWeekPrice.toDouble();
       
        setState(() {
        basePrice = weeklyRate;
       });
       
      } 
      else if (weeks == 3) {
        print("Weeks == 3");
        // Apply 15% discount for 3 weeks
        double weeklyRate = widget.vehicleDetails.threeWeekPrice.toDouble();
       
        setState(() {
        basePrice = weeklyRate;
       });
       
      }

      else {
        print("Weeks < 2");
       
        setState(() {
        basePrice = widget.vehicleDetails.weeklyPrice.toDouble();
       });
      }
    }
    if (months > 0) {
      // Calculate monthly price based on number of months selected
      if(months == 1){
        double monthlyRate = widget.vehicleDetails.monthlyPrice.toDouble();
       
        setState(() {
        basePrice = monthlyRate;
       });
     
      }else if (months == 2) {
        print("Months >= 2");
        // Apply 10% discount for 2 or more months
        double monthlyRate = widget.vehicleDetails.twoMonthPrice.toDouble();
       
        setState(() {
        basePrice = monthlyRate;
       });
   
      } 
      else if (months == 3) {
        print("Months == 3");
        // Apply 15% discount for 3 months
        double monthlyRate = widget.vehicleDetails.threeMonthPrice.toDouble();
     
        setState(() {
        basePrice = monthlyRate;
       });
       
      }
      else {
        print("Months < 2");
       
        setState(() {
        basePrice = widget.vehicleDetails.monthlyPrice.toDouble();
       });
      }
    }
    
    // Calculate delivery fee if home delivery is selected
    double deliveryFee = isDeliveryAtHome ? widget.vehicleDetails.deliveryFees.toDouble() : 0;
    print("Delivery Fee: $deliveryFee");

    setState(() {
      totalPrice = basePrice + deliveryFee;
    });

  }

  Future<void>_checkAddress()async{
    final address = await getRequest('users/address');
    print("Address: $address");
    if(address.data['data'] == null){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> AddressScreen()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Book Your Ride',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.black87, size: 16.sp),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BookingSuccessScreen(bookingDetails: state.data)));
            
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>  BookingSuccessScreen(bookingDetails: state.data)),
              );
          }
          if (state is BookingSuccessAvailable) {
            bookingAvailable = state.data;
            bool isAvailable = bookingAvailable?.available ?? false;
           
            if (isAvailable) {
              if(paymentType == 'full'){
              _onBookingPressed(context);
            }else{
              _onpartialbookingPressed();
            }
            } else {
                  showToast('Vehicle is not available' , isSuccess: false);}
          }
          if (state is BookingError) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BookingFailureScreen(errorMessage: state.message)));
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Compact Vehicle Preview
              Container(
                margin: EdgeInsets.all(16.w),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Vehicle Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        '${widget.vehicleDetails.images[0]}',
                        height: 80.h,
                        width: 80.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Vehicle Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.vehicleDetails.name,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${widget.vehicleDetails.year} • ${widget.vehicleDetails.variant}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              '₹${widget.vehicleDetails.dailyPrice}/day',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Booking Form Container
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Duration',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Date and Time Selection
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            controller: _startDateController,
                            label: 'Date',
                            icon: Icons.calendar_today_rounded,
                            onTap: _showCalendar,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildTimeDropdown(),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Duration Selection
                    Row(
                      children: [
                        Expanded(
                          child: _buildDurationDropdown(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if(widget.vehicleDetails.availableDelivery == 'Non-Deliverable')...[

              SizedBox(height: 30.h),
              ]else...[ 
                SizedBox(height: 0.h),
              ],

              // Delivery Option
              if(widget.vehicleDetails.availableDelivery == 'Deliverable')
              Container(
                margin: EdgeInsets.all(16.w),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Options',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.delivery_dining,
                            color: primaryColor,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Home Delivery',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Get the vehicle delivered to your doorstep',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: isDeliveryAtHome,
                          onChanged: (value) async {
                            if (value) {
                              // Show address bottom sheet when turning on
                              final addressId = await showAddressBottomSheet(context);
                              if (addressId != null) {
                                setState(() {
                                  selectedAddressId = addressId;
                                  isDeliveryAtHome = true;
                                  totalPrice = basePrice + widget.vehicleDetails.deliveryFees.toDouble();
                                });
                                print('Selected Address ID: $addressId');
                              } else {
                                // If no address was selected, keep switch off
                                setState(() {
                                  isDeliveryAtHome = false;
                                });
                              }
                            } else {
                              // When turning off
                              setState(() {
                                selectedAddressId = null;
                                isDeliveryAtHome = false;
                                totalPrice = basePrice;
                              });
                            }
                          },
                          activeColor: primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Price Summary
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price Summary',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildPriceRow('Rental Charge', '₹${basePrice}'),
                    _buildPriceRow(
                      'Delivery Fee',
                      isDeliveryAtHome ? '₹${widget.vehicleDetails.deliveryFees}' : '₹0',
                    ),
                    _buildPriceRow('Insurance', '₹0'),
                    Divider(height: 24.h),
                    _buildPriceRow(
                      'Total Amount',
                      '₹${totalPrice.round()}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),

              // Payment Buttons
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Set partial payment (20% of total)
                          double partialAmount = totalPrice /100 * 20;
                          totalPrice = partialAmount;
                          paymentType = 'partial';
                        });
                        // _onpartialbookingPressed();
                        _checkAvailability();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                     
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          side: BorderSide(color: primaryColor),
                        ),
                        elevation: 0,
                       
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payment, color: primaryColor),
                          SizedBox(width: 8.w),
                          Text(
                            'Pay 20% Now (₹${(totalPrice / 100 * 20).round()})',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ElevatedButton(
                      onPressed: _checkAvailability,
                     
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payment),
                          SizedBox(width: 8.w),
                          Text(
                            'Pay Full Amount (₹${totalPrice.round()})',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Payment Security Text
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 16.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Secured by Razorpay Payment Gateway',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widgets...
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.w),
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(icon, color: primaryColor),
        ),
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Summary',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          _buildPriceRow('Rental Charge', '₹${widget.vehicleDetails.dailyPrice}'),
          _buildPriceRow('Delivery Fee', isDeliveryAtHome ? '₹${widget.vehicleDetails.deliveryFees}' : '₹0'),
          _buildPriceRow('Insurance', '₹0'),
          Divider(height: 24.h),
          _buildPriceRow(
            'Total Amount',
            '₹${totalPrice.round()}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              color: isTotal ? primaryColor : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationDropdown() {
    return Row(
      children: [
        // Days Dropdown
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: DropdownButtonHideUnderline(

              child: DropdownButton<String>(
                icon: SizedBox.shrink(),
                value: selectedDaysDuration,
                hint: Text(
                  'Days',
                  style: extraSmallTextStyle.copyWith(color: Colors.grey[400]),
                ),
                items: List.generate(6, (index) => (index + 1).toString())
                    .map((day) => DropdownMenuItem(
                          value: day,
                          child: Text(
                            '$day day${int.parse(day) > 1 ? 's' : ''}',
                            style: smallTextStyle,
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    // Clear other duration selections
                    selectedWeeksDuration = null;
                    selectedMonthsDuration = null;
                    selectedDaysDuration = value;
                    selectedDuration = '$value day';
                  });
                  _calculateTotalPrice();
                },
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Weeks Dropdown
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: SizedBox.shrink(),

                value: selectedWeeksDuration,
                hint: Text(
                  'Weeks',
                  style: extraSmallTextStyle.copyWith(color: Colors.grey[400]),
                ),
                items: List.generate(3, (index) => (index + 1).toString())
                    .map((week) => DropdownMenuItem(
                          value: week,
                          child: Text(
                            '$week week${int.parse(week) > 1 ? 's' : ''}',
                            style: smallTextStyle,
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    // Clear other duration selections
                    selectedDaysDuration = null;
                    selectedMonthsDuration = null;
                    selectedWeeksDuration = value;
                    selectedDuration = '$value week';
                  });
                  _calculateTotalPrice();
                },
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Months Dropdown
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: SizedBox.shrink(),

                value: selectedMonthsDuration,
                hint: Text(
                  'Months',
                  style: extraSmallTextStyle.copyWith(color: Colors.grey[400]),
                ),
                items: List.generate(3, (index) => (index + 1).toString())
                    .map((month) => DropdownMenuItem(
                          value: month,
                          child: Text(
                            '$month month${int.parse(month) > 1 ? 's' : ''}',
                            style: extraSmallTextStyle,
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    // Clear other duration selections
                    selectedDaysDuration = null;
                    selectedWeeksDuration = null;
                    selectedMonthsDuration = value;
                    selectedDuration = '$value month';
                  });
                  _calculateTotalPrice();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonFormField<String>(
        value: null,
        icon: SizedBox.shrink(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.w),
          border: InputBorder.none,
          labelText: 'Time',
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.access_time_rounded, color: primaryColor),
        ),
        items: ['9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM', '6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM', '11:00 PM']
            .map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            selectedTime = value;
            _startTimeController.text = value.toString();
          });
        },
      ),
    );
  }
}

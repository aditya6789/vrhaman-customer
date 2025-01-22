import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/app.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingAvailable.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingdata.dart';
import 'package:vrhaman/src/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:vrhaman/src/features/booking/presentation/screens/booking_failure_screen.dart';
import 'package:vrhaman/src/features/booking/presentation/screens/booking_success_screen.dart';
import 'package:vrhaman/src/features/home/presentation/pages/bottom_navigation_bar.dart';
import 'package:vrhaman/src/features/home/presentation/pages/home_screen.dart';
import 'package:vrhaman/src/features/vehicle_details/domain/entities/vehicleDetails.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vrhaman/src/utils/api_response.dart';

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
  BookingAvailable? bookingAvailable;

  TextEditingController _startTimeController = TextEditingController();

  String? selectedVehicleType;

  bool isPaymentComplete = false;
  Razorpay _razorpay = Razorpay();
  List<DateTime> bookedDates = [];

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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected date is already booked')),
      );
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
                onDaySelected: _onDateSelected,
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
    ));

      
    
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
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
    
    double basePrice = 0;
    if (days > 0) {
      basePrice += days * widget.vehicleDetails.dailyPrice.toDouble();
    }
    if (weeks > 0) {
      basePrice += weeks * widget.vehicleDetails.weeklyPrice.toDouble();
    }
    if (months > 0) {
      basePrice += months * widget.vehicleDetails.monthlyPrice.toDouble();
    }
    
    double deliveryFee = isDeliveryAtHome ? widget.vehicleDetails.deliveryFees.toDouble() : 0;
    
    setState(() {
      totalPrice = basePrice + deliveryFee;
    });
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
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vehicle is not available')));
            }
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
                        '$IMAGE_URL${widget.vehicleDetails.images[0]}',
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
                            label: 'Pick-up Date',
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

              // Delivery Option
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
                          onChanged: (value) => setState(() => isDeliveryAtHome = value),
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
                    _buildPriceRow('Rental Charge', '₹${widget.vehicleDetails.dailyPrice}'),
                    _buildPriceRow(
                      'Delivery Fee',
                      isDeliveryAtHome ? '₹${widget.vehicleDetails.deliveryFees}' : '₹0',
                    ),
                    _buildPriceRow('Insurance', '₹0'),
                    Divider(height: 24.h),
                    _buildPriceRow(
                      'Total Amount',
                      '₹${totalPrice.toStringAsFixed(2)}',
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
                          // Set partial payment (30% of total)
                          double partialAmount = totalPrice * 0.2;
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
                            'Pay 30% Now (₹${(totalPrice * 0.3).toStringAsFixed(2)})',
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
                            'Pay Full Amount (₹${totalPrice.toStringAsFixed(2)})',
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
            '₹${totalPrice.toStringAsFixed(2)}',
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
        value: selectedTime,
        icon: SizedBox.shrink(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.w),
          border: InputBorder.none,
          labelText: 'Pick-up Time',
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.access_time_rounded, color: primaryColor),
        ),
        items: ['9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM']
            .map((String value) {
          return DropdownMenuItem<String>(
            
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            _startTimeController.text = value.toString();
          });
        },
      ),
    );
  }
}

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/booking/domain/entities/confirmBookingData.dart';
import 'package:vrhaman/src/features/home/presentation/pages/bottom_navigation_bar.dart';
import 'package:vrhaman/src/utils/api_response.dart';
import 'package:vrhaman/src/utils/user_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class BookingSuccessScreen extends StatefulWidget {
  final ConfirmBookingData bookingDetails;

  const BookingSuccessScreen({Key? key, required this.bookingDetails}) : super(key: key);

  @override
  _BookingSuccessScreenState createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> {
  Timer? _pollingTimer;
  Timer? _countdownTimer;
  int _remainingSeconds = 300; // 5 minutes
  String _bookingStatus = 'Pending';
  bool _isPaymentComplete = false;
  final Razorpay _razorpay = Razorpay();
  late IO.Socket socket;
  final UserPreferences userPreferences = UserPreferences();

  @override
  void initState() {
    super.initState();
    _startPolling();
    _startCountdown();
    _initializeRazorpay();
    _saveCurrentBooking();
    initializeSocket();
  }

   Future<IO.Socket> initializeSocket() async {
    print("Running socket");
    final prefs = await SharedPreferences.getInstance();
     final String token = prefs.getString('accessToken') ?? '';
    print("Token: $token");

     socket = IO.io(SOCKET_URL, <String, dynamic>{
      'transports': ['websocket'],
      'auth': {
        'token': token,
      },
      'autoConnect': true,
      'connectTimeout': 30000, // 30 seconds timeout
      'reconnection': true,
      'reconnectionDelay': 1000,
      'reconnectionAttempts': 5,
    });

   

    _setupSocketListeners();

    socket.connect();
     socket.onConnectError((error) {
  print('Connection error: $error');
  // Implement retry logic here
  Future.delayed(Duration(seconds: 3), () {
    if (!socket.connected) {
      print('Retrying connection...');
      socket.connect();
    }
  });
});

socket.onReconnectAttempt((attempt) {
  print('Reconnect attempt: $attempt');
  socket = IO.io('http://10.0.2.2:5000', <String, dynamic>{
    'transports': ['websocket'],
    'auth': {
      'token': token,
    },
    'autoConnect': false,
  });
});

    return socket;
  }

   void _setupSocketListeners() async {
    
    
    print("Socket connected: ${socket.connected}");

    final user = await userPreferences.getUserId();
    
    socket.onConnect((_) {
      print('Connected to server');
      // Register vendor
      socket.emit('register-customer', {
        "customerId": user,
        "role": 'customer',
      });
    });

    socket.on('registered', (data) {
      print('Registration successful: $data');
    });

    socket.onError((error) {
      print('Socket Error: $error');
    });

    socket.onReconnectFailed((_) {
      print('Reconnection failed');
    });

    socket.on('bookingUpdate', (data) {
      print('New booking update: $data');
      if (data != null ) {
        // _showBookingDialog(data);
      }
    });

    socket!.onDisconnect((_) {
      print('Socket Disconnected');
    });
  }

   void disconnect() {
    socket?.disconnect();
    // socket = null;
  }

  void _saveCurrentBooking() async {
    if (_bookingStatus != 'Confirmed' && _bookingStatus != 'Cancelled') {
      await UserPreferences().setActiveBookingId(widget.bookingDetails.id);
    }
  }

  void _clearCurrentBooking() async {
    await UserPreferences().setActiveBookingId(null);
  }

  void _initializeRazorpay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      await _checkBookingStatus();
    });
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _cancelBooking();
          timer.cancel();
        }
      });
    });
  }

  Future<void> _checkBookingStatus() async {
    if (!mounted) return;
    
    try {
      final response = await getRequest('booking/customer/send-booking/${widget.bookingDetails.id}');
      
      if (response.statusCode == 200) {
        final status = response.data['data']['status'];
        if (!mounted) return;
        
        setState(() {
          _bookingStatus = status;
        });

        if (status == 'Accepted') {
          _stopPolling(); // Stop polling when status is Accepted
          _resetTimer(); // Reset timer for payment
        } else if (status == 'Confirmed' || status == 'Cancelled') {
          _stopPolling();
          _clearCurrentBooking(); // Clear the active booking ID
        }
      }
    } catch (e) {
      print('Error checking booking status: $e');
    }
  }

  void _resetTimer() {
    if (!mounted) return;
    
    _countdownTimer?.cancel();
    setState(() {
      _remainingSeconds = 300; // Reset to 5 minutes
    });
    _startCountdown();
  }

  Future<void> _cancelBooking() async {
    if (!mounted) return;

    try {
      await postRequest('booking/cancel/${widget.bookingDetails.id}', {});
      if (!mounted) return;
      
      setState(() {
        _bookingStatus = 'Cancelled';
      });
      _stopPolling();
    } catch (e) {
      print('Error cancelling booking: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('handle payment success ${response.data}');
    if (!mounted) return;

   

    try {
      await postRequest('payment/success', {
        'payment_id': response.paymentId,
        'booking_id': widget.bookingDetails.id,
        'amount': widget.bookingDetails.totalPrice,
        'status': 'Confirmed',


      });
      if (!mounted) return;
      
      // setState(() {
      //   _isPaymentComplete = true;
      //   _bookingStatus = 'Completed';
      // });
      _stopPolling();
    } catch (e) {
      print('Error updating payment status: $e');
    }

    _updateBookingStatus('Confirmed', response.paymentId ?? '');
    
  }

  
  void _updateBookingStatus(String status , String paymentId) async {

    try {
      final response = await patchRequest('booking/customer/', {
        'status': status,
        'payment_id': paymentId,
        'booking_id': widget.bookingDetails.id,
        
      });
      if (response.statusCode == 200) {
        setState(() {
          _bookingStatus = status;
        });
      }
    } catch (e) {
      print('Error updating booking status: $e');
      
    }
    setState(() {
      _bookingStatus = status;
    });
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment failed: ${response.message}');
  }

  Future<bool> _onWillPop() async {
    if (_bookingStatus == 'Confirmed' || _bookingStatus == 'Cancelled') {
      return true;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please wait until booking is confirmed or cancelled'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
    return false;
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _stopPolling();
    _razorpay.clear();
    super.dispose();
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
    _pollingTimer = null;
    _countdownTimer = null;
  }

  void _makePayment() {
    if (!mounted) return;
    
    var options = {
      'key': 'rzp_test_j7QHEzEapiwVwQ',
      'amount': (widget.bookingDetails.totalPrice * 100).toInt(),
      'name': 'Vrhaman',
      'description': 'Vehicle Booking Payment',
      'prefill': {
        'contact': widget.bookingDetails.customerPhone,
        'email': widget.bookingDetails.customerEmail,
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error making payment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _bookingStatus == 'Confirmed' || _bookingStatus == 'Cancelled'
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  // Status Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(16.r),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.black.withOpacity(0.03),
                    //       blurRadius: 10,
                    //       offset: Offset(0, 5),
                    //     ),
                    //   ],
                    // ),
                  child: Column(
                    children: [
                        _buildStatusIcon(),
                        SizedBox(height: 16.h),
                        _buildStatusText(),
                        if (_bookingStatus != 'Confirmed' && _bookingStatus != 'Cancelled')
                          Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: Colors.orange.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.timer_outlined, color: Colors.orange, size: 18.sp),
                                  SizedBox(width: 8.w),
                      Text(
                                    'Time remaining: ${_formatTime(_remainingSeconds)}',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                  // Booking Reference
                    Container(
                    padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(Icons.description_outlined, color: Colors.blue, size: 20.sp),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Booking Reference',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                        Text(
                              widget.bookingDetails.id.substring(0, 8).toUpperCase(),
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Booking Details
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          Icons.directions_car_outlined,
                          'Vehicle',
                          widget.bookingDetails.vehicleName,
                        ),
                        _buildDivider(),
                        _buildDetailRow(
                          Icons.calendar_today_outlined,
                          'Start Date',
                          DateFormat('MMM dd, yyyy').format(widget.bookingDetails.startDate),
                        ),
                        _buildDivider(),
                        _buildDetailRow(
                          Icons.access_time_outlined,
                          'Start Time',
                          widget.bookingDetails.startTime,
                        ),
                        _buildDivider(),
                        _buildDetailRow(
                          Icons.calendar_today_outlined,
                          'End Date',
                          DateFormat('MMM dd, yyyy').format(widget.bookingDetails.endDate),
                        ),
                        _buildDivider(),
                        _buildDetailRow(
                          Icons.store_outlined,
                          'Vendor',
                          widget.bookingDetails.vendorBusinessName,
                        ),
                        _buildDivider(),
                        _buildDetailRow(
                          Icons.location_on_outlined,
                          'Address',
                          widget.bookingDetails.vendorBusinessAddress,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Tips Section
                  if (_bookingStatus == 'Confirmed')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Text(
                            'Our Technologies',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                          children: [
                              _buildTechnologyCard(
                                Icons.security_outlined,
                                'Secure Payments',
                                'End-to-end encrypted payment system',
                                Colors.blue,
                              ),
                              SizedBox(width: 12.w),
                              _buildTechnologyCard(
                                Icons.gps_fixed_outlined,
                                'GPS Tracking',
                                'Real-time vehicle location tracking',
                                Colors.green,
                              ),
                              SizedBox(width: 12.w),
                              _buildTechnologyCard(
                                Icons.verified_user_outlined,
                                'Verified Vendors',
                                'All vendors are verified and trusted',
                                Colors.orange,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Text(
                            'Our Services',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _buildServiceCard(
                          Icons.local_shipping_outlined,
                          'Home Delivery',
                          'Get your vehicle delivered at your doorstep',
                          'Available in selected areas',
                          Colors.purple,
                        ),
                        SizedBox(height: 12.h),
                        _buildServiceCard(
                          Icons.support_agent_outlined,
                          '24/7 Support',
                          'Our support team is always ready to help',
                          'Call us anytime at our helpline',
                          Colors.indigo,
                        ),
                        SizedBox(height: 12.h),
                        _buildServiceCard(
                          Icons.shield_outlined,
                          'Insurance Coverage',
                          'All vehicles come with basic insurance',
                          'Additional coverage available',
                          Colors.teal,
                        ),
                        SizedBox(height: 24.h),
                        Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Text(
                            'Important Tips',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _buildTipCard(
                          Icons.assignment_outlined,
                          'Documents Required',
                          'Please bring your valid driver\'s license and an ID proof',
                        ),
                        SizedBox(height: 12.h),
                        _buildTipCard(
                          Icons.access_time_outlined,
                          'Arrival Time',
                          'Please arrive 30 minutes before your scheduled time',
                        ),
                        SizedBox(height: 12.h),
                        _buildTipCard(
                          Icons.support_agent_outlined,
                          'Need Help?',
                          'Contact our support team at support@vrhaman.com',
                        ),
                      ],
                    ),

                  SizedBox(height: 24.h),
                  _buildActionButton(),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 18.sp, color: primaryColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[100],
      height: 16.h,
      thickness: 1,
    );
  }

  Widget _buildTipCard(IconData icon, String title, String description) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
                  children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: primaryColor, size: 18.sp),
          ),
          SizedBox(width: 16.w),
                    Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;

    switch (_bookingStatus) {
      case 'Confirmed':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'Cancelled':
        icon = Icons.cancel;
        color = Colors.red;
        break;
      case 'Accepted':
        icon = Icons.access_time;
        color = Colors.orange;
        break;
      default:
        icon = HugeIcons.strokeRoundedTime04;
        color = Colors.blue;
    }

    return Icon(icon, size: 80.sp, color: color);
  }

  Widget _buildStatusText() {
    String message;
    switch (_bookingStatus) {
      case 'Confirmed':
        message = 'Booking Confirmed!';
        break;
      case 'Cancelled':
        message = 'Booking Cancelled';
        break;
      case 'Accepted':
        message = 'Booking Accepted\nPlease make payment';
        break;
      default:
        message = 'Waiting for confirmation...';
    }

    return Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildActionButton() {
    if (_bookingStatus == 'Accepted' && !_isPaymentComplete) {
      return Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _makePayment,
          child: Text(
            'Make Payment',
            style: TextStyle(fontSize: 14.sp),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
        ),
      );
    } else if (_bookingStatus == 'Confirmed' || _bookingStatus == 'Cancelled') {
      return Container(
        width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
            _clearCurrentBooking(); // Clear active booking before navigation
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => CustomNavigationBar()),
              (route) => false,
            );
          },
          child: Text(
            'Go to Home',
            style: TextStyle(fontSize: 14.sp),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildTechnologyCard(IconData icon, String title, String description, Color color) {
    return Container(
      width: 160.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(IconData icon, String title, String description, String note, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  note,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
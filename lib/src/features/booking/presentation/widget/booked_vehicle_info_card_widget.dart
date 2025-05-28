import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingVehicle.dart';
import 'package:vrhaman/src/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:vrhaman/src/features/booking/presentation/screens/booking_details_screen.dart';
import 'package:vrhaman/src/features/booking/presentation/widget/date_widget.dart';
import 'package:vrhaman/src/features/booking/presentation/widget/time_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vrhaman/src/utils/api_response.dart';
import 'package:vrhaman/src/utils/launch_url.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrhaman/src/utils/toast.dart';

class BookedVehicleInfoCard extends StatefulWidget {
  final BookingVehicle booking;
  const BookedVehicleInfoCard({super.key, required this.booking});

  @override
  State<BookedVehicleInfoCard> createState() => _BookedVehicleInfoCardState();
}

class _BookedVehicleInfoCardState extends State<BookedVehicleInfoCard> {
  Razorpay _razorpay = Razorpay();
  int amount = 0;
  

  @override
  void initState() {
    super.initState();
     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }
    @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  
  void _openRazorpay() async {
    var options = {
      'key': 'rzp_live_jkdw3rMi0JwTiT',
      'amount': amount,
      'name': 'Razorpay Inc.',
      'description': 'Thank you for shopping with us!',
      'prefill': {
        'contact': '8888888888',
        'email': 'test@razorpay.com'
      },
      'theme': {
        'color': '#008000',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }


  void _onPaymentPressed(BuildContext context) async {
    print('Payment pressed');
    if(widget.booking.payment_type== 'partial'){
      amount = (widget.booking.totalPrice  * 20 / 100 ).toInt() * 100;

    }else{
      amount = widget.booking.totalPrice.toInt() * 100;
    }
    _openRazorpay();
  }

  Future<void> _onBookingPressed(BuildContext context, String paymentId) async {
    print('Booking pressed');
    try {
      final res = await patchRequest('booking/payment/${widget.booking.id}', {
        'booking_id': widget.booking.id,
        'payment_id': paymentId,
      });
      print('booking payment response ${res}');

      context.read<BookingCubit>().getBookings();
     
      print('Booking completed');
    } catch (e) {
      print(e);
    }

    // Implement booking logic here
  }

  
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _onBookingPressed(context, response.paymentId ?? '');
    showPaymentPopupMessage(context, true, 'Payment Successful!');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showPaymentPopupMessage(context, false, 'Payment Failed!');
  }

  void showCancelBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red[50],
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color: Colors.red,
                    size: 32.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Cancel Booking',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Are you sure you want to cancel this booking? This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'No, Keep it',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final res = await cancelBooking();
                          if(res == 'success'){
                            context.read<BookingCubit>().getBookings();
                            Navigator.pop(context, true);
                            showToast( 'Booking cancelled successfully');
                          }else{
                            showToast( 'Failed to cancel booking');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          ' Cancel',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> cancelBooking() async{
    final res = await postRequest('booking/cancel-booking/${widget.booking.id}', {});
    print('booking cancel response ${res}');
    if(res.statusCode == 200){
      return 'success';
    }else{
      return 'error';
    }
  }

  
  void showPaymentPopupMessage(
      BuildContext ctx, bool isPaymentSuccess, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog<void>(
        context: ctx,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                isPaymentSuccess
                    ? Icon(Icons.done, color: Colors.green)
                    : Icon(Icons.clear, color: Colors.red),
                SizedBox(width: 5.w),
                Text(
                  isPaymentSuccess ? 'Payment Successful' : 'Payment Failed',
                  style: TextStyle(fontSize: 20.sp),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Divider(color: Colors.grey),
                  SizedBox(height: 5.h),
                  Text(message),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
          );
        },
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailsScreen(bookingDetails: widget.booking)));
          },
          borderRadius: BorderRadius.circular(24.r),
          child: Container(
            height: 258.h,
            child: Column(
              children: [
                // Top section with image and basic info
                Expanded(
                  child: Row(
                    children: [
                      // Left side - Vehicle Image
                      Hero(
                        tag: 'vehicle_${widget.booking.id}',
                        child: Container(
                          width: 160.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.r),
                              bottomLeft: Radius.circular(24.r),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.r),
                              bottomLeft: Radius.circular(24.r),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                 (widget.booking.vehicleImages[0] ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtc3-y63KN_r5LwOC9PNqpwc5C1JPeN36_ug&s'),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[100],
                                      child: Icon(
                                        Icons.directions_car,
                                        size: 40.sp,
                                        color: Colors.grey[400],
                                      ),
                                    );
                                  },
                                ),
                                // Gradient overlay
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.6),
                                      ],
                                    ),
                                  ),
                                ),
                                // Price tag
                                Positioned(
                                  bottom: 12.h,
                                  left: 12.w,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          primaryColor,
                                          Color.fromARGB(255, 71, 59, 194),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.currency_rupee,
                                          color: Colors.white,
                                          size: 14.sp,
                                        ),
                                        Text(
                                          '${widget.booking.totalPrice}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.sp,
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
                      ),

                      // Right side - Booking Details
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Status Badge
                              _buildStatusBadge(widget.booking.status),
                              SizedBox(height: 12.h),

                              // Vehicle Name
                              Text(
                                widget.booking.vehicleName,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 12.h),

                              // Booking Details
                              _buildInfoRow(
                                HugeIcons.strokeRoundedCalendar01,
                                widget.booking.startDate.toString().split(' ')[0],
                              ),
                              SizedBox(height: 8.h),
                              _buildInfoRow(
                                HugeIcons.strokeRoundedClock01,
                                widget.booking.startTime,
                              ),
                              SizedBox(height: 8.h),
                              _buildInfoRow(
                                Icons.location_on_outlined,
                                widget.booking.pickupAddress,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Action Bar
                Container(
                  margin: EdgeInsets.only(top: 5.h),
                  
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[200]!, width: 1),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    children: [
                      if(widget.booking.status == 'Accepted')
                        Expanded(
                          child: _buildActionButton(
                            onPressed: () => _onPaymentPressed(context),
                            icon: HugeIcons.strokeRoundedMoney01,
                            label: 'Payment',
                            color: primaryColor,
                          ),
                        ),
                      if(widget.booking.status == 'Confirmed')
                        Expanded(
                          child: _buildActionButton(
                            onPressed: () {
                              launchGoogleMaps(widget.booking.pickupAddress);
                            },
                            icon: HugeIcons.strokeRoundedNavigation04,
                            label: 'Navigate',
                            color: Colors.green,
                          ),
                        ),
                      if(widget.booking.status == 'Pending')
                        Expanded(
                          child: _buildActionButton(
                            onPressed: () {
                              showCancelBookingDialog(context);
                            },
                            icon: HugeIcons.strokeRoundedCancel02,
                            label: 'Cancel',
                            color: Colors.red,
                          ),
                        ),
                      if(widget.booking.status == 'Cancelled')
                        Expanded(
                          child: _buildActionButton(
                            onPressed: null,
                            icon: Icons.cancel,
                            label: 'Cancelled',
                            color: Colors.grey,
                          ),
                        ),
                      if(widget.booking.status == 'Completed')
                        Expanded(
                          child: _buildActionButton(
                            onPressed: null,
                            icon: Icons.check_circle,
                            label: 'Completed',
                            color: Colors.grey,
                          ),
                        ),
                     
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 16.sp,
            color: primaryColor,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[700],
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      height: 40.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18.sp),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: color.withOpacity(0.2)),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

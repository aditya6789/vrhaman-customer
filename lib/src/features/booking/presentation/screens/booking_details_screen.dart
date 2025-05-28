import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/core/cubit/review_cubit.dart';
import 'package:vrhaman/src/core/entities/review_entity.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingVehicle.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrhaman/src/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:vrhaman/src/utils/api_response.dart';
import 'package:vrhaman/src/utils/launch_url.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrhaman/src/utils/toast.dart';
import 'package:vrhaman/src/utils/user_prefences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

// ignore: must_be_immutable
class BookingDetailsScreen extends StatefulWidget {
  final BookingVehicle bookingDetails;

   BookingDetailsScreen({
    Key? key,
    required this.bookingDetails,
  }) : super(key: key);

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}


class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  UserPreferences userPreferences = UserPreferences();

  TextEditingController commentController = TextEditingController();

  int rating = 0;
  int amount = 0;
  double partialAmount = 0;

  Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    // context.read<BookingCubit>().getBookingVehicleById(widget.bookingDetails.id);
    partialAmount = widget.bookingDetails.totalPrice / 100 * 20;

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

    void _makePayment() {
    if (!mounted) return;
    
    var options = {
      'key': 'rzp_live_jkdw3rMi0JwTiT',
      'amount': (amount * 100).toInt(),
      'name': 'Vrhaman',
      'description': 'Vehicle Booking Payment',
      'prefill': {
        'contact': '8968779413',
        'email': 'support@vrhaman.com',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error making payment: $e');
    }
  }

    void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment failed: ${response.message}');
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
    } catch (e) {
      print('Error updating payment status: $e');
    }

    _updateBookingStatus(widget.bookingDetails.status ?? '', response.paymentId ?? '');
  }

  void _updateBookingStatus(String status, String paymentId) async {
    try {
      final response = await postRequest('booking/full-payment', {
        'booking_id': widget.bookingDetails.id,
       
      });
      if (response.statusCode == 200) {
        context.read<BookingCubit>().getBookings();
        Navigator.pop(context);
        showToast('Booking status updated successfully');

       
      }
    } catch (e) {
      print('Error updating booking status: $e');
    }
    


  }

  void calculateAmount() {
    final fullAmount = widget.bookingDetails.totalPrice ?? 0;
    print("full amount $fullAmount");
    final newAmount = fullAmount / 100 * 20;
    final newPartialAmount = fullAmount - newAmount;
    setState(() {
      amount = newPartialAmount.toInt();
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Booking Details',
          style: mediumTextStyle
        ),
      ),
      
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Hero Vehicle Image Section with Enhanced Design
            Container(
              height: 300.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image with Enhanced Gradient
                  Hero(
                    tag: 'vehicle_${widget.bookingDetails.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            (widget.bookingDetails.vehicleImages[0] ?? ''),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                  // Vehicle Info Overlay with Enhanced Layout
                  Positioned(
                    bottom: 40.h,
                    left: 20.w,
                    right: 20.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildStatusBadge(widget.bookingDetails.status ?? 'Pending'),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.timer_outlined, color: Colors.white, size: 16.sp),
                                  SizedBox(width: 4.w),
                                  Text(
                                    widget.bookingDetails.rentalPeriod ?? 'N/A',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          widget.bookingDetails.vehicleName ?? 'Vehicle Name',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, color: Colors.white70, size: 16.sp),
                            SizedBox(width: 4.w),
                            Text(
                              widget.bookingDetails.pickupAddress ?? 'N/A',
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Content with Negative Margin for Card Overlap
            Transform.translate(
              offset: Offset(0, -30.h),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.r),
                    topRight: Radius.circular(32.r),
                  ),
                ),
                child: Column(
                  children: [
                    // Booking Status Card with Enhanced Design
                    Container(
                      margin: EdgeInsets.fromLTRB(16.w, 24.w, 16.w, 16.w),
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(230, 255, 177, 59),
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                            color: primaryColor.withOpacity(0.2),
                            blurRadius: 16,
                    offset: const Offset(0, 8),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 0,
                            offset: const Offset(0, -1),
                            spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildStatusRow('Booking ID', '#${widget.bookingDetails.id ?? 'N/A'}'.substring(0, 8)),
                          _buildAnimatedDivider(isWhite: true),
               
                  _buildStatusRow('Status', widget.bookingDetails.status ?? 'Pending', isStatus: true),
                ],
              ),
            ),

                    // Vehicle Details Card with Enhanced Design
            _buildDetailsCard(
              title: 'Vehicle Details',
              icon: Icons.directions_car,
              content: Column(
                children: [
                  _buildDetailRow(
                    icon: Icons.directions_car_outlined,
                    label: 'Vehicle',
                    value: widget.bookingDetails.vehicleName ?? 'N/A',
                    iconColor: primaryColor,
                  ),
                  _buildAnimatedDivider(),
                  _buildDetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Start Date',
                    value: _formatDate(widget.bookingDetails.startDate),
                    iconColor: primaryColor,
                  ),
                  _buildAnimatedDivider(),
                  _buildDetailRow(
                    icon: Icons.access_time_rounded,
                    label: 'Duration',
                    value: widget.bookingDetails.rentalPeriod ?? 'N/A',
                    iconColor: primaryColor,
                  ),
                ],
              ),
            ),

                    // Payment Details Card with Enhanced Design
            _buildDetailsCard(
              title: 'Payment Details',
              icon: Icons.payment,
              content: Column(
                children: [
                  _buildDetailRow(
                    icon: Icons.receipt_long_outlined,
                    label: 'Total Amount',
                    value: '₹${widget.bookingDetails.totalPrice ?? '0'}',
                    iconColor: Colors.green,
                            // isAmount: true,
                  ),
                  _buildAnimatedDivider(),
                  if (widget.bookingDetails.payment_type == 'partial')
                  _buildDetailRow(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Partial Payment',
                    value: '₹${partialAmount.toStringAsFixed(2)}',
                    iconColor: Colors.orange,
                  ),
                  _buildAnimatedDivider(),
                  _buildDetailRow(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Payment Status',
                    value: widget.bookingDetails.payment_type ?? 'N/A',
                    iconColor: Colors.orange,
                  ),
                ],
              ),
            ),

                    // Vendor Details Card with Enhanced Design
            _buildDetailsCard(
              title: 'Vendor Details',
              icon: Icons.store,
              content: Column(
                children: [
                  _buildDetailRow(
                    icon: Icons.business,
                    label: 'Business Name',
                    value: widget.bookingDetails.vendorBusinessName ?? 'N/A',
                    iconColor: Colors.blue[700]!,
                  ),
                  _buildAnimatedDivider(),
                  _buildDetailRow(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: widget.bookingDetails.vendorBusinessAddress ?? 'N/A',
                    iconColor: Colors.red[600]!,
                  ),
                  
                  _buildAnimatedDivider(),
                  _buildDetailRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone Number',
                    value: widget.bookingDetails.vendorPhone ?? 'N/A',
                    iconColor: Colors.green[600]!,
                    isPhone: true,
                    onTap: () {
                      if (widget.bookingDetails.vendorPhone != null) {
                        launch('tel:${widget.bookingDetails.vendorPhone}');
                      }
                    },
                  ),
                  _buildAnimatedDivider(),
                  _buildDetailRow(
                    icon: Icons.phone_android_outlined,
                    label: 'Alternative Phone',
                    value: widget.bookingDetails.vendorAlternativePhone ?? 'N/A',
                    iconColor: Colors.green[600]!,
                    isPhone: true,
                    onTap: () {
                      if (widget.bookingDetails.vendorAlternativePhone != null) {
                        launch('tel:${widget.bookingDetails.vendorAlternativePhone}');
                      }
                    },
                  ),
                ],
              ),
            ),

                    // Pickup Location Card with Enhanced Design
            _buildDetailsCard(
              title: 'Pickup Location',
              icon: Icons.location_on,
              content: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                  children: [
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.location_on, color: primaryColor, size: 24.sp),
                                ),
                    SizedBox(width: 12.w),
                    Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pickup Address',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12.sp,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                        widget.bookingDetails.pickupAddress ?? 'N/A',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.black87,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            OutlinedButton.icon(
                              onPressed: () {
                                launchGoogleMaps(widget.bookingDetails.pickupAddress);
                              },
                              icon: Icon(Icons.directions, size: 18.sp),
                              label: Text('Get Directions'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryColor,
                                side: BorderSide(color: primaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

                    // Action Buttons with Enhanced Design
            Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          if (widget.bookingDetails.status?.toLowerCase() == 'pending')
                            Container(
                              width: double.infinity,
                              height: 50.h,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.cancel_outlined),
                                label: Text(
                                  'Cancel Booking',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[400],
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
            // if (widget.bookingDetails.payment_type == 'partial')
            //                 Column(
            //                   children: [
            //                     SizedBox(height: 12.h),
            //                     Container(
            //                       width: double.infinity,
            //                       height: 50.h,
            //                       child: ElevatedButton.icon(
            //                         onPressed: () {
            //                           calculateAmount();
            //                           _makePayment();
            //                         },
            //                         icon: Icon(Icons.payment),
            //                         label: Text(
            //                           'Make Full Payment',
            //                           style: GoogleFonts.poppins(
            //                             fontSize: 16.sp,
            //                             fontWeight: FontWeight.w600,
            //                           ),
            //                         ),
            //                         style: ElevatedButton.styleFrom(
            //                           backgroundColor: primaryColor,
            //                           foregroundColor: Colors.white,
            //                           shape: RoundedRectangleBorder(
            //                             borderRadius: BorderRadius.circular(12.r),
            //                           ),
            //                           elevation: 0,
            //                         ),
            //                       ),
            //                     ),
            //                     SizedBox(height: 8.h),
            //                     Row(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                         Icon(
            //                           Icons.info_outline,
            //                           size: 14.sp,
            //                           color: Colors.grey[600],
            //                         ),
            //                         SizedBox(width: 4.w),
            //                         Text(
            //                           'Make full payment for hassle free pickup',
            //                           style: GoogleFonts.poppins(
            //                             fontSize: 12.sp,
            //                             color: Colors.grey[600],
            //                             fontStyle: FontStyle.italic,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ],
            //                 ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                  // Review Card
                  _buildDetailsCard(
                    title: 'Rate & Review',
                    icon: Icons.star_outline,
                    content: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Share your experience',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          // Rating Bar
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 30.w,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (value) {
                              rating = value.toInt();
                            },
                          ),
                          SizedBox(height: 16.h),
                          // Review Text Field
                          TextFormField(
                            maxLines: 3,
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: 'Write your review here...',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: Colors.grey[400],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: Colors.grey[200]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: Colors.grey[200]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.all(16.w),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Submit Button
                          Container(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                print('rating: $rating');
                                final userId = await userPreferences.getUserId();
                                final result = await context.read<ReviewCubit>().submitReview(ReviewEntity(
                                  userId: userId ?? '',
                                  vehicleId:  widget.bookingDetails.vehicleId?? '',
                                  rating: rating,
                                  comment: commentController.text,
                                  createdAt: DateTime.now(),
                                ));
                                showToast(result ? 'Review submitted successfully' : 'Failed to submit review' , isSuccess: result);
                                // Handle review submission
                              },
                              icon: Icon(Icons.send_rounded),
                              label: Text(
                                'Submit Review',
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 0,
                              ),
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
          ],
        ),
      ),
      bottomNavigationBar: (widget.bookingDetails.payment_type == 'partial' && 
                            (
                             widget.bookingDetails.status == 'Confirmed'))
          ? Container(
              padding: EdgeInsets.all(16.w),
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
              child: ElevatedButton(
                onPressed: () {
                  calculateAmount();
                  _makePayment();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Make Full Payment',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildStatusRow(String label, String value, {bool isOtp = false, bool isStatus = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
              color: Colors.black45,
            fontSize: 14.sp,
          ),
        ),
        if (isOtp || isStatus)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: isOtp ? 18.sp : 14.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: isOtp ? 3 : 0,
              ),
            ),
          )
        else
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
      ),
    );
  }

  Widget _buildDetailsCard({required String title, required Widget content, required IconData icon}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: primaryColor, size: 24.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          content,
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    bool isPhone = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16.r),
        ),
      child: Row(
        children: [
            // Icon Container
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: iconColor.withOpacity(0.15),
                  width: 1,
                ),
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 16.w),
            
            // Content
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                            color: isPhone ? primaryColor : Colors.black87,
                            fontWeight: isPhone ? FontWeight.w600 : FontWeight.w500,
                            decoration: isPhone ? TextDecoration.underline : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isPhone && onTap != null)
                        Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Icon(
                            Icons.call,
                            color: Colors.green[600],
                            size: 20.sp,
                          ),
                        ),
                    ],
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDivider({bool isWhite = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      height: 1,
      color: isWhite ? Colors.white.withOpacity(0.15) : Colors.grey[200],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            status.toUpperCase(),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

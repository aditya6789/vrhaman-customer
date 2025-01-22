import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vrhaman/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
          style: bigTextStyle.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header Section with Gradient
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How can we help you?',
                    style: bigTextStyle.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "We're here to help you with any questions or concerns you may have about our services.",
                    style: smallTextStyle.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Contact Cards Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Us',
                    style: mediumTextStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Customer Support Card
                  _buildContactCard(
                    icon: Icons.headset_mic_rounded,
                    title: 'Customer Support',
                    subtitle: '24/7 Dedicated Support',
                    actionTitle: '9910213793',
                    onTap: () => _launchPhone('9910213793'),
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Email Support Card
                  _buildContactCard(
                    icon: Icons.email_rounded,
                    title: 'Email Support',
                    subtitle: 'Response within 24 hours',
                    actionTitle: 'info@vrhaman.com',
                    onTap: () => _launchEmail('info@vrhaman.com'),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.blue.withOpacity(0.8),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // FAQ Section
                  Text(
                    'Frequently Asked Questions',
                    style: mediumTextStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildFaqItem(
                    'How do I book a vehicle?',
                    'You can easily book a vehicle through our app by selecting your desired vehicle, choosing the dates, and completing the payment process.',
                  ),
                  _buildFaqItem(
                    'What documents do I need?',
                    'You\'ll need a valid driver\'s license, proof of identity, and a credit card for security deposit.',
                  ),
                  _buildFaqItem(
                    'What is the cancellation policy?',
                    'Free cancellation up to 24 hours before your booking starts. Cancellations within 24 hours may incur charges.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionTitle,
    required VoidCallback onTap,
    required Gradient gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: mediumTextStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: smallTextStyle.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        actionTitle,
                        style: mediumTextStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: mediumTextStyle.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
            child: Text(
              answer,
              style: smallTextStyle.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _launchEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
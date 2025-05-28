import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/auth/presentation/bloc/login_cubit.dart';
import 'package:vrhaman/src/features/auth/presentation/bloc/resend_cubit.dart';
import 'package:vrhaman/src/features/auth/presentation/pages/login_screen.dart';
import 'package:vrhaman/src/features/home/presentation/pages/bottom_navigation_bar.dart';
// import 'package:vrhaman/src/features/auth/login/cubit/login_cubit.dart';
import 'package:vrhaman/src/features/home/presentation/pages/home_screen.dart';
import 'package:vrhaman/src/features/auth/presentation/bloc/otp_cubit.dart';
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:vrhaman/src/utils/toast.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _otplessFlutterPlugin = Otpless();
  String otp = '';
  bool isButtonEnabled = false;
  int secondsRemaining = 120;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                // Header Section
                Text(
                  'Verification Code',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Code sent to ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showAlertDialog(context, ""),
                      child: Row(
                        children: [
                          Text(
                            '+91 ${context.read<LoginCubit>().phoneController.text}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFA726),
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.edit,
                            size: 16,
                            color: Color(0xFFFFA726),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                // OTP Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    cursorColor: Color(0xFFFFA726),
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12),
                      fieldHeight: 56,
                      fieldWidth: 44,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.grey[50],
                      selectedFillColor: Colors.white,
                      activeColor: Color(0xFFFFA726),
                      inactiveColor: Colors.grey[300],
                      selectedColor: Color(0xFFFFA726),
                      borderWidth: 1.5,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: true,
                    onChanged: (value) {
                      setState(() {
                        otp = value;
                      });
                    },
                    beforeTextPaste: (text) => true,
                  ),
                ),
                SizedBox(height: 24),
                // Timer and Resend
                Center(
                  child: Column(
                    children: [
                      if (!isButtonEnabled)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.timer_outlined, 
                                size: 18, 
                                color: Colors.grey[600]
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Resend code in ${secondsRemaining}s',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (isButtonEnabled)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isButtonEnabled = false;
                              secondsRemaining = 30;
                              startTimer();
                            });
                               context.read<LoginCubit>().sendOtp(context.read<LoginCubit>().phoneController.text);
                                    showToast('Resend OTP sent on whatsapp successfully', isSuccess: true);
                          },
                          child: Text(
                            'Resend Code',
                            style: TextStyle(
                              color: Color(0xFFFFA726),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                // Verify Button
                BlocConsumer<OtpCubit, OtpState>(
                  listener: (context, state) {
                    if (state is OtpValidationSuccess ||
                        state is OtpValidationSuccessNewUser) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CustomNavigationBar()),
                      );
                    } else if (state is OtpValidationFailure) {
                      showToast(state.error , isSuccess: false);
                    }
                  },
                  builder: (context, state) {
                    return Container(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<OtpCubit>().validateOtp(context, otp);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFA726),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: state is OtpLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Verify',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context, String message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Change Phone Number?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Are you sure you want to change your phone number?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '+91 ${context.read<LoginCubit>().phoneController.text}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFFA726),
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Color(0xFFFFA726)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFFFFA726),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFA726),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Change',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
  }

  void startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
        startTimer(); // Continue the timer
      } else {
        setState(() {
          isButtonEnabled = true;
        });
      }
    });
  }
}

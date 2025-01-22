import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/common/custom_text_formfield.dart';
import 'package:vrhaman/src/features/auth/presentation/pages/verification_screen.dart';
import 'package:vrhaman/src/features/auth/presentation/bloc/login_cubit.dart';
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:flutter/services.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _errorMessage;

  @override
  void initState() {
   
    super.initState();
  }



  void _validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      setState(() {
        _errorMessage = 'Phone number cannot be empty';
      });
    } else if (phoneNumber.length < 10) {
      setState(() {
        _errorMessage = 'Phone number must be at least 10 digits';
      });
    } else {
      setState(() {
        _errorMessage = null;
      });
      context.read<LoginCubit>().sendOtp(phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                // Animated Logo
                TweenAnimationBuilder<double>(
                  duration: Duration(seconds: 1),
                  tween: Tween(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Hero(
                        tag: 'logo',
                        child: Image.asset(
                          'assets/images/logo_yellow.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 50),
                // Welcome Text with Slide Animation
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(-0.5, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: ModalRoute.of(context)!.animation!,
                    curve: Curves.easeOut,
                  )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ready to explore rental bikes and cars?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                // Phone Input Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '🇮🇳',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '+91',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: context.read<LoginCubit>().phoneController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter mobile number',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                            ),
                            errorText: _errorMessage,
                            errorStyle: TextStyle(
                              color: Colors.red.shade400,
                              fontSize: 12,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            if (_errorMessage != null) {
                              setState(() {
                                _errorMessage = null;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // Terms Container
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildCheckboxRow(
                        'I agree to the Terms & Conditions and Privacy Policy',
                        true,
                        (value) {},
                        isFirst: true,
                      ),
                      Divider(height: 20, thickness: 1),
                      _buildCheckboxRow(
                        'Receive updates on WhatsApp',
                        true,
                        (value) {},
                        isFirst: false,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                // Continue Button
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      print(state.message);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('OTP sent successfully! ${state.message}')),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerificationScreen()),
                      );
                    } else if (state is LoginFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Container(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          _validatePhoneNumber(
                            context.read<LoginCubit>().phoneController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFA726),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: state is LoginLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Continue',
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
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxRow(
    String text, 
    bool value, 
    Function(bool?) onChanged, 
    {bool isFirst = false}
  ) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            activeColor: Color(0xFFFFA726),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isFirst ? Colors.black87 : Colors.black54,
              fontWeight: isFirst ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/common/custom_text_formfield.dart';
import 'package:vrhaman/src/core/cubit/user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrhaman/src/core/entities/user.dart';
import 'package:vrhaman/src/utils/user_prefences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountInformationEditScreen extends StatefulWidget {
  const AccountInformationEditScreen({super.key});

  @override
  State<AccountInformationEditScreen> createState() =>
      _AccountInformationEditScreenState();
}

class _AccountInformationEditScreenState
    extends State<AccountInformationEditScreen> {

        XFile? _imageFile;

  Future<void> _pickImage() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        _imageFile = image;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera permission is required to upload a document.')),
      );
    }
  }

  final UserPreferences userPreferences = UserPreferences();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await userPreferences.getUserData();
    setState(() {
      userData = data;
    });
    print(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('Personal Information'),
          ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: userData == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: bigTextStyle,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryColor.withOpacity(0.2),
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60.w),
                            child: _imageFile != null
                                ? Image.file(
                                    File(_imageFile!.path),
                                    fit: BoxFit.cover,
                                  )
                                : userData?['profile_picture'] != null &&
                                        userData!['profile_picture'].isNotEmpty
                                    ? Image.network(
                                        userData!['profile_picture'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return _buildDefaultAvatar();
                                        },
                                      )
                                    : _buildDefaultAvatar(),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    CustomTextFormField(
                      hintText: userData?['name'] ?? 'John Doe',
                      controller: context.read<UserCubit>().nameController,
                      label: 'Name',
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    CustomTextFormField(
                      hintText: userData?['email'] ?? 'jondoe@gmail.com',
                      controller: context.read<UserCubit>().emailController,
                      label: 'Email',
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    CustomTextFormField(
                      hintText: userData?['phone'] ?? '+91 9876543210',
                      controller: context.read<UserCubit>().phoneController,
                      label: 'Phone',
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    DropdownButtonFormField<String>(
  value: (userData?['gender'] != null && 
          ['Male', 'Female', 'Transgender', 'Other'].contains(userData!['gender'] ?? ''))
      ? userData!['gender']
      : 'Male',
  decoration: InputDecoration(
    labelText: 'Gender',
    hintText: 'Select Gender',
    border: OutlineInputBorder(),
  ),
  items: [
    DropdownMenuItem(value: 'Male', child: Text('Male')),
    DropdownMenuItem(value: 'Female', child: Text('Female')),
    DropdownMenuItem(value: 'Transgender', child: Text('Transgender')),
    DropdownMenuItem(value: 'Other', child: Text('Other')),
  ],
  onChanged: (value) {
    context.read<UserCubit>().genderController.text = value ?? userData!['gender'];
  },
),

                    SizedBox(
                      height: 16.h,
                    ),
                    const Spacer(),
                    BlocConsumer<UserCubit, UserState>(
                      listener: (context, state) {
                        if (state is UserLoaded) {
                          Navigator.pop(context);
                        }
                      },
                      builder: (context, state) {
                        return Container(
                          width: double.infinity,
                          height: 56.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            gradient: LinearGradient(
                              colors: [
                                primaryColor,
                                primaryColor.withOpacity(0.8),
                              ],
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
                            onPressed: state is UserLoading 
                                ? null 
                                : () {
                                    final userCubit = context.read<UserCubit>();
                                    final user = User(
                                      name: userCubit.nameController.text.isNotEmpty
                                          ? userCubit.nameController.text
                                          : userData!['name'],
                                      email: userCubit.emailController.text.isNotEmpty
                                          ? userCubit.emailController.text
                                          : userData!['email'],
                                      phone: userCubit.phoneController.text.isNotEmpty
                                          ? userCubit.phoneController.text
                                          : userData!['phone'],
                                      gender: userCubit.genderController.text.isNotEmpty
                                          ? userCubit.genderController.text
                                          : userData!['gender'],
                                      profile_picture: _imageFile?.path ?? userData?['profile_picture'] ?? '',
                                    );
                                    userCubit.getUserData(user);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: state is UserLoading
                                ? SizedBox(
                                    height: 20.h,
                                    width: 20.h,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.save_outlined, color: Colors.white, size: 20.sp),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Save Changes',
                                        style: mediumTextStyle.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[100],
      child: Icon(
        Icons.person,
        size: 50.sp,
        color: Colors.grey[400],
      ),
    );
  }
}

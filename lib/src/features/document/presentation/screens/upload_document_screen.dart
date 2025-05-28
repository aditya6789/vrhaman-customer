import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vrhaman/src/features/document/domain/entities/documentData.dart';
import 'package:vrhaman/src/features/document/presentation/cubit/document_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrhaman/src/features/document/presentation/screens/document_screen.dart';
import 'package:vrhaman/src/features/home/presentation/pages/bottom_navigation_bar.dart';
import 'package:vrhaman/src/features/home/presentation/pages/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vrhaman/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:vrhaman/src/utils/toast.dart';

class UploadDocumentScreen extends StatefulWidget {
  final bool isEditing;
  final String? currentDocument;

  const UploadDocumentScreen({
    super.key, 
    this.isEditing = false,
    this.currentDocument,
  });

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  XFile? _imageFile;
  bool get hasImage => _imageFile != null || widget.currentDocument != null;

  Future<void> _pickImage() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      print('image picker file: ${image}');
      setState(() {
        _imageFile = image;
      });
    } else {
      showToast('Camera permission is required to upload a document.' , isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DocumentCubit, DocumentState>(
      listener: (context, state) {
        if (state is DocumentUploaded) {
          showToast(
            widget.isEditing ? 'Document updated successfully' : 'Document uploaded successfully',
            isSuccess: true
          );
          if (widget.isEditing) {
            Navigator.pop(context); // Return to document screen
          } else {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(
                builder: (context) => CustomNavigationBar(initialIndex: 3,)
              )
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.sp),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withOpacity(0.1),
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isEditing ? 'Update Your Document' : 'Upload Your Document',
                          style: bigTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          widget.isEditing
                              ? 'Update your document with a clear photo to maintain verification status.'
                              : 'Please upload clear photos of your required documents to complete the verification process.',
                          style: smallTextStyle.copyWith(
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Document Upload Section
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 300.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                      child: !hasImage
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.document_scanner_outlined,
                                    size: 40.sp,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'Tap to Upload Document',
                                  style: mediumTextStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Supported formats: JPG, PNG, PDF',
                                  style: smallTextStyle.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(24.r),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  _imageFile != null
                                      ? Image.file(
                                          File(_imageFile!.path),
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          widget.currentDocument!,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.white,
                                        size: 40.sp,
                                      ),
                                      SizedBox(height: 12.h),
                                      Text(
                                        widget.isEditing ? 'Current Document' : 'Document Uploaded',
                                        style: mediumTextStyle.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        widget.isEditing ? 'Tap to update' : 'Tap to change',
                                        style: smallTextStyle.copyWith(
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: _imageFile == null && !widget.isEditing ? null : () {
                        if (_imageFile != null) {
                          final file = File(_imageFile!.path);
                          if (widget.isEditing) {
                            context.read<DocumentCubit>().updateDocument(
                              DocumentData(image: file),
                            );
                          } else {
                            context.read<DocumentCubit>().uploadDocument(
                              DocumentData(image: file),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        widget.isEditing ? 'Update Document' : 'Submit Document',
                        style: mediumTextStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
                
              ),
            ),
          ),
        ),
      ),
    );
  }
}

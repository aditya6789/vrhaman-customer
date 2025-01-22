import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/document/presentation/screens/upload_document_screen.dart';
import 'package:vrhaman/src/utils/api_response.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  List? document;

  @override
  void initState() {
    checkdocumentRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Documents',
          style: bigTextStyle.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: document == null
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 3,
              ),
            )
          : SingleChildScrollView(
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
                            'Verified Documents',
                            style: bigTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Your documents have been verified and are securely stored.',
                            style: smallTextStyle.copyWith(
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Document Preview Section
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Document Image
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24.r),
                            ),
                            child: Image.network(
                              '${IMAGE_URL2}${document![0]['document']}',
                              height: 300.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 300.h,
                                  color: Colors.grey[100],
                                  child: Center(
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Colors.grey[400],
                                      size: 40.sp,
                                    ),
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 300.h,
                                  color: Colors.grey[100],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Document Info
                          Padding(
                            padding: EdgeInsets.all(24.w),
                            child: Column(
                              children: [
                                // Verification Status
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified_user,
                                        color: Colors.green,
                                        size: 24.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Verified Document',
                                        style: mediumTextStyle.copyWith(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16.h),

                                // Security Message
                                Text(
                                  'Your document is securely stored and will only be used for verification purposes.',
                                  textAlign: TextAlign.center,
                                  style: smallTextStyle.copyWith(
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Update Document Button
                   
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> checkdocumentRequest() async {
    try {
      final response = await getRequest('document');
      if (response.statusCode == 200) {
        setState(() {
          document = response.data['data'];
        });
      }
    } catch (e) {
      print('Error fetching documents: $e');
    }
  }
}

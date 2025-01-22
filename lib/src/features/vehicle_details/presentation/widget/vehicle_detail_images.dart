import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/vehicle_details/domain/entities/vehicleDetails.dart';
import 'image_preview_screen.dart';

class VehicleDetailImages extends StatelessWidget {
  final VehicleDetails vehicleModel;
  const VehicleDetailImages({super.key, required this.vehicleModel});

  void _openImagePreview(BuildContext context, List<String> images, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePreviewScreen(
          imageUrls: images,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = (vehicleModel.images?.isNotEmpty ?? false)
        ? vehicleModel.images.map((i) => '$IMAGE_URL$i').toList()
        : ['https://images.pexels.com/photos/819805/pexels-photo-819805.jpeg'];

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.grey[100],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Row(
            children: [
              // Main large image
              Expanded(
                flex: 7,
                child: _buildMainImage(context, images, 0),
              ),
              SizedBox(width: 1.w),
              // Right side small images
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: _buildSmallImage(context, images, 1),
                    ),
                    SizedBox(height: 1.h),
                    Expanded(
                      child: Stack(
                        children: [
                          _buildSmallImage(context, images, 2),
                          if (images.length > 3)
                            _buildMorePhotosOverlay(context, images, images.length - 3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainImage(BuildContext context, List<String> images, int index) {
    return Hero(
      tag: 'image_$index',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openImagePreview(context, images, index),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
                    );
                  },
                ),
                // Premium badge
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Premium',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildSmallImage(BuildContext context, List<String> images, int index) {
    if (index >= images.length) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
        
      );
    }
    return Hero(
      tag: 'image_$index',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openImagePreview(context, images, index),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMorePhotosOverlay(BuildContext context, List<String> images, int remaining) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openImagePreview(context, images, 2),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.photo_library_rounded,
                  color: Colors.white,
                  size: 24.sp,
                ),
                SizedBox(height: 4.h),
                Text(
                  '+$remaining',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
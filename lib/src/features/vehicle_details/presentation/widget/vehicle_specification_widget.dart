import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/vehicle_details/domain/entities/vehicleDetails.dart';

class VehicleSpecificationWidget extends StatelessWidget {
  final VehicleDetails vehicleModel;
  const VehicleSpecificationWidget({super.key, required this.vehicleModel});

  Widget _buildSpecItem(String label, String value, IconData icon) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0.8, end: 1.0),
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryColor.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: primaryColor, size: 28),
                const SizedBox(height: 12),
                Text(
                  value,
                  style: extraSmallTextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                // const SizedBox(height: 6),
                Text(
                  label,
                  style: extraSmallTextStyle.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildSpecItem(
                    'Engine', '${vehicleModel.engineCc} cc', Icons.engineering),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSpecItem(
                    'HP', '${vehicleModel.horsepower} HP', Icons.speed),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSpecItem(
                    'Torque', '${vehicleModel.torque} Nm', Icons.rotate_right),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildSpecItem('Mileage', '${vehicleModel.mileage} kmpl',
                    Icons.local_gas_station),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSpecItem(
                    'Top Speed', '${vehicleModel.topSpeed} km/h', Icons.speed),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSpecItem(
                    'Weight', '${vehicleModel.weight} kg', Icons.line_weight),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Row(
          //   children: [
          //     Expanded(
          //       child: _buildSpecItem(
          //           'Top Speed', '${vehicleModel.topSpeed} km/h', Icons.speed),
          //     ),
          //     const Spacer(flex: 2),
          //   ],
          // ),
        ],
      ),
    );
  }
}

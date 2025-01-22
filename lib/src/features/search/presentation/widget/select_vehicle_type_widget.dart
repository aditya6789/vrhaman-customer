import 'package:flutter/material.dart';
import 'package:vrhaman/constants.dart';
class SelectVehicle extends StatelessWidget {
  final String vehicleType;
  final ValueChanged<bool> onSelected;
  const SelectVehicle(
      {super.key, required this.onSelected, required this.vehicleType});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        vehicleType,
        style: smallTextStyle,
      ),
      backgroundColor: Colors.white,
      selectedColor: primaryColor,
      elevation: 0,
      labelStyle: TextStyle(
          color: vehicleType == vehicleType ? Colors.white : Colors.black),
      shape: StadiumBorder(
        side: BorderSide(
          color:
              vehicleType == vehicleType ? Colors.transparent : Colors.grey,
        ),
      ),
      selected: vehicleType == vehicleType,
      onSelected: onSelected,
      // onSelected: (value) {
      //   setState(() {
      //     selectedVehicleType = value ? 'Bike' : null;
      //   });
      // },
    );
  }
}


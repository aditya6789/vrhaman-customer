import 'package:flutter/material.dart';
import 'package:vrhaman/constants.dart';
  Widget buildSettingsOption(IconData icon, String title, {String? trailing, VoidCallback? onTap}) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: smallTextStyle,),
        trailing: trailing != null ? Text(trailing, style: TextStyle(color: Colors.grey)) : Icon(Icons.arrow_forward_ios, color: Colors.grey),
      ),
    );
  }


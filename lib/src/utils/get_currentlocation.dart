 import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> getCurrentLocation() async {
    // Request location permission at runtime
    var permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      // Check for Geolocator permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied.');
        } else if (permission == LocationPermission.deniedForever) {
          return Future.error('Location permissions are permanently denied.');
        }
      }

      // Get the current location if permissions are granted
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);


      return  placemarks[0].locality.toString();

          

      // setState(() {
      //   cityName = placemarks[0].locality ?? 'Unknown location';
      // });
    } else {
      // Handle permission denial
      return Future.error('Location permissions denied.');
    }
  }
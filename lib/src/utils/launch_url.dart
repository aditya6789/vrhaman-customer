
import 'package:url_launcher/url_launcher.dart';

Future<void> launchGoogleMaps(String address) async {
  final encodedAddress = Uri.encodeComponent(address);
  final url = 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
  
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch Google Maps';
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<void> sendSOS() async {
    Position pos = await Geolocator.getCurrentPosition();
    await FirebaseFirestore.instance.collection('sos').add({
      'lat': pos.latitude,
      'lng': pos.longitude,
      'location': '${pos.latitude}, ${pos.longitude}',
      'time': DateTime.now(),
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class SosService {
  static Future<void> sendSOS() async {
    try {
      print("🟡 SOS button pressed");

      // 🔐 Get logged-in user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }
      print("✅ User: ${user.phoneNumber}");

      // 📍 Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      print("📍 Permission status: $permission");

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        print("📍 Permission requested: $permission");
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permission permanently denied");
      }

      // 📍 Get location (SAFE METHOD with fallback)
      Position position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        print(
            "📍 Current position: ${position.latitude}, ${position.longitude}");
      } catch (e) {
        print("⚠️ Failed to get current position, using last known position");
        final lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition == null) {
          throw Exception("Unable to fetch location");
        }
        position = lastPosition;
        print(
            "📍 Last known position: ${position.latitude}, ${position.longitude}");
      }

      // 🔥 Save SOS to Firestore
      await FirebaseFirestore.instance.collection('sos_alerts').add({
        'uid': user.uid,
        'phone': user.phoneNumber,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'NEW',
      });

      print("🔥 SOS successfully saved to Firestore");
    } catch (e) {
      print("❌ SOS ERROR: $e");
      rethrow;
    }
  }
}

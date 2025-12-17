import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<void> saveProfile({
    required String aadhaar,
    required String name,
    required String age,
    required String address,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    await _firestore.collection('users').doc(user.uid).set({
      'aadhaar': aadhaar,
      'name': name,
      'age': age,
      'address': address,
      'phone': user.phoneNumber,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<bool> profileExists() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final doc =
        await _firestore.collection('users').doc(user.uid).get();
    return doc.exists;
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_service.dart';
import '../../services/user_profile_service.dart';

// Screens
import '../user/profile_screen.dart';
import '../user/user_dashboard.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String verificationId;

  const OtpVerifyScreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final TextEditingController _otpController = TextEditingController();
  final AuthService _authService = AuthService();

  bool loading = false;

  Future<void> verifyOTP() async {
    setState(() => loading = true);

    try {
      // 🔐 Verify OTP & sign in
      await _authService.signInWithOTP(
        verificationId: widget.verificationId,
        smsCode: _otpController.text.trim(),
      );

      // 🔍 Check if profile already exists
      bool profileExists =
          await UserProfileService.profileExists();

      if (!mounted) return;

      if (profileExists) {
        // ➡️ Go to Dashboard
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const UserDashboard(),
          ),
          (_) => false,
        );
      } else {
        // ➡️ Go to Profile creation screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfileScreen(),
          ),
          (_) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Invalid OTP"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Enter OTP",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "6-digit OTP",
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: loading ? null : verifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      "Verify & Continue",
                      style: TextStyle(fontSize: 18),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

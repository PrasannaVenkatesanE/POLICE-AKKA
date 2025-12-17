
import 'package:flutter/material.dart';
import 'user_dashboard.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Enter OTP')),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Verify'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const UserDashboard()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

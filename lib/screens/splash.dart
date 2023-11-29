import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color here
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo goes here
            Image.asset('assets/images/qismat-logo.png',
                width: 100, height: 100),
            const SizedBox(height: 16),
            const Text('Your App Name', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qismat/screens/auth/auth.dart';
import 'package:qismat/screens/auth/auth_navigator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Add a delay before navigating
    Timer(
      const Duration(seconds: 2), // Adjust the duration as needed
      () {
        navigateToNextScreen();
      },
    );
  }

  void navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FirebaseAuth.instance.currentUser != null
            ? AuthNavigator()
            : const AuthScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/qismat-logo.png',
                width: 300, height: 300),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

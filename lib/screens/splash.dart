import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qismat/screens/auth.dart';
import 'package:qismat/screens/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Add a delay and then navigate to AuthOrDashboardScreen
    Timer(
      Duration(seconds: 2), // Adjust the duration as needed
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  // User is signed in, show the dashboard or home screen
                  return const DashboardScreen();
                } else {
                  // User is not signed in, show the authentication screen
                  return const AuthScreen();
                }
              },
            ),
          ),
        );
      },
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

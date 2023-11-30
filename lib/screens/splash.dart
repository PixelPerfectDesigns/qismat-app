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
      Duration(seconds: 2), // Adjust the duration as needed
      () {
        navigateToNextScreen();
      },
    );
  }

  void navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AuthOrDashboardScreen(),
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

class AuthOrDashboardScreen extends StatelessWidget {
  const AuthOrDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return AuthNavigator();
        } else {
          // User is not signed in, show the authentication screen
          return const AuthScreen();
        }
      },
    );
  }
}

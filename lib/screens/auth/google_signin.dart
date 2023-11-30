import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qismat/screens/auth/auth_navigator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleSignInButton extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        // User successfully signed in with Google
        // Navigate using AuthNavigator widget
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AuthNavigator(),
          ),
        );
      } else {
        // Handle sign-in failure
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(color: Color(0xFFFF5858), width: 2.0), // Border style
        borderRadius: BorderRadius.circular(30), // Border radius
      ),
      padding: const EdgeInsets.symmetric(
          vertical: 5.0, horizontal: 13), // Adjust padding as needed
      child: ElevatedButton.icon(
        onPressed: () async {
          await _handleGoogleSignIn(context);
        },
        icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
        label: Text("Sign In with Google"),
        style: ElevatedButton.styleFrom(
          primary: Colors.white, // Background color
          onPrimary: Colors.black, // Foreground (text) color
          elevation: 0, // Remove elevation
        ),
      ),
    );
  }
}

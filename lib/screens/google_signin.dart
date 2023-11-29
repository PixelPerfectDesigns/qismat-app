import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qismat/screens/dashboard.dart';
import 'package:qismat/screens/profile_questions.dart';
import 'package:qismat/screens/profile_setup.dart';
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
        print("Google Sign-In Successful: ${user.displayName}");

        // Check the profile setup status
        bool isProfileSetupComplete = await checkProfileSetupStatus(user.uid);

        if (isProfileSetupComplete) {
          // Profile setup is complete, navigate to the Dashboard screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(),
            ),
          );
        } else {
          // Profile setup is not complete, navigate to the Profile Questions screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileQuestionsScreen(),
            ),
          );
        }
      } else {
        // Handle sign-in failure
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(color: Color(0xFFFF5858), width: 2.0), // Border style
        borderRadius: BorderRadius.circular(30), // Border radius
      ),
      padding: EdgeInsets.symmetric(
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

  // @override
  // Widget build(BuildContext context) {
  //   return ElevatedButton(
  //     onPressed: () async {
  //       await _handleGoogleSignIn(context);
  //     },
  //     icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
  //     label: Text("Sign In with Google"),
  //     style: ElevatedButton.styleFrom(
  //       primary: Colors.white,
  //       onPrimary: Colors.black,
  //       elevation: 3,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     ),
  //   );
  // }

  // Future<bool> checkProfileSetupStatus(String userUid) async {
  //   try {
  //     // Reference to the user's Firestore document
  //     DocumentReference userDocRef =
  //         FirebaseFirestore.instance.collection('users').doc(userUid);

  //     // Get the user's document using await
  //     DocumentSnapshot userSnapshot = await userDocRef.get();

  //     // Check if the document exists and if profile setup is complete
  //     // Check if the document exists and if profile setup is complete

  //     if (userSnapshot.exists) {
  //       final Map<String, dynamic> userData =
  //           userSnapshot.data() as Map<String, dynamic>;
  //       final bool isProfileSetupComplete =
  //           userData['isProfileSetupComplete'] as bool;
  //       return isProfileSetupComplete;
  //     }

  //     // If the user document doesn't exist, consider the setup as incomplete
  //     return false;
  //   } catch (e) {
  //     // Handle any errors, such as Firestore exceptions
  //     print("Error checking profile setup status: $e");
  //     return false; // Handle the error as needed in your application
  //   }
  // }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:qismat/screens/dashboard.dart';
import 'package:qismat/screens/profilequestions2.dart';
import 'package:qismat/screens/profile_setup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FacebookSignInButton extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookAuth facebookAuth = FacebookAuth.instance;

  Future<void> _handleFacebookSignIn(BuildContext context) async {
    try {
      final LoginResult result = await facebookAuth.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          // User successfully signed in with Facebook
          print("Facebook Sign-In Successful: ${user.displayName}");

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
        }
      } else {
        // Handle login failure
        print("Facebook Sign-In Failed: ${result.message}");
      }
    } catch (error) {
      print("Facebook Sign-In Error: $error");
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
      padding: EdgeInsets.all(5.0), // Adjust padding as needed
      child: ElevatedButton.icon(
        onPressed: () async {
          await _handleFacebookSignIn(context);
        },
        icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
        label: Text("Sign In with Facebook"),
        style: ElevatedButton.styleFrom(
          primary: Colors.white, // Background color
          onPrimary: Colors.black, // Foreground (text) color
          elevation: 0, // Remove elevation
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qismat/screens/dashboard.dart';
import 'package:qismat/screens/profile_setup/profile_questions.dart';

class AuthNavigator extends StatefulWidget {
  @override
  _AuthNavigatorState createState() => _AuthNavigatorState();
}

class _AuthNavigatorState extends State<AuthNavigator> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        bool isProfileSetupComplete = await checkProfileSetupStatus(user.uid);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isProfileSetupComplete) {
            // Profile setup is complete, navigate to the Dashboard screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardScreen(),
              ),
            );
          } else {
            // Profile setup is not complete, navigate to the Profile Questions screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileQuestionsScreen(),
              ),
            );
          }
        });
      } catch (e) {
        print("Error checking profile setup status: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can return a loading indicator or any other widget if needed
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFF5858),
        ),
      ),
    );
  }
}

Future<bool> checkProfileSetupStatus(String userUid) async {
  try {
    // Reference to the user's Firestore document
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('settings')
        .doc('general');

    // Get the user's document using await
    DocumentSnapshot userSnapshot = await userDocRef.get();

    // Check if the document exists and if profile setup is complete
    // Check if the document exists and if profile setup is complete

    if (userSnapshot.exists) {
      final Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      final bool isProfileSetupComplete =
          userData['isProfileSetupComplete'] as bool;
      return isProfileSetupComplete;
    }

    // If the user document doesn't exist, consider the setup as incomplete
    return false;
  } catch (e) {
    // Handle any errors, such as Firestore exceptions
    print("Error checking profile setup status: $e");
    return false; // Handle the error as needed in your application
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkProfileSetupStatus(String userUid) async {
  try {
    // Reference to the user's Firestore document
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userUid);

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

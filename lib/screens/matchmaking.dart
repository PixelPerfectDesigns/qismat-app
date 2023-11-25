import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> retrieveUserResponsesFromFirestore() async {
  String userUid = "";
  // Example usage:
  User? user = getCurrentUser();
  if (user != null) {
    userUid = user.uid;
  } else {
    print('No user is currently logged in.');
  }

  final collectionId = 'user_info'; // Define your Firestore collection name

  List<Map<String, dynamic>> userResponses = [];
  try {
    DocumentReference userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('user_info')
        .doc("profile");

    String? userGender = await getUserGender(userUid, userDoc);

    if (userGender != null) {
      String oppositeGender = (userGender == 'male') ? 'female' : 'male';
      List<Map<String, dynamic>> oppositeGenderProfiles =
          await retrieveOppositeGenderProfile(userUid, userGender);
      // filterMatches(oppositeGenderProfiles);

      // Now you can use the userGender variable outside the function
    } else {}
  } catch (e) {
    print('Error retrieving user responses: $e');
    throw e; // You can throw an error or handle it as needed
  }
}

User? getCurrentUser() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user;
  } else {
    return null; // No user is currently logged in
  }
}

Future<String?> getUserGender(String userId, DocumentReference userDoc) async {
  try {
    DocumentSnapshot documentSnapshot = await userDoc.get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> userProfile =
          documentSnapshot.data() as Map<String, dynamic>;

      if (userProfile.containsKey("gender")) {
        String userGender = userProfile["gender"];
        print('User with ID $userId has gender: $userGender');
        return userGender;
      } else {
        print('Gender information not found for user with ID $userId.');
      }
    } else {
      print('Document not found for user with ID $userId.');
    }
  } catch (error) {
    print('Error: $error');
  }

  return null; // Return null in case of an error or missing data
}

Future<List<Map<String, dynamic>>> retrieveOppositeGenderProfile(
    String userUid, String userGender) async {
  try {
    // Determine the opposite gender
    String oppositeGender = (userGender == 'Male') ? 'Female' : 'Male';
    // Query Firestore to retrieve users with the opposite gender
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    print("Query result size: ${querySnapshot.size}");
    List<Map<String, dynamic>> oppositeGenderProfile = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Retrieve the user_profile document from the user_info subcollection
      DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(doc.id)
          .collection('user_info')
          .doc('profile')
          .get();

      if (profileSnapshot.exists) {
        // Check the gender and add to the list if it's the opposite gender
        Map<String, dynamic>? profileData =
            profileSnapshot.data() as Map<String, dynamic>?;

        if (profileData?['gender'] == oppositeGender) {
          oppositeGenderProfile.add(profileData!);
        }
      }
    }
    print(oppositeGenderProfile);
    return oppositeGenderProfile;
  } catch (error) {
    print('Error retrieving opposite gender preferences: $error');
    return [];
  }
}

Future<List<Map<String, dynamic>>> retrieveOppositeGenderPreferences(
    String userUid, String userGender) async {
  try {
    // Determine the opposite gender
    String oppositeGender = (userGender == 'Male') ? 'Female' : 'Male';

    // Query Firestore to retrieve users with the opposite gender
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('user_info')
        .where('profile.gender', isEqualTo: oppositeGender)
        .get();

    print("Query result size: ${querySnapshot.size}");

    List<Map<String, dynamic>> oppositeGenderPreferences = [];
    print(oppositeGenderPreferences);

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Retrieve preferences from the 'user_preferences' subcollection
      DocumentSnapshot preferencesSnapshot =
          await doc.reference.collection('user_info').doc("preferences").get();

      if (preferencesSnapshot.exists) {
        oppositeGenderPreferences
            .add(preferencesSnapshot.data() as Map<String, dynamic>);
      }
    }
    return oppositeGenderPreferences;
  } catch (error) {
    print('Error retrieving opposite gender preferences: $error');
    return [];
  }
}

// Future<List<Map<String, dynamic>>> filterMatches(
//     List<Map<String, dynamic>> oppositeGenderProfiles) {}

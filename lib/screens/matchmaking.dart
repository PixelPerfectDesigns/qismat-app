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

  List<Map<String, dynamic>> userResponses = [];
  try {
    String? userGender = await getUserGender(userUid);

    if (userGender != null) {
      List<Map<String, dynamic>> oppositeGenderProfiles =
          await retrieveOppositeGenderProfile(userUid, userGender);
      // filterMatches(oppositeGenderProfiles);
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

Future<String?> getUserGender(String userUid) async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('user_info')
        .doc("profile")
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> userProfile =
          documentSnapshot.data() as Map<String, dynamic>;

      if (userProfile.containsKey("gender")) {
        String userGender = userProfile["gender"];
        print('User with ID $userUid has gender: $userGender');
        return userGender;
      } else {
        print('Gender information not found for user with ID $userUid.');
      }
    } else {
      print('Document not found for user with ID $userUid.');
    }
  } catch (error) {
    print('Error: $error');
  }

  return null; // Return null in case of an error or missing data
}

Future<Map<String, dynamic>> retrieveUserDoc(
    String userUid, String docid) async {
  try {
    DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('user_info')
        .doc(docid)
        .get();

    if (profileSnapshot.exists) {
      Map<String, dynamic>? profileData =
          profileSnapshot.data() as Map<String, dynamic>?;
      if (profileData != null) {
        return profileData;
      }
    }
    return {};
  } catch (error) {
    print('Error retrieving User Profile: $error');
    return {};
  }
}

Future<List<Map<String, dynamic>>> retrieveOppositeGenderDoc(
    String userUid, String userGender, String docid) async {
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
      // DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(doc.id)
      //     .collection('user_info')
      //     .doc('profile')
      //     .get();

      // if (profileSnapshot.exists) {
      //   // Check the gender and add to the list if it's the opposite gender
      //   Map<String, dynamic>? profileData =
      //       profileSnapshot.data() as Map<String, dynamic>?;

      Map<String, dynamic>? profileData = await retrieveUserDoc(doc.id, docid);

      if (profileData?['gender'] == oppositeGender) {
        oppositeGenderProfile.add(profileData!);
      }
      // }
    }
    print(oppositeGenderProfile);
    return oppositeGenderProfile;
  } catch (error) {
    print('Error retrieving opposite gender preferences: $error');
    return [];
  }
}

Future<List<Map<String, dynamic>>> retrieveOppositeGenderPreferences(
    String userUid, String userGender) {
  return retrieveOppositeGenderDoc(userUid, userGender, 'preferences');
}

Future<List<Map<String, dynamic>>> retrieveOppositeGenderProfile(
    String userUid, String userGender) {
  return retrieveOppositeGenderDoc(userUid, userGender, 'profile');
}

Future<Map<String, dynamic>> retrieveCurrentUserPreferences(
    String userUid, String userGender) {
  return retrieveUserDoc(userUid, 'preferences');
}

Future<Map<String, dynamic>> retrieveCurrentUserProfile(
    String userUid, String userGender) {
  return retrieveUserDoc(userUid, 'profile');
}

 
// Future<List<Map<String, dynamic>>> retrieveOppositeGenderPreferences(
//     String userUid, String userGender) async {
//   try {
//     // Determine the opposite gender
//     String oppositeGender = (userGender == 'Male') ? 'Female' : 'Male';

//     // Query Firestore to retrieve users with the opposite gender
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userUid)
//         .collection('user_info')
//         .where('profile.gender', isEqualTo: oppositeGender)
//         .get();

//     print("Query result size: ${querySnapshot.size}");

//     List<Map<String, dynamic>> oppositeGenderPreferences = [];
//     print(oppositeGenderPreferences);

//     for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//       // Retrieve preferences from the 'user_preferences' subcollection
//       DocumentSnapshot preferencesSnapshot =
//           await doc.reference.collection('user_info').doc("preferences").get();

//       if (preferencesSnapshot.exists) {
//         oppositeGenderPreferences
//             .add(preferencesSnapshot.data() as Map<String, dynamic>);
//       }
//     }
//     return oppositeGenderPreferences;
//   } catch (error) {
//     print('Error retrieving opposite gender preferences: $error');
//     return [];
//   }
// }

// Future<List<Map<String, dynamic>>> filterMatches(
//     List<Map<String, dynamic>> oppositeGenderProfiles) {}

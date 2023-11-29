import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qismat/screens/person.dart';

double calculateMatchPercentage(Person user1, Person user2) {
  // Ensure both users have preferences and profiles
  if (user1.preferences == null ||
      user2.profile == null ||
      user2.preferences == null) {
    throw Exception(
        "User 1 must have preferences and User 2 must have a profile and preferences for matchmaking.");
  }

  // Compare preferences and profile attributes
  PersonPreferences person1Preferences = user1.preferences!;
  PersonPreferences person2Preferences = user2.preferences!;
  PersonProfile person2Profile = user2.profile!;

  int totalAttributes = 9;

  int matchingAttributes = 0;

  // Compare each preference with the corresponding attribute in the other user's profile
  if ((person1Preferences.preferredAgeRange['max'] ?? 0) >=
          person2Profile.age ||
      (person1Preferences.preferredAgeRange['min'] ?? 0) <=
          person2Profile.age) {
    print('matchinfattributes-age: $matchingAttributes');
    matchingAttributes++;
  }

  if (person1Preferences.acceptableEthnicities
      .contains(person2Profile.ethnicity)) {
    print('matchinfattributes-ethnicities: $matchingAttributes');

    matchingAttributes++;
  }

  if (person1Preferences.relocationPreference ==
      person2Preferences.relocationPreference) {
    print('matchinfattributes-relocation: $matchingAttributes');

    matchingAttributes++;
  }

  if (person1Preferences.livingSituations
      .contains(person2Preferences.livingSituations)) {
    print('matchinfattributes-livingsituations: $matchingAttributes');

    matchingAttributes++;
  }

  if (person1Preferences.educationLevelPreference ==
      person2Profile.educationLevel) {
    print('matchinfattributes-educationlevel: $matchingAttributes');

    matchingAttributes++;
  }

  if ((person1Preferences.preferredSalaryRange['max'] ?? 0) >=
          person2Profile.currentSalary ||
      (person1Preferences.preferredSalaryRange['min'] ?? 0) <=
          person2Profile.currentSalary) {
    print('matchinfattributes-salary: $matchingAttributes');

    matchingAttributes++;
  }

  if (person1Preferences.employmentArrangement ==
      person2Preferences.employmentArrangement) {
    print('matchinfattributes-employmentarrangement: $matchingAttributes');

    matchingAttributes++;
  }

  if (person1Preferences.desiredNumberOfKids ==
      person2Preferences.desiredNumberOfKids) {
    print('matchinfattributes-NOK: $matchingAttributes');

    matchingAttributes++;
  }

  if (person1Preferences.acceptableRelationshipTypes
      .contains(person2Profile.relationshipStatus)) {
    print('matchinfattributes-Rstatus: $matchingAttributes');

    matchingAttributes++;
  }
  // if (person1Preferences.desiredSkills.contains(person2Profile.skills)) {
  //   print('matchinfattributes-skills: $matchingAttributes');

  //   matchingAttributes++;
  // }
  // if (person1Preferences.desiredPersonalityTraits.contains(person2Profile.personalityTraits)) {
  //   print('matchinfattributes-skills: $matchingAttributes');

  //   matchingAttributes++;
  // }
  if (person1Preferences.preferredProfessions
      .contains(person2Profile.profession)) {
    print('matchinfattributes-profession: $matchingAttributes');

    matchingAttributes++;
  }

  // if (person1Preferences.preferredEducationSystem.contains(person2Preferences.preferredEducationSystem)) {
  //   print('matchinfattributes-profession: $matchingAttributes');

  //   matchingAttributes++;
  // }

  // Calculate match percentage
  double matchPercentage = (matchingAttributes / totalAttributes) * 100;
  return matchPercentage;
}

Future<Person> createCurrentUser(String userUid) async {
  print('reached here');

  Map<String, dynamic> profileMap = await retrieveCurrentUserProfile(userUid);
  PersonProfile profile = PersonProfile.fromMap(profileMap);

  Map<String, dynamic> preferencesMap =
      await retrieveCurrentUserPreferences(userUid);
  print('created preferencesMap ');
  PersonPreferences preferences = PersonPreferences.fromMap(preferencesMap);
  print('created preferencesPerson ');

  return Person(
    userUid: userUid,
    profile: profile,
    preferences: preferences,
  );
}

Future<Person> createMatchingUser(String userUid) async {
  Map<String, dynamic> profileMap = await retrieveUserDoc(userUid, 'profile');
  PersonProfile profile = PersonProfile.fromMap(profileMap);

  Map<String, dynamic> preferencesMap =
      await retrieveUserDoc(userUid, 'preferences');
  PersonPreferences preferences = PersonPreferences.fromMap(preferencesMap);

  return Person(
    userUid: userUid,
    profile: profile,
    preferences: preferences,
  );
}

Future<List<Person>> filterMatches() async {
  String userUid = "";
  // Example usage:
  User? user = getCurrentUser();
  if (user != null) {
    userUid = user.uid;
  } else {
    print('No user is currently logged in.');
  }

  try {
    String? userGender = await getUserGender(userUid);

    Person currentUser = await createCurrentUser(userUid);

    if (userGender != null) {
      List<Person> oppositeGenderProfiles =
          await retrieveOppositeGenderDoc(userUid, userGender);
      List<Person> filteredMatches = [];

      print('done retrieving oppositegenderdoc');

      for (Person matchingUser in oppositeGenderProfiles) {
        double matchingPercentage =
            calculateMatchPercentage(currentUser, matchingUser);
        print(matchingPercentage);
        if (matchingPercentage >= 50) {
          print(matchingUser.userUid);
          filteredMatches.add(matchingUser);
        }
      }
      return filteredMatches;
    }
  } catch (e) {
    print('Error retrieving user responses: $e');
    throw e; // You can throw an error or handle it as needed
  }
  return [];
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
        print(profileData.toString());

        return profileData;
      }
    }
    return {};
  } catch (error) {
    print('Error retrieving User Profile: $error');
    return {};
  }
}

Future<List<Person>> retrieveOppositeGenderDoc(
    String userUid, String userGender) async {
  try {
    // Determine the opposite gender
    String oppositeGender = (userGender == 'Male') ? 'Female' : 'Male';
    // Query Firestore to retrieve users with the opposite gender
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    print("Query result size: ${querySnapshot.size}");
    // List<Map<String, dynamic>> oppositeGenderProfile = [];
    List<Person> oppositeGenderProfile = [];
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

      Map<String, dynamic>? profileData =
          await retrieveUserDoc(doc.id, 'profile');

      // if (profileData?['gender'] == oppositeGender) {
      //   oppositeGenderProfile.add(profileData!);

      // }

      if (profileData?['gender'] == oppositeGender) {
        print(doc.id);
        Person matchingUser = await createMatchingUser(doc.id);
        oppositeGenderProfile.add(matchingUser);
      }
      // }
    }
    print(oppositeGenderProfile.toString());
    return oppositeGenderProfile;
  } catch (error) {
    print('Error retrieving opposite gender preferences: $error');
    return [];
  }
}

// Future<List<Map<String, dynamic>>> retrieveOppositeGenderPreferences(
//     String userUid, String userGender) {
//   return retrieveOppositeGenderDoc(userUid, userGender, 'preferences');
// }

// Future<List<Map<String, dynamic>>> retrieveOppositeGenderProfile(
//     String userUid, String userGender) {
//   return retrieveOppositeGenderDoc(userUid, userGender, 'profile');
// }

Future<Map<String, dynamic>> retrieveCurrentUserPreferences(String userUid) {
  print('retrieving current user preferences ');

  return retrieveUserDoc(userUid, 'preferences');
}

Future<Map<String, dynamic>> retrieveCurrentUserProfile(String userUid) {
  print('retrieving current user profile ');
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

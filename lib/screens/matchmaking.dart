import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qismat/screens/person.dart';

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
      Map<String, dynamic> filteredMatchesID = {};
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (Person matchingUser in oppositeGenderProfiles) {
        double matchingPercentage =
            calculateMatchPercentage(currentUser, matchingUser);
        print(matchingPercentage);
        if (matchingPercentage >= 60) {
          filteredMatches.add(matchingUser);
          String matchingUserID = matchingUser.userUid.toString();
          Map<String, dynamic> filteredMatchingUser = {
            'matchPercentage': matchingPercentage,
            'hideProfilePicture': true,
          };
          filteredMatchesID[matchingUserID] = filteredMatchingUser;

          // Add each write operation to the batch
          batch.set(
            FirebaseFirestore.instance
                .collection('users')
                .doc(userUid)
                .collection('matches')
                .doc('allFilteredMatches')
                .collection(matchingUserID) // Subcollection with the user ID
                .doc('info'),
            filteredMatchingUser,
            // SetOptions(merge: true), // Merge with existing data
          );
        }
      }

      // Add a single batch.set for allFilteredMatches with placeholder field
      batch.set(
        FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .collection('matches')
            .doc('allFilteredMatches'),
        {'placeholder': true}, // Add a placeholder field
        // SetOptions(merge: true), // Create the document if it doesn't exist
      );

      // Commit the batch
      await batch.commit().then((_) {}).catchError((error) {
        print('Error: $error');
      });

      return filteredMatches;
    }
  } catch (e) {
    print('Error retrieving user responses: $e');
    throw e; // You can throw an error or handle it as needed
  }
  return [];
}

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

  int totalAttributes = 13;

  int matchingAttributes = 0;

  // Compare each preference with the corresponding attribute in the other user's profile
  if ((person1Preferences.preferredAgeRange['max'] ?? 0) >=
          person2Profile.age ||
      (person1Preferences.preferredAgeRange['min'] ?? 0) <=
          person2Profile.age) {
    print('matchingattributes-age: $matchingAttributes');
    matchingAttributes++;
  }

  if (person1Preferences.acceptableEthnicities
      .contains(person2Profile.ethnicity)) {
    print('matchingattributes-ethnicity: $matchingAttributes');

    matchingAttributes++;
  }

  if (person1Preferences.relocationPreference ==
      person2Preferences.relocationPreference) {
    print('matchingattributes-relocationPreference: $matchingAttributes');

    matchingAttributes++;
  }

  if (person1Preferences.livingSituations
      .contains(person2Preferences.livingSituations)) {
    print('matchingattributes-livingsituations: $matchingAttributes');

    matchingAttributes++;
  }

  if (person1Preferences.educationLevelPreference ==
      person2Profile.educationLevel) {
    print('matchingattributes-educationlevel: $matchingAttributes');

    matchingAttributes++;
  }

  if ((person1Preferences.preferredSalaryRange['max'] ?? 0) >=
          person2Profile.currentSalary ||
      (person1Preferences.preferredSalaryRange['min'] ?? 0) <=
          person2Profile.currentSalary) {
    print('matchingattributes-currentSalary: $matchingAttributes');

    matchingAttributes++;
  }

  if (person1Preferences.employmentArrangement ==
      person2Preferences.employmentArrangement) {
    print('matchingattributes-employmentarrangement: $matchingAttributes');

    matchingAttributes++;
  }

  if (person1Preferences.desiredNumberOfKids ==
      person2Preferences.desiredNumberOfKids) {
    print('matchingattributes-desiredNumberOfKids: $matchingAttributes');

    matchingAttributes++;
  }

  if (person1Preferences.acceptableRelationshipTypes
      .contains(person2Profile.relationshipStatus)) {
    print('matchingattributes-relationshipStatus: $matchingAttributes');
    matchingAttributes++;
  }
  if (person1Preferences.partnerSkills.contains(person2Profile.skills)) {
    print('matchingattributes-skills: $matchingAttributes');
    matchingAttributes++;
  }
  for (String trait in person1Preferences.desiredPersonalityTraits) {
    if (person2Profile.personalityTraits.contains(trait)) {
      print(
          'Matching attribute - personalityTrait: $trait, $matchingAttributes');
      matchingAttributes++;
      break; // Exit the loop after finding a match
    }
  }
  for (String profession in person1Preferences.preferredProfessions) {
    if (profession == person2Profile.profession) {
      print(
          'Matching attribute - profession: $profession, $matchingAttributes');
      matchingAttributes++;
      break; // Exit the loop after finding a match
    }
  }

  for (String educationSystem in person1Preferences.preferredEducationSystem) {
    if (person2Preferences.preferredEducationSystem.contains(educationSystem)) {
      print(
          'Matching attribute - educationSystem: $educationSystem, $matchingAttributes');
      matchingAttributes++;
      break; // Exit the loop after finding a match
    }
  }

  // Calculate match percentage
  double matchPercentage = (matchingAttributes / totalAttributes) * 100;
  return matchPercentage;
}

//Helper User Functions

Future<Person> createCurrentUser(String userUid) async {
  Map<String, dynamic> profileMap = await retrieveCurrentUserProfile(userUid);
  PersonProfile profile = PersonProfile.fromMap(profileMap);

  Map<String, dynamic> preferencesMap =
      await retrieveCurrentUserPreferences(userUid);
  PersonPreferences preferences = PersonPreferences.fromMap(preferencesMap);

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
      Map<String, dynamic>? profileData =
          await retrieveUserDoc(doc.id, 'profile');

      if (profileData['gender'] == oppositeGender) {
        Person matchingUser = await createMatchingUser(doc.id);
        oppositeGenderProfile.add(matchingUser);
      }
    }
    return oppositeGenderProfile;
  } catch (error) {
    print('Error retrieving opposite gender preferences: $error');
    return [];
  }
}

Future<Map<String, dynamic>> retrieveCurrentUserPreferences(String userUid) {
  return retrieveUserDoc(userUid, 'preferences');
}

Future<Map<String, dynamic>> retrieveCurrentUserProfile(String userUid) {
  return retrieveUserDoc(userUid, 'profile');
}

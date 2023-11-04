import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<Map<String, dynamic>>> retrieveUserResponsesFromFirestore() async {
  String userUid = "";
  // Example usage:
  User? user = getCurrentUser();
  if (user != null) {
    userUid = user.uid;
  } else {
    print('No user is currently logged in.');
  }
  final collectionId =
      'profile_responses'; // Define your Firestore collection name

  List<Map<String, dynamic>> userResponses = [];
  try {
    QuerySnapshot responseQuery = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('profile_responses')
        .get();

    if (responseQuery.docs.isNotEmpty) {
      final responseList = responseQuery.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      print(responseList);
      return responseList;
    } else {
      print('No responses found in Firestore.');
      return []; // Return an empty list if no responses are found
    }
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

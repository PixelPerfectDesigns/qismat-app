import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qismat/screens/dashboard.dart';
import 'package:qismat/screens/question.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:qismat/screens/matchmaking.dart';

class ProfileQuestionsScreen extends StatefulWidget {
  @override
  _ProfileQuestionsScreenState createState() => _ProfileQuestionsScreenState();
}

class _ProfileQuestionsScreenState extends State<ProfileQuestionsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  PageController _pageController = PageController();
  List<QuestionPage> questionPages = [];
  int currentPage = 0;
  Map<String, dynamic> userProfile = {};
  Map<String, dynamic> userPreferences = {};
  Map<String, dynamic> userInfo = {};

  @override
  void initState() {
    super.initState();
    loadQuestions();
    _user = _auth.currentUser!;
  }

  Future<void> loadQuestions() async {
    // Load questions from the JSON file
    final String profileQuestionsJson =
        await rootBundle.loadString('assets/profile_questions.json');
    final List<Map<String, dynamic>> profileQuestions =
        List<Map<String, dynamic>>.from(jsonDecode(profileQuestionsJson));

    final String preferenceQuestionsJson =
        await rootBundle.loadString('assets/preference_questions.json');
    final List<Map<String, dynamic>> preferenceQuestions =
        List<Map<String, dynamic>>.from(jsonDecode(preferenceQuestionsJson));

    // print(questions);

    for (var questionData in profileQuestions) {
      questionPages.add(QuestionPage(
        questionData: questionData,
        onSave: saveResponse,
      ));
    }
    print(profileQuestions.toString());

    for (var questionData in preferenceQuestions) {
      questionPages.add(QuestionPage(
        questionData: questionData,
        onSave: savePreferences,
      ));
    }
  }

  void saveResponse(String question, String field, dynamic response) {
    // final userUid = _user.uid; // Add the user's UID here

    userProfile[field] = response;
    if (currentPage < questionPages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      setState(() {
        currentPage++;
      });
    }

    // final collectionId = 'profile_responses'; // Define your collection name
    // final responseDocument = {
    //   'question': question,
    //   'response': response,
    //   'timestamp': FieldValue.serverTimestamp(),
    // };

    // Add the response to Firestore

    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userUid)
    //     .collection(collectionId)
    //     .add(responseDocument)
    //     .then((_) {
    //   print('Response saved to Firestore');
    // });

    // All questions are completed, set isProfileSetupComplete to true
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userUid)
    //     .update({'isProfileSetupComplete': true}).then((_) {
    //   print('Profile setup is complete.');
    // });
  }

  void savePreferences(String question, String field, dynamic response) {
    final userUid = _user.uid; // Add the user's UID here
    userPreferences[field] = response;

    if (currentPage < questionPages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      setState(() {
        currentPage++;
      });
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .set({}, SetOptions(merge: true))
          .then((_) {
            print('User document with ID $userUid created');
            return FirebaseFirestore.instance
                .collection('users')
                .doc(userUid)
                .collection('user_info')
                .doc("profile")
                .set(userProfile, SetOptions(merge: true));
          })
          .then((_) => print('Profile saved to Firestore'))
          .catchError((error) => print('Error: $error'));

      FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('user_info')
          .doc('preferences')
          .set(userPreferences)
          .then((_) {
        print('Preferences saved to Firestore');
      });
      // All questions are completed, set isProfileSetupComplete to true
      FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('settings')
          .doc("general")
          .set({'isProfileSetupComplete': true}).then((_) {
        print('Profile setup is complete.');
      }).catchError((error) {
        print('Error setting up profile: $error');
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Questions")),
      body: PageView(
        controller: _pageController,
        children: questionPages,
      ),
    );
  }
}

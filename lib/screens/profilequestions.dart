import 'package:flutter/material.dart';
import 'package:qismat/screens/questions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileQuestionsScreen extends StatefulWidget {
  @override
  _ProfileQuestionsScreenState createState() => _ProfileQuestionsScreenState();
}

class _ProfileQuestionsScreenState extends State<ProfileQuestionsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user;

  List<String> questions = [
    "What is your age?",
    "What is your favorite hobby?",
    "Where are you from?",
    // Add more questions here
  ];

  int currentIndex = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
  }

  void _saveResponse(String response) {
    // Save the response to Firebase
    final question = questions[currentIndex];
    _firestore.collection('users').doc(_user.uid).update({
      'profile_responses.$question': response,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Questions"),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: questions.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return QuestionScreen(
                  question: questions[index],
                  onNextPressed: (response) {
                    _saveResponse(response);
                    if (currentIndex >= questions.length - 1) {
                      // Set isProfileSetupComplete to true
                      _firestore.collection('users').doc(_user.uid).update({
                        'isProfileSetupComplete': true,
                      });
                    }
                    if (currentIndex < questions.length - 1) {
                      pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Profile Complete"),
                            content: Text("You have answered all questions."),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Question ${currentIndex + 1} of ${questions.length}"),
          ),
        ],
      ),
    );
  }
}

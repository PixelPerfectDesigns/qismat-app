import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qismat/screens/dashboard.dart';
import 'package:qismat/screens/profile_setup/question.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qismat/screens/auth/auth.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ProfileQuestionsScreen extends StatefulWidget {
  @override
  _ProfileQuestionsScreenState createState() => _ProfileQuestionsScreenState();
}

class _ProfileQuestionsScreenState extends State<ProfileQuestionsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  PageController _pageController = PageController();
  late Future<List<QuestionPage>> questionPages;
  int currentPage = 0;
  Map<String, dynamic> userProfile = {};
  Map<String, dynamic> userPreferences = {};
  Map<String, dynamic> userInfo = {};

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    questionPages = loadQuestions();
  }

  Future<List<QuestionPage>> loadQuestions() async {
    // Load questions from the JSON file
    final String profileQuestionsJson =
        await rootBundle.loadString('assets/profile_questions.json');
    final List<Map<String, dynamic>> profileQuestions =
        List<Map<String, dynamic>>.from(jsonDecode(profileQuestionsJson));

    final String preferenceQuestionsJson =
        await rootBundle.loadString('assets/preference_questions.json');
    final List<Map<String, dynamic>> preferenceQuestions =
        List<Map<String, dynamic>>.from(jsonDecode(preferenceQuestionsJson));

    List<QuestionPage> questionPagesList = [];

    for (var questionData in profileQuestions) {
      questionPagesList.add(QuestionPage(
        questionData: questionData,
        onSave: saveResponse,
      ));
    }

    for (var questionData in preferenceQuestions) {
      questionPagesList.add(QuestionPage(
        questionData: questionData,
        onSave: savePreferences,
      ));
    }

    return questionPagesList;
  }

  Future<void> saveResponse(
      String question, String field, dynamic response) async {
    userProfile[field] = response;
    List<QuestionPage> pages = await questionPages;

    if (currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      setState(() {
        currentPage++;
      });
    }
  }

  Future<void> savePreferences(
      String question, String field, dynamic response) async {
    final userUid = _user.uid;
    userPreferences[field] = response;

    // Wait for the questionPages future to complete
    List<QuestionPage> pages = await questionPages;

    if (currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      setState(() {
        currentPage++;
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .set({}, SetOptions(merge: true)).then((_) {
        print('User document with ID $userUid created');
        return FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .collection('user_info')
            .doc("profile")
            .set(userProfile, SetOptions(merge: true));
      }).then((_) {});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('user_info')
          .doc('preferences')
          .set(userPreferences)
          .then((_) {});
      // All questions are completed, set isProfileSetupComplete to true
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('settings')
          .doc("general")
          .set({
        'isProfileSetupComplete': true,
        'hideProfilePicture': true
      }).then((_) {
        print('Profile setup is complete.');
      }).catchError((error) {
        print('Error setting up profile: $error');
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Questions', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFF5858),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            itemBuilder: (BuildContext context) {
              return {'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            onSelected: (String choice) {
              if (choice == 'Logout') {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<QuestionPage>>(
        future: questionPages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return PageView(
              controller: _pageController,
              children: snapshot.data!,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF5858),
              ),
            );
          }
        },
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:qismat/screens/dashboard.dart';
// import 'package:qismat/screens/profile_setup/question.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:qismat/screens/auth/auth.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;

// class ProfileQuestionsScreen extends StatefulWidget {
//   @override
//   _ProfileQuestionsScreenState createState() => _ProfileQuestionsScreenState();
// }

// class _ProfileQuestionsScreenState extends State<ProfileQuestionsScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   late User _user;
//   PageController _pageController = PageController();
//   List<QuestionPage> questionPages = [];
//   int currentPage = 0;
//   Map<String, dynamic> userProfile = {};
//   Map<String, dynamic> userPreferences = {};
//   Map<String, dynamic> userInfo = {};

//   @override
//   void initState() {
//     super.initState();
//     loadQuestions();
//     _user = _auth.currentUser!;
//   }

//   Future<void> loadQuestions() async {
//     // Load questions from the JSON file
//     final String profileQuestionsJson =
//         await rootBundle.loadString('assets/profile_questions.json');
//     final List<Map<String, dynamic>> profileQuestions =
//         List<Map<String, dynamic>>.from(jsonDecode(profileQuestionsJson));

//     final String preferenceQuestionsJson =
//         await rootBundle.loadString('assets/preference_questions.json');
//     final List<Map<String, dynamic>> preferenceQuestions =
//         List<Map<String, dynamic>>.from(jsonDecode(preferenceQuestionsJson));

//     for (var questionData in profileQuestions) {
//       questionPages.add(QuestionPage(
//         questionData: questionData,
//         onSave: saveResponse,
//       ));
//     }

//     for (var questionData in preferenceQuestions) {
//       questionPages.add(QuestionPage(
//         questionData: questionData,
//         onSave: savePreferences,
//       ));
//     }
//   }

//   void saveResponse(String question, String field, dynamic response) {
//     userProfile[field] = response;
//     if (currentPage < questionPages.length - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.ease,
//       );
//       setState(() {
//         currentPage++;
//       });
//     }
//   }

//   Future<void> savePreferences(
//       String question, String field, dynamic response) async {
//     final userUid = _user.uid; // Add the user's UID here
//     userPreferences[field] = response;

//     if (currentPage < questionPages.length - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.ease,
//       );
//       setState(() {
//         currentPage++;
//       });
//     } else {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userUid)
//           .set({}, SetOptions(merge: true)).then((_) {
//         print('User document with ID $userUid created');
//         return FirebaseFirestore.instance
//             .collection('users')
//             .doc(userUid)
//             .collection('user_info')
//             .doc("profile")
//             .set(userProfile, SetOptions(merge: true));
//       }).then((_) {});

//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userUid)
//           .collection('user_info')
//           .doc('preferences')
//           .set(userPreferences)
//           .then((_) {});
//       // All questions are completed, set isProfileSetupComplete to true
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userUid)
//           .collection('settings')
//           .doc("general")
//           .set({
//         'isProfileSetupComplete': true,
//         'hideProfilePicture': true
//       }).then((_) {
//         print('Profile setup is complete.');
//       }).catchError((error) {
//         print('Error setting up profile: $error');
//       });

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const DashboardScreen(),
//         ),
//       );
//     }
//   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return FutureBuilder(
// //       future: loadQuestions(),
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.done) {
// //           // Questions are loaded, display the screen
// //           return Scaffold(
// //             appBar: AppBar(
// //               title: const Text('Profile Questions',
// //                   style: TextStyle(color: Colors.white)),
// //               backgroundColor: const Color(0xFFFF5858),
// //               iconTheme: const IconThemeData(color: Colors.white),
// //               actions: [
// //                 PopupMenuButton<String>(
// //                   color: Colors.white,
// //                   itemBuilder: (BuildContext context) {
// //                     return {'Logout'}.map((String choice) {
// //                       return PopupMenuItem<String>(
// //                         value: choice,
// //                         child: Text(choice),
// //                       );
// //                     }).toList();
// //                   },
// //                   onSelected: (String choice) {
// //                     if (choice == 'Logout') {
// //                       FirebaseAuth.instance.signOut();
// //                       Navigator.pop(context);

// //                       Navigator.of(context).push(
// //                         MaterialPageRoute(
// //                             builder: (context) => const AuthScreen()),
// //                       );
// //                     }
// //                   },
// //                 ),
// //               ],
// //             ),
// //             body: PageView(
// //               controller: _pageController,
// //               children: questionPages,
// //             ),
// //           );
// //         } else {
// //           // Questions are still loading, show a loading indicator
// //           return const Scaffold(
// //             body: Center(
// //               child: CircularProgressIndicator(
// //                 color: Color(0xFFFF5858),
// //               ),
// //             ),
// //           );
// //         }
// //       },
// //     );
// //   }
// // }`

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile Questions', style: TextStyle(color: Colors.white)),
//         backgroundColor: Color(0xFFFF5858),
//         iconTheme: IconThemeData(color: Colors.white),
//         actions: [
//           PopupMenuButton<String>(
//             color: Colors.white,
//             itemBuilder: (BuildContext context) {
//               return {'Logout'}.map((String choice) {
//                 return PopupMenuItem<String>(
//                   value: choice,
//                   child: Text(choice),
//                 );
//               }).toList();
//             },
//             onSelected: (String choice) {
//               if (choice == 'Logout') {
//                 FirebaseAuth.instance.signOut();
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(builder: (context) => const AuthScreen()),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//       body: PageView(
//         controller: _pageController,
//         children: questionPages,
//       ),
//     );
//   }
// }

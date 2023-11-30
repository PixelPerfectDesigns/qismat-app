import 'package:flutter/material.dart';
import 'package:qismat/screens/person.dart';
import 'package:qismat/screens/matchmaking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qismat/screens/auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPage extends StatelessWidget {
  final Person user;

  const UserPage({Key? key, required this.user}) : super(key: key);

  Future<void> requestPictureLogic() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(getCurrentUser()!.uid)
          .collection('matches')
          .doc('allFilteredMatches')
          .collection(user.userUid!) // Subcollection with the user ID
          .doc('info')
          .update({'hideProfilePicture': false});
    } catch (e) {
      print('Error updating user data: $e');
      // Handle the error as needed
    }
  }

  void _showContactInfoPopup(BuildContext context, Person user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200], // Customize background color
          title: const Text(
            'Contact Information',
            style: TextStyle(
              color: Color(0xFFFF5858), // Customize text color
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Email:',
                style: TextStyle(
                  color: Color(0xFFFF5858),
                  fontWeight: FontWeight.bold, // Make the label bold
                ),
              ),
              Text(
                '${user.profile?.contactEmail ?? 'N/A'}',
                style: TextStyle(
                  color: Colors.black, // Customize text color
                  fontSize: 20.0, // Increase the font size
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Phone:',
                style: TextStyle(
                  color: Color(0xFFFF5858),
                  fontWeight: FontWeight.bold, // Make the label bold
                ),
              ),
              Text(
                '${user.profile?.contactPhoneNumber ?? 'N/A'}',
                style: const TextStyle(
                  color: Colors.black, // Customize text color
                  fontSize: 20.0, // Increase the font size
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the pop-up
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Color(0xFFFF5858), // Customize button text color
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(user.profile?.name ?? 'Name not available',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFF5858),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            itemBuilder: (BuildContext context) {
              return [
                'Request Picture',
                'Request Contact Info',
                'Save to Favorites',
                'Logout'
              ].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            onSelected: (String choice) async {
              switch (choice) {
                case 'Request Picture':
                  await requestPictureLogic();
                  // Implement your logic for 'Request Picture'
                  break;
                case 'Request Contact Info':
                  _showContactInfoPopup(context, user);

                  break;
                case 'Save to Favorites':
                  break;
                case 'Logout':
                  FirebaseAuth.instance.signOut();

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                  // Implement your logic for 'Option 3'
                  break;
                // Add more cases for additional options
              }
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(getCurrentUser()!.uid)
                    .collection('matches')
                    .doc('allFilteredMatches')
                    .collection(user.userUid!)
                    .doc('info')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While waiting for the data, you can show a loading indicator or a default state.
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Handle errors here
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Check the value of hideProfilePicture in the document
                    bool hideProfilePicture =
                        snapshot.data?['hideProfilePicture'] ?? false;

                    // Display either the placeholder icon or the user's profile picture
                    return hideProfilePicture
                        ? CircleAvatar(
                            radius: 80.0,
                            backgroundColor: const Color(0xFFFF5858),
                            child: Icon(
                              user.profile?.gender == 'Male'
                                  ? Icons.face
                                  : Icons.face_4_rounded,
                              size: 60.0,
                              color: Colors.white,
                            ),
                          )
                        : user.profile?.profilePicture != null
                            ? CircleAvatar(
                                radius: 80.0,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: Image.network(
                                    user.profile!.profilePicture,
                                    width:
                                        150.0, // Adjust the width and height as needed
                                    height: 150.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 80.0,
                                backgroundColor: const Color(0xFFFF5858),
                                child: Icon(
                                  user.profile?.gender == 'Male'
                                      ? Icons.face
                                      : Icons.face_4_rounded,
                                  size: 60.0,
                                  color: Colors.white,
                                ),
                              );
                  }
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                user.profile?.name ?? 'No name',
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'About Me:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                user.profile?.about ?? 'No information available',
                style: const TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              const Divider(color: Color(0xFFFF5858)),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add ProfileAttribute widget for each attribute
                  // Adjust the label and value accordingly
                  ProfileAttribute(
                    label: 'Age',
                    value: (user.profile?.age.toString() ?? 'N/A'),
                    icon: Icons.cake,
                  ),
                  ProfileAttribute(
                    label: 'Location',
                    value:
                        '${user.profile?.city ?? 'N/A'}, ${user.profile?.country ?? 'N/A'}',
                    icon: Icons.location_on,
                  ),
                  ProfileAttribute(
                    label: 'Occupation',
                    value: user.profile?.profession ?? 'N/A',
                    icon: Icons.work,
                  ),
                  ProfileAttribute(
                    label: 'Education Level',
                    value: user.profile?.educationLevel ?? 'N/A',
                    icon: Icons.school,
                  ),
                  ProfileAttribute(
                    label: 'Current Education',
                    value: user.profile?.currentEducation ?? 'N/A',
                    icon: Icons.school_outlined,
                  ),
                  ProfileAttribute(
                    label: 'Skills',
                    value: (user.profile?.skills ?? []).join(', ') ?? 'N/A',
                    icon: Icons.star,
                  ),

                  ProfileAttribute(
                    label: 'Status',
                    value: user.profile?.relationshipStatus ?? 'N/A',
                    icon: Icons.favorite,
                  ),
                  ProfileAttribute(
                    label: 'Personality',
                    value: (user.profile?.personalityTraits ?? []).join(', ') ??
                        'N/A',
                    icon: Icons.person,
                  ),
                  ProfileAttribute(
                    label: 'Hobbies',
                    value: (user.profile?.hobbies ?? []).join(', ') ?? 'N/A',
                    icon: Icons.sports_esports,
                  ),

                  ProfileAttribute(
                    label: 'Aspiration and Goals',
                    value: user.profile?.aspirationsAndGoals ?? 'N/A',
                    icon: Icons.flag,
                  ),
                  ProfileAttribute(
                    label: 'Future Plans',
                    value: user.profile?.futurePlans ?? 'N/A',
                    icon: Icons.next_plan,
                  ),
                  // Add more attributes as needed
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileAttribute extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ProfileAttribute({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFFFF5858),
          ),
          const SizedBox(width: 8.0),
          // Wrap the Column with Expanded
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

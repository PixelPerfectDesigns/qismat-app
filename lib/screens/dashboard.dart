import 'package:flutter/material.dart';
import 'package:qismat/screens/matchmaking.dart';
import 'package:qismat/screens/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Person>> filteredMatches;
  late Person currentMatch;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    filteredMatches = filterMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFF5858),
        iconTheme:
            IconThemeData(color: Colors.white), // Set icon color to white
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Add filtering functionality
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Person>>(
        future: filteredMatches,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF5858),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No matches found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                currentMatch = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    tileColor: Colors.grey[200], // Light gray color
                    contentPadding: EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Color(0xFFFF5858),
                      child: Icon(
                        snapshot.data![index].profile?.gender == 'Male'
                            ? Icons.face
                            : Icons.face_4_rounded,
                        size: 24.0,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      snapshot.data![index].profile?.name ?? 'No name',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(
                              Icons.cake,
                              size: 16.0,
                              color: Color(0xFFFF5858),
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              'Age: ${snapshot.data![index].profile?.age ?? "N/A"}',
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16.0,
                              color: Color(0xFFFF5858),
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              '${snapshot.data![index].profile?.city ?? "N/A"}, ${snapshot.data![index].profile?.country ?? "N/A"}',
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(
                              Icons.work,
                              size: 16.0,
                              color: Color(0xFFFF5858),
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              '${snapshot.data![index].profile?.profession ?? "N/A"}',
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFFFF5858),
                    ),
                    onTap: () {
                      navigateToUserPage(snapshot.data![index]);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFFFF5858),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            // Navigate to Matches screen
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DashboardScreen()));
          } else if (index == 1) {
            // Navigate to Settings screen
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DashboardScreen()));
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Color(0xFFFF5858)), // Red color
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Color(0xFFFF5858)), // Red color
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void navigateToUserPage(Person user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserPage(user: user),
      ),
    );
  }
}

class UserPage extends StatelessWidget {
  final Person user;

  const UserPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(user.profile?.name ?? 'Name not available',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFF5858),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            itemBuilder: (BuildContext context) {
              return {'Request Picture'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            onSelected: (String choice) {
              if (choice == 'Request Picture') {
                // Implement your logic to handle picture request
                // For example, show a dialog or perform an action
                // when the user selects 'Request Picture'
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
              // StreamBuilder<DocumentSnapshot>(
              //   stream: FirebaseFirestore.instance
              //       .collection('users')
              //       .doc(user.userUid)
              //       .collection('settings')
              //       .doc('general')
              //       .snapshots(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       // While waiting for the data, you can show a loading indicator or a default state.
              //       return CircularProgressIndicator();
              //     } else if (snapshot.hasError) {
              //       // Handle errors here
              //       return Text('Error: ${snapshot.error}');
              //     } else {
              //       // Check the value of hideProfilePicture in the document
              //       bool hideProfilePicture =
              //           snapshot.data?['hideProfilePicture'] ?? false;

              //       // Display either the placeholder icon or the user's profile picture
              //       return CircleAvatar(
              //         radius: 80.0,
              //         backgroundColor: Color(0xFFFF5858),
              //         child: hideProfilePicture
              //             ? Icon(
              //                 user.profile?.gender == 'Male'
              //                     ? Icons.face
              //                     : Icons.face_4_rounded,
              //                 size: 60.0,
              //                 color: Colors.white,
              //               )
              //             : // Use user's profile picture here
              //             user.profile?.pic != null
              //                 ? Image.network(user.profile?.pic)
              //                 : Icon(
              //                     user.profile?.gender == 'Male'
              //                         ? Icons.face
              //                         : Icons.face_4_rounded,
              //                     size: 60.0,
              //                     color: Colors.white,
              //                   ),
              //       );
              //     }
              //   },
              // ),
              CircleAvatar(
                radius: 80.0,
                backgroundColor: Color(0xFFFF5858),
                child: Icon(
                  user.profile?.gender == 'Male'
                      ? Icons.face
                      : Icons.face_4_rounded, // Choose the male icon
                  size: 60.0, // Adjust the size as needed
                  color: Colors.white, // Placeholder icon color
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                user.profile?.name ?? 'No name',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                'About Me:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                // user.profile?.aboutMe ??
                'No information available',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              Divider(color: Color(0xFFFF5858)),
              SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add ProfileAttribute widget for each attribute
                  // Adjust the label and value accordingly
                  ProfileAttribute(
                    label: 'Age',
                    value: (user.profile?.age?.toString() ?? 'N/A'),
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
                    label: 'Aspiration and Goals Plans',
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

  ProfileAttribute(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Color(0xFFFF5858), // Customize the icon color as needed
          ),
          SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

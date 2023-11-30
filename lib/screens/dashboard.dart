import 'package:flutter/material.dart';
import 'package:qismat/screens/matchmaking.dart';
import 'package:qismat/screens/person.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qismat/screens/auth/auth.dart';
import 'package:qismat/screens/user_page.dart';

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
        backgroundColor: const Color(0xFFFF5858),
        iconTheme:
            const IconThemeData(color: Colors.white), // Set icon color to white
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Add filtering functionality
            },
          ),
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
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Person>>(
        future: filteredMatches,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF5858),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No matches found.'));
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
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      radius: 30.0,
                      backgroundColor: const Color(0xFFFF5858),
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
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.cake,
                              size: 16.0,
                              color: Color(0xFFFF5858),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              'Age: ${snapshot.data![index].profile?.age ?? "N/A"}',
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16.0,
                              color: Color(0xFFFF5858),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              '${snapshot.data![index].profile?.city ?? "N/A"}, ${snapshot.data![index].profile?.country ?? "N/A"}',
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.work,
                              size: 16.0,
                              color: Color(0xFFFF5858),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              '${snapshot.data![index].profile?.profession ?? "N/A"}',
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    trailing: const Icon(
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
        selectedItemColor: const Color(0xFFFF5858),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            // Navigate to Matches screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardScreen()));
          } else if (index == 1) {
            // Navigate to Settings screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardScreen()));
          }
        },
        items: const [
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

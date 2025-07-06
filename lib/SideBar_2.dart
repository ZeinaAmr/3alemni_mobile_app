import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'LoginPage.dart';
import 'Teacher_profile.dart';
import 'PostJobForm.dart';
import 'teacher_dashboard.dart';
import 'Notifications2.dart';
import 'calendar_page2.dart';
import 'JobOffers.dart';

class Sidebar2 extends StatelessWidget {
  final String userId;

  const Sidebar2({Key? key, required this.userId}) : super(key: key);

  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return snapshot.exists ? snapshot.data() : null;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData(userId),
        builder: (context, snapshot) {
          final userData = snapshot.data;
          final fullName = userData != null
              ? "${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}".trim()
              : "Unknown";
          final email = userData != null ? userData['email'] ?? '' : '';

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFC482), Color(0xFFD85E09)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0, bottom: 16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/Teacher4.jpg'),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName.isNotEmpty ? fullName : "Unknown",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            email.isNotEmpty ? email : '',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('My Profile'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => TeacherProfile(userId: userId)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => NotificationsPage2(userId: userId)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.library_books),
                title: const Text('My Courses'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => TeacherDashboard(userId: userId)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('My Calendar'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => CalendarPage2(userId: userId)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.work),
                title: const Text('Post Job Offers'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => JobOffersPage(userId: userId)));
                },
              ),
              const SizedBox(height: 400),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'ProfilePage.dart';
import 'subjects_page.dart';
import 'Study_Tools.dart';
import 'course_page.dart';
import 'Bundles_page.dart';
import 'HomePage.dart';
import 'Notifications.dart';
import 'centers_page.dart';
import 'Teachers_page.dart';
import 'student_dashboard.dart';
import 'calendar_page.dart';
import 'chatbot_page.dart';
import 'student_LMS.dart';

class Sidebar extends StatelessWidget {
  final String? userId; // made nullable to fix type errors

  const Sidebar({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Zeina',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'zeina@gmail.com',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('My Courses'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentDashboard(userId: userId!),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfilePage(userId: userId!)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_filled),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(userId: userId!)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage(userId: userId!)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('My Calendar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarPage(userId: userId!)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Subjects'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SubjectsPage(userId: userId!)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Centers'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CentersPage(userId: userId!)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Teachers'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeachersPage(userId: userId!)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: const Text('AI Study Tools'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AIStudyScreen(userId: userId!)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.smart_toy_outlined),
            title: const Text('Chatbot'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatbotPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: const Text('Bundles'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BundlesPage(userId: userId!)),
              );
            },
          ),
          const SizedBox(height: 100),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

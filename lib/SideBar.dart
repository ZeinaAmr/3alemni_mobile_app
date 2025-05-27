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
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFC482), Color(0xFFD85E09)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0, bottom: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/Teacher4.jpg'),
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
            leading: Icon(Icons.person),
            title: Text('My Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfilePage()),
              );
            },
          ),


          ListTile(
            leading: Icon(Icons.home_filled),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.library_books),
            title: Text('My Courses'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentDashboard()),
              );
            },
          ),
          SizedBox(height: 10),

          ListTile(
            leading: Icon(Icons.mail),
            title: Text('Notifications'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),


          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('My Calendar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarPage()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.book),
            title: Text('Subjects'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SubjectsPage()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.store),
            title: Text('Centers'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CentersPage()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.person),
            title: Text('Teachers'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeachersPage()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.auto_awesome),
            title: Text('AI Study Tools'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AIStudyScreen()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.smart_toy_outlined),
            title: Text('Chatbot'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatbotPage()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('Bundles'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BundlesPage()),
              );
            },
          ),
          const SizedBox(height: 100),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

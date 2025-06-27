import 'package:flutter/material.dart';
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
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('My Profile'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherProfile(userId: userId,)));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsPage2(userId: userId)));
            },
          ),
          ListTile(
            leading: Icon(Icons.library_books),
            title: Text('My Courses'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherDashboard(userId: userId)));
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('My Calendar'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CalendarPage2(userId: userId)));
            },
          ),
          ListTile(
            leading: Icon(Icons.work),
            title: Text('Post Job Offers'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => JobOffersPage(userId: userId)));
            },
          ),
          const SizedBox(height: 400),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

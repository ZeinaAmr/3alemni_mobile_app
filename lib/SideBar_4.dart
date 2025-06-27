import 'package:allemni/Assistant_dashboard.dart';
import 'package:allemni/PostJobForm.dart';
import 'package:allemni/subjects_page.dart';
import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'Assistant_profile.dart';

class Sidebar4 extends StatelessWidget {
  final String userId;

  const Sidebar4({Key? key, required this.userId}) : super(key: key);
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssistantProfile(userId: userId)),
              );
            },
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.work),
            title: Text('Job Offers'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssistantsDashboard(userId: userId)),
              );
            },
          ),
          
          const SizedBox(height: 550),
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

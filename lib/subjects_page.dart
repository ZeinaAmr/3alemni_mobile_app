import 'package:flutter/material.dart';
import 'SideBar.dart';
import 'HomePage.dart';
import 'calendar_page.dart';
import 'chatbot_page.dart';
import 'ProfilePage.dart';
import 'course_page.dart';

class SubjectsPage extends StatefulWidget {
  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  final List<Map<String, String>> subjects = [
    {"title": "Mathematics", "description": "Algebra, Geometry, Calculus"},
    {"title": "Science", "description": "Physics, Chemistry, Biology"},
    {"title": "History", "description": "World History and Civilizations"},
    {"title": "Computer Science", "description": "Programming, AI, Data Science"},
    {"title": "English Literature", "description": "Poetry, Drama, Fiction"},
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Subjects",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xFF187E8A)),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: Colors.black),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_alt_rounded, color: Colors.black),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFFF7C34),
                  child: Text(
                    subject['title']![0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  subject['title']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
                subtitle: Text(
                  subject['description']!,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFFF7C34),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CoursesPage()),
                  );
                },
              ),
            );
          },
        ),
      ),

    );
  }
}

import 'package:flutter/material.dart';
import 'SideBar_3.dart';
import 'HomePage.dart';
import 'calendar_page.dart';
import 'chatbot_page.dart';
import 'ProfilePage.dart';
import 'course_page.dart';

class SubjectsPage2 extends StatefulWidget {
  @override
  State<SubjectsPage2> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage2> {
  final List<Map<String, String>> subjects = [
    {"title": "Mathematics", "description": "Algebra, Geometry, Calculus"},
    {"title": "Science", "description": "Physics, Chemistry, Biology"},
    {"title": "History", "description": "World History and Civilizations"},
    {"title": "Computer Science", "description": "Programming, AI, Data Science"},
    {"title": "English Literature", "description": "Poetry, Drama, Fiction"},
  ];

  int myIndex = 0; // Default to no selection, preventing errors

  final List<Widget> _pages = [
    HomePage(),
    CalendarPage(),
    ChatbotPage(),
    MyProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      myIndex = index;
    });

    // Only navigate if a valid index is selected
    if (index >= 0 && index < _pages.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _pages[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar3(),

      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Manage Subjects",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xFF187E8A)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add, color: Colors.black),
          ),

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
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: myIndex, // Ensure valid index
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF13A7B1), // Ensure selected icon is colored
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: myIndex == 0 ? const Color(0xFF13A7B1) : Colors.grey, // Color for selected icon
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
              color: myIndex == 1 ? const Color(0xFF13A7B1) : Colors.grey,
            ),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              color: myIndex == 2 ? const Color(0xFF13A7B1) : Colors.grey,
            ),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: myIndex == 3 ? const Color(0xFF13A7B1) : Colors.grey,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
class AddCourseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Implement functionality to add a new course
        print("Add new course");
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFF7C34),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text(
              "Add Course",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


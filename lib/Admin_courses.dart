import 'package:flutter/material.dart';
import 'SideBar_3.dart';
import 'CourseDetailsPage.dart';

class AdminDashboard extends StatelessWidget {
  final String userId;

  AdminDashboard({Key? key, required this.userId}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Key for drawer

  final List<Map<String, dynamic>> courses = [
    {
      "title": "Mathematics OL",
      "center": "Tech Academy",
      "timing": "Mon-Wed 6:00 PM - 8:00 PM",
      "students": 25,
      "color": Colors.blue,
    },
    {
      "title": "Mathematics AS",
      "center": "Data Hub",
      "timing": "Tue-Thu 5:00 PM - 7:00 PM",
      "students": 40,
      "color": Colors.green,
    },
    {
      "title": "Mathematics A2",
      "center": "AI Institute",
      "timing": "Sat-Sun 4:00 PM - 6:00 PM",
      "students": 35,
      "color": Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar3(),
      key: _scaffoldKey, // Assign key to control the drawer
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Manage Courses",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length + 1, // Add one for the "+" button
                itemBuilder: (context, index) {
                  if (index == courses.length) {
                    return AddCourseButton();
                  }
                  final course = courses[index];
                  return CourseCard(
                    title: course["title"],
                    center: course["center"],
                    timing: course["timing"],
                    students: course["students"],
                    color: course["color"],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Coursedetailspage(courseId: course["title"], // or use a real course ID if you have one
                            userId: userId,),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CourseCard extends StatelessWidget {
  final String title;
  final String center;
  final String timing;
  final int students;
  final Color color;
  final VoidCallback onTap;

  CourseCard({
    required this.title,
    required this.center,
    required this.timing,
    required this.students,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(Icons.school, color: color),
              radius: 24,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Center: $center",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Timing: $timing",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "$students Students Enrolled",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseDetailsPage extends StatelessWidget {
  final Map<String, dynamic> course;

  CourseDetailsPage({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course["title"]),
        backgroundColor: course["color"],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course["title"],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text("Center: ${course["center"]}"),
            Text("Timing: ${course["timing"]}"),
            Text("Students Enrolled: ${course["students"]}"),
          ],
        ),
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

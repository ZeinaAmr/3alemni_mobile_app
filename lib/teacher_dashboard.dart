
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SideBar_2.dart';
import 'create_course.dart';
import 'teacher_lms.dart';
import 'package:allemni/CourseDetailsPage.dart';
class TeacherDashboard extends StatefulWidget {
  final String userId;

  const TeacherDashboard({Key? key, required this.userId}) : super(key: key);

  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  late Future<List<Map<String, dynamic>>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = fetchCourses();
  }

  Future<List<Map<String, dynamic>>> fetchCourses() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .where('teacherId', isEqualTo: widget.userId)
        .get();

    List<Map<String, dynamic>> courses = [];

    for (var doc in querySnapshot.docs) {
      final data = doc.data();

      // You can also fetch subject/center name here if needed
      courses.add({
        'title': data['title'] ?? 'Untitled',
        'center': data['centerId'] ?? 'Unknown Center',
        'timing': data['session'] ?? 'No Time',
        'students': data['students'] ?? 0,
        'color': Colors.teal, // You may customize based on data
      });
    }

    return courses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      drawer: Sidebar2(userId: widget.userId),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.search, color: Colors.black),
          ),
          IconButton(
            onPressed: null,
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
            const Text(
              "Enrolled Courses",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _coursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No courses found."));
                  }

                  final courses = snapshot.data!;

                  return ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
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
                              builder: (context) => Coursedetailspage(
                                courseId: course["title"], // or use a real course ID if you have one
                                userId: widget.userId,
                              ),
                            ),
                          );
                        },

                      );
                    },
                  );
                },
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateCoursePage(teacherId: widget.userId),
                  ),
                );
              },
              backgroundColor: const Color(0xFFFF7C34),
              child: const Icon(Icons.add, color: Colors.white,),
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

  const CourseCard({
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
          boxShadow: const [
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 4),
                  Text("Center: $center", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text("Timing: $timing", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text("$students Students Enrolled", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SideBar.dart';
import 'student_LMS.dart';

class StudentDashboard extends StatefulWidget {
  final String userId;

  const StudentDashboard({Key? key, required this.userId}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Map<String, dynamic>>> _enrolledCoursesFuture;

  @override
  void initState() {
    super.initState();
    _enrolledCoursesFuture = fetchEnrolledCourses();
  }

  Future<List<Map<String, dynamic>>> fetchEnrolledCourses() async {
    final enrollmentSnapshot = await FirebaseFirestore.instance
        .collection('enrollments')
        .where('studentId', isEqualTo: widget.userId)
        .get();

    List<Map<String, dynamic>> courses = [];

    for (var enrollment in enrollmentSnapshot.docs) {
      final courseId = enrollment['courseId'];

      final courseDoc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .get();

      if (courseDoc.exists) {
        final courseData = courseDoc.data()!;
        final centerId = courseData['centerId'];
        final subjectId = courseData['subjectId'];
        final teacherId = courseData['teacherId'];

        final centerDoc = await FirebaseFirestore.instance
            .collection('centers')
            .doc(centerId)
            .get();

        final subjectDoc = await FirebaseFirestore.instance
            .collection('subjects')
            .doc(subjectId)
            .get();

        final teacherDoc = await FirebaseFirestore.instance
            .collection('teachers')
            .doc(teacherId)
            .get();

        final centerName = centerDoc.data()?['name'] ?? 'Unknown Center';
        final subjectTitle = subjectDoc.data()?['title'] ?? 'Unknown Subject';
        final teacherName = teacherDoc.data()?['name'] ?? 'Unknown Teacher';

        courses.add({
          'courseId': courseId,
          'title': "$subjectTitle with $teacherName",
          'center': centerName,
          'timing': enrollment['sessionTime'] ?? 'No Time',
          'students': courseData['students'] ?? 0,
          'color': Colors.teal,
        });
      }
    }

    return courses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(userId: widget.userId),
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
                future: _enrolledCoursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No enrolled courses found."));
                  }

                  final courses = snapshot.data!;

                  return ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return CourseCard(
                        title: course['title'],
                        center: course['center'],
                        timing: course['timing'],
                        students: course['students'],
                        color: course['color'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentLMS(
                                courseId: course['courseId'],
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
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Center: $center",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Timing: $timing",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$students Students Enrolled",
                    style: const TextStyle(
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

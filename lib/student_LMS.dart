import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'AttendanceApp.dart';
import 'Sidebar.dart';

class StudentLMS extends StatefulWidget {
  final String courseId;
  final String userId;

  const StudentLMS({Key? key, required this.courseId, required this.userId}) : super(key: key);

  @override
  _StudentLMSState createState() => _StudentLMSState();
}

class _StudentLMSState extends State<StudentLMS> {
  Map<String, dynamic>? courseData;
  bool isLoading = true;

  final Map<String, bool> _sections = {
    "General": true,
    "Week 1": false,
    "Week 2": false,
    "Week 3": false,
    "Week 4": false,
    "Week 5": false,
    "Week 6": false,
  };

  final Map<String, List<String>> _activities = {
    "General": ["Course introduction", "Syllabus overview"],
    "Week 1": ["Topic 1", "Assignment 1"],
    "Week 2": ["Topic 2", "Quiz 1"],
  };

  @override
  void initState() {
    super.initState();
    fetchCourseData();
  }

  Future<void> fetchCourseData() async {
    final doc = await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseId)
        .get();

    if (doc.exists) {
      setState(() {
        courseData = doc.data();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleSection(String section) {
    setState(() {
      _sections[section] = !_sections[section]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoading
            ? "Loading..."
            : (courseData?["title"] ?? "Course")),
        backgroundColor: courseData != null ? Colors.teal : Colors.grey,
      ),
      drawer: Sidebar(userId: widget.userId),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : courseData == null
          ? const Center(child: Text("Course not found"))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseData?["title"] ?? "Course Name",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("Center: ${courseData?["centerId"] ?? "Unknown"}"),
                  Text("${courseData?["students"] ?? 0} Students Enrolled"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _sections.keys.map((section) {
                  return Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            section,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              _sections[section]!
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                            ),
                            onPressed: () => _toggleSection(section),
                          ),
                        ),
                        if (_sections[section]!)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                ...?_activities[section]?.map(
                                      (activity) => ListTile(
                                    title: Text(activity),
                                    leading: const Icon(Icons.check_circle, color: Colors.green),
                                  ),
                                ),
                                if (section.startsWith("Week"))
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF7C34),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      minimumSize: const Size(double.infinity, 50),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AttendanceApp(
                                            userId: widget.userId,
                                            courseId: widget.courseId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Take Attendance for $section",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

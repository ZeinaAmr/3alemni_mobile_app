import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AttendanceApp.dart';
import 'FaceAttendanceApp.dart';
import 'qr_generator.dart';

class Coursedetailspage extends StatefulWidget {
  final String courseId;
  final String userId;

  const Coursedetailspage({
    Key? key,
    required this.courseId,
    required this.userId,
  }) : super(key: key);

  @override
  _CoursedetailsState createState() => _CoursedetailsState();
}

class _CoursedetailsState extends State<Coursedetailspage> {
  bool isLoading = true;
  Map<String, dynamic> course = {
    "title": "",
    "center": "",
    "timing": "",
    "students": 0,
    "color": Colors.blueAccent,
  };

  final Map<String, bool> _sections = {
    "General": true,
    "Week 1": false,
    "Week 2": false,
    "Week 3": false,
    "Week 4": false,
    "Week 5": false,
    "Week 6": false,
  };

  final Map<String, List<String>> _activities = {};

  @override
  void initState() {
    super.initState();
    _loadCourseData();
  }

  Future<void> _loadCourseData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          course = {
            "title": data['title'] ?? '',
            "center": data['centerId'] ?? '',
            "timing": data['timing'] ?? '',
            "students": data['students'] ?? 0,
            "color": Colors.blueAccent,
          };
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error loading course data: $e');
      setState(() => isLoading = false);
    }
  }

  void _toggleSection(String section) {
    setState(() {
      _sections[section] = !_sections[section]!;
    });
  }

  void _addActivity(String section) {
    // ... (same as before)
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(course["title"].isEmpty ? "Course Details" : course["title"]),
        backgroundColor: course["color"],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course["title"],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("Center: ${course["center"]}"),Text("Timing: ${course["timing"]}"),
                  Text("${course["students"]} Students Enrolled"),
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
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              _sections[section]! ? Icons.expand_less : Icons.expand_more,
                            ),
                            onPressed: () => _toggleSection(section),
                          ),
                        ),
                        if (_sections[section]!)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                ...?_activities[section]?.map((activity) =>
                                    ListTile(
                                      title: Text(activity),
                                      leading: const Icon(Icons.check_circle, color: Colors.green),
                                    ),
                                ),
                                TextButton(
                                  onPressed: () => _addActivity(section),
                                  child: const Text("Add Activity", style: TextStyle(color: Color(0xFF13A7B1))),
                                ),
                                if (section.startsWith("Week")) ...[
                                  const SizedBox(height: 10),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.location_on),
                                    label: const Text("Take Attendance (QR)"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    ),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => QRGeneratorPage(
                                          userId: widget.userId,
                                          courseId: widget.courseId,
                                          classId: widget.courseId,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.person),
                                    label: const Text("Take Attendance (Geo)"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    ),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AttendanceApp(
                                          userId: widget.userId,
                                          courseId: widget.courseId,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.face),
                                    label: const Text("Take Attendance (Face)"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    ),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FaceAttendanceApp(),
                                      ),
                                    ),
                                  ),
                                ]
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

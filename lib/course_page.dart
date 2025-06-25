import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SideBar.dart';
import 'enroll_page.dart';

class CoursesPage extends StatelessWidget {
  final String userId;
  final String? subjectId;

  const CoursesPage({Key? key, required this.userId, this.subjectId}) : super(key: key);

  bool _isNetworkImage(String path) => path.startsWith('http');

  Widget _buildCourseImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(height: 180, color: Colors.grey.shade200);
    }
    return _isNetworkImage(imagePath)
        ? Image.network(imagePath, height: 180, width: double.infinity, fit: BoxFit.cover)
        : Image.asset(imagePath, height: 180, width: double.infinity, fit: BoxFit.cover);
  }

  Future<Map<String, dynamic>> _fetchExtraInfo(String teacherId, String subjectId) async {
    final teacherDoc = await FirebaseFirestore.instance.collection('teachers').doc(teacherId).get();
    final subjectDoc = await FirebaseFirestore.instance.collection('subjects').doc(subjectId).get();

    return {
      'teacher': teacherDoc.data()?['name'] ?? 'Unknown Teacher',
      'subject': subjectDoc.data()?['title'] ?? 'Unknown Subject',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(userId: userId),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Courses", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF187E8A))),
        centerTitle: true,
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.search, color: Colors.black)),
          IconButton(onPressed: null, icon: Icon(Icons.filter_alt_rounded, color: Colors.black)),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: subjectId != null
              ? FirebaseFirestore.instance.collection('courses').where('subjectId', isEqualTo: subjectId).snapshots()
              : FirebaseFirestore.instance.collection('courses').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No courses available."));
            }

            final courseDocs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: courseDocs.length,
              itemBuilder: (context, index) {
                final courseData = courseDocs[index].data() as Map<String, dynamic>;
                final courseId = courseDocs[index].id;

                return FutureBuilder<Map<String, dynamic>>(
                  future: _fetchExtraInfo(courseData['teacherId'], courseData['subjectId']),
                  builder: (context, extraSnapshot) {
                    if (!extraSnapshot.hasData) {
                      return const SizedBox(height: 150, child: Center(child: CircularProgressIndicator()));
                    }

                    final teacher = extraSnapshot.data!['teacher'];
                    final subject = extraSnapshot.data!['subject'];

                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: _buildCourseImage(courseData['image']),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  teacher,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  subject,
                                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Session Period: ${courseData['session'] ?? ''}",
                                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.currency_pound, size: 16, color: Color(0xFF187E8A)),
                                    const SizedBox(width: 4),
                                    Text(courseData['price'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.black)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.wifi, size: 16, color: Color(0xFF187E8A)),
                                    const SizedBox(width: 4),
                                    Text(courseData['mode'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.black)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.people, size: 16, color: Color(0xFF187E8A)),
                                    const SizedBox(width: 4),
                                    Text("${courseData['students'] ?? ''} students", style: const TextStyle(fontSize: 14, color: Colors.black)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EnrollCoursePage(courseId: courseId, userId: userId),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF7C34),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                    ),
                                    child: const Text("Enroll now", style: TextStyle(fontSize: 16, color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

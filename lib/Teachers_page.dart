import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'course_page.dart';
import 'SideBar.dart';

class TeachersPage extends StatelessWidget {
  final String? userId;

  const TeachersPage({Key? key, this.userId}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchTeachers() async {
    final teachersSnapshot = await FirebaseFirestore.instance.collection('teachers').get();
    List<Map<String, dynamic>> teachers = [];

    for (var doc in teachersSnapshot.docs) {
      final teacher = doc.data();
      final subjectId = teacher['subjectId'];

      final subjectDoc = await FirebaseFirestore.instance.collection('subjects').doc(subjectId).get();
      final subjectName = subjectDoc.data()?['title'] ?? 'Unknown';

      teachers.add({
        "name": teacher['name'],
        "subject": subjectName,
        "subjectId": subjectId,
        "image": teacher['image'],
        "id": doc.id,
      });
    }
    return teachers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: userId != null ? Sidebar(userId: userId!) : null, // safely used
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Teachers",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF187E8A)),
        ),
        centerTitle: true,
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.search, color: Colors.black)),
          IconButton(onPressed: null, icon: Icon(Icons.filter_alt_rounded, color: Colors.black)),
          SizedBox(width: 10),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTeachers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final teachers = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                final teacher = teachers[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoursesPage(
                          subjectId: teacher['subjectId'],
                          userId: userId ?? "", // fallback if null
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              teacher['image'],
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  teacher['name'],
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  teacher['subject'],
                                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

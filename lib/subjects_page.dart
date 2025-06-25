import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SideBar.dart';
import 'course_page.dart';

class SubjectsPage extends StatefulWidget {
  final String userId;

  const SubjectsPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(userId: widget.userId),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Subjects",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF187E8A)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.black),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_alt_rounded, color: Colors.black),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('subjects').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final subjects = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index].data() as Map<String, dynamic>;
                final subjectId = subjects[index].id;

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
                        (subject['title'] ?? 'S')[0],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      subject['title'] ?? 'No Title',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                    ),
                    subtitle: Text(
                      subject['description'] ?? '',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFFF7C34)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoursesPage(
                            subjectId: subjectId,
                            userId: widget.userId,
                          ),
                        ),
                      );
                    },
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

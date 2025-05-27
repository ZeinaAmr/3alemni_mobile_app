import 'package:flutter/material.dart';
import 'course_page.dart';
import 'SideBar.dart';
class TeachersPage extends StatelessWidget {
  TeachersPage({Key? key}) : super(key: key);

  final List<Map<String, String>> teachers = [
    {
      "name": "Maram Hamed",
      "subject": "IGCSE Mathematics OL & IAL Teacher",

      "image": "assets/Teacher1.jpg",
    },
    {
      "name": "Ahmed Khafagah",
      "subject": "IGCSE CS & ICT OL & IAL Teacher",
      "image": "assets/Teacher2.jpg",
    },
    {
      "name": "Mirelle Osama",
      "subject": "IGCSE English Teacher For Year 8 Checkpoint, Core, OL, & IAL",
      "image": "assets/Teacher3.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Teachers",
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
          itemCount: teachers.length,
          itemBuilder: (context, index) {
            final teacher = teachers[index];
            return GestureDetector(
              onTap: () {
                // ✅ Remove const here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoursesPage()),
                );
              },
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          teacher['image']!,
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
                              teacher['name']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              teacher['subject']!,
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
      ),
    );
  }
}

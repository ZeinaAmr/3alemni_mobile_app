import 'package:flutter/material.dart';
import 'package:allemni/SideBar_2.dart';
class MyCoursesPage extends StatelessWidget {
  MyCoursesPage({Key? key}) : super(key: key);

  final List<Map<String, String>> courses = [
    {
      "title": "",
      "subject": "Mathematics",
      "session": "Monday & Wednesday",
      "price": "£7500 per paper",
      "mode": "Online",
      "students": "20",
      "image": "assets/Teacher2.jpg",
    },
    {
      "title": "Ahmed Khafagah",
      "subject": "Mathematics",
      "session": "Tuesday & Thursday",
      "price": "£6500 per paper",
      "mode": "Offline",
      "students": "25",
      "image": "assets/Teacher2.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar2(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "My Courses",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF13A7B1),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.asset(
                      course['image']!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Course Details
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['title']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          course['subject']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Session Period: ${course['session']!}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.currency_pound, size: 16, color: Color(0xFF187E8A)),
                            const SizedBox(width: 4),
                            Text(
                              course['price']!,
                              style: const TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.wifi, size: 16, color: Color(0xFF187E8A)),
                            const SizedBox(width: 4),
                            Text(
                              course['mode']!,
                              style: const TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.people, size: 16, color: Color(0xFF187E8A)),
                            const SizedBox(width: 4),
                            Text(
                              "${course['students']} students",
                              style: const TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Enroll Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Enroll Action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF7C34),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            ),
                            child: const Text(
                              "Enroll now",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

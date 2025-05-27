import 'package:flutter/material.dart';
import 'SideBar_3.dart';
class CourseRequestScreen extends StatelessWidget {
  final List<Map<String, String>> courses = [
    {
      "title": "Mathematics",
      "center": "Cairo Center",
      "time": "10:00 AM - 12:00 PM",
      "session": "Weekly (Monday)"
    },
    {
      "title": "Physics",
      "center": "Alexandria Center",
      "time": "2:00 PM - 4:00 PM",
      "session": "Bi-Weekly (Wednesday)"
    },
    {
      "title": "Chemistry",
      "center": "Giza Center",
      "time": "4:00 PM - 6:00 PM",
      "session": "Weekly (Friday)"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar3(),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Manage Courses",
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
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return Card(
              color: Colors.white,
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Course Request: ${course["title"]}",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF187E8A)
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("Center: ${course["center"]}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Time: ${course["time"]}"),
                    Text("Session: ${course["session"]}"),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),

                          ),
                          child: const Text("Approve",style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Reject",style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


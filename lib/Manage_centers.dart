import 'package:flutter/material.dart';
import 'Teachers_page.dart';
import 'SideBar_3.dart';

class ManageCenters extends StatelessWidget {
  ManageCenters({Key? key}) : super(key: key);

  final List<Map<String, String>> centers = [
    {"name": "IG Zone", "location": "Mohandessin, Lebanon Street", "image": "assets/igzone.jpeg"},
    {"name": "JTA", "location": "Sheikh Zayed, Beverly Hills", "image": "assets/jta.jpg"},
    {"name": "Genius", "location": "Nasr City, Hay el Sefarat", "image": "assets/genius.jpg"},
    {"name": "Infinity", "location": "Fifth Settlement, Point 90", "image": "assets/infinity.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar3(),

      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Manage Centers",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xFF187E8A)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: centers.length,
          itemBuilder: (context, index) {
            final center = centers[index];
            return GestureDetector(
              onTap: () {
                // ✅ Remove const here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeachersPage()),
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
                          center['image']!,
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
                              center['name']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Color(0xFF13A7B1)),
                                const SizedBox(width: 5),
                                Text(
                                  center['location']!,
                                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                              ],
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


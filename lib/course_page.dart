import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SideBar.dart';
import 'enroll_page.dart';

class CoursesPage extends StatefulWidget {
  final String userId;
  final String? subjectId;

  const CoursesPage({Key? key, required this.userId, this.subjectId}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  String _searchText = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  bool _isNetworkImage(String path) => path.startsWith('http');

  Widget _buildCourseImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Image.asset('assets/default.jpg', height: 180, width: double.infinity, fit: BoxFit.cover);
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

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Filter Options", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // TODO: Add filter logic
                  Navigator.pop(context);
                },
                child: const Text("Apply Filter"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(userId: widget.userId),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search by teacher or subject...',
            border: InputBorder.none,
          ),
        )
            : const Text(
          "Courses",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF187E8A)),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.black),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchController.clear();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_rounded, color: Colors.black),
            onPressed: _showFilterDialog,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: widget.subjectId != null
              ? FirebaseFirestore.instance
              .collection('courses')
              .where('subjectId', isEqualTo: widget.subjectId)
              .snapshots()
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

                    if (_searchText.isNotEmpty &&
                        !(teacher.toLowerCase().contains(_searchText) ||
                            subject.toLowerCase().contains(_searchText))) {
                      return const SizedBox(); // Filter out
                    }

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
                                          builder: (context) => EnrollCoursePage(courseId: courseId, userId: widget.userId),
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

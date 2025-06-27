import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'course_page.dart';
import 'SideBar.dart';

class TeachersPage extends StatefulWidget {
  final String? userId;

  const TeachersPage({Key? key, this.userId}) : super(key: key);

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  List<Map<String, dynamic>> _allTeachers = [];
  String _searchText = '';
  String? _selectedSubject;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> _fetchTeachers() async {
    final teachersSnapshot = await FirebaseFirestore.instance.collection('teachers').get();
    List<Map<String, dynamic>> teachers = [];

    for (var doc in teachersSnapshot.docs) {
      final teacher = doc.data();
      final subjectId = teacher['subjectId'];

      final subjectDoc =
      await FirebaseFirestore.instance.collection('subjects').doc(subjectId).get();
      final subjectName = subjectDoc.data()?['title'] ?? 'Unknown';

      teachers.add({
        "name": teacher['name'] ?? 'No Name',
        "subject": subjectName,
        "subjectId": subjectId,
        "image": teacher['image'] ?? 'assets/default.jpeg',
        "id": doc.id,
      });
    }

    setState(() {
      _allTeachers = teachers;
    });
  }

  void _showFilterDialog() {
    final subjects = _allTeachers.map((t) => t['subject']).toSet().toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Filter by Subject",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF187E8A)),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: subjects.map((subject) {
                  return ChoiceChip(
                    label: Text(subject),
                    selected: _selectedSubject == subject,
                    selectedColor: const Color(0xFF13A7B1),
                    backgroundColor: const Color(0xFFF0F0F0),
                    labelStyle: TextStyle(
                      color: _selectedSubject == subject ? Colors.white : Colors.black,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedSubject = selected ? subject : null;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF187E8A),
                        backgroundColor: const Color(0xFFEFF6F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedSubject = null;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Clear Filter"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13A7B1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Apply"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTeachers = _allTeachers.where((teacher) {
      final nameMatch = teacher['name'].toLowerCase().contains(_searchText);
      final subjectMatch =
          _selectedSubject == null || teacher['subject'] == _selectedSubject;
      return nameMatch && subjectMatch;
    }).toList();

    return Scaffold(
      drawer: widget.userId != null ? Sidebar(userId: widget.userId!) : null,
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search Teachers...',
            border: InputBorder.none,
          ),
        )
            : const Text(
          "Teachers",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF187E8A)),
        ),
        centerTitle: true,
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
      body: _allTeachers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: filteredTeachers.length,
          itemBuilder: (context, index) {
            final teacher = filteredTeachers[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoursesPage(
                      subjectId: teacher['subjectId'],
                      userId: widget.userId ?? '',
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
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              teacher['subject'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
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

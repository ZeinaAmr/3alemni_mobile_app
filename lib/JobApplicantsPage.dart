import 'package:flutter/material.dart';

class JobApplicantsPage extends StatefulWidget {
  @override
  _JobApplicantsPageState createState() => _JobApplicantsPageState();
}

class _JobApplicantsPageState extends State<JobApplicantsPage> {
  List<Map<String, String>> applicants = [
    {
      'name': 'Ahmed Hamdy',
      'email': 'Hamdy@gmail.com',
      'cvUrl': 'https://example.com/cv/Ahmed_Hamdy.pdf',
    },
    {
      'name': 'Nadeen Tarek',
      'email': 'Nadeen@gmail.com',
      'cvUrl': 'https://example.com/cv/Nadeen_Tarek.pdf',
    },
  ];

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("✅ Success"),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _onAccept(int index) {
    String name = applicants[index]['name']!;
    setState(() {
      applicants.removeAt(index);
    });

  }

  void _onReject(int index) {
    String name = applicants[index]['name']!;
    setState(() {
      applicants.removeAt(index);
    });

  }

  void _onDownloadCV() {
    _showDialog("CV downloaded successfully.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Applicants'),
        backgroundColor: const Color(0xFF13A7B1),
      ),
      body: applicants.isEmpty
          ? const Center(child: Text('No applicants left.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: applicants.length,
        itemBuilder: (context, index) {
          final applicant = applicants[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 30, color: Color(0xFF13A7B1)),
                      const SizedBox(width: 10),
                      Text(
                        applicant['name'] ?? 'Unknown',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Email: ${applicant['email']}'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _onDownloadCV,
                    child: const Text(
                      'View CV',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _onAccept(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text("Accept", style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () => _onReject(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.close, color: Colors.white),
                        label: const Text("Reject", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

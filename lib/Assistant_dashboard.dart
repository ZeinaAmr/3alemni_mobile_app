import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AssistantsDashboard(),
    );
  }
}

class AssistantsDashboard extends StatefulWidget {
  @override
  _AssistantsDashboardState createState() => _AssistantsDashboardState();
}

class _AssistantsDashboardState extends State<AssistantsDashboard> {
  final List<Map<String, String>> jobOffers = [
    {
      'title': 'Math Assistant',
      'type': 'Online',
      'location': 'Remote',
      'teacher name': 'Ahmed Khafagah',
      'description': 'Assist students in learning math topics online.',
      'requirements': 'Strong math background, excellent communication skills.',
      'salary': '\$20/hour',
      'deadline': '10th Feb 2025'
    },
    {
      'title': 'Physics Tutor',
      'type': 'On-Ground',
      'location': 'Cairo',
      'teacher name': 'Maged Wageeh',
      'description': 'Teach physics to high school students in person.',
      'requirements': 'Physics degree, teaching experience.',
      'salary': '\$30/hour',
      'deadline': '15th Feb 2025'
    },
    {
      'title': 'Programming Mentor',
      'type': 'Online',
      'location': 'Remote',
      'teacher name': 'Maram Hamed',
      'description': 'Guide students through programming assignments.',
      'requirements': 'Proficiency in programming languages (Python, Java).',
      'salary': '\$25/hour',
      'deadline': '12th Feb 2025'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Available Jobs",
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
          itemCount: jobOffers.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xFF187E8A),
                  child: Icon(Icons.work, color: Colors.white),
                ),
                title: Text(
                  jobOffers[index]['title']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type: ${jobOffers[index]['type']}'),
                    Text('Location: ${jobOffers[index]['location']}'),
                  ],
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF7C34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailsPage(job: jobOffers[index]),
                      ),
                    );
                  },
                  child: Text(
                    'View',
                    style: TextStyle(color: Colors.white),
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

class JobDetailsPage extends StatefulWidget {
  final Map<String, String> job;

  JobDetailsPage({required this.job});

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  String? fileName;

  void pickFile() {
    setState(() {
      fileName = "sample_document.pdf"; // Simulated file selection
    });
  }

  void applyForJob() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Job applied successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text(
          "Job Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xFF187E8A)),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.job['title']!,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF187E8A),
              ),
            ),
            SizedBox(height: 10),
            Text('Type', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(widget.job['type']!,style: TextStyle(fontSize: 16,)),
            SizedBox(height: 20),
            Text('Location', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
            Text(widget.job['location']!,style: TextStyle(fontSize: 16,)),
            SizedBox(height: 20),
            Text('Job Description:', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
            Text(widget.job['description']!,style: TextStyle(fontSize: 16,)),
            SizedBox(height: 20),
            Text('Requirements:', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
            Text(widget.job['requirements']!,style: TextStyle(fontSize: 16,)),
            SizedBox(height: 20),
            Text('Salary: ${widget.job['salary']}', style: TextStyle(fontSize: 16,color: Colors.green)),
            Text('Application Deadline: ${widget.job['deadline']}', style: TextStyle(fontSize: 16,color: Colors.red)),
            SizedBox(height: 20),
            GestureDetector(
              onTap: pickFile,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF187E8A)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.attach_file, color: Color(0xFF187E8A)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fileName ?? "Attach your CV (PDF or DOCX)",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 45),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF7C34),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: applyForJob,
                child: Text(
                  'Apply Now',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

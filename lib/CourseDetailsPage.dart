import 'package:flutter/material.dart';

class Coursedetailspage extends StatefulWidget {
  const Coursedetailspage({Key? key}) : super(key: key);

  @override
  _CoursedetailsState createState() => _CoursedetailsState();
}

class _CoursedetailsState extends State<Coursedetailspage> {
  final Map<String, dynamic> course = {
    "title": "Course Name",
    "center": "Default Center",
    "timing": "10:00 AM - 12:00 PM",
    "students": 50,
    "color": Colors.blueAccent, // Default color
  };

  final Map<String, bool> _sections = {
    "General": true,
    "Week 1": false,
    "Week 2": false,
    "Week 3": false,
    "Week 4": false,
    "Week 5": false,
    "Week 6": false,
  };

  final Map<String, List<String>> _activities = {};

  void _toggleSection(String section) {
    setState(() {
      _sections[section] = !_sections[section]!;
    });
  }

  void _addActivity(String section) {
    TextEditingController activityController = TextEditingController();
    String selectedType = "Quiz";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Activity"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: activityController,
                    decoration: const InputDecoration(hintText: "Enter activity name"),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedType = newValue!;
                      });
                    },
                    items: ["Quiz", "Assignment", "Material", "Zoom Link"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (activityController.text.isNotEmpty) {
                      setState(() {
                        _activities.putIfAbsent(section, () => []).add("$selectedType: ${activityController.text}");
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course["title"]),
        backgroundColor: course["color"],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course["title"],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("Center: ${course["center"]}"),
                  Text("Timing: ${course["timing"]}"),
                  Text("${course["students"]} Students Enrolled"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _sections.keys.map((section) {
                  return Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            section,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              _sections[section]! ? Icons.expand_less : Icons.expand_more,
                            ),
                            onPressed: () => _toggleSection(section),
                          ),
                        ),
                        if (_sections[section]!)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                ...?_activities[section]?.map((activity) => ListTile(
                                  title: Text(activity),
                                  leading: const Icon(Icons.check_circle, color: Colors.green),
                                )),
                                TextButton(
                                  onPressed: () => _addActivity(section),
                                  child: const Text("Add Activity", style: TextStyle(color: Color(0xFF13A7B1))),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'SideBar.dart';

class NotificationsPage extends StatelessWidget {
  final String userId; // ✅ updated

  const NotificationsPage({Key? key, required this.userId}) : super(key: key); // ✅ updated

  final List<Map<String, String>> notifications = const [
    {
      "sender": "Ahmed Khafagah",
      "message": "uploaded an assignment.",
      "time": "10:30 AM"
    },
    {
      "sender": "Sarah Smith",
      "message": "posted a new course update.",
      "time": "9:15 AM"
    },
    {
      "sender": "AI Assistant",
      "message": "reminded you about your upcoming quiz.",
      "time": "8:00 AM"
    },
    {
      "sender": "Professor Adams",
      "message": "shared new learning material.",
      "time": "7:45 AM"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(userId: userId), // ✅ updated
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Notications",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF187E8A),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFFC229),
                child: Icon(Icons.notifications, color: Colors.white),
              ),
              title: Text(
                "${notification['sender']} ${notification['message']}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                notification['time']!,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                // Optional: Add navigation to a detail view
              },
            ),
          );
        },
      ),
    );
  }
}

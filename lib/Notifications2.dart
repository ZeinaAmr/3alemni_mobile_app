import 'package:flutter/material.dart';
import 'SideBar_2.dart';
class NotificationsPage2 extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      "sender": "Ahmed Samir",
      "message": "submitted an assignment.",
      "time": "10:30 AM"
    },
    {
      "sender": "Sarah Smith",
      "message": "submitted a quiz.",
      "time": "9:15 AM"
    },
    {
      "sender": "Mohamed Raafat",
      "message": "submitted an assignment.",
      "time": "8:00 AM"
    },
    {
      "sender": "Lara Hany",
      "message": "submitted a quiz.",
      "time": "7:45 AM"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar2(),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Notications",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xFF187E8A)),
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
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF187E8A),
                child: const Icon(Icons.mail, color: Colors.white),
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
                // Add navigation or details functionality here
              },
            ),
          );
        },
      ),
    );
  }
}

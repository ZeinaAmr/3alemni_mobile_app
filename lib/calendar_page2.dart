import 'package:flutter/material.dart';
import 'SideBar_2.dart';
import 'HomePage.dart';
import 'chatbot_page.dart';
import 'ProfilePage.dart';

class CalendarPage2 extends StatefulWidget {
  @override
  _CalendarPageState2 createState() => _CalendarPageState2();
}

class _CalendarPageState2 extends State<CalendarPage2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> upcomingEvents = [
    {"title": "Math Exam", "date": "12 Dec, 2024", "time": "10:00 AM"},
    {"title": "Science Quiz", "date": "15 Dec, 2024", "time": "12:00 PM"},
  ];

  final List<Map<String, String>> pendingEvents = [
    {"title": "History Assignment", "date": "8 Dec, 2024", "time": "11:59 PM"},
    {"title": "Literature Essay", "date": "9 Dec, 2024", "time": "3:00 PM"},
  ];

  final List<Map<String, String>> completedEvents = [
    {"title": "Computer Science Project", "date": "5 Dec, 2024", "time": "4:00 PM"},
    {"title": "Physics Lab", "date": "2 Dec, 2024", "time": "2:00 PM"},
  ];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildEventList(List<Map<String, String>> events) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3,
          color: Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFFF7C34),
              child: Icon(Icons.event, color: Colors.white),
            ),
            title: Text(
              event['title']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF000000),
              ),
            ),
            subtitle: Text(
              "${event['date']} at ${event['time']}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFFF7C34),
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar2(),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text(
          "My Calendar",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xFF187E8A)),
        ),
        centerTitle: true,

        backgroundColor: const Color(0xFFF8F9FC),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFFC229),
          labelColor: Color(0xFF187E8A),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "Assigned"),
            Tab(text: "Missing"),
            Tab(text: "Done"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventList(upcomingEvents),
          _buildEventList(pendingEvents),
          _buildEventList(completedEvents),
        ],
      ),

    );
  }
}

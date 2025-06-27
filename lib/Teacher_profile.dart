import 'package:flutter/material.dart';
import 'SideBar_2.dart';

class TeacherProfile extends StatelessWidget {
  final String userId;
  const TeacherProfile({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar2(userId: userId),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xFF187E8A)),
        ),
        centerTitle: true,

        backgroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/avatar.png"),
            ),
            const SizedBox(height: 16),
            const Text(
              "Zeina Amr",  // Replace with dynamic data
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "zeina@example.com",  // Replace with dynamic data
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Role"),
                subtitle: const Text("Teacher"), // Replace with dynamic data
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage(userId:userId)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7C34),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),

    );
  }
}
class EditProfilePage extends StatelessWidget {
  final String userId;

  const EditProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar2(userId: userId),
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFF13A7B1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Name",
                hintText: "Enter your name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: "Student",
              items: const [
                DropdownMenuItem(child: Text("Student"), value: "Student"),
                DropdownMenuItem(child: Text("Teacher"), value: "Teacher"),
                DropdownMenuItem(child: Text("Assistant"), value: "Assistant"),
              ],
              onChanged: (value) {
                // Handle role change
              },
              decoration: InputDecoration(
                labelText: "Role",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7C34),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

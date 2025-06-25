import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Admin_courses.dart';
import 'SignUpPage.dart';
import 'ForgotPasswordPage.dart';
import 'HomePage.dart';
import 'teacher_dashboard.dart';
import 'Assistant_dashboard.dart';
import 'student_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  void _loginUser() async {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Please enter both email and password.");
      return;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _showMessage("User not found.");
        return;
      }

      final doc = querySnapshot.docs.first;
      final userData = doc.data();
      final userId = doc.id;

      if (userData['password'] != password) {
        _showMessage("Incorrect password.");
        return;
      }

      final role = userData['role'] ?? 'Student';

      Widget targetPage;
      switch (role) {
        case "Teacher":
          targetPage = TeacherDashboard(userId: userId);
          break;
        case "Assistant":
          targetPage = AssistantsDashboard(userId: userId);
          break;
        case "Admin":
          targetPage = AdminDashboard(userId: userId);
          break;
        default:
          targetPage = HomePage(userId: userId);
          break;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => targetPage),
      );
    } catch (e) {
      _showMessage("Login failed: $e");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            const Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Image.asset('assets/Computer login-amico.png', height: 250),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0x1D13A7B1),
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF13A7B1)),
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0x1D13A7B1),
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF13A7B1)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF13A7B1),
                    ),
                    onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                  ),
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7C34),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Login", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignUpPage()));
              },
              child: const Text.rich(
                TextSpan(
                  text: "Don’t have an Account? ",
                  style: TextStyle(color: Colors.black54),
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: TextStyle(color: Color(0xFFD85E09), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) =>  ForgotPasswordPage()));
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text("Forgot Password?", style: TextStyle(color: Colors.black54)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

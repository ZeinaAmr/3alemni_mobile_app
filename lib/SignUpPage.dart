import 'package:allemni/Admin_courses.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart'; // Import pages for navigation
import 'teacher_dashboard.dart'; // Example Teacher Dashboard
import 'Assistant_dashboard.dart'; // Example Assistant Dashboard
import 'LoginPage.dart';
// Example Student Dashboard

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? selectedRole; // Stores selected role

  void _navigateToRolePage(BuildContext context) {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a role before signing up")),
      );
      return;
    }

    Widget targetPage;
    switch (selectedRole) {
      case "Student":
        targetPage = HomePage();
        break;
      case "Teacher":
        targetPage = TeacherDashboard();
        break;
      case "Assistant":
        targetPage = AssistantsDashboard();
      case "Admin":
        targetPage = AdminDashboard();
        break;
      default:
        targetPage = HomePage(); // Fallback page
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
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
            const Text(
              "SIGN UP",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/Sign up-amico.png',
              height: 250,
            ),
            const SizedBox(height: 20),

            // First Name & Last Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTextField(Icons.person, "First Name"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(Icons.person, "Last Name"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: _buildTextField(Icons.email, "Email"),
            ),
            const SizedBox(height: 20),

            // Password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: _buildPasswordField("Password"),
            ),
            const SizedBox(height: 20),

            // Confirm Password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: _buildPasswordField("Confirm Password"),
            ),
            const SizedBox(height: 20),

            // Role Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: DropdownButtonFormField<String>(
                decoration: _buildInputDecoration(Icons.school),
                value: selectedRole,
                hint: const Text("Select Role"),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
                items: ["Student", "Teacher", "Assistant","Admin"]
                    .map(
                      (role) => DropdownMenuItem<String>(
                    value: role,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(role),
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Sign Up Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _navigateToRolePage(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7C34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sign Up Option
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text.rich(
                TextSpan(
                  text: "Already have an Account? ",
                  style: TextStyle(color: Colors.black54),
                  children: [
                    TextSpan(
                      text: "Login",
                      style: TextStyle(
                        color: Color(0xFFD85E09),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Input Field
  Widget _buildTextField(IconData icon, String hint) {
    return TextField(
      decoration: _buildInputDecoration(icon).copyWith(hintText: hint),
    );
  }

  // Custom Password Field
  Widget _buildPasswordField(String hint) {
    return TextField(
      obscureText: true,
      decoration: _buildInputDecoration(Icons.lock).copyWith(
        hintText: hint,
        suffixIcon: const Icon(Icons.visibility, color: Color(0xFF13A7B1)),
      ),
    );
  }

  // Common Input Decoration
  InputDecoration _buildInputDecoration(IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0x1D13A7B1),
      prefixIcon: Icon(icon, color: const Color(0xFF13A7B1)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }
}
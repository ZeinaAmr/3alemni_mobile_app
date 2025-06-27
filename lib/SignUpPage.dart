import 'package:allemni/FaceRegistrationPage.dart';
import 'package:allemni/fmain.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'LoginPage.dart';
import 'HomePage.dart';
import 'teacher_dashboard.dart';
import 'Assistant_dashboard.dart';
import 'Admin_courses.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmVisible = false;

  String? selectedRole;
  bool emailExists = false;

  Future<bool> _isEmailUnique(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isEmpty;
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      final email = _email.text.trim();
      final password = _password.text.trim();

      final isUnique = await _isEmailUnique(email);
      if (!isUnique) {
        setState(() {
          emailExists = true;
        });
        _formKey.currentState!.validate();
        return;
      }

      final rolePrefix = {
        'Student': 'stu',
        'Teacher': 'teach',
        'Assistant': 'assis',
        'Admin': 'admin'
      }[selectedRole] ?? 'user';

      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: selectedRole)
          .get();

      final id = "$rolePrefix${(query.docs.length + 1).toString().padLeft(3, '0')}";

      await FirebaseFirestore.instance.collection('users').doc(id).set({
        'firstName': _firstName.text.trim(),
        'lastName': _lastName.text.trim(),
        'email': email,
        'password': password,
        'role': selectedRole,
        'createdAt': Timestamp.now(),
      });

      // ✅ Navigate to correct page with userId
      Widget page;
      switch (selectedRole) {
        case 'Student':
          page = HomePage(userId: id);
          break;
        case 'Teacher':
          page = TeacherDashboard(userId: id);
          break;
        case 'Assistant':
          page = AssistantsDashboard(userId: id);
          break;
        case 'Admin':
          page = AdminDashboard(userId: id);
          break;
        default:
          page = HomePage(userId: id);
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
    }
  }

  InputDecoration _inputDecoration(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: const Color(0x1D13A7B1),
    prefixIcon: Icon(icon, color: const Color(0xFF13A7B1)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
  );

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z][a-zA-Z0-9._]*@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return regex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 8 &&
        password.length <= 20 &&
        !password.contains(' ') &&
        RegExp(r'[a-zA-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text("SIGN UP", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Image.asset('assets/Sign up-amico.png', height: 250),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstName,
                        decoration: _inputDecoration("First Name", Icons.person),
                        validator: (value) => value == null || value.trim().isEmpty ? 'First name required' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _lastName,
                        decoration: _inputDecoration("Last Name", Icons.person),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Last name required' : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: _email,
                  decoration: _inputDecoration("Email", Icons.email),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Email is required';
                    if (value.contains(' ')) return 'Email cannot contain spaces';
                    if (!_isValidEmail(value)) return 'Enter a valid email';
                    if (emailExists) return 'Email already registered';
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: _password,
                  obscureText: !_passwordVisible,
                  decoration: _inputDecoration("Password", Icons.lock).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF13A7B1),
                      ),
                      onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password is required';
                    if (!_isValidPassword(value)) return '8-20 chars, letters+digits, no spaces';
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: _confirmPassword,
                  obscureText: !_confirmVisible,
                  decoration: _inputDecoration("Confirm Password", Icons.lock).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmVisible ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF13A7B1),
                      ),
                      onPressed: () => setState(() => _confirmVisible = !_confirmVisible),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Confirm your password';
                    if (value != _password.text) return 'Passwords do not match';
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Select Role", Icons.school),
                  value: selectedRole,
                  hint: const Text("Select Role"),
                  validator: (value) => value == null ? 'Please select a role' : null,
                  onChanged: (value) => setState(() => selectedRole = value),
                  items: ["Student", "Teacher", "Assistant", "Admin"]
                      .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7C34),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Sign Up", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginPage())),
                child: const Text.rich(
                  TextSpan(
                    text: "Already have an Account? ",
                    style: TextStyle(color: Colors.black54),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(color: Color(0xFFD85E09), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

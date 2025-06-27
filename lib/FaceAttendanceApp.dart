import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FaceAttendanceApp extends StatelessWidget {
  final String? courseId;
  final String? userId;

  const FaceAttendanceApp({Key? key, this.courseId, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ❌ DO NOT use MaterialApp inside nested page — causes black screen
    return FaceAttendanceHome(); // Return the page directly instead
  }
}

class FaceAttendanceHome extends StatefulWidget {
  const FaceAttendanceHome({Key? key}) : super(key: key);

  @override
  _FaceAttendanceHomeState createState() => _FaceAttendanceHomeState();
}

class _FaceAttendanceHomeState extends State<FaceAttendanceHome> {
  File? _image;
  final picker = ImagePicker();
  final String backendUrl = 'http://192.168.100.139:5000';

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerFace() async {
    if (_image == null) return;

    var request = http.MultipartRequest('POST', Uri.parse('$backendUrl/register'));
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    var result = json.decode(responseBody);

    _showMessage(result['message']);
  }

  Future<void> _verifyFace() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });

    var request = http.MultipartRequest('POST', Uri.parse('$backendUrl/verify'));
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    var result = json.decode(responseBody);

    _showMessage(result['success']
        ? (result['matched']
        ? "✅ Face verified. Attendance marked!"
        : "❌ Face not similar.")
        : result['message']);
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Result'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK')),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: _image != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(_image!, width: 200, height: 200, fit: BoxFit.cover),
      )
          : const Padding(
        padding: EdgeInsets.all(50),
        child: Icon(Icons.person_outline, size: 100, color: Colors.grey),
      ),
    );
  }

  Widget _customButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Attendance"),
        backgroundColor: const Color(0xFF13A7B1),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "FACE ATTENDANCE",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              _buildImagePreview(),
              _customButton(
                icon: Icons.camera_alt,
                label: "Capture Face",
                color: const Color(0xFF13A7B1),
                onPressed: _pickImage,
              ),
              const SizedBox(height: 15),
              _customButton(
                icon: Icons.app_registration,
                label: "Register Face",
                color: const Color(0xFFCD2E5E),
                onPressed: _registerFace,
              ),
              const SizedBox(height: 15),
              _customButton(
                icon: Icons.check_circle_outline,
                label: "Mark Attendance",
                color: const Color(0xFFFF7C34),
                onPressed: _verifyFace,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

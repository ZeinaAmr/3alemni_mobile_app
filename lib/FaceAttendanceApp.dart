
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class FaceAttendanceApp extends StatelessWidget {
  final String userId;
  final String courseId;

  const FaceAttendanceApp({Key? key, required this.userId, required this.courseId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF13A7B1),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: FaceAttendanceHome(),
    );
  }
}

class FaceAttendanceHome extends StatefulWidget {
  @override
  _FaceAttendanceHomeState createState() => _FaceAttendanceHomeState();
}

class _FaceAttendanceHomeState extends State<FaceAttendanceHome> {
  File? _image;
  final picker = ImagePicker();
  final String backendUrl = 'http://192.168.100.139:5000'; // Change if needed

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

    if (result['success']) {
      _showMessage(result['matched']
          ? "✅ Face verified. Attendance marked!"
          : "❌ Face not similar.");
    } else {
      _showMessage(result['message']);
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Result'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: _image != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(_image!, width: 200, height: 200, fit: BoxFit.cover),
      )
          : Padding(
        padding: const EdgeInsets.all(50),
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
      label: Text(label, style: TextStyle(fontSize: 16, color: Colors.white)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "FACE ATTENDANCE",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              _buildImagePreview(),
              _customButton(
                icon: Icons.camera_alt,
                label: "Capture Face",
                color: Color(0xFF13A7B1),
                onPressed: _pickImage,
              ),
              SizedBox(height: 15),
              _customButton(
                icon: Icons.app_registration,
                label: "Register Face",
                color: Color (0xFFCD2E5E),
                onPressed: _registerFace,
              ),
              SizedBox(height: 15),
              _customButton(
                icon: Icons.check_circle_outline,
                label: "Mark Attendance",
                color: Color(0xFFFF7C34),
                onPressed: _verifyFace,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

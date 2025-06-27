import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FaceRegistrationPage extends StatefulWidget {
  final String userId;

  const FaceRegistrationPage({Key? key, required this.userId}) : super(key: key);

  @override
  _FaceRegistrationPageState createState() => _FaceRegistrationPageState();
}

class _FaceRegistrationPageState extends State<FaceRegistrationPage> {
  File? _image;
  final picker = ImagePicker();
  final String backendUrl = 'http://192.168.100.139:5000'; // adjust to your backend IP

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
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

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Face Registration'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }

  Widget _previewImage() {
    return _image != null
        ? Image.file(_image!, height: 200, width: 200, fit: BoxFit.cover)
        : const Icon(Icons.person_outline, size: 120, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Face')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _previewImage(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("Capture Face"),
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF13A7B1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.app_registration),
              label: const Text("Register Face"),
              onPressed: _registerFace,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCD2E5E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

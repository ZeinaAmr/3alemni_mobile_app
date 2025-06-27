import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateCoursePage extends StatefulWidget {
  final String teacherId;

  const CreateCoursePage({super.key, required this.teacherId});

  @override
  State<CreateCoursePage> createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  final _formKey = GlobalKey<FormState>();
  String? title, centerId, session, time, capacity, model, price, description;
  File? _pickedImage;
  List<Map<String, dynamic>> centers = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCenters();
  }

  Future<void> fetchCenters() async {
    final snapshot = await FirebaseFirestore.instance.collection('centers').get();
    setState(() {
      centers = snapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, 'name': data['name'] ?? 'Unknown Center'};
      }).toList();
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref().child('course_images/$fileName.jpg');
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    String? imageUrl;
    if (_pickedImage != null) {
      imageUrl = await uploadImage(_pickedImage!);
      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to upload image")),
        );
        setState(() => isLoading = false);
        return;
      }
    }

    try {
      final courseDoc = FirebaseFirestore.instance.collection('courses').doc(title);
      await courseDoc.set({
        'title': title,
        'centerId': centerId,
        'session': session,
        'mode': model,
        'time': time,
        'students': int.tryParse(capacity ?? '0') ?? 0,
        'price': price,
        'description': description,
        'teacherId': widget.teacherId,
        'image': imageUrl ?? '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Course created successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating course: $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Course", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLabel("Course Title"),
              buildTextField(hint: "Enter course title", onSaved: (v) => title = v),

              const SizedBox(height: 20),
              buildLabel("Center"),
              DropdownButtonFormField<String>(
                decoration: inputDecoration("Choose a center"),
                value: centerId,
                items: centers.map((center) {
                  return DropdownMenuItem<String>(
                    value: center['id'].toString(),
                    child: Text(center['name'].toString()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => centerId = value),
                onSaved: (v) => centerId = v,
              ),

              const SizedBox(height: 20),
              buildLabel("Session"),
              buildTextField(hint: "e.g. Mon & Wed", onSaved: (v) => session = v),

              const SizedBox(height: 20),
              buildLabel("Time"),
              buildTextField(hint: "e.g. 7:00 PM - 8:30 PM", onSaved: (v) => time = v),

              const SizedBox(height: 20),
              buildLabel("Capacity"),
              buildTextField(
                hint: "Enter capacity",
                keyboardType: TextInputType.number,
                onSaved: (v) => capacity = v,
              ),

              const SizedBox(height: 20),
              buildLabel("Model"),
              Column(
                children: ["Online", "Offline", "Hybrid"].map((m) {
                  return RadioListTile<String>(
                    title: Text(m),
                    value: m,
                    groupValue: model,
                    activeColor: const Color(0xFF187E8A),
                    onChanged: (value) => setState(() => model = value),
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),
              buildLabel("Price"),
              buildTextField(hint: "Enter price", onSaved: (v) => price = v),

              const SizedBox(height: 20),
              buildLabel("Description"),
              buildTextField(hint: "Enter course description", onSaved: (v) => description = v, maxLines: 3),

              //const SizedBox(height: 20),
              /*buildLabel("Course Image"),
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.upload_file),
                label: const Text("Pick Image"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF187E8A),
                  foregroundColor: Colors.white,
                ),
              ),
              if (_pickedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.file(_pickedImage!, height: 150),
                ),*/

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7C34),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Create Course", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
  }

  Widget buildTextField({
    required String hint,
    void Function(String?)? onSaved,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: inputDecoration(hint),
      onSaved: onSaved,
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

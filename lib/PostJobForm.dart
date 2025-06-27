import 'package:allemni/SideBar_2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobOfferPage extends StatefulWidget {
  final String userId;
  const JobOfferPage({Key? key, required this.userId}) : super(key: key);
  @override
  _JobOfferPageState createState() => _JobOfferPageState();
}

class _JobOfferPageState extends State<JobOfferPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  void _submitJob() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('job_offers').add({
          'teacherId': widget.userId,
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'type': _typeController.text.trim(),
          'location': _locationController.text.trim(),
          'requirements': _requirementsController.text.trim(),
          'salary': _salaryController.text.trim(),
          'Application deadline': _deadlineController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Job posted successfully!', style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xFF187E8A),
          ),
        );

        _titleController.clear();
        _descriptionController.clear();
        _typeController.clear();
        _locationController.clear();
        _requirementsController.clear();
        _salaryController.clear();
        _deadlineController.clear();
      } catch (e) {
        print("Error posting job: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to post job. Please try again.', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar2(userId: widget.userId),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Post a Job",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xFF187E8A)),
        ),
        centerTitle: true,


      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "POST A JOB",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Image.asset(
              'assets/Job offers-pana.png',
              height: 300,
              width: 300,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(_titleController, "Job Title", Icons.work),
                  SizedBox(height: 10),
                  _buildTextField(_descriptionController, "Job Description", Icons.description, maxLines: 3),
                  SizedBox(height: 10),
                  _buildTextField(_requirementsController, "Required Skills", Icons.book_sharp),
                  SizedBox(height: 10),
                  _buildTextField(_typeController, "Type", Icons.wifi),
                  SizedBox(height: 10),
                  _buildTextField(_locationController, "Location", Icons.location_on_sharp),
                  SizedBox(height: 10),
                  _buildTextField(_salaryController, "Salary", Icons.currency_pound, isNumber: true),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitJob,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF7C34),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                    child: Text(
                      "POST JOB",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0x1D13A7B1),
        prefixIcon: Padding(
          padding: EdgeInsets.all(12),
          child: Icon(icon, color: Color(0xFF13A7B1)),
        ),
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Enter $labelText' : null,
    );
  }
}

import 'package:allemni/SideBar_2.dart';
import 'package:flutter/material.dart';

class JobOfferPage extends StatefulWidget {
  @override
  _JobOfferPageState createState() => _JobOfferPageState();
}

class _JobOfferPageState extends State<JobOfferPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  void _submitJob() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Job posted successfully!', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF187E8A),
        ),
      );
      _titleController.clear();
      _descriptionController.clear();
      _skillsController.clear();
      _salaryController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar2(),
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
                  _buildTextField(_skillsController, "Required Skills", Icons.book_sharp),
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

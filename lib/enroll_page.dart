import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnrollCoursePage extends StatefulWidget {
  final String courseId;
  final String userId; // ✅ updated

  const EnrollCoursePage({Key? key, required this.courseId, required this.userId}) : super(key: key);

  @override
  _EnrollCoursePageState createState() => _EnrollCoursePageState();
}

class _EnrollCoursePageState extends State<EnrollCoursePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  String? selectedCenter;
  String? selectedTime;
  String? paymentType;

  List<String> centers = [];
  List<String> times = [];

  String courseTitle = '';
  String coursePrice = '';

  @override
  void initState() {
    super.initState();
    loadCourseDetails();
    loadCenters();
    loadTimes();
    loadUserDetails();
  }

  void loadCourseDetails() async {
    final doc = await FirebaseFirestore.instance.collection('courses').doc(widget.courseId).get();
    if (doc.exists) {
      setState(() {
        courseTitle = doc['title'] ?? 'Course';
        coursePrice = doc['price'] ?? '0 EGP';
      });
    }
  }

  void loadCenters() async {
    final snapshot = await FirebaseFirestore.instance.collection('centers').get();
    setState(() {
      centers = snapshot.docs.map((doc) => doc['name'].toString()).toList();
    });
  }

  void loadTimes() async {
    final snapshot = await FirebaseFirestore.instance.collection('class_times').get();
    setState(() {
      times = snapshot.docs.map((doc) => doc['time'].toString()).toList();
    });
  }

  void loadUserDetails() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
    if (doc.exists) {
      setState(() {
        _firstNameController.text = doc['firstName'] ?? '';
        _lastNameController.text = doc['lastName'] ?? '';
      });
    }
  }

  void submitEnrollment() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        selectedCenter == null ||
        selectedTime == null ||
        paymentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('enrollments').add({
      'studentId': widget.userId,
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'centerId': selectedCenter,
      'sessionTime': selectedTime,
      'PaymentType': paymentType,
      'courseId': widget.courseId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Enrollment submitted successfully.")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enroll in Course'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text(
              courseTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF187E8A),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              coursePrice,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFF7C34),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            const Text("First Name"),
            const SizedBox(height: 5),
            TextField(
              controller: _firstNameController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Enter your first name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),

            const Text("Last Name"),
            const SizedBox(height: 5),
            TextField(
              controller: _lastNameController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Enter your last name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),

            const Text("Select Center"),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: selectedCenter,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              hint: const Text("Select Center"),
              items: centers.map((center) {
                return DropdownMenuItem<String>(
                  value: center,
                  child: Text(center),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCenter = value;
                });
              },
            ),
            const SizedBox(height: 15),

            const Text("Select Time"),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: selectedTime,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              hint: const Text("Select Time"),
              items: times.map((time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTime = value;
                });
              },
            ),
            const SizedBox(height: 20),

            const Text("Payment Type"),
            ListTile(
              leading: Radio<String>(
                value: 'Cash at Center',
                groupValue: paymentType,
                onChanged: (value) {
                  setState(() {
                    paymentType = value;
                  });
                },
              ),
              title: const Text("Cash at Center"),
            ),
            ListTile(
              leading: Radio<String>(
                value: 'Card',
                groupValue: paymentType,
                onChanged: (value) {
                  setState(() {
                    paymentType = value;
                  });
                },
              ),
              title: const Text("Card"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: submitEnrollment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7C34),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "Submit Enrollment",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

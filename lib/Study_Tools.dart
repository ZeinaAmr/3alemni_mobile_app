
import 'package:flutter/material.dart';
import 'SideBar.dart';
import 'package:allemni/Flashcards.dart';
class AIStudyScreen extends StatefulWidget {
  AIStudyScreen({Key? key}) : super(key: key);

  @override
  _AIStudyScreenState createState() => _AIStudyScreenState();
}

class _AIStudyScreenState extends State<AIStudyScreen> {
  String? fileName;

  void pickFile() {
    setState(() {
      fileName = "sample_document.pdf"; // Simulated file selection
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "AI Study Tools",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xFF187E8A)),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true, // Ensures the back button appears
        iconTheme: const IconThemeData(color: Colors.black), // Ensure back button is visible
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload Your Study Material",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Center(
              child: Image.asset(
                'assets/WhatsApp Image 2025-01-31 at 02.27.22_86030366.jpg',
                height: 350,
                width: 350,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Upload your PDF, PPT, or DOCX files and choose to generate Flashcards or Reels to enhance your learning experience.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: pickFile,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF187E8A)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.upload, color: Color(0xFF187E8A)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fileName ?? "Choose File",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionButton(Icons.copy_rounded, "Generate Flashcards"),
                _buildOptionButton(Icons.local_movies_outlined, "Generate Reels"),
              ],
            ),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FlashcardsScreen()), // Navigate to Flashcards page
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7C34),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Generate",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(IconData icon, String text) {
    return Container(
      width: 160, // Fixed width for consistency
      height: 120, // Fixed height for equal sizing
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF187E8A), size: 40),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

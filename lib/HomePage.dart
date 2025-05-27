import 'package:flutter/material.dart';
import 'centers_page.dart';
import 'Teachers_page.dart';
import 'LoginPage.dart';
import 'SideBar.dart';
import 'calendar_page.dart';
import 'chatbot_page.dart';
import 'ProfilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xFF187E8A)),
        ),centerTitle: true,

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              const Text(
                "Embark On Your Educational Journey",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Welcome To 3allemni — Your Gateway To Personalized Learning!",
                style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Image
              Center(
                child: Image.asset('assets/home.png', fit: BoxFit.contain),
              ),
              const SizedBox(height: 40),

              // "Get Started" Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7C34),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  child: const Text("Get Started", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 40),

              // Featured Centers Section
              _buildSectionTitle("Featured Centers"),
              _buildCardList([
                CardData(name: "IG Zone", details: "Leading IGCSE Learning Center", imagePath: 'assets/igzone.jpeg'),
                CardData(name: "JTA", details: "IGCSE Education for All Levels", imagePath: 'assets/jta.jpg'),
                CardData(name: "Genius", details: "American & IGCSE Programs", imagePath: 'assets/genius.jpg'),
                CardData(name: "Infinity", details: "National & American & IGCSE Programs", imagePath: 'assets/infinity.jpg'),
              ]),
              _buildSeeMoreButton("See More", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CentersPage()),
                );
              }),

              const SizedBox(height: 40),

              // Top Teachers Section
              _buildSectionTitle("Top Teachers"),
              _buildCardList([
                CardData(name: "Maram Hamed", details: "IGCSE Mathematics OL & IAL Teacher", imagePath: 'assets/Teacher1.jpg'),
                CardData(name: "Ahmed Khafagah", details: "IGCSE CS & ICT OL & IAL Teacher", imagePath: 'assets/Teacher2.jpg'),
                CardData(name: "Mirelle Osama", details: "IGCSE English Teacher for Year 8", imagePath: 'assets/Teacher3.jpg'),
              ]),
              _buildSeeMoreButton("See More", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeachersPage()),
                );
              }),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildCardList(List<CardData> cardDataList) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cardDataList
            .map((data) => _buildCard(
          name: data.name,
          details: data.details,
          imagePath: data.imagePath,
        ))
            .toList(),
      ),
    );
  }

  Widget _buildCard({required String name, required String details, required String imagePath}) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 6)),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: Image.asset(imagePath, height: 150, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                Text(details, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeeMoreButton(String label, VoidCallback onPressed) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF7C34),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}

class CardData {
  final String name;
  final String details;
  final String imagePath;

  CardData({required this.name, required this.details, required this.imagePath});
}

import 'package:flutter/material.dart';
import 'dart:math';
import 'SideBar.dart';

class BundlesPage extends StatelessWidget {
  final String userId; // ✅ changed from studentId

  const BundlesPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(userId: userId), // ✅ updated here
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "3alemni",
          style: TextStyle(
            color: Color(0xFF187E8A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            children: const [
              Text(
                "OUR BUNDLES",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF187E8A),
                ),
              ),
              SizedBox(height: 20),
              BundleCard(
                title: "Starter Bundle",
                price: "£200",
                duration: "/3-Month",
                description:
                "Perfect For Beginners. Includes Access To Basic Courses, Study Materials, And 1-Month Chatbot Support.",
                features: [
                  "Basic Courses",
                  "Study Materials",
                  "1-Month Chatbot Support"
                ],
                ribbonIcon: Icons.star_border,
                iconColor: Color(0xFF8B5A2B),
                borderColor: Color(0xFF8B5A2B),
              ),
              SizedBox(height: 20),
              BundleCard(
                title: "Pro Bundle",
                price: "£500",
                duration: "/6-Month",
                description:
                "For Intermediate Learners. Includes Advanced Courses, Personalized Study Plans, And 3-Month Chatbot Support.",
                features: [
                  "Advanced Courses",
                  "Personalized Study Plans",
                  "3-Month Chatbot Support"
                ],
                ribbonIcon: Icons.star_half,
                iconColor: Color(0xFFC0C0C0),
                borderColor: Color(0xFFC0C0C0),
              ),
              SizedBox(height: 20),
              BundleCard(
                title: "Premium Bundle",
                price: "£900",
                duration: "/9-Month",
                description:
                "For Advanced Learners. Includes All Courses, 1-On-1 Tutoring, And Lifetime Chatbot Support.",
                features: [
                  "All Courses",
                  "1-On-1 Tutoring",
                  "Lifetime Chatbot Support"
                ],
                ribbonIcon: Icons.star,
                iconColor: Color(0xFFDAA520),
                borderColor: Color(0xFFDAA520),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BundleCard extends StatelessWidget {
  final String title;
  final String price;
  final String duration;
  final String description;
  final List<String> features;
  final IconData ribbonIcon;
  final Color iconColor;
  final Color borderColor;

  const BundleCard({
    required this.title,
    required this.price,
    required this.duration,
    required this.description,
    required this.features,
    required this.ribbonIcon,
    required this.iconColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFF187E8A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF187E8A),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          duration,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: features
                          .map(
                            (feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            children: [
                              const Icon(Icons.check, color: Color(0xFF187E8A), size: 18),
                              const SizedBox(width: 8),
                              Text(feature, style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      )
                          .toList(),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7C34),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                      ),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Icon(ribbonIcon, color: iconColor, size: 40),
        ),
      ],
    );
  }
}

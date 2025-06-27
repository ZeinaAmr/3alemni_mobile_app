import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SideBar_2.dart';
import 'PostJobForm.dart';

class JobOffersPage extends StatelessWidget {
  final String userId;

  const JobOffersPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar2(userId: userId),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Job Offers",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF187E8A)),
        ),
        centerTitle: true,
        // Removed the AppBar action icon
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('job_offers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No job offers available."));
          }

          final jobOffers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobOffers.length,
            itemBuilder: (context, index) {
              final job = jobOffers[index].data() as Map<String, dynamic>;

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF187E8A),
                    child: Icon(Icons.work, color: Colors.white),
                  ),
                  title: Text(
                    job['title'] ?? 'Untitled Job',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    job['description'] ?? 'No description',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    // You can implement a detailed view here
                  },
                ),
              );
            },
          );
        },
      ),

      // ✅ Floating action button to add job
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 20),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JobOfferPage(userId: userId)),
              );
            },
            backgroundColor: const Color(0xFFFF7C34),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),

    );
  }
}

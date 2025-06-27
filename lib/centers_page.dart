import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Teachers_page.dart';
import 'SideBar.dart';

class CentersPage extends StatefulWidget {
  final String userId;

  const CentersPage({Key? key, required this.userId}) : super(key: key);

  @override
  _CentersPageState createState() => _CentersPageState();
}

class _CentersPageState extends State<CentersPage> {
  List<Map<String, dynamic>> _allCenters = [];
  String _searchText = '';
  String? _selectedLocation;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCenters();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> _fetchCenters() async {
    final snapshot = await FirebaseFirestore.instance.collection('centers').get();
    setState(() {
      _allCenters = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'name': data['name'] ?? 'No Name',
          'location': data['location'] ?? 'Unknown Location',
          'image': data['image'] ?? 'assets/default.jpg', // Use a default asset
        };
      }).toList();
    });
  }

  void _showFilterDialog() {
    final locations = _allCenters
        .map((center) => center['location'] ?? 'Unknown Location')
        .toSet()
        .toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Filter by Location",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF187E8A),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: locations.map((location) {
                      return ChoiceChip(
                        label: Text(location),
                        labelStyle: TextStyle(
                          color: _selectedLocation == location ? Colors.white : Colors.black,
                        ),
                        selected: _selectedLocation == location,
                        selectedColor: const Color(0xFF13A7B1),
                        backgroundColor: const Color(0xFFF0F0F0),
                        onSelected: (selected) {
                          setState(() {
                            _selectedLocation = selected ? location : null;
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF187E8A),
                        backgroundColor: const Color(0xFFEFF6F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedLocation = null;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Clear Filter"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13A7B1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Already applied on chip select
                      },
                      child: const Text("Apply"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredCenters = _allCenters.where((center) {
      final matchesSearch = center['name'].toLowerCase().contains(_searchText);
      final matchesLocation = _selectedLocation == null || center['location'] == _selectedLocation;
      return matchesSearch && matchesLocation;
    }).toList();

    return Scaffold(
      drawer: Sidebar(userId: widget.userId),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search Centers...',
            border: InputBorder.none,
          ),
        )
            : const Text(
          "Centers",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF187E8A),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.black),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchController.clear();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_rounded, color: Colors.black),
            onPressed: _showFilterDialog,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _allCenters.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: filteredCenters.length,
          itemBuilder: (context, index) {
            final center = filteredCenters[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeachersPage(userId: widget.userId),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          center['image'],
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              center['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Color(0xFF13A7B1)),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    center['location'],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'student_LMS.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3allemni Attendance',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFFFF7C34),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const AttendancePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String _status = 'Press a button to check in or out';
  bool _loading = false;
  bool _checkedIn = false;
  DateTime? _lastCheckInTime;
  Position? _currentPosition;
  final MapController _mapController = MapController();

  final String studentId = 'student123';
  final String classId = 'classA';

  final LatLng classLocation = const LatLng(30.0038, 30.9086);
  final double allowedDistanceMeters = 100;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        _currentPosition = position;
        _mapController.move(LatLng(position.latitude, position.longitude), 15);
      });
    } catch (e) {
      setState(() {
        _status = 'Error getting location: ${e.toString().replaceAll('Exception: ', '')}';
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location services are disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  double _calculateDistanceMeters(LatLng p1, LatLng p2) {
    return Geolocator.distanceBetween(p1.latitude, p1.longitude, p2.latitude, p2.longitude);
  }

  Future<void> _sendAttendance(String action) async {
    setState(() {
      _loading = true;
      _status = 'Getting location...';
    });

    try {
      Position position = await _determinePosition();
      final currentLatLng = LatLng(position.latitude, position.longitude);
      final distance = _calculateDistanceMeters(currentLatLng, classLocation);

      setState(() {
        _currentPosition = position;
      });

      if (distance > allowedDistanceMeters) {
        setState(() {
          _status = 'You are too far from class to $action.\nDistance: ${distance.toStringAsFixed(2)} m';
          _loading = false;
        });
        return;
      }

      await FirebaseFirestore.instance.collection('attendance').add({
        'studentId': studentId,
        'classId': classId,
        'action': action,
        'timestamp': DateTime.now().toUtc(),
        'latitude': position.latitude,
        'longitude': position.longitude,
        'distanceFromClassMeters': distance,
      });

      setState(() {
        _status = '$action successful!\nDistance: ${distance.toStringAsFixed(2)} m';
        _checkedIn = action == 'checkin';
        if (action == 'checkin') _lastCheckInTime = DateTime.now();
      });
    } catch (e) {
      setState(() {
        _status = 'Error: ${e.toString().replaceAll('Exception: ', '')}';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildMap() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 230,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(center: classLocation, zoom: 15),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.3alemni',
            ),
            CircleLayer(circles: [
              CircleMarker(
                point: classLocation,
                color: Colors.orange.withOpacity(0.3),
                borderColor: Colors.orange,
                borderStrokeWidth: 2,
                radius: allowedDistanceMeters,
              ),
            ]),
            MarkerLayer(markers: [
              Marker(
                point: classLocation,
                width: 40,
                height: 40,
                builder: (ctx) => const Icon(Icons.school, color: Colors.orange, size: 40),
              ),
              if (_currentPosition != null)
                Marker(
                  point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                  width: 40,
                  height: 40,
                  builder: (ctx) => const Icon(Icons.person_pin_circle, color: Color(0xFFFF7C34), size: 40),
                ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.location_on, size: 48, color: Color(0xFF13A7B1)),
            const SizedBox(height: 16),
            Text(
              _status,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            if (_loading) const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (_lastCheckInTime != null && _checkedIn)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Checked in at ${_lastCheckInTime!.hour}:${_lastCheckInTime!.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, String action, IconData icon) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF7C34),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(250, 50), // width 250, height 50 minimum
      ),
      onPressed: _loading ? null : () => _sendAttendance(action),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StudentLMS()),
            );
          },
        ),
        title: const Text(
          '3allemni Attendance',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            tooltip: 'Refresh Location',
            onPressed: _getCurrentLocation,
          ),
        ],
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMap(),
            const SizedBox(height: 16),
            _buildStatusCard(),
            const SizedBox(height: 24),
            if (!_checkedIn) _buildActionButton('Check In', 'checkin', Icons.login),
            if (!_checkedIn) const SizedBox(height: 16),
            if (_checkedIn) _buildActionButton('Check Out', 'checkout', Icons.logout),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Class Location Info',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    ListTile(
                      leading: Icon(Icons.location_pin, color: Color(0xFF13A7B1)),
                      title: Text('Classroom A'),
                      subtitle: Text('Main Building, Floor 3'),
                    ),
                    ListTile(
                      leading: Icon(Icons.timer, color: Color(0xFF13A7B1)),
                      title: Text('Allowed Distance'),
                      subtitle: Text('100 meters from class'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
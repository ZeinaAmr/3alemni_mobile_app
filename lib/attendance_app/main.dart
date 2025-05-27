import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AttendancePage(),
  ));
}

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final String backendUrl = 'http://10.0.2.2:3000'; // for Android emulator
  final String studentId = 'student123';
  final String classId = 'classA';

  String _status = '🕒 Ready';
  bool _loading = false;

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _sendAttendance(String action) async {
    setState(() {
      _loading = true;
      _status = '📍 Getting location...';
    });

    try {
      Position position = await _determinePosition();
      double latitude = position.latitude;
      double longitude = position.longitude;

      // Class location (replace with actual classroom location)
      const double classLatitude = 30.0038;
      const double classLongitude = 30.9086;

      // Calculate distance in meters
      double distanceInMeters = Geolocator.distanceBetween(
        latitude,
        longitude,
        classLatitude,
        classLongitude,
      );

      const double allowedDistance = 50.0; // meters

      if (distanceInMeters > allowedDistance) {
        setState(() {
          _status = '❌ Too far from class!\nDistance: ${distanceInMeters.toStringAsFixed(2)} m';
          _loading = false;
        });
        return;
      }

      final timestamp = DateTime.now().toUtc().toIso8601String();
      final response = await http.post(
        Uri.parse('$backendUrl/attendance/$action'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'studentId': studentId,
          'classId': classId,
          'timestamp': timestamp,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _status = '✅ $action successful!';
        });
      } else {
        setState(() {
          _status = '❌ Failed to send: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_loading) const CircularProgressIndicator(),
            if (!_loading) ...[
              ElevatedButton(
                onPressed: () => _sendAttendance('checkin'),
                child: const Text("Check In"),
              ),
              ElevatedButton(
                onPressed: () => _sendAttendance('checkout'),
                child: const Text("Check Out"),
              ),
              const SizedBox(height: 20),
              Text(_status, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}

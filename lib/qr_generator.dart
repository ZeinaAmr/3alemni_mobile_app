// qr_generator_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGeneratorPage extends StatelessWidget {
  final String classId;
  final String userId;     // teacherId
  final String courseId;

  const QRGeneratorPage({
    Key? key,
    required this.classId,
    required this.userId,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate valid QR data in JSON format
    final qrPayload = {
      'courseId': courseId,
      'teacherId': userId,
      'classId': classId,
      'secret': '3alemniSecureToken' // optional validation
    };

    final encodedQrData = jsonEncode(qrPayload);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher QR Generator"),
        backgroundColor: Color(0xFF187E8A),
      ),
      body: Center(
        child: QrImageView(
          data: encodedQrData,
          version: QrVersions.auto,
          size: 250,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}

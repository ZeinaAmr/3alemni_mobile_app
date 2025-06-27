import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  final String userId;
  final String courseId;

  const QRScannerPage({Key? key, required this.userId, required this.courseId}) : super(key: key);

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedData;
  bool attendanceMarked = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      setState(() => scannedData = scanData.code);

      // Optional: validate QR content here (e.g., contains teacher ID/course ID)
      if (scanData.code != null && scanData.code!.contains(widget.courseId)) {
        // Add attendance record to Firestore
        await FirebaseFirestore.instance.collection('attendance').add({
          'studentId': widget.userId,
          'courseId': widget.courseId,
          'action': 'qr-checkin',
          'timestamp': DateTime.now().toUtc(),
          'source': 'qr',
        });

        setState(() => attendanceMarked = true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Attendance Taken Successfully via QR!'),
            backgroundColor: Colors.green,
          ),
        );

        // Optional: Delay then go back or close
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Invalid QR Code'),
            backgroundColor: Colors.red,
          ),
        );
        controller.resumeCamera();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Teacher QR Code'),
        backgroundColor: const Color(0xFF187E8A),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          if (scannedData != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                attendanceMarked
                    ? '✅ Attendance Taken for ${widget.courseId}'
                    : 'Scanned: $scannedData',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: attendanceMarked ? Colors.green : Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeScan extends StatefulWidget {
  const BarcodeScan({super.key});

  @override
  _BarcodeScanState createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  String _scanResult = '';

  Future<void> scanBarcode() async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        String scanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666',
          'cancel',
          true,
          ScanMode.BARCODE,
        );
        if (!mounted) return;
        setState(() {
          _scanResult = scanResult != '-1' ? scanResult : 'Canceled';
        });
      } else {
        setState(() => _scanResult = 'Permission denied');
      }
    } catch (e) {
      setState(() => _scanResult = 'Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register New Item')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: scanBarcode,
              child: Text('Start scan'),
            ),
            SizedBox(height: 20),
            Text(_scanResult),
          ],
        ),
      ),
    );
  }
}

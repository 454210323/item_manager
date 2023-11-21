import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeScannerUtil {
  static Future<String> scanBarcode() async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        final scanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666',
          'Cancel',
          true,
          ScanMode.BARCODE,
        );
        return scanResult == '-1' ? '' : scanResult;
      } else {
        return 'Permission denied';
      }
    } catch (e) {
      return 'Error occurred: $e';
    }
  }
}

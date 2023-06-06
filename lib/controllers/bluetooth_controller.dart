import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothController extends GetxController {
  // bluetooth instance
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  // scans for bluetooth devices
  Future scanDevices() async {
    // stats scan for 5 seconds
    flutterBlue.startScan(timeout: const Duration(seconds: 5));

    // stops the scan after time has passed
    flutterBlue.stopScan();
  }

  Stream<List<ScanResult>> get scanResults => flutterBlue.scanResults;
}

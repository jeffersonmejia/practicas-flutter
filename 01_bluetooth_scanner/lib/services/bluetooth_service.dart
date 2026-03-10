import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScannerService {

  // Escaneo de dispositivos
  Stream<List<ScanResult>> scanDevices() {
    print("SERVICE: startScan called");

    // Inicia escaneo usando la API estática
    FlutterBluePlus.stopScan();
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    // Devuelve el stream de resultados
    return FlutterBluePlus.scanResults;
  }

  // Dispositivos emparejados / conectados
  Future<List<BluetoothDevice>> getPairedDevices() async {
    // En 2.2.1 se obtiene con el getter estático bondedDevices
    return await FlutterBluePlus.bondedDevices;
  }
}
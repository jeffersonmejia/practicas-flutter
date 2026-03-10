import 'package:flutter/material.dart';
import 'screens/scanner_screen.dart';

void main() {
  runApp(const BluetoothDemoApp());
}

class BluetoothDemoApp extends StatelessWidget {
  const BluetoothDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const ScannerScreen(),
    );
  }
}
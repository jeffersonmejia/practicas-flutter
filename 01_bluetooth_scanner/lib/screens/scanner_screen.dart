import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../widgets/device_tile.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {

  List<BluetoothDevice> pairedDevices = [];
  List<ScanResult> availableDevices = [];
  bool scanning = false;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    fetchPairedDevices();
    startScan(); // escaneo automático al iniciar
  }

  void fetchPairedDevices() async {
    List<BluetoothDevice> bonded = await FlutterBluePlus.bondedDevices;
    setState(() {
      pairedDevices = bonded;
    });
  }

  void startScan() {
    if (scanning) return;
    setState(() {
      scanning = true;
      availableDevices = [];
    });

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) {
      List<ScanResult> filtered = results.where((r) =>
        !pairedDevices.any((d) => d.id == r.device.id)
      ).toList();

      setState(() {
        availableDevices = filtered;
      });
    });

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          scanning = false;
        });
      }
    });
  }

  Widget sectionBox({
    required IconData icon,
    required String title,
    required Color color,
    required int count
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            count.toString(),
            style: TextStyle(
                color: scheme.onSurface.withOpacity(.6),
                fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget deviceCard(Widget child) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.grey.withOpacity(.18),
          ),
        ),
        child: child,
      ),
    );
  }

  Widget emptyBox(String message) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.bluetooth_disabled,
              size: 40, color: scheme.outline),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // color azul suave igual a "Paired Devices"
    final Color scanButtonBackground = scheme.primaryContainer; 

    return Scaffold(
      appBar: AppBar(title: const Text("Bluetooth")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: scanning ? null : startScan,
        backgroundColor: scanButtonBackground,
        icon: scanning
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: scheme.primary, // loader azul fuerte
                ),
              )
            : Icon(Icons.bluetooth, color: scheme.primary), // icono azul fuerte
        label: Text(
          scanning ? "Scanning..." : "Scan",
          style: TextStyle(color: scheme.primary), // texto azul fuerte
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: ListView(
          children: [
            sectionBox(
              icon: Icons.devices,
              title: "Paired Devices",
              color: scheme.primaryContainer,
              count: pairedDevices.length,
            ),

            if (pairedDevices.isEmpty)
              emptyBox("No paired devices"),

            ...pairedDevices.map((d) {
              return deviceCard(DeviceTile(
                result: ScanResult(
                  device: d,
                  rssi: 0,
                  advertisementData: AdvertisementData(
                    advName: d.name,
                    serviceData: {},
                    manufacturerData: {},
                    serviceUuids: [],
                    txPowerLevel: null,
                    appearance: null,
                    connectable: false,
                  ),
                  timeStamp: DateTime.now(),
                ),
              ));
            }).toList(),

            sectionBox(
              icon: Icons.device_unknown,
              title: "Available Devices",
              color: scheme.secondaryContainer,
              count: availableDevices.length,
            ),

            if (availableDevices.isEmpty)
              emptyBox("No available devices"),

            ...availableDevices.map((d) => deviceCard(DeviceTile(result: d))).toList(),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
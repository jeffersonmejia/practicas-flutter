import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceTile extends StatelessWidget {
  final ScanResult result;

  const DeviceTile({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print(
      "DEVICE -> "
      "id:${result.device.id} | "
      "name:${result.device.name} | "
      "adv:${result.advertisementData.localName} | "
      "rssi:${result.rssi}"
    );

    String name;

    if (result.device.name.isNotEmpty) {
      name = result.device.name;
    } else if (result.advertisementData.localName.isNotEmpty) {
      name = result.advertisementData.localName;
    } else {
      name = "Unknown Device";
    }

    return ListTile(
      leading: const Icon(Icons.bluetooth),
      title: Text(name),
      subtitle: Text(result.device.id.toString()),
      trailing: Text("${result.rssi} dBm"),
    );
  }
}
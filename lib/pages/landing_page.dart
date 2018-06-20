import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_blue/flutter_blue.dart';

class LandingPage extends StatefulWidget {
  @override
  State createState() => new LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> _scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  StreamSubscription<BluetoothDeviceState> _connection;

  void _done() {
    print("WE'RE DONE!");
    _stopScan();
  }

  void _scan() {
    scanResults = new Map();
    _scanSubscription = _flutterBlue
        .scan(timeout: const Duration(seconds: 5))
        .listen((ScanResult scanResult) {
      print("Found: ${scanResult.device.name}");
      scanResults[scanResult.device.id] = scanResult;
      setState(() {
        scanResults = scanResults;
      });
    }, onDone: _done);
  }

  void _stopScan() {
    _scanSubscription.cancel();
  }

  void initState() {
    super.initState();
  }

  void _cancelConnection() {
    _connection.cancel();
  }

  void _discoverServices(DeviceIdentifier id) async {
    _connection?.cancel();
    _connection = _flutterBlue
        .connect(scanResults[id].device, timeout: const Duration(seconds: 5))
        .listen((BluetoothDeviceState state) async {
      print("Connection attempted");
      if (state == BluetoothDeviceState.connected) {
        List<BluetoothService> services =
            await scanResults[id].device.discoverServices();
        services.forEach((service) {
          service.characteristics.forEach((characteristic) {
            characteristic.descriptors.forEach((descriptor) {
              print("found this in ${scanResults[id].device.name}");
              print("properties: ${characteristic.properties}");
            });
          });
        });
      }
    }, onDone: _cancelConnection);
  }

  List<ListTile> _buildTiles() {
    return scanResults.values
        .map((ScanResult result) => new ListTile(
              title: new Text(result.device.name),
              subtitle: new Text(result.device.id.toString()),
              leading: const Icon(Icons.bluetooth),
              onTap: () => _discoverServices(result.device.id),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: const Text("Bluetooth Devices"),
            backgroundColor: Colors.red),
        floatingActionButton: new FloatingActionButton(
            onPressed: _scan, child: new Icon(Icons.track_changes)),
        body: new ListView(children: _buildTiles()));

    // return new Material(
    //     color: Colors.purple[100],
    //     child: new Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         new FloatingActionButton(
    //             onPressed: _scan, child: new Icon(Icons.track_changes)),
    //         new FloatingActionButton(
    //             onPressed: _stopScan, child: new Icon(Icons.stop)),
    //       ],
    //     ));
  }
}

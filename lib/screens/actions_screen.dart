import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class ActionsScreen extends StatefulWidget {
  final BluetoothDevice device;

  const ActionsScreen({Key? key, required this.device}) : super(key: key);

  @override
  ActionsScreenState createState() => ActionsScreenState();
}

class ActionsScreenState extends State<ActionsScreen> {
  List<BluetoothService> _services = [];
  BluetoothCharacteristic? _characteristic;

  // Información del ESP32
  final serviceUUID = '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
  final characteristicUUID = 'beb5483e-36e1-4688-b7f5-ea07361b26a8';

  bool _ledState = false;

  @override
  void initState() {
    super.initState();

    getService();
  }

  getService() async {
    _services = await widget.device.discoverServices();
    _characteristic = _services
        .expand((service) => service.characteristics)
        .firstWhere((characteristic) => characteristic.uuid.toString() == characteristicUUID);
    
    print(_characteristic);
  }

  void sendLedCommand(BluetoothCharacteristic characteristic, bool turnOn) {
    String command = turnOn ? "on" : "off";
    List<int> bytes = utf8.encode(command);
    characteristic.write(bytes);
  }   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
      appBar: AppBar(
        title: const Text('Controlar led', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_ledState ? 'Encendido' : 'Apagado', style: const TextStyle(color: Colors.white)),
            Switch(
              value: _ledState,
              onChanged: ((value) => onChangedHandler(value)),
            )
          ],
        ),
      ),
    );
  }

  void onChangedHandler(bool value) {
    setState(() {
      _ledState = value;

      if (_characteristic != null) {
        sendLedCommand(_characteristic!, value);
      }
    });
  }
}
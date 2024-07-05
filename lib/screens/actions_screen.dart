import 'package:flutter/material.dart';

class ActionsScreen extends StatefulWidget {
  const ActionsScreen({Key? key}) : super(key: key);

  @override
  ActionsScreenState createState() => ActionsScreenState();
}

class ActionsScreenState extends State<ActionsScreen> {
  var _ledState = false;

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
    });
  }
}
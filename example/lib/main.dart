import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:verloop_flutter_sdk/verloop_flutter_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const String _clientId = "raghav";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: const Center(
            child: Text('Running for client $_clientId'),
          ),
          floatingActionButton: const VerloopWidget(
            clientId: _clientId,
            child: FloatingActionButton(
              tooltip: "Support",
              onPressed: null,
              child: Icon(Icons.chat),
            ),
          )),
    );
  }
}

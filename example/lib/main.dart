import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:verloop_flutter_sdk/verloop_flutter_sdk.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String clientId = "hello.stage";
  final Map<String, String> roomMap = {"key1": "value1"};
  final Map<String, String> userMap = {"key2": "value2"};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running for client $clientId'),
        ),
        floatingActionButton: FutureBuilder<String?>(
          // Initialize FlutterFire
          future: FirebaseMessaging.instance.getToken(),
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            if (snapshot.hasData && snapshot.data != "") {
              String token = snapshot.data ?? "";
              return VerloopWidget(
                clientId: clientId,
                fcmToken: token,
                roomVariables: roomMap,
                userVariables: userMap,
                userId: "12345",
                userName: "Raghav",
                userEmail: "test@verloop.io",
                userPhone: "+919001501111",
                onButtonClicked:
                    (String? title, String? payload, String? type) {
                  print("button click title $title");
                },
                onUrlClicked:
                    (String? url) {
                  print("url clicked $url");
                },
                overrideUrlOnClick: true,
                child: const FloatingActionButton(
                  onPressed: null,
                  child: Icon(Icons.chat),
                ),
              );
            }
            return const Text("Loading...");
          },
        ),
      ),
    );
  }
}

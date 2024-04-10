import 'dart:developer';
import 'dart:ffi';

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
  final Map<String, String> roomMap = {"key1": "value1"};
  final Map<String, String> userMap = {"key2": "value2"};
  String clientId = "hello";
  String? recipeId;
  String? userId;
  String? userName;
  String? userEmail;
  String? userPhone;
  final clientIdController = TextEditingController();
  final recipeIdController = TextEditingController();
  final userIdController = TextEditingController();
  final userNameController = TextEditingController();
  final userEmailController = TextEditingController();
  final userPhoneController = TextEditingController();
  bool changed = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Flex(
                direction: Axis.vertical,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: TextField(
                      controller: clientIdController,
                      onChanged: (String text) {
                        setState(() {
                          clientId = clientIdController.text;
                          changed = true;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:
                            'Enter the client id eg: hello or hello.stage',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: TextField(
                      controller: recipeIdController,
                      onChanged: (String text) {
                        setState(() {
                          recipeId = recipeIdController.text;
                          changed = true;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter the recipe ID',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: TextField(
                      controller: userIdController,
                      onChanged: (String text) {
                        setState(() {
                          userId = userIdController.text;
                          changed = true;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter the user Id',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: TextField(
                      controller: userNameController,
                      onChanged: (String text) {
                        setState(() {
                          userName = userNameController.text;
                          changed = true;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter the user name',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: TextField(
                      controller: userPhoneController,
                      onChanged: (String text) {
                        setState(() {
                          userPhone = userPhoneController.text;
                          changed = true;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter the user phone',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: TextField(
                      controller: userEmailController,
                      onChanged: (String text) {
                        setState(() {
                          userEmail = userEmailController.text;
                          changed = true;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter the user email',
                      ),
                    ),
                  ),
                  Text('Running for client $clientId'),
                  changed == false
                      ? const SizedBox()
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              changed = false;
                            });
                          },
                          child: const Text("Submit")),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: changed == true
            ? const SizedBox()
            : FutureBuilder<String?>(
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
                      recipeId: recipeId,
                      roomVariables: roomMap,
                      userVariables: userMap,
                      userId: userId,
                      userName: userName,
                      userEmail: userEmail,
                      userPhone: userPhone,
                      onButtonClicked:
                          (String? title, String? payload, String? type) {
                        log("button click title $title $payload");
                      },
                      onUrlClicked: (String? url) {
                        log("url clicked $url");
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

  @override
  void dispose() {
    clientIdController.dispose();
    recipeIdController.dispose();
    super.dispose();
  }
}

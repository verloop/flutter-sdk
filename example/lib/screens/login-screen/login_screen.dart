import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:verloop_flutter_sdk/verloop_flutter_sdk.dart';
import 'package:verloop_flutter_sdk_example/screens/home_screen.dart';
// ignore: depend_on_referenced_packages
 import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
  final VerloopSdk verloop = VerloopSdk();
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            future: getTokenByDevice(),
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
                  showDownloadButton: true,
                  openMenuWidget:true,
                  headerConfig: VerloopHeaderConfig(title: "my test",widgetColor: const Color.fromARGB(255, 66, 165, 245)),
                  onButtonClicked:_handleButtonClick,
                  onUrlClicked: _handleUrlClick,
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
        );
  }

  void _handleButtonClick(String? title, String? payload, String? type) async {
    log("button click title $title $payload");
    if (payload != null) {
      verloop.dismissChat();
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => HomeScreen(
              title: title,
              payload: payload,
              type: type,
            )),
      );
    }
  }

  void _handleUrlClick(String? url) {
    log("url clicked $url");
    if (url != null) {
      //verloop.dismissChat();
      // Pop Verloop and remove all routes until the initial route
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen(title: url)),
              (Route<dynamic> route) => route.isFirst);
    }
  }

    Future<String?> getTokenByDevice() async {
    String? token;
    if (Platform.isIOS) {
      // On iOS/MacOS, it is possible to get the users APNs token.
      // This may be required if you want to send messages to your iOS/MacOS devices without using the FCM service.
      // On Android & web, this returns null.

      await firebaseMessaging.requestPermission(
        provisional: true,
      );
      token = await firebaseMessaging
          .getAPNSToken(); // It will generate the Token for only iOS side.
    } else {
      // Android Returns the default FCM token for this device.
      token = await firebaseMessaging
          .getToken(); // It will generate the Token for only Android side.
    }
    return token;
  }

  @override
  void dispose() {
    clientIdController.dispose();
    recipeIdController.dispose();
    super.dispose();
  }
}

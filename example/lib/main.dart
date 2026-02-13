import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:verloop_flutter_sdk_example/screens/login-screen/login_screen.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      
      debugShowCheckedModeBanner: true,
      home: const LoginScreen(),
    );
  }
}





// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:verloop_flutter_sdk/verloop_flutter_sdk.dart';
// // import 'package:url_launcher/url_launcher.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final VerloopSdk _verloopSdk = VerloopSdk();

//   StreamSubscription? _btnSub;
//   StreamSubscription? _urlSub;
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initVerloop();
//   }

//   Future<void> _initVerloop() async {
//     try{
//       await _verloopSdk.setConfig(
//         clientId: "subhadipmondal",
//         // userId: "flutter-user",
//         userName: "Flutter User",
//         userEmail: "flutteruser@verloop.io",
//         userPhone: "+911234567890",
//         userVariables: {"device": "flutter"},
//         roomVariables: {"client": "subhadipmondal"},
//       );

//       await _verloopSdk.setButtonClickListener();
//       await _verloopSdk.setUrlClickListener(overrideUrlOnClick: true);
//       await _verloopSdk.showDownloadButton(isAllowFileDownload: true);

//       _btnSub = _verloopSdk.onButtonClicked.listen((e) {
//         debugPrint('Button clicked: ${e.title} / ${e.type} / ${e.payload}');
//         if (e.payload != null) {
//           try {
//             final Map<String, dynamic> payloadMap = jsonDecode(e.payload!);
//             final String urlString = payloadMap['url'];
//             final Uri url = Uri.parse(urlString);
//             // launchUrl(url, mode: LaunchMode.externalApplication);
//             _verloopSdk.dismissChat();
//           } catch (err) {
//             debugPrint("Invalid payload: $err");
//           }
//         }
//       });

//       _urlSub = _verloopSdk.onUrlClicked.listen((e) async {
//         if (e.url != null) {
//           final Uri url = Uri.parse(e.url!);
//           debugPrint("URL clicked: $url");
//           _verloopSdk.dismissChat();
//           // await launchUrl(url, mode: LaunchMode.externalApplication);
//         }
//       });

//       await _verloopSdk.setHeaderConfig(
//         headerConfig: VerloopHeaderConfig(
//           title: "Support Chat",
//           widgetColor: Colors.blue,
//         ),
//       );

//       await _verloopSdk.buildVerloop();

//       setState(() {
//         _isInitialized = true;
//       });
//     }
//     catch (e, stack) {
//       debugPrint("VERLOOP INIT FAILED: $e");
//       debugPrintStack(stackTrace: stack);
//   }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text("Verloop Flutter Example")),
//         body: Center(
//           child: _isInitialized
//               ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: () async {
//                         await _verloopSdk.startChat();
//                       },
//                       icon: const Icon(Icons.chat),
//                       label: const Text("Open Chat"),
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton.icon(
//                       onPressed: () async {
//                         await _verloopSdk.closeChat();
//                       },
//                       icon: const Icon(Icons.close),
//                       label: const Text("Close Chat"),
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton.icon(
//                       onPressed: () async {
//                         await _verloopSdk.logout();
//                       },
//                       icon: const Icon(Icons.logout),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                       ),
//                       label: const Text("Logout"),
//                     ),
//                   ],
//                 )
//               : const CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _btnSub?.cancel();
//     _urlSub?.cancel();
//     _verloopSdk.dispose();
//     super.dispose();
//   }
// }


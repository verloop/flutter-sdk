import 'package:flutter/material.dart';
import 'package:verloop_flutter_sdk_example/screens/login-screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //     // options: DefaultFirebaseOptions.currentPlatform,
  //     );
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

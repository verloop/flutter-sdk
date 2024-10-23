import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String? title;
  final String? payload;
  final String? type;

  const HomeScreen({
    super.key,
    this.title,
    this.type,
    this.payload,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home-screen"),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child:  Center(
          child: Column(
            children: [
              Text(widget.title ?? ""),
              Text(widget.payload ?? ""),
              Text(widget.type ?? ""),
            ],
          ),
        ),
      ),
    );
  }
}

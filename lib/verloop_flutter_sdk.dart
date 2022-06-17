import 'verloop_flutter_sdk_platform_interface.dart';

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'url_click_values.dart';
import 'button_click_values.dart';

class VerloopWidget extends StatefulWidget {

  final String clientId;
  final String? userId;
  final String? recipeId;
  final String? fcmToken;
  final String? userName;
  final String? userEmail;
  final String? userPhone;
  final bool overrideUrlOnClick;
  final Widget? child;

  const VerloopWidget({Key? key,
    required this.clientId,
    this.child,
    this.userId,
    this.recipeId,
    this.fcmToken,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.overrideUrlOnClick = false})
      : super(key: key);

  @override
  State<VerloopWidget> createState() => _VerloopWidgetState();
}

class _VerloopWidgetState extends State<VerloopWidget> {
  bool _ready = false;
  VerloopSdk? sdk;

  @override
  void initState() {
    super.initState();
    sdk = VerloopSdk();
    _buildVerloop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showChat,
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }

  Future<void> _buildVerloop() async {
    sdk?.setConfig(
      clientId: widget.clientId,
      userId: widget.userId,
      recipeId: widget.recipeId,
      fcmToken: widget.fcmToken,
      userName: widget.userName,
      userEmail: widget.userEmail,
      userPhone: widget.userPhone,
    );
    sdk?.setButtonClickListener();
    sdk?.setUrlClickListener(overrideUrlOnClick: widget.overrideUrlOnClick);
    sdk?.buildVerloop();
    setState(() {
      _ready = true;
    });
    log("widget built");
  }

  Future<void> _showChat() async {
    for (int i = 0; i < 5; i++) {
      if (!_ready) {
        log("verloop widget is not yet ready");
        await Future.delayed(const Duration(seconds: 1));
        continue;
      }
      sdk?.startChat();
      return;
    }
    log("verloop sdk is not initialised");
  }

  @override
  void dispose() async {
    super.dispose();
    log("disposing verloop widget");
    sdk?.dispose();
  }
}

class VerloopSdk {
  Future<void> setConfig({
    required String clientId,
    String? userId,
    String? recipeId,
    String? fcmToken,
    String? userName,
    String? userEmail,
    String? userPhone}) async {
    return await VerloopFlutterSdkPlatform.instance.setConfig(
        clientId: clientId,
        userId: userId,
        recipeId: recipeId,
        fcmToken: fcmToken,
        userName: userName,
        userEmail: userEmail,
        userPhone: userPhone
    );
  }

  Future<void> setButtonClickListener() async {
    return await VerloopFlutterSdkPlatform.instance.setButtonClickListener();
  }

  Future<void> setUrlClickListener({bool overrideUrlOnClick = false}) async {
    return await VerloopFlutterSdkPlatform.instance.setUrlClickListener(overrideUrlOnClick: overrideUrlOnClick);
  }

  Future<void> buildVerloop() async {
    return await VerloopFlutterSdkPlatform.instance.buildVerloop();
  }

  Future<void> startChat() async {
    return await VerloopFlutterSdkPlatform.instance.startChat();
  }

  Future<void> dispose() async {
    return await VerloopFlutterSdkPlatform.instance.dispose();
  }
}

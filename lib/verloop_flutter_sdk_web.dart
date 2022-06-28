// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html show window;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'verloop_flutter_sdk_platform_interface.dart';

/// A web implementation of the VerloopFlutterSdkPlatform of the VerloopFlutterSdk plugin.
class VerloopFlutterSdkWeb extends VerloopFlutterSdkPlatform {
  /// Constructs a VerloopFlutterSdkWeb
  VerloopFlutterSdkWeb();

  static void registerWith(Registrar registrar) {
    VerloopFlutterSdkPlatform.instance = VerloopFlutterSdkWeb();
  }

  /// Returns a [String] containing the version of the platform.
  /*@override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }*/

  @override
  Future<void> setConfig({
    required String clientId,
    String? userId,
    String? recipeId,
    String? fcmToken,
    String? userName,
    String? userEmail,
    String? userPhone,
    Map<String, String>? userVariables,
    Map<String, String>? roomVariables,
  }) async {
    throw UnimplementedError('setConfig() has not been implemented.');
  }

  @override
  Future<void> setButtonClickListener() async {
    throw UnimplementedError(
        'setButtonClickListener() has not been implemented.');
  }

  @override
  Future<void> setUrlClickListener({bool overrideUrlOnClick = false}) async {
    throw UnimplementedError('setUrlClickListener() has not been implemented.');
  }

  @override
  Future<void> buildVerloop() async {
    throw UnimplementedError('buildVerloop() has not been implemented.');
  }

  @override
  Future<void> startChat() async {
    throw UnimplementedError('startChat() has not been implemented.');
  }

  // @override
  // Stream<ButtonClickValue> get onButtonClicked {
  //   throw UnimplementedError('onButtonClicked() has not been implemented.');
  // }
  //
  // Stream<UrlClickValue> get onUrlClicked {
  //   throw UnimplementedError('onUrlClicked() has not been implemented.');
  // }

  @override
  Future<void> dispose() async {
    throw UnimplementedError('dispose() has not been implemented.');
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'url_click_values.dart';
import 'button_click_values.dart';
import 'verloop_flutter_sdk_platform_interface.dart';

/// An implementation of [VerloopFlutterSdkPlatform] that uses method channels.
class MethodChannelVerloopFlutterSdk extends VerloopFlutterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final verloopMethods = const MethodChannel('verloop.flutter.dev/method-call');

  @visibleForTesting
  final EventChannel verloopButtonClickEvents =
      const EventChannel('verloop.flutter.dev/events/button-click');

  @visibleForTesting
  final EventChannel verloopUrlClickEvents =
      const EventChannel('verloop.flutter.dev/events/url-click');

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
    try {
      await verloopMethods.invokeMethod('setConfig', <String, dynamic>{
        'USER_ID': userId,
        'CLIENT_ID': clientId,
        'RECIPE_ID': recipeId,
        'FCM_TOKEN': fcmToken,
        'USER_NAME': userName,
        'USER_EMAIL': userEmail,
        'USER_PHONE': userPhone,
        'USER_CUSTOM_FIELDS': userVariables,
        'ROOM_CUSTOM_FIELDS': roomVariables,
      });
    } on PlatformException catch (e) {
      log("Failed to set config for the widget: '${e.message}'.");
    }
  }

  @override
  Future<void> setButtonClickListener() async {
    try {
      await verloopMethods.invokeMethod('setButtonClickListener');
    } on PlatformException catch (e) {
      log("Failed to set button click listener: '${e.message}'.");
    }
  }

  @override
  Future<void> setUrlClickListener({bool overrideUrlOnClick = false}) async {
    try {
      await verloopMethods
          .invokeMethod('setUrlClickListener', <String, dynamic>{
        'OVERRIDE_URL': overrideUrlOnClick,
      });
    } on PlatformException catch (e) {
      log("Failed to set url click listener: '${e.message}'.");
    }
  }

  @override
  Future<void> buildVerloop() async {
    try {
      await verloopMethods.invokeMethod('buildVerloop');
    } on PlatformException catch (e) {
      log("Failed to build verloop widget: '${e.message}'.");
    }
  }

  @override
  Future<void> startChat() async {
    try {
      await verloopMethods.invokeMethod('showChat');
    } on PlatformException catch (e) {
      log("Failed to load widget: '${e.message}'.");
    }
  }

  @override
  Stream<ButtonClickValue> get onButtonClicked {
    return verloopButtonClickEvents
        .receiveBroadcastStream()
        .cast()
        .map((event) {
      String? type = event["TYPE"];
      String? title = event["TITLE"];
      String? payload = event["PAYLOAD"];

      return ButtonClickValue(title, payload, type);
    });
  }

  @override
  Stream<UrlClickValue> get onUrlClicked {
    return verloopUrlClickEvents.receiveBroadcastStream().cast().map((event) {
      String? url = event["URL"];
      return UrlClickValue(url);
    });
  }

  @override
  Future<void> dispose() async {
    try {
      await verloopMethods.invokeMethod('dispose');
    } on PlatformException catch (e) {
      log("Failed to dispose widget: '${e.message}'.");
    }
  }
}

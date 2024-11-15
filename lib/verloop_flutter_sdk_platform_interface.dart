import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:verloop_flutter_sdk/verloop_flutter_sdk.dart';

import 'verloop_flutter_sdk_method_channel.dart';

import 'url_click_values.dart';
import 'button_click_values.dart';

abstract class VerloopFlutterSdkPlatform extends PlatformInterface {
  /// Constructs a VerloopFlutterSdkPlatform.
  VerloopFlutterSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static VerloopFlutterSdkPlatform _instance = MethodChannelVerloopFlutterSdk();

  /// The default instance of [VerloopFlutterSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelVerloopFlutterSdk].
  static VerloopFlutterSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VerloopFlutterSdkPlatform] when
  /// they register themselves.
  static set instance(VerloopFlutterSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

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

  Future<void> setButtonClickListener() async {
    throw UnimplementedError(
        'setButtonClickListener() has not been implemented.');
  }

  Future<void> openMenuWidget() async {
    throw UnimplementedError(
        'openMenuWidget() has not been implemented.');
  }

  Future<void> setUrlClickListener({bool overrideUrlOnClick = false}) async {
    throw UnimplementedError('setUrlClickListener() has not been implemented.');
  } 

  Future<void> showDownloadButton({bool isAllowFileDownload = false}) async {
    throw UnimplementedError('showDownloadButton() has not been implemented.');
  }

  Future<void> setHeaderConfig({VerloopHeaderConfig? headerConfig}) async {
    throw UnimplementedError('setHeaderConfig() has not been implemented.');
  }

  Future<void> buildVerloop() async {
    throw UnimplementedError('buildVerloop() has not been implemented.');
  }

  Future<void> startChat() async {
    throw UnimplementedError('startChat() has not been implemented.');
  }

  Stream<ButtonClickValue> get onButtonClicked {
    throw UnimplementedError('onButtonClicked() has not been implemented.');
  }

  Stream<UrlClickValue> get onUrlClicked {
    throw UnimplementedError('onUrlClicked() has not been implemented.');
  }

  Future<void> dispose() async {
    throw UnimplementedError('dispose() has not been implemented.');
  }

  Future<void> dismissChat() async {
    throw UnimplementedError('dismissChat() has not been implemented.');
  }
  
}

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'verloop_flutter_sdk_method_channel.dart';

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
    String? userPhone}) async {
    throw UnimplementedError('setConfig() has not been implemented.');
  }

  Future<void> setButtonClickListener() async {
    throw UnimplementedError('setButtonClickListener() has not been implemented.');
  }

  Future<void> setUrlClickListener({bool overrideUrlOnClick = false}) async {
    throw UnimplementedError('setUrlClickListener() has not been implemented.');
  }

  Future<void> buildVerloop() async {
    throw UnimplementedError('buildVerloop() has not been implemented.');
  }

  Future<void> startChat() async {
    throw UnimplementedError('startChat() has not been implemented.');
  }

  Future<void> dispose() async {
    throw UnimplementedError('dispose() has not been implemented.');
  }
}

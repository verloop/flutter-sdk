import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:verloop_flutter_sdk/button_click_values.dart';
import 'package:verloop_flutter_sdk/url_click_values.dart';
import 'package:verloop_flutter_sdk/verloop_flutter_sdk_method_channel.dart';
import 'package:verloop_flutter_sdk/verloop_flutter_sdk_platform_interface.dart';

class MockVerloopFlutterSdkPlatform 
    with MockPlatformInterfaceMixin
    implements VerloopFlutterSdkPlatform {

  @override
  Future<void> buildVerloop() {
    // TODO: implement buildVerloop
    throw UnimplementedError();
  }

  @override
  Future<void> dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  @override
  // TODO: implement onButtonClicked
  Stream<ButtonClickValue> get onButtonClicked => throw UnimplementedError();

  @override
  // TODO: implement onUrlClicked
  Stream<UrlClickValue> get onUrlClicked => throw UnimplementedError();

  @override
  Future<void> setButtonClickListener() {
    // TODO: implement setButtonClickListener
    throw UnimplementedError();
  }

  @override
  Future<void> setConfig({required String clientId, String? userId, String? recipeId, String? fcmToken, String? userName, String? userEmail, String? userPhone, Map<String, String>? userVariables, Map<String, String>? roomVariables}) {
    // TODO: implement setConfig
    throw UnimplementedError();
  }

  @override
  Future<void> setUrlClickListener({bool overrideUrlOnClick = false}) {
    // TODO: implement setUrlClickListener
    throw UnimplementedError();
  }

  @override
  Future<void> startChat() {
    // TODO: implement startChat
    throw UnimplementedError();
  }
}

void main() {
  final VerloopFlutterSdkPlatform initialPlatform = VerloopFlutterSdkPlatform.instance;

  test('$MethodChannelVerloopFlutterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVerloopFlutterSdk>());
  });

  test('getPlatformVersion', () async {
    // VerloopFlutterSdk verloopFlutterSdkPlugin = VerloopFlutterSdk();
    // MockVerloopFlutterSdkPlatform fakePlatform = MockVerloopFlutterSdkPlatform();
    // VerloopFlutterSdkPlatform.instance = fakePlatform;
    //
    // expect(await verloopFlutterSdkPlugin.getPlatformVersion(), '42');
  });
}

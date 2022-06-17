import 'package:flutter_test/flutter_test.dart';
import 'package:verloop_flutter_sdk/verloop_flutter_sdk.dart';
import 'package:verloop_flutter_sdk/verloop_flutter_sdk_platform_interface.dart';
import 'package:verloop_flutter_sdk/verloop_flutter_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockVerloopFlutterSdkPlatform 
    with MockPlatformInterfaceMixin
    implements VerloopFlutterSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final VerloopFlutterSdkPlatform initialPlatform = VerloopFlutterSdkPlatform.instance;

  test('$MethodChannelVerloopFlutterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVerloopFlutterSdk>());
  });

  test('getPlatformVersion', () async {
    VerloopFlutterSdk verloopFlutterSdkPlugin = VerloopFlutterSdk();
    MockVerloopFlutterSdkPlatform fakePlatform = MockVerloopFlutterSdkPlatform();
    VerloopFlutterSdkPlatform.instance = fakePlatform;
  
    expect(await verloopFlutterSdkPlugin.getPlatformVersion(), '42');
  });
}

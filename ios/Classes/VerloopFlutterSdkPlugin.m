#import "VerloopFlutterSdkPlugin.h"
#if __has_include(<verloop_flutter_sdk/verloop_flutter_sdk-Swift.h>)
#import <verloop_flutter_sdk/verloop_flutter_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "verloop_flutter_sdk-Swift.h"
#endif

@implementation VerloopFlutterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVerloopFlutterSdkPlugin registerWithRegistrar:registrar];
}
@end

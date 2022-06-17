import Flutter
import UIKit

public class SwiftVerloopFlutterSdkPlugin: NSObject, FlutterPlugin {

  private static methodChannel = "verloop.flutter.dev/method-call"
  private static buttonClickChannel = "verloop.flutter.dev/events/button-click'"
  private static urlClickChannel = "verloop.flutter.dev/events/url-click'"


  private static ERROR_101 = "101" // verloop object not built
  private static ERROR_102 = "102" // client id not defined

  public static func register(with registrar: FlutterPluginRegistrar) {

    let channel = FlutterMethodChannel(name: methodChannel, binaryMessenger: registrar.messenger())
    let buttonChannel = FlutterEventChannel(name: buttonClickChannel, binaryMessenger: registrar.messenger())
    let urlChannel = FlutterEventChannel(name: urlClickChannel, binaryMessenger: registrar.messenger())

    let instance = SwiftVerloopFlutterSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    let buttonHandler = ButtonClickHandler()
    buttonChannel.setStreamHandler(buttonHandler)
    let urlHandler = UrlClickHandler()
    urlChannel.setStreamHandler(urlHandler)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "getDb":
            if let args = call.arguments as? [String] {
                if args.count == 2 {
                    var error : NSError?
                    let db = MobileapiReadDatabase(args[0], args[1], &error)
                    if let errorMessage = error?.userInfo.description {
                        result(FlutterError.init(code: "NATIVE_ERR",
                                                 message: "Error: " + errorMessage,
                                                 details: nil))
                    } else {
                        // SUCCESS!!
                        result(1)
                    }
                } else {
                    result(FlutterError.init(code: "BAD_ARGS",
                                             message: "Wrong arg count (getDb expects 2 args): " + args.count.description,
                                             details: nil))
                }
            } else {
                result(FlutterError.init(code: "BAD_ARGS",
                                         message: "Wrong argument types",
                                         details: nil))
            }
        case "setConfig":
        case "setButtonClickListener":
        case "setUrlClickListener":
        case "buildVerloop":
        case "showChat":

        default:
            result(FlutterMethodNotImplemented)
        }
    }
  }
}

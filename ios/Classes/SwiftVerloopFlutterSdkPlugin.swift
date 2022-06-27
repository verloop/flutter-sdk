import Flutter
import UIKit
import VerloopSDKiOS

public class SwiftVerloopFlutterSdkPlugin: NSObject, FlutterPlugin, VLEventDelegate {
  private var previousWindow: UIWindow? = nil
  private var window = UIWindow()

  private static var methodChannel = "verloop.flutter.dev/method-call"
  private static var buttonClickChannel = "verloop.flutter.dev/events/button-click"
  private static var urlClickChannel = "verloop.flutter.dev/events/url-click"

  private static var buttonHandler: ButtonClickHandler?
  private static var urlHandler: UrlClickHandler?


  private static var ERROR_101 = "101" // verloop object not built
  private static var ERROR_102 = "102" // client id not defined

  private var verloop: VerloopSDK?
  private var clientId: String?
  private var config: VLConfig?

  public static func register(with registrar: FlutterPluginRegistrar) {

    let channel = FlutterMethodChannel(name: methodChannel, binaryMessenger: registrar.messenger())
    let buttonChannel = FlutterEventChannel(name: buttonClickChannel, binaryMessenger: registrar.messenger())
    let urlChannel = FlutterEventChannel(name: urlClickChannel, binaryMessenger: registrar.messenger())

    let instance = SwiftVerloopFlutterSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    buttonHandler = ButtonClickHandler()
    buttonChannel.setStreamHandler(buttonHandler)
    urlHandler = UrlClickHandler()
    urlChannel.setStreamHandler(urlHandler)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "setConfig":
            if let args = call.arguments as? Dictionary<String, Any> {
                var clientId = args["CLIENT_ID"] as? String
                if clientId == nil || clientId == "" {
                    result(FlutterError.init(code: SwiftVerloopFlutterSdkPlugin.ERROR_102,
                                                         message: "CLIENT_ID missing",
                                                         details: nil))
                    return
                }
                config = VLConfig(clientId: clientId!)

                var userId = args["USER_ID"] as? String
                if userId != nil && userId != "" {
                    config?.setUserId(userId: userId!)
                }

                var fcmToken = args["FCM_TOKEN"] as? String
                if fcmToken != nil && fcmToken != "" {
                    config?.setNotificationToken(notificationToken: fcmToken!)               // If you wish to get notifications, else, skip this
                }

                var recipeId = args["RECIPE_ID"] as? String
                if recipeId != nil && recipeId != "" {
                    config?.setRecipeId(recipeId: recipeId!)               // In case you want to use default recipe, skip this
                }

                var userName = args["USER_NAME"] as? String
                if userName != nil && userName != "" {
                    config?.setUserName(userName: userName!)               // If guest name variable is a part of the recipe, or the value is not required, skip this
                }

                var userEmail = args["USER_EMAIL"] as? String
                if userEmail != nil && userEmail != "" {
                    config?.setUserEmail(userEmail: userEmail!)               // If email variable is a part of the recipe, or the value is not required, skip this
                }

                var userPhone = args["USER_PHONE"] as? String
                if userPhone != nil && userPhone != "" {
                    config?.setUserPhone(userPhone: userPhone!)               // If phone variable is a part of the recipe, or the value is not required, skip this
                }

                var isStaging = args["IS_STAGING"] as? Bool
                if isStaging != nil {
                    config?.setStaging(isStaging: isStaging!)               // Keep this as true if you want to access <client_id>.stage.verloop.io account. If the account doesn't exist, keep it as false or skip it
                }

                var customFields = args["ROOM_CUSTOM_FIELDS"] as? Dictionary<String, String>  // These are predefined variables added on room level
                if customFields != nil {
                  for (key, value) in customFields! {
                    config?.putCustomField(key: key, value: value, scope: VLConfig.SCOPE.ROOM)
                  }
                }

                var userCustomFields = args["USER_CUSTOM_FIELDS"] as? Dictionary<String, String>  // These are predefined variables added on user level
                if userCustomFields != nil {
                  for (key, value) in userCustomFields! {
                    config?.putCustomField(key: key, value: value, scope: VLConfig.SCOPE.USER)
                  }
                }

                result(1)
            } else {
                result(FlutterError.init(code: "BAD_ARGS",
                                         message: "Wrong argument types",
                                         details: nil))
            }
        case "setButtonClickListener":
            config?.setButtonOnClickListener(onButtonClicked:{(title: String?, type: String?, payload: String?) in
                SwiftVerloopFlutterSdkPlugin.buttonHandler?.buttonClicked(title: title, type: type, payload: payload)
                return;
            })
            result(1)
        case "setUrlClickListener":
            config?.setUrlClickListener(onUrlClicked:{(url: String?) in
                SwiftVerloopFlutterSdkPlugin.urlHandler?.urlClicked(url: url)
                return;
            })
            result(1)
        case "buildVerloop":
            if config == nil {
                result(FlutterError.init(code: SwiftVerloopFlutterSdkPlugin.ERROR_101,
                                         message: "config missing",
                                         details: "call setConfig before calling buildVerloop"))
                return
            }
            verloop = VerloopSDK(config: config!)
            verloop?.observeLiveChatEventsOn(vlEventDelegate: self)
        case "showChat":
            if verloop == nil {
                result(FlutterError.init(code: SwiftVerloopFlutterSdkPlugin.ERROR_101,
                                         message: "verloop object missing",
                                         details: "call buildVerloop before calling showChat"))
                return
            }
            previousWindow = UIApplication.shared.keyWindow
            window.isOpaque = true
//             window.backgroundColor = UIColor.white
//             window.frame = UIScreen.main.bounds

            window.windowLevel = UIWindow.Level.normal + 1
            window.rootViewController = verloop!.getNavController()
            window.makeKeyAndVisible()
        default:
            result(FlutterMethodNotImplemented)
    }
  }
  public func onChatMinimized() {
      window.resignKey()
      previousWindow?.makeKeyAndVisible()
      previousWindow = nil
      window.windowLevel = UIWindow.Level.normal - 30
  }
}

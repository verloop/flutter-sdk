import Flutter
import UIKit
import VerloopSDKiOS

public class SwiftVerloopFlutterSdkPlugin: NSObject, FlutterPlugin, VLEventDelegate {
  private var previousWindow: UIWindow? = nil
  private var window = UIWindow()
    
  private var viewController: UIViewController?

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
                let clientId = args["CLIENT_ID"] as? String
                if clientId == nil || clientId == "" {
                    result(FlutterError.init(code: SwiftVerloopFlutterSdkPlugin.ERROR_102,
                                                         message: "CLIENT_ID missing",
                                                         details: nil))
                    return
                }
                config = VLConfig(clientId: clientId!)

                let userId = args["USER_ID"] as? String
                if userId != nil && userId != "" {
                    config?.setUserId(userId: userId!)
                }

                let fcmToken = args["FCM_TOKEN"] as? String
                if fcmToken != nil && fcmToken != "" {
                    config?.setNotificationToken(notificationToken: fcmToken!)               // If you wish to get notifications, else, skip this
                }

                let recipeId = args["RECIPE_ID"] as? String
                if recipeId != nil && recipeId != "" {
                    config?.setRecipeId(recipeId: recipeId!)               // In case you want to use default recipe, skip this
                }

                let userName = args["USER_NAME"] as? String
                if userName != nil && userName != "" {
                    config?.setUserName(userName: userName!)               // If guest name variable is a part of the recipe, or the value is not required, skip this
                }

                let userEmail = args["USER_EMAIL"] as? String
                if userEmail != nil && userEmail != "" {
                    config?.setUserEmail(userEmail: userEmail!)               // If email variable is a part of the recipe, or the value is not required, skip this
                }

                let userPhone = args["USER_PHONE"] as? String
                if userPhone != nil && userPhone != "" {
                    config?.setUserPhone(userPhone: userPhone!)               // If phone variable is a part of the recipe, or the value is not required, skip this
                }

                let isStaging = args["IS_STAGING"] as? Bool
                if isStaging != nil {
                    config?.setStaging(isStaging: isStaging!)               // Keep this as true if you want to access <client_id>.stage.verloop.io account. If the account doesn't exist, keep it as false or skip it
                }

                let customFields = args["ROOM_CUSTOM_FIELDS"] as? Dictionary<String, String>  // These are predefined variables added on room level
                if customFields != nil {
                  for (key, value) in customFields! {
                    config?.putCustomField(key: key, value: value, scope: VLConfig.SCOPE.ROOM)
                  }
                }

                let userCustomFields = args["USER_CUSTOM_FIELDS"] as? Dictionary<String, String>  // These are predefined variables added on user level
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
            if let args = call.arguments as? Dictionary<String, Any> {
                let overrideUrl = args["OVERRIDE_URL"] as? Bool
                if overrideUrl != nil {
                    config?.setUrlRedirectionFlag(canRedirect: !overrideUrl!)               // if you wish to open the url in a browser, then keep it as false
                }
            }
            config?.setUrlClickListener(onUrlClicked:{(url: String?) in
                SwiftVerloopFlutterSdkPlugin.urlHandler?.urlClicked(url: url)
                return;
            })
            result(1)
        case "showDownloadButton":
            if let args = call.arguments as? Dictionary<String, Any> {
                let isAllowFileDownload = args["isAllowFileDownload"] as? Bool
                if isAllowFileDownload != nil {
                    config?.showDownloadButton(isAllowFileDownload ?? false)
                }
            }
            result(1)
        case "openMenuWidget":
            config?.openMenuWidget()
            result(1)
        case "setHeaderConfig":
        if let args = call.arguments as? Dictionary<String, Any> {
                let widgetTitle = args["title"] as? String
                let widgetColors = args["widgetColor"] as? String
                if widgetTitle != nil {
                    config?.setTitle(widgetTitle: widgetTitle ?? "")
                }
                if widgetColors != nil {
                let uiColor = hexStringToUIColor(hex: widgetColors!)
                 config?.setWidgetColor(widgetColor: uiColor)
               }
            }
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
//           previousWindow = UIApplication.shared.keyWindow
//           window.isOpaque = true
//           window.windowLevel = UIWindow.Level.normal + 1
           //window.rootViewController = verloop!.getNavController()
           //window.makeKeyAndVisible()
            viewController = verloop!.getNavController()
        if let rootVC = UIApplication.shared.delegate?.window??.rootViewController {
            rootVC.present(viewController!, animated: true, completion: nil)
        }
        result(1)
       case "dispose":
            verloop = nil
            clientId = nil
            config?.setUrlClickListener(onUrlClicked: nil)
            config?.setButtonOnClickListener(onButtonClicked: nil)
            config = nil
            return

        case "dismissChat":
            self.viewController?.dismiss(animated: true, completion: {
                self.viewController = nil // Clear the reference after dismissing
            })
            result(1)

        case "logout": 
            config?.logout()
            result(1)

        case "closeChat":
            config?.close()
            result(1)

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
    
    func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

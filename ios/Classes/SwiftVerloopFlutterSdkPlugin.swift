import Flutter
import UIKit
import VerloopSDK

public class SwiftVerloopFlutterSdkPlugin: NSObject, FlutterPlugin {

  private static var methodChannel = "verloop.flutter.dev/method-call"
  private static var buttonClickChannel = "verloop.flutter.dev/events/button-click'"
  private static var urlClickChannel = "verloop.flutter.dev/events/url-click'"


  private static var ERROR_101 = "101" // verloop object not built
  private static var ERROR_102 = "102" // client id not defined

  private var verloop: VerloopSDK? = null
  private var clientId: String? = null
  private var config: VLConfig? = null

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
        case "setConfig":
            if let args = call.arguments as? Dictionary<String, Any> {
                var clientId = args["CLIENT_ID"] as? String
                config = VLConfig(clientId)

                var userId = args["USER_ID"] as? String
                if userId != nil && userId != "" {
                    config.setUserId(userId)
                }

                var fcmToken = args["FCM_TOKEN"] as? String
                if fcmToken != null && fcmToken != "" {
                    config.setFcmToken(fcmToken)               // If you wish to get notifications, else, skip this
                }

                var recipeId = args["RECIPE_ID"] as? String
                if recipeId != null && recipeId != "" {
                    config.setRecipeId(recipeId)               // In case you want to use default recipe, skip this
                }

                var userName = args["USER_NAME"] as? String
                if userName != null && userName != "" {
                    config.setUserName(userName)               // If guest name variable is a part of the recipe, or the value is not required, skip this
                }

                var userEmail = args["USER_EMAIL"] as? String
                if userEmail != null && userEmail != "" {
                    config.setUserEmail(userEmail)               // If email variable is a part of the recipe, or the value is not required, skip this
                }

                var userPhone = args["USER_PHONE"] as? String
                if userPhone != null && userPhone != "" {
                    config.setUserPhone(userPhone)               // If phone variable is a part of the recipe, or the value is not required, skip this
                }

                var isStaging = args["IS_STAGING"] as? Bool
                if isStaging != null {
                    config.setIsStaging(isStaging)               // Keep this as true if you want to access <client_id>.stage.verloop.io account. If the account doesn't exist, keep it as false or skip it
                }

                var customFields = args["ROOM_CUSTOM_FIELDS"] as? Dictionary<String, String>  // These are predefined variables added on room level
                if customFields != null {
                  for (key, value) in customFields {
                    config.putCustomField(key, value, VerloopConfig.Scope.ROOM)
                  }
                }

                var userCustomFields = args["USER_CUSTOM_FIELDS"] as? Dictionary<String, String>  // These are predefined variables added on user level
                if userCustomFields != null {
                  for (key, value) in userCustomFields {
                    config.putCustomField(key, value, VerloopConfig.Scope.USER)
                  }
                }

                result(1)
            } else {
                result(FlutterError.init(code: "BAD_ARGS",
                                         message: "Wrong argument types",
                                         details: nil))
            }
//         case "setButtonClickListener":
//         case "setUrlClickListener":
//         case "buildVerloop":
//         case "showChat":
        default:
            result(FlutterMethodNotImplemented)
    }
  }
}

package io.verloop.verloop_flutter_sdk

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.verloop.sdk.LiveChatButtonClickListener
import io.verloop.sdk.LiveChatUrlClickListener
import io.verloop.sdk.Verloop
import io.verloop.sdk.VerloopConfig
import java.util.ArrayList
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding


import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** VerloopFlutterSdkPlugin */
class VerloopFlutterSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private lateinit var buttonCallbackChannel: EventChannel
    private lateinit var buttonClickHandler: ButtonClickHandler

    private lateinit var urlCallbackChannel: EventChannel
    private lateinit var urlClickHandler: UrlClickHandler

    private val CHANNEL = "verloop.flutter.dev/method-call"
    private val CALLBACK_BUTTON_CLICK_CHANNEL = "verloop.flutter.dev/events/button-click"
    private val CALLBACK_URL_CLICK_CHANNEL = "verloop.flutter.dev/events/url-click"

    private val ERROR_101 = "101" // verloop object not built
    private val ERROR_102 = "102" // client id not defined

    private var verloop: Verloop? = null
    private var clientId: String? = null
    private var configBuilder: VerloopConfig.Builder? = null
    private var config: VerloopConfig? = null

    private lateinit var activity: Activity

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)

        // This channel would listen for all the button clicks on the chat
        buttonCallbackChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, CALLBACK_BUTTON_CLICK_CHANNEL)
        buttonClickHandler = ButtonClickHandler()
        buttonCallbackChannel.setStreamHandler(buttonClickHandler)

        // This channel would listen for all the url clicks on the chat
        urlCallbackChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, CALLBACK_URL_CLICK_CHANNEL)
        urlClickHandler = UrlClickHandler()
        urlCallbackChannel.setStreamHandler(urlClickHandler)

    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setConfig" -> {
                if (configBuilder == null) {
                    configBuilder = VerloopConfig.Builder()
                }
                val userId = call.argument<String>("USER_ID")
                if (userId != null && userId != "") {
                    configBuilder =
                        configBuilder!!.userId(userId)                   // If user is logged in, and if you want to associate older chats, else, skip this for anonymous user
                }
                val clientId = call.argument<String>("CLIENT_ID")
                if (clientId != null && clientId != "") {
                    this.clientId = clientId
                    configBuilder =
                        configBuilder!!.clientId(clientId)
                }

                val fcmToken = call.argument<String>("FCM_TOKEN")
                if (fcmToken != null && fcmToken != "") {
                    configBuilder =
                        configBuilder!!.fcmToken(fcmToken)               // If you wish to get notifications, else, skip this
                }

                val recipeId = call.argument<String>("RECIPE_ID")
                if (recipeId != null && recipeId != "") {
                    configBuilder =
                        configBuilder!!.recipeId(recipeId)               // In case you want to use default recipe, skip this
                }

                val userName = call.argument<String>("USER_NAME")
                if (userName != null && userName != "") {
                    configBuilder =
                        configBuilder!!.userName(userName)               // If guest name variable is a part of the recipe, or the value is not required, skip this
                }

                val userEmail = call.argument<String>("USER_EMAIL")
                if (userEmail != null && userEmail != "") {
                    configBuilder =
                        configBuilder!!.userEmail(userEmail)               // If email variable is a part of the recipe, or the value is not required, skip this
                }

                val userPhone = call.argument<String>("USER_PHONE")
                if (userPhone != null && userPhone != "") {
                    configBuilder =
                        configBuilder!!.userPhone(userPhone)               // If phone variable is a part of the recipe, or the value is not required, skip this
                }

                val isStaging = call.argument<Boolean>("IS_STAGING")
                if (isStaging != null) {
                    configBuilder =
                        configBuilder!!.isStaging(isStaging)               // Keep this as true if you want to access <client_id>.stage.verloop.io account. If the account doesn't exist, keep it as false or skip it
                }

                val customFields = call.argument<Map<String, String>>("ROOM_CUSTOM_FIELDS")
                val fields: ArrayList<VerloopConfig.CustomField> =
                    ArrayList<VerloopConfig.CustomField>()
                if (customFields != null) {
                    for ((key, value) in customFields) {
                        val customField = VerloopConfig.CustomField()
                        customField.key = key
                        customField.value = value
                        customField.scope = VerloopConfig.Scope.ROOM
                        fields.add(customField)
                    }
                }

                val userCustomFields = call.argument<Map<String, String>>("USER_CUSTOM_FIELDS")
                if (userCustomFields != null) {
                    for ((key, value) in userCustomFields) {
                        val customField = VerloopConfig.CustomField()
                        customField.key = key
                        customField.value = value
                        customField.scope = VerloopConfig.Scope.USER
                        fields.add(customField)
                    }
                }
                if (userCustomFields != null || customFields != null) {
                    configBuilder =
                        configBuilder!!.fields(fields)               // These are predefined variables
                }

                result.success(1)
                return
            }
            "setButtonClickListener" -> {
                if (configBuilder == null) {
                    configBuilder = VerloopConfig.Builder()
                }
                if (config == null && clientId == null) {
                    val clientId =
                        call.argument<String>("CLIENT_ID")
                    if (clientId == null) {
                        result.error(
                            ERROR_102,
                            "CLIENT_ID not defined 1",
                            "either set CLIENT_ID using setConfig or pass it in this function call"
                        )
                        return
                    }

                }

                val config = configBuilder!!
                    .clientId(clientId)
                    .build()

                config.setButtonClickListener(object : LiveChatButtonClickListener {
                    override fun buttonClicked(title: String?, type: String?, payload: String?) {
                        // Add the app logic for button click
                        buttonClickHandler.buttonClicked(title, type, payload)
                    }
                })

                this.config = config
                result.success(1)
                return
            }
            "setUrlClickListener" -> {
                if (configBuilder == null) {
                    configBuilder = VerloopConfig.Builder()
                }
                if (config == null && clientId == null) {
                    val clientId =
                        call.argument<String>("CLIENT_ID")
                    if (clientId == null) {
                        result.error(
                            ERROR_102,
                            "CLIENT_ID not defined 1",
                            "either set CLIENT_ID using setConfig or pass it in this function call"
                        )
                        return
                    }
                }
                // if this is set to true, we will not open the url in the browser
                var overrideUrlClick =
                    call.argument<Boolean>("OVERRIDE_URL")
                if (overrideUrlClick == null) {
                    overrideUrlClick = false
                }

                val config = configBuilder!!
                    .clientId(clientId)
                    .build()

                config.setUrlClickListener(object : LiveChatUrlClickListener {
                    override fun urlClicked(url: String?) {
                        // Add the app logic for button click
                        urlClickHandler.urlClicked(url)
                    }
                }, overrideUrlClick)

                this.config = config
                result.success(1)
                return
            }
            "buildVerloop" -> {
                if (configBuilder == null) {
                    configBuilder = VerloopConfig.Builder()
                }
                if (clientId == null) {
                    val clientId =
                        call.argument<String>("CLIENT_ID")           // Required: this would be your account name associated with verloop. eg: <client_id>.verloop.io
                    if (clientId == null) {
                        result.error(
                            ERROR_102,
                            "CLIENT_ID not defined",
                            "pass map with CLIENT_ID when calling buildVerloop"
                        )
                        return
                    }
                    this.clientId = clientId
                }
                val config = configBuilder!!
                    .clientId(clientId)
                    .build()                // this would build the final config object which is later used by Verloop object to star the chat
                if (this.config != null && this.config!!.buttonOnClickListener != null) {
                    this.config!!.buttonOnClickListener?.let { config.setButtonClickListener(it) }
                }
                if (this.config != null && this.config!!.chatUrlClickListener != null) {
                    this.config!!.chatUrlClickListener?.let { config.setUrlClickListener(it) }
                    config.overrideUrlClick = this.config!!.overrideUrlClick
                }
                this.config = config
                verloop = Verloop(activity, config)
                result.success(1)
                return
            }
            "showChat" -> {
                if (verloop == null) {
                    result.error(
                        ERROR_101,
                        "verloop object null",
                        "buildVerloop is not called before calling showChat"
                    )
                    return
                }
                verloop!!.showChat()
                result.success(1)
                return
            }
            "dispose" -> {
                verloop = null
                configBuilder = null
                clientId = null
                config = null
                buttonCallbackChannel.setStreamHandler(null)
                urlCallbackChannel.setStreamHandler(null)
                return
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        verloop = null
        configBuilder = null
        clientId = null
        config = null

        channel.setMethodCallHandler(null)
        buttonCallbackChannel.setStreamHandler(null)
        urlCallbackChannel.setStreamHandler(null)
    }
}

package io.verloop.verloop_flutter_sdk

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel


class ButtonClickHandler : EventChannel.StreamHandler {
    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())
    var sink: EventChannel.EventSink? = null

    fun buttonClicked(title: String?, type: String?, payload: String?) {
        uiThreadHandler.post {
            sink?.success(
                mapOf(
                    "TITLE" to title,
                    "TYPE" to type,
                    "PAYLOAD" to payload
                )
            )
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }
}
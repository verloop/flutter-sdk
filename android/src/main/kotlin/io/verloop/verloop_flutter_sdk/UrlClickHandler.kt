package io.verloop.verloop_flutter_sdk

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel


class UrlClickHandler : EventChannel.StreamHandler {
    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())
    var sink: EventChannel.EventSink? = null

    fun urlClicked(url: String?) {
        uiThreadHandler.post {
            sink?.success(
                mapOf(
                    "URL" to url,
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
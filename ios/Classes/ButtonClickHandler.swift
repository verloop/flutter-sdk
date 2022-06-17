import Foundation
import Flutter

class ButtonClickHandler: NSObject, FlutterStreamHandler{
    var sink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }

    @objc func buttonClicked(title: String?, type: String?, payload: String?) {
        guard let sink = sink else { return }
        let dictionary = [
            "TITLE": title,
            "TYPE": type,
            "PAYLOAD": payload
        ]
        sink(dictionary)
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
}
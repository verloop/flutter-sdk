import Foundation
import Flutter

class UrlClickHandler: NSObject, FlutterStreamHandler{
    var sink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }

    @objc func buttonClicked(url: String?) {
        guard let sink = sink else { return }
        let dictionary = ["URL": url]
        sink(dictionary)
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
}
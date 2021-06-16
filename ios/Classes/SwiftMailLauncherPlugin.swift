import Flutter
import UIKit


public class SwiftMailLauncherPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "mail_launcher", binaryMessenger: registrar.messenger())
        let instance = SwiftMailLauncherPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "launch":
            launch(call.arguments as! [String : String?], result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func launch(_ email: [String:String?], result: @escaping FlutterResult) {
        let to = unwrap(email["to"])
        let subject = unwrap(email["subject"]??.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        let body = unwrap(email["body"]??.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        let apps = [
            "Apple Mail":"mailto:\(to)?subject=\(subject)&body=\(body)",
            "Google Mail":"googlegmail://co?to=\(to)&subject=\(subject)&body=\(body)",
            "Microsoft Outlook":"ms-outlook://compose?to=\(to)&subject=\(subject)&body=\(body)",
            "Yahoo Mail":"ymail://mail/compose?to=\(to)&subject=\(subject)&body=\(body)",
            "Spark":"readdle-spark://compose?recipient=\(to)&subject=\(subject)&body=\(body)",
            "Airmail":"airmail://compose?to=\(to)&subject=\(subject)&plainBody=\(body)",
            "Dispatch":"x-dispatch://compose?to=\(to)&subject=\(subject)&body=\(body)",
            "Fastmail":"fastmail://mail/compose?to=\(to)&subject=\(subject)&body=\(body)",
        ]
        let available = apps.filter {
            if let url = URL(string: $0.value) {
                return UIApplication.shared.canOpenURL(url)
            }
            return false
        }
        if (available.isEmpty) {
            result(
                FlutterError(code: "empty_available_clients",
                             message: "Empty available Email clients",
                             details: nil
                )
            )
        } else if (available.count == 1) {
            if let url = URL(string: available.first?.value ?? "mailto:") {
                openUrl(url, result: result)
                result(nil)
            }
        } else {
            let title = email["dialogTitle"] as? String
            let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            available.forEach { (key: String, value: String) in
                if let url = URL(string: value) {
                    let handler: (UIAlertAction) -> Void = { _ in self.openUrl(url, result: result)}
                    let action = UIAlertAction(title: key, style: .default, handler: handler)
                    actionSheet.addAction(action)
                }
            }
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            if let controller = UIApplication.shared.delegate?.window??.rootViewController {
                controller.present(actionSheet, animated: true) { result(nil) }
            }
        }
    }
    
    private func unwrap(_ string: String??) -> String {
        let s = string ?? ""
        return s ?? ""
    }
    
    private func openUrl(_ url: URL, result: @escaping FlutterResult) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: {_ in result(nil)})
        } else {
            UIApplication.shared.openURL(url)
            result(nil)
        }
    }
}

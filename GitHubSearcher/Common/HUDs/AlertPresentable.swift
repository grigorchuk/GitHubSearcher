import UIKit

protocol AlertPresentable {
    
    associatedtype AnyAlert: Alert
    
    var alert: AnyAlert { get }
    var spinnerColor: UIColor { get }
    
    func showAlert(with title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction])
}

extension AlertPresentable where Self: UIViewController {
    
    var spinnerColor: UIColor {
        return .blue
    }
    
    func showAlert(with title: String? = nil, message: String? = nil, style: UIAlertController.Style, actions: [UIAlertAction]) {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
        alert.show(on: self, title: title, message: message, style: style, actions: actions)
    }
}

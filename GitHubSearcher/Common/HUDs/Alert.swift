import UIKit

protocol Alert {
    func show(
        on viewController: UIViewController,
        title: String?,
        message: String?,
        style: UIAlertController.Style,
        actions: [UIAlertAction])
    
}

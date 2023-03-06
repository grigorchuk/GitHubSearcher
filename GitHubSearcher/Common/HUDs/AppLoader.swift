import SVProgressHUD

final class AppLoader: Loader {
    
    func show(on view: UIView, text: String?, blockUI: Bool) {
        SVProgressHUD.setDefaultMaskType(blockUI ? .clear : .none)
        
        if let text = text {
            SVProgressHUD.show(withStatus: text)
        } else {
            SVProgressHUD.show()
        }
    }
    
    func hide(from view: UIView) {
        SVProgressHUD.dismiss()
    }
    
}

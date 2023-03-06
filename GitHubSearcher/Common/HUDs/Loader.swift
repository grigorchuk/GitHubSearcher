import SVProgressHUD

protocol Spinner {
    
    func show(on view: UIView, text: String?, blockUI: Bool)
    func hide(from view: UIView)
}

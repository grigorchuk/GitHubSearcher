import UIKit

protocol LoaderPresentable {
    
    associatedtype LoaderType: Loader
    
    var Loader: LoaderType { get }
}

extension LoaderPresentable where Self: UIViewController {
    
    func showLoader(with text: String? = nil, blockUI: Bool = true) {
        Loader.show(on: view, text: text, blockUI: blockUI)
    }
    
    func hideLoader() {
        Loader.hide(from: view)
    }
}

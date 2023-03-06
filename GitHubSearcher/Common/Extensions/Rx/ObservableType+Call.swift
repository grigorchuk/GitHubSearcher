import Foundation
import RxSwift

extension ObservableType {
    
    /// calls given selector with each next value from current stream
    public func call<T: AnyObject>(_ object: T, _ selector: @escaping (T) -> () -> Void) -> Disposable {
        return subscribe(
            onNext: { [weak object] _ in
                if let `object` = object {
                    selector(object)()
                }
            },
            onError: nil,
            onCompleted: nil,
            onDisposed: nil
        )
    }
    
    /// calls given selector with each next value from current stream and passes the value
    public func call<T: AnyObject>(_ object: T, _ selector: @escaping (T) -> (E) -> Void) -> Disposable {
        return subscribe(
            onNext: { [weak object] value in
                if let `object` = object {
                    selector(object)(value)
                }
            },
            onError: nil,
            onCompleted: nil,
            onDisposed: nil
        )
    }

}

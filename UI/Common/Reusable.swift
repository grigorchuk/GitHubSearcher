import UIKit

public protocol Reusable: class {
    
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    
    static var reuseIdentifier: String { String(describing: self) }
}

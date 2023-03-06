//
//  BaseView.swift
// AlarmClock
//

import UIKit

public class BaseView: UIView {
    
    public init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Init is not implemented")
    }
}

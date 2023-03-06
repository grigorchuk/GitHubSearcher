//
//  TitledSelectionHeaderView.swift
//  UI
//
//  Created by Alex on 03.09.2020.
//  Copyright © 2020 Grigorchuk. All rights reserved.
//

import UIKit

final public class TitledSelectionHeaderView: UITableViewHeaderFooterView, Reusable {
    
    public let titleLabel: UILabel = UILabel()
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView = UIView(frame: bounds)
        backgroundView!.backgroundColor = .groupTableViewBackground
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.numberOfLines = 0
        
        addSubview(titleLabel)
        titleLabel.layout {
            $0.top.equal(to: topAnchor, offsetBy: 8.0)
            $0.leading.equal(to: leadingAnchor, offsetBy: 16.0)
            $0.trailing.equal(to: trailingAnchor, offsetBy: -16.0)
            $0.bottom.equal(to: bottomAnchor, offsetBy: -8.0)
        }
    }
}

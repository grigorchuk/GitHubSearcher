//
//  RepositoryTableViewCell.swift
//  UI
//
//  Created by Alex on 03.09.2020.
//  Copyright © 2020 Grigorchuk. All rights reserved.
//

import UIKit

public final class RepositoryTableViewCell: BaseTableViewCell, Reusable {
    
    public let titleLabel: UILabel = UILabel()
    
    // MARK: - Lifecycle
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        setupTitleLabel()
    }
    
    public override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        titleLabel.layout.leading?.constant = editing ? 48.0 : 16.0
        
        UIView.animate(withDuration: 0.05) {
            self.layoutIfNeeded()
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        titleLabel.layout {
            $0.top.equal(to: topAnchor, offsetBy: 16.0)
            $0.leading.equal(to: leadingAnchor, offsetBy: 16.0)
            $0.trailing.equal(to: trailingAnchor, offsetBy: -16.0)
            $0.bottom.equal(to: bottomAnchor, offsetBy: -16.0)
        }
    }
    
}

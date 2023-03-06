//
//  ProfileView.swift
//  UI
//
//  Created by Alex on 01.09.2020.
//  Copyright © 2020 Grigorchuk. All rights reserved.
//

import UIKit

public final class ProfileView: BaseView {
    
    public let avatarImageView = UIImageView()
    public let nameLabel = UILabel()
    public let logoutButton = UIButton(type: .system)
    
    public override init() {
        super.init()
        
        setupView()
        backgroundColor = .white
    }
    
    private func setupView() {
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 12.0
        avatarImageView.clipsToBounds = true
        addSubview(avatarImageView)
        avatarImageView.layout {
            $0.top.equal(to: safeAreaLayoutGuide.topAnchor, offsetBy: 32.0)
            $0.centerX.equal(to: centerXAnchor)
            $0.height.equal(to: 100.0)
            $0.width.equal(to: 100.0)
        }
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        addSubview(nameLabel)
        nameLabel.layout {
            $0.top.equal(to: avatarImageView.bottomAnchor, offsetBy: 16.0)
            $0.leading.equal(to: leadingAnchor, offsetBy: 24.0)
            $0.trailing.equal(to: trailingAnchor, offsetBy: -24.0)
        }
        
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.tintColor = .white
        logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        logoutButton.backgroundColor = .red
        logoutButton.layer.cornerRadius = 12.0
        addSubview(logoutButton)
        logoutButton.layout {
            $0.leading.equal(to: leadingAnchor, offsetBy: 48.0)
            $0.trailing.equal(to: trailingAnchor, offsetBy: -48.0)
            $0.bottom.equal(to: bottomAnchor, offsetBy: -24.0)
            $0.height.equal(to: 46.0)
        }
    }
}

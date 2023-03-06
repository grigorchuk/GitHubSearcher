//
//  RepositoryDetailsView.swift
//  UI
//
//  Created by Alex on 02.09.2020.
//  Copyright © 2020 Grigorchuk. All rights reserved.
//

import UIKit

public final class RepositoryDetailsView: BaseView {
    
    public let fullNameLabel = UILabel()
    public let descriptionLabel = UILabel()
    public let languageLabel = UILabel()
    
    public override init() {
        super.init()
        
        setupView()
        backgroundColor = .white
    }
    
    private func setupView() {
        fullNameLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
        fullNameLabel.textAlignment = .center
        fullNameLabel.numberOfLines = 0
        addSubview(fullNameLabel)
        fullNameLabel.layout {
            $0.top.equal(to: safeAreaLayoutGuide.topAnchor, offsetBy: 16.0)
            $0.leading.equal(to: leadingAnchor, offsetBy: 24.0)
            $0.trailing.equal(to: trailingAnchor, offsetBy: -24.0)
        }
        
        descriptionLabel.numberOfLines = 0
        addSubview(descriptionLabel)
        descriptionLabel.layout {
            $0.top.equal(to: fullNameLabel.bottomAnchor, offsetBy: 8.0)
            $0.leading.equal(to: leadingAnchor, offsetBy: 24.0)
            $0.trailing.equal(to: trailingAnchor, offsetBy: -24.0)
        }
        
        languageLabel.textColor = .gray
        languageLabel.numberOfLines = 0
        addSubview(languageLabel)
        languageLabel.layout {
            $0.top.equal(to: descriptionLabel.bottomAnchor, offsetBy: 8.0)
            $0.leading.equal(to: leadingAnchor, offsetBy: 24.0)
            $0.trailing.equal(to: trailingAnchor, offsetBy: -24.0)
        }
    }
}

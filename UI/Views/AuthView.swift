//
//  AuthView.swift
//  UI
//
//  Created by Alex on 01.09.2020.
//  Copyright © 2020 Grigorchuk. All rights reserved.
//

import UIKit

public final class AuthView: BaseView {
    
    public let loginTextField = UITextField()
    public let passwordTextField = UITextField()
    public let authButton = UIButton(type: .system)
    
    public override init() {
        super.init()
        
        setupView()
        backgroundColor = .white
    }
    
    private func setupView() {
        loginTextField.placeholder = "Enter login"
        loginTextField.autocorrectionType = .no
        loginTextField.autocapitalizationType = .none
        loginTextField.borderStyle = .roundedRect
        addSubview(loginTextField)
        loginTextField.layout {
            $0.top.equal(to: centerYAnchor, offsetBy: -80.0)
            $0.leading.equal(to: leadingAnchor, offsetBy: 48.0)
            $0.trailing.equal(to: trailingAnchor, offsetBy: -48.0)
            $0.height.equal(to: 40.0)
        }
        
        passwordTextField.placeholder = "Enter password"
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        addSubview(passwordTextField)
        passwordTextField.layout {
            $0.top.equal(to: loginTextField.bottomAnchor, offsetBy: 16.0)
            $0.leading.equal(to: leadingAnchor, offsetBy: 48.0)
            $0.trailing.equal(to: trailingAnchor, offsetBy: -48.0)
            $0.height.equal(to: 40.0)
        }
        
        authButton.setTitle("Sign In", for: .normal)
        authButton.tintColor = .white
        authButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        authButton.backgroundColor = .cyan
        authButton.layer.cornerRadius = 12.0
        addSubview(authButton)
        authButton.layout {
            $0.top.equal(to: passwordTextField.bottomAnchor, offsetBy: 24.0)
            $0.leading.equal(to: leadingAnchor, offsetBy: 48.0)
            $0.trailing.equal(to: trailingAnchor, offsetBy: -48.0)
            $0.height.equal(to: 46.0)
        }
    }
}

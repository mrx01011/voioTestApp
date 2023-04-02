//
//  AuthView.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 30.03.2023.
//

import UIKit
import SnapKit

protocol AuthorizationViewDelegate: AnyObject {
    func signInButtonPressed(mail: String, password: String)
    func signUpButtonPressed()
}

final class AuthorizationView: UIView {
    var delegate: AuthorizationViewDelegate?
    //MARK: UI elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 40)
        label.text = "Sign In"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    private let loginField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter email"
        textField.returnKeyType = .done
        return textField
    }()
    private let passField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter password"
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        return textField
    }()
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitle("Sign In", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .yellow
        button.setTitle("Sign Up", for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 10
        return button
    }()
    //MARK: Initialization
    init() {
        super.init(frame: .zero)
        defaultConfigurations()
        setupUI()
        setupDelegates()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    //MARK: Methods
    private func defaultConfigurations() {
        backgroundColor = .white
    }
    
    private func addTargets() {
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        loginField.delegate = self
        passField.delegate = self
    }
    
    private func setupUI() {
        // title
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }
        // login textfield
        addSubview(loginField)
        loginField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview()
        }
        // password textfield
        addSubview(passField)
        passField.snp.makeConstraints { make in
            make.top.equalTo(loginField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
        }
        //sign in button
        addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passField.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(25)
        }
        addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(25)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func signInButtonTapped() {
        let mail = loginField.text ?? ""
        let password = passField.text ?? ""
        self.delegate?.signInButtonPressed(mail: mail, password: password)
    }
    
    @objc private func signUpButtonTapped() {
        self.delegate?.signUpButtonPressed()
    }
}
//MARK: - UITextFieldDelegate
extension AuthorizationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
    }
}

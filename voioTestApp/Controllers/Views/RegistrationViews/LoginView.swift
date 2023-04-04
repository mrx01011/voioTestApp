//
//  LoginView.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 01.04.2023.
//

import UIKit
import SnapKit

final class LoginView: UIView {
    var email: String {
        get {
            return emailTextField.text ?? ""
        }
    }
    var password: String {
        get {
            return passTextField.text ?? ""
        }
    }
    //MARK: Managers
    private let registrationFieldsManager = RegistrationFieldManager()
    //MARK: UI elements
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter email"
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        return textField
    }()
    private let passLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    private let passTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter password"
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        return textField
    }()
    //MARK: Initialization
    init() {
        super.init(frame: .zero)
        setupUI()
        defaultConfigurations()
        setupDelegates()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    //MARK: Methods
    private func setupUI() {
        // email input
        addSubview(emailLabel)
        addSubview(emailTextField)
        emailLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
        }
        // second name input
        addSubview(passLabel)
        addSubview(passTextField)
        passLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
        }
        passTextField.snp.makeConstraints { make in
            make.top.equalTo(passLabel.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func defaultConfigurations() {
        backgroundColor = .white
    }
    
    private func setupDelegates() {
        emailTextField.delegate = self
        passTextField.delegate = self
    }
    
    private func setTextField(textField: UITextField, label: UILabel, labelText: String, wrongMessage: String, validType: String.ValidTypes, string: String, range: NSRange) {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.isValid(validType) {
            textField.layer.borderWidth = 0
            label.text = labelText
            label.textColor = .black
        } else {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = #colorLiteral(red: 1, green: 0.0755190127, blue: 0.06367275965, alpha: 1)
            textField.layer.cornerRadius = 6
            label.text = wrongMessage
            label.textColor = #colorLiteral(red: 1, green: 0.0755190127, blue: 0.06367275965, alpha: 1)
        }
    }
}
//MARK: - Text Field Delegate
extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case emailTextField:
            registrationFieldsManager.setTextField(textField: emailTextField,
                                                   label: emailLabel,
                                                   labelText: "Email",
                                                   wrongMessage: "example123@gmail.com",
                                                   validType: .email,
                                                   string: string, range: range)
        case passTextField:
            registrationFieldsManager.setTextField(textField: passTextField,
                                                   label: passLabel,
                                                   labelText: "Password",
                                                   wrongMessage: "min 1 uppercase, 1 lowercase, 1 digit, 8 characters",
                                                   validType: .password,
                                                   string: string, range: range)
        default:
            break
        }
        return true
    }
}


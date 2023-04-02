//
//  FullNameView.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 31.03.2023.
//

import UIKit
import SnapKit

final class FullNameView: UIView {
    var firstName: String {
        get {
            return firstNameTextField.text ?? ""
        }
    }
    var lastName: String {
        get {
            return lastNameTextField.text ?? ""
        }
    }
    //MARK: Manager
    private let registrationFieldsManager = RegistrationFieldManager()
    //MARK: UI elements
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First name"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter first name"
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        return textField
    }()
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last name"
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    private let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter last name"
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
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
        // first name input
        addSubview(firstNameLabel)
        addSubview(firstNameTextField)
        firstNameLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
        }
        // second name input
        addSubview(lastNameLabel)
        addSubview(lastNameTextField)
        lastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
        }
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameLabel.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func defaultConfigurations() {
        backgroundColor = .white
        
    }
    
    private func setupDelegates() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
    }
}
//MARK: - Text Field Delegate
extension FullNameView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case firstNameTextField:
            registrationFieldsManager.setTextField(textField: firstNameTextField,
                                                   label: firstNameLabel,
                                                   labelText: "First name",
                                                   wrongMessage: "Only a-Z, min 2, max 20 characters",
                                                   validType: .name,
                                                   string: string, range: range)
        case lastNameTextField:
                registrationFieldsManager.setTextField(textField: lastNameTextField,
                                                       label: lastNameLabel,
                                                       labelText: "Last Name",
                                                       wrongMessage: "Only a-Z, min 2, max 20 characters",
                                                       validType: .name,
                                                       string: string, range: range)
        default:
            break
        }
        return true
    }

}

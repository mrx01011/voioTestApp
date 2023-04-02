//
//  RegistrationFieldsManager.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 01.04.2023.
//

import UIKit

final class RegistrationFieldManager {
    func setTextField(textField: UITextField, label: UILabel, labelText: String, wrongMessage: String, validType: String.ValidTypes, string: String, range: NSRange) {
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

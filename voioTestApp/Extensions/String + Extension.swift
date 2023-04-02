//
//  String + Extension.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 01.04.2023.
//

import Foundation

extension String {
    enum ValidTypes {
        case name
        case email
        case password
    }
    
    enum Regex: String {
        case name = "[a-zA-Z]{2,20}"
        case email = "[a-zA-Z0-9._]+@[a-zA-Z]+\\.[a-zA-Z]{2,3}"
        case password = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}"
    }
    
    func isValid(_ validType: ValidTypes) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validType {
        case .name:
            regex = Regex.name.rawValue
        case .email:
            regex = Regex.email.rawValue
        case .password:
            regex = Regex.password.rawValue
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}

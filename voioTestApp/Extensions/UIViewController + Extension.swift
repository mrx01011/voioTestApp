//
//  UIViewController + Extension.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 04.04.2023.
//

import UIKit

extension UIViewController {
    func alertOK(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

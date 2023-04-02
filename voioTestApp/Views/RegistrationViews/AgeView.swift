//
//  AgeView.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 01.04.2023.
//

import UIKit
import SnapKit

final class AgeView: UIView {
    var dateOfBirth: Date {
        get {
            return ageDatePicker.date
        }
    }
    //MARK: UI elements
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    private let ageDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.backgroundColor = .white
        picker.layer.borderWidth = 1
        picker.layer.borderColor = #colorLiteral(red: 0.9019704461, green: 0.9019549489, blue: 0.9060467482, alpha: 1)
        picker.clipsToBounds = true
        picker.layer.cornerRadius = 6
        picker.tintColor = .black
        picker.contentHorizontalAlignment = .left
        return picker
    }()
    //MARK: Initialization
    init() {
        super.init(frame: .zero)
        defaultConfigurations()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    //MARK: Methods
    private func defaultConfigurations() {
        backgroundColor = .white
    }
    
    private func setupUI() {
        addSubview(ageLabel)
        ageLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        addSubview(ageDatePicker)
        ageDatePicker.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

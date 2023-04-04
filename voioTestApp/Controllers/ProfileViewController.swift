//
//  ProfileViewController.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 01.04.2023.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    //MARK: UI elements
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.fill"))
        imageView.tintColor = .gray
        return imageView
    }()
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name Surname"
        label.font = .boldSystemFont(ofSize: 36)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    private let dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.text = "Date of birth: da.te.birth"
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email: email@gmail.com"
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    private let logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemRed
        button.setTitle("Log Out", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConfigurations()
        setupUI()
        addTargets()
        setInfo()
    }
    //MARK: Methods
    private func defaultConfigurations() {
        view.backgroundColor = .white
    }
    
    private func addTargets() {
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }
    
    private func setInfo() {
        guard let activeUser = UserDefaultsManager.shared.activeUser else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        fullNameLabel.text = "\(activeUser.firstName) \(activeUser.lastName)"
        emailLabel.text = activeUser.email
        dateOfBirthLabel.text = dateFormatter.string(from: activeUser.age)
        if let imageURL = activeUser.avatarURL,
           let imageData = try? Data(contentsOf: imageURL) {
            let image = UIImage(data: imageData)
            profileImageView.image = image
        }
    }
    
    private func setupUI() {
        // profile picture view
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        // full name label
        view.addSubview(fullNameLabel)
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        // date of birth label
        view.addSubview(dateOfBirthLabel)
        dateOfBirthLabel.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        // email label
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(dateOfBirthLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        // log out button
        view.addSubview(logOutButton)
        logOutButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(40)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    @objc private func logOutButtonTapped() {
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = AuthViewController()
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil)
        }
    }
}

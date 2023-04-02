//
//  RegistrationViewController.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 31.03.2023.
//

import UIKit
import SnapKit

final class RegistrationViewController: UIViewController {
    //MARK: UI elements
    private let scrollView = UIScrollView()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Registration"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    private let profilePictureView = ProfilePictureView()
    private let fullNameView = FullNameView()
    private let ageView = AgeView()
    private let loginView = LoginView()
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .yellow
        button.setTitle("Sign Up", for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 10
        return button
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConfigurations()
        setupUI()
        observeKeyboardNotificaton()
        addTapToHideKeyboard()
        setupDelegates()
        addTargets()
    }
    //MARK: Methods
    private func defaultConfigurations() {
        view.backgroundColor = .white
    }
    
    private func setupDelegates() {
        profilePictureView.delegate = self
    }
    
    private func addTargets() {
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        // scroll view + content view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height)
        }
        // title
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        // profile image view
        contentView.addSubview(profilePictureView)
        profilePictureView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        // full name view
        contentView.addSubview(fullNameView)
        fullNameView.snp.makeConstraints { make in
            make.top.equalTo(profilePictureView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        // age view
        contentView.addSubview(ageView)
        ageView.snp.makeConstraints { make in
            make.top.equalTo(fullNameView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        // login view
        contentView.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.top.equalTo(ageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        // sing up button
        contentView.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(loginView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(40)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    @objc private func signUpButtonTapped() {
        let firstName = fullNameView.firstName
        let lastName = fullNameView.lastName
        let email = loginView.email
        let password = loginView.password
        let dateOfBirth = ageView.dateOfBirth
        let avatarURL = profilePictureView.imageURL
        
        if firstName.isValid(.name)
            && lastName.isValid(.name)
            && email.isValid(.email)
            && password.isValid(.password) {
            DataBase.shared.saveUser(firstName: firstName,
                                     lastName: lastName,
                                     email: email,
                                     password: password,
                                     age: dateOfBirth,
                                     avatarURL: avatarURL)
            self.dismiss(animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "All fields must be filled", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
        
    }
}
//MARK: - ProfilePictureViewDelegate
extension RegistrationViewController: ProfilePictureViewDelegate {
    func pickImage(from imagePickerController: UIImagePickerController) {
        self.present(imagePickerController, animated: true)
    }
}
//MARK: - Keyboard
extension RegistrationViewController {
    private func addTapToHideKeyboard() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard(gesture:))
        )
        contentView.addGestureRecognizer(tap)
    }
    
    private func observeKeyboardNotificaton() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(sender:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(sender:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let kbSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = kbSize.size.height - 200
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @objc private func hideKeyboard(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

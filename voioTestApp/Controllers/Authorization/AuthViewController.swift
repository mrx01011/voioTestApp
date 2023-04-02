//
//  AuthViewController.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 30.03.2023.
//

import UIKit
import SnapKit

final class AuthViewController: UIViewController {
    //MARK: UI elements
    private let scrollView = UIScrollView()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let authorizationView = AuthorizationView()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConfigurations()
        setupUI()
        observeKeyboardNotificaton()
        addTapToHideKeyboard()
        setupDelegates()
    }
    //MARK: Methods
    private func defaultConfigurations() {
        view.backgroundColor = .white
    }
    
    private func setupDelegates() {
        authorizationView.delegate = self
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
        // authorization view
        contentView.addSubview(authorizationView)
        authorizationView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.horizontalEdges.equalToSuperview().inset(40)
        }
    }
}

//MARK: - AuthorizationViewDelegate
extension AuthViewController: AuthorizationViewDelegate {
    
    private func findUserInBase(mail: String) -> User? {
        let dataBase = DataBase.shared.users
        print(dataBase)
        
        for user in dataBase {
            if user.email == mail {
                return user
            }
        }
        return nil
    }
    
    func signInButtonPressed(mail: String, password: String) {
        let user = findUserInBase(mail: mail)
        if user == nil || user?.password != password {
            let alert = UIAlertController(title: "Error", message: "Wrong email or password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        } else {
            let tabBarController = TabBarController()
            tabBarController.modalPresentationStyle = .fullScreen
            self.present(tabBarController, animated: true)
            
            guard let activeUser = user else { return }
            DataBase.shared.saveActiveUser(user: activeUser)
        }
    }
    
    func signUpButtonPressed() {
        let registrationVC = RegistrationViewController()
        self.present(registrationVC, animated: true)
    }
}

//MARK: - Keyboard
extension AuthViewController {
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

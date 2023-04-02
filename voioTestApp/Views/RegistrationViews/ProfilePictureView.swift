//
//  ProfilePictureView.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 01.04.2023.
//

import UIKit
import SnapKit

protocol ProfilePictureViewDelegate: AnyObject {
    func pickImage(from imagePickerController: UIImagePickerController)
}

final class ProfilePictureView: UIView {
    var imageURL: URL?
    weak var delegate: ProfilePictureViewDelegate?
    //MARK: UI elements
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.fill"))
        imageView.tintColor = .gray
        return imageView
    }()
    private let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select photo", for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    //MARK: Initialization
    init() {
        super.init(frame: .zero)
        defaultConfigurations()
        setupUI()
        addTargerts()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    //MARK: Methods
    private func defaultConfigurations() {
        backgroundColor = .white
    }
    
    private func addTargerts() {
        selectPhotoButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
    }
    
    private func setupUI() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.width.equalTo(100)
        }
        addSubview(selectPhotoButton)
        selectPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    @objc private func selectImage() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        delegate?.pickImage(from: imagePickerVC)
    }
}

//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ProfilePictureView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            let imageName = "profileImage.jpg"
            guard let imageURL = documentsURL?.appendingPathExtension(imageName),
                  let imageData = image.jpegData(compressionQuality: 1.0) else { return }
            try? imageData.write(to: imageURL)
            self.imageURL = imageURL
            profileImageView.image = image
        }
        
    }
}

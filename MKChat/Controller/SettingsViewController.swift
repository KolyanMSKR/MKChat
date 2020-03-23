//
//  SettingsViewController.swift
//  MKChat
//
//  Created by Admin on 13.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    // MARK: - properties
    
    private let currentUser: User
    
    // MARK: - UI's elements
    
    fileprivate var profileImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile_photo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        
        return imageView
    }()
    @objc
    private func selectProfileImageAction() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    private let usernameLabel = UILabel(title: "Username:")
    private let descriptionLabel = UILabel(title: "Status:")
    private let usernameTextField = UITextField(borderStyle: .roundedRect, placeholder: "Username")
    private let descriptionTextField = UITextField(borderStyle: .roundedRect, placeholder: "Status")
    
    private let sexSegmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Male", "Female"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(changeSexAction), for: .valueChanged)
        
        return segment
    }()
    @objc private func changeSexAction() {
        switch sexSegmentedControl.selectedSegmentIndex {
        case 0:
            print("sexSegmentedControl.selectedSegmentIndex = ", sexSegmentedControl.selectedSegmentIndex)
        case 1:
            print("sexSegmentedControl.selectedSegmentIndex = ", sexSegmentedControl.selectedSegmentIndex)
        default:
            print("something's going wrong with sexSegmentedControl")
        }
    }
    
    let chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.setTitle("Time to Chat!", for: .normal)
        button.addTarget(self, action: #selector(chatButtonAction), for: .touchUpInside)
        
        return button
    }()
    @objc func chatButtonAction() {
        FirestoreService.shared.saveProfileWith(
            id: currentUser.uid,
            email: currentUser.email!,
            username: usernameTextField.text,
            avatarImage: profileImageView.image,
            description: descriptionTextField.text,
            sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { result in
                
                switch result {
                case .success(let chatUser):
                    self.showAlert(title: "Success!", message: "Have a nice time ;-)") {
                        let tabBarController = TabBarController(currentUser: chatUser)
                        let navController = UINavigationController(rootViewController: tabBarController)
                        navController.modalPresentationStyle = .fullScreen
                        self.present(navController, animated: true, completion: nil)
                    }
                case .failure(let error):
                    self.showAlert(title: "Error!", message: error.localizedDescription)
                }
        }
        
    }
    
    // MARK: - Inits
    
    init(currentUser: User) {
        self.currentUser = currentUser
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle's methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    // MARK: - UI's logic
    func setUI() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0.4705658555, blue: 0, alpha: 1)
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectProfileImageAction))
        profileImageView.addGestureRecognizer(tap)
        
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(usernameTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(sexSegmentedControl)
        view.addSubview(chatButton)
        
        setConstraints()
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            sexSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sexSegmentedControl.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 40),
            sexSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100),
            sexSegmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            chatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chatButton.topAnchor.constraint(equalTo: sexSegmentedControl.bottomAnchor, constant: 40),
            chatButton.widthAnchor.constraint(equalToConstant: 150),
            chatButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

}




extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

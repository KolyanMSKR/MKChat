//
//  LoginViewController.swift
//  MKChat
//
//  Created by asd dsa on 2/1/20.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class LoginViewController: UIViewController {

    // MARK: - properties
    
    
    
    // MARK: - UI's elements
    
     fileprivate var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profile_photo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImageAction)))
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
    
    
    private var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        sc.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterValueChange), for: .valueChanged)
        
        return sc
    }()
    @objc private func handleLoginRegisterValueChange() {
        title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)!
        loginRegisterButton.setTitle(title, for: .normal)
    }
    
    private let loginView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    private let passwordTextField = UITextField(borderStyle: .none, placeholder: "Password")
    private let emailTextField = UITextField(borderStyle: .none, placeholder: "E-mail")
    
    private let passwordLabelSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        return view
    }()
    
    lazy private var loginRegisterButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(loginRegisterButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle's methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    // MARK: - UI's logic
    
    private func setUI() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0.4705658555, blue: 0, alpha: 1)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(loginView)
        view.addSubview(passwordTextField)
        view.addSubview(passwordLabelSeparator)
        view.addSubview(emailTextField)
        view.addSubview(loginRegisterButton)
        
        setConstraints()
    }
    
    @objc private func loginRegisterButtonAction() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    private func handleLogin() {
        AuthService.shared.login(email: emailTextField.text, password: passwordTextField.text) { result in
            switch result {
            case .success(let user):
                self.showAlert(title: "Success", message: "Sign-In") {
                    FirestoreService.shared.getUserData(user: user) { snapshot in
                        switch snapshot {
                        case .success(let chatUser):
                            let tabBarController = TabBarController(currentUser: chatUser)
                            let navController = UINavigationController(rootViewController: tabBarController)
                            
                            navController.modalPresentationStyle = .fullScreen
                            self.present(navController, animated: true, completion: nil)
                        case .failure(_):
                            
                            let navController = UINavigationController(rootViewController: SettingsViewController(currentUser: user))
                            self.present(navController, animated: true, completion: nil)
                        }
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func handleRegister() {
        AuthService.shared.register(email: emailTextField.text, password: passwordTextField.text) { result in
            switch result {
            case .success(let user):
                self.showAlert(title: "Success", message: "Sign-Up") {
                    let settingsViewController = SettingsViewController(currentUser: user)
                    settingsViewController.modalPresentationStyle = .fullScreen
                    self.present(settingsViewController, animated: true, completion: nil)
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -25),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: loginView.topAnchor, constant: -20),
            loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: loginView.widthAnchor),
            loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.heightAnchor.constraint(equalToConstant: 80),
            loginView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: loginView.topAnchor),
            emailTextField.widthAnchor.constraint(equalTo: loginView.widthAnchor),
            emailTextField.heightAnchor.constraint(equalTo: loginView.heightAnchor, multiplier: 1/2)
        ])
        
        NSLayoutConstraint.activate([
            passwordLabelSeparator.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            passwordLabelSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            passwordLabelSeparator.widthAnchor.constraint(equalTo: loginView.widthAnchor),
            passwordLabelSeparator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: passwordLabelSeparator.bottomAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: loginView.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: loginView.heightAnchor, multiplier: 1/2)
        ])
        
        NSLayoutConstraint.activate([
            loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterButton.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 20),
            loginRegisterButton.heightAnchor.constraint(equalToConstant: 50),
            loginRegisterButton.widthAnchor.constraint(equalTo: loginView.widthAnchor)
        ])
    }

}


extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picker cancel")
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

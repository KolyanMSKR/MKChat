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
    
    private var loginViewHeightAnchor: NSLayoutConstraint?
    private var nameTextFieldHeightAnchor: NSLayoutConstraint?
    private var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    private var emailTextFieldHeightAnchor: NSLayoutConstraint?
    
    var messagesController: MessagesController?
    
    // MARK: - UI's elements
    
    lazy fileprivate var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profile_photo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        
        return imageView
    }()
    @objc
    private func handleSelectProfileImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    lazy private var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterValueChange), for: .valueChanged)
        
        return sc
    }()
    @objc
    private func handleLoginRegisterValueChange() {
        title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)!
        loginRegisterButton.setTitle(title, for: .normal)
        
        loginViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 80 : 120
        nameTextFieldHeightAnchor?.isActive = false
        var multiplier: CGFloat = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: loginView.heightAnchor, multiplier: multiplier)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        multiplier = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: loginView.heightAnchor, multiplier: multiplier)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: loginView.heightAnchor, multiplier: multiplier)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    private let loginView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Nickname"
        
        return textField
    }()
    
    private let nameLabelSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        
        return textField
    }()
    
    private let passwordLabelSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        return view
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "E-mail"
        
        return textField
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
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0.4705658555, blue: 0, alpha: 1)
        
        setUI()
    }
    
    // MARK: - UI's logic
    private func setUI() {
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(loginView)
        view.addSubview(nameTextField)
        view.addSubview(nameLabelSeparator)
        view.addSubview(passwordTextField)
        view.addSubview(passwordLabelSeparator)
        view.addSubview(emailTextField)
        view.addSubview(loginRegisterButton)
        
        setConstraints()
    }
    
    @objc private func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    private func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
                print("Invalid input data")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            self.messagesController?.fetchUserAndSetupNavBarTitle()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text,
            email != "", password != "", name != "" else {

            print("Invalid input data")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { snapshot, error in
            if error != nil {
                print(error!)
                return
            }

            guard let uid = snapshot?.user.uid else { return }
            var downloadUrlString = String()
            let storageRef = Storage.storage().reference().child("profile_images/\(uid).png")
            
            if let profileImage = self.profileImageView.image,
                let uploadData = profileImage.jpegData(compressionQuality: 0.9) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { metadata, error in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        guard let downloadURL = url else {
                            print("Bad url")
                            return
                        }
                        
                        downloadUrlString = downloadURL.absoluteString
                        
                        let values = ["name": name, "email": email, "profileImageURL": downloadUrlString]
                        self.registerUserIntoDatabaseWith(uid: uid, values: values)
                    })
                })
            }
        }
    }
    
    private func registerUserIntoDatabaseWith(uid: String, values: [String: Any]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.messagesController?.navigationItem.title = values["name"] as? String
            
            self.dismiss(animated: true, completion: nil)
        })
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
        
        loginViewHeightAnchor = loginView.heightAnchor.constraint(equalToConstant: 120)
        NSLayoutConstraint.activate([
            loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginViewHeightAnchor!,
            loginView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
            ])
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: loginView.heightAnchor, multiplier: 1/3)
        NSLayoutConstraint.activate([
            nameTextField.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: loginView.topAnchor),
            nameTextField.widthAnchor.constraint(equalTo: loginView.widthAnchor),
            nameTextFieldHeightAnchor!
            ])
        
        NSLayoutConstraint.activate([
            nameLabelSeparator.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            nameLabelSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameLabelSeparator.widthAnchor.constraint(equalTo: loginView.widthAnchor),
            nameLabelSeparator.heightAnchor.constraint(equalToConstant: 0.5)
            ])
        
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: loginView.heightAnchor, multiplier: 1/3)
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: nameLabelSeparator.bottomAnchor),
            emailTextField.widthAnchor.constraint(equalTo: loginView.widthAnchor),
            emailTextFieldHeightAnchor!
            ])
        
        
        NSLayoutConstraint.activate([
            passwordLabelSeparator.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            passwordLabelSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            passwordLabelSeparator.widthAnchor.constraint(equalTo: loginView.widthAnchor),
            passwordLabelSeparator.heightAnchor.constraint(equalToConstant: 0.5)
            ])
        
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: loginView.heightAnchor, multiplier: 1/3)
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: passwordLabelSeparator.bottomAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: loginView.widthAnchor),
            passwordTextFieldHeightAnchor!
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

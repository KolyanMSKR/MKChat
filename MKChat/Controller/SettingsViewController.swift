//
//  SettingsViewController.swift
//  MKChat
//
//  Created by Admin on 13.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - UI's elements
    
    fileprivate var profileImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile_photo"))
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
    
    private let firstNameLabel = UILabel(title: "First Name:")
    private let secondNameLabel = UILabel(title: "Second Name:")
    private let firstNameTextField = UITextField(borderStyle: .roundedRect, placeholder: "First Name")
    private let secondNameTextField = UITextField(borderStyle: .roundedRect, placeholder: "Second name")
    
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

    // MARK: - Lifecycle's methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    // MARK: - UI's logic
    func setUI() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0.4705658555, blue: 0, alpha: 1)
        
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        secondNameLabel.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        secondNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileImageView)
        view.addSubview(firstNameLabel)
        view.addSubview(firstNameTextField)
        view.addSubview(secondNameLabel)
        view.addSubview(secondNameTextField)
        view.addSubview(sexSegmentedControl)
        
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
            firstNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            firstNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 8),
            firstNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            secondNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            secondNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            secondNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            secondNameTextField.topAnchor.constraint(equalTo: secondNameLabel.bottomAnchor, constant: 8),
            secondNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            sexSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sexSegmentedControl.topAnchor.constraint(equalTo: secondNameTextField.bottomAnchor, constant: 40),
            sexSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100),
            sexSegmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}




extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

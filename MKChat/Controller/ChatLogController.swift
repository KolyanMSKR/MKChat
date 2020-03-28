//
//  ChatLogController.swift
//  MKChat
//
//  Created by asd dsa on 2/13/20.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    var friendUser: MKChatUser!
    
    private let inputTextField = UITextField()
    
    // MARK: - Inits
    
    init(friendUser: MKChatUser) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        self.friendUser = friendUser
        title = friendUser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    var messages: [Message] = []
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath)
        cell.backgroundColor = .cyan
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        
        setupInputComponents()
    }
    
    private func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.delegate = self
        inputTextField.placeholder = "Write a message..."
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separateView = UIView()
        separateView.translatesAutoresizingMaskIntoConstraints = false
        separateView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.addSubview(separateView)
        
        separateView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separateView.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separateView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separateView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @objc private func handleSend() {
        
        guard let message = inputTextField.text, message != "" else { return }
        
        FirestoreService.shared.createChat(message: message, receiver: friendUser) { result in
            switch result {
            case .success:
                self.showAlert(title: "Yeah!", message: "Check Firebase Firestore!")
                break
            case .failure(_):
                self.showAlert(title: "Error!", message: "Try to write a message later!")
            }
        }
        
        
        /*let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toID = chatUser!.id
        let fromID = Auth.auth().currentUser!.uid
        let timestamp = Date().timeIntervalSince1970
        let values = ["text": inputTextField.text!, "toID": toID, "fromID": fromID, "timestamp": timestamp] as [String : Any]
        //childRef.updateChildValues(values)
        
        childRef.updateChildValues(values) { error, ref in
            if error != nil {
                print(error)
                return
            }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromID)
            
            let messageID = childRef.key
            userMessagesRef.updateChildValues([messageID: 1])
        }*/
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: view.frame.width, height: 250)
    }
    
}

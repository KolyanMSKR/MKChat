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

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let currentUser = Auth.auth().currentUser!
    var friendUser: MKChatUser!
    var messages: [Message] = [] {
        didSet {
            self.messages.sort(by: <)
            collectionView.reloadData()
        }
    }
    
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
    
    // MARK: - Lifecycle's methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.cellID)
        collectionView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        setupInputComponents()
        
        observeMessages()
    }
    
    func observeMessages() {
        Firestore.firestore().collection("users").document(friendUser.id).collection("chats").document(currentUser.uid).collection("messages").addSnapshotListener { snapshot, error  in
            
            snapshot?.documentChanges.forEach({ diff in
                guard let message = Message(document: diff.document) else {
                    return
                }
                
                if diff.type == .added {
                    self.messages.append(message)
                }
            })
        }
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
                self.inputTextField.text = ""
                self.showAlert(title: "Yeah!", message: "Check Firebase Firestore!")
                break
            case .failure(_):
                self.showAlert(title: "Error!", message: "Try to write a message later!")
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension ChatLogController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.cellID, for: indexPath as IndexPath) as! MessageCell
        
        cell.textView.text = messages[indexPath.row].text
        cell.bubbleViewWidthAnchor.constant = estimateFrameFor(text: messages[indexPath.row].text).width + 30
        
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        if indexPath.row % 2 == 0 {
            
            if messages[indexPath.row].senderID == currentUser.uid {
                cell.bubbleViewTrailingAnchor.isActive = false
                cell.bubbleViewLeadingAnchor.isActive = true
                
                cell.bubbleView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }
            
        } else {
            cell.bubbleViewTrailingAnchor.isActive = true
            cell.bubbleViewLeadingAnchor.isActive = false
            
            cell.bubbleView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChatLogController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var height: CGFloat = 40.0
        let text = messages[indexPath.row].text
//        height = estimateFrameFor(text: text).height + 18
        height = messages[indexPath.row].text.height(width: 300, font: .systemFont(ofSize: 14)) + 18
        
        
        return CGSize(width: collectionView.bounds.width, height: height)
    }
    
    func estimateFrameFor(text: String) -> CGRect {
        let size = CGSize(width: view.frame.width * 2/3, height: 1000)
        
        return NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

// MARK: - UITextFieldDelegate

extension ChatLogController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        
        return true
    }
    
}

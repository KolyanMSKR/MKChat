//
//  ViewController.swift
//  MKChat
//
//  Created by asd dsa on 2/6/20.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class MessagesController: UITableViewController {
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        checkIfUserIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        observeMessages()
    }
    
    private func observeMessages() {
        let ref = Database.database().reference().child("messages")
        
        ref.observe(.childAdded, with: { snapshot in
            if let dictionary = snapshot.value as? [String: Any] {
                let message = Message()
                message.fromID = dictionary["fromID"] as? String
                message.toID = dictionary["toID"] as? String
                message.timestamp = dictionary["timestamp"] as? TimeInterval
                message.text = dictionary["text"] as? String
                self.messages.append(message)
                
                if let toID = message.toID {
                    self.messagesDictionary[toID] = message
                    self.messages = Array(self.messagesDictionary.values)
                    
                    self.messages.sort(by: { m1, m2 in
                        Int(m1.timestamp!) > Int(m2.timestamp!)
                    })
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    @objc
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    private func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        
        ref.child("users").child(uid)
            .observeSingleEvent(of: .value,
                                with: { snapshot in
                                    
                                    if let dictionary = snapshot.value as? [String: AnyObject] {
                                        self.navigationItem.title = dictionary["name"] as? String
                                    }
                                    
            }, withCancel: { error in
                print(error)
            })
    }
    
    func showChatControllerFor(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        self.navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc
    private func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        
        let loginController = LoginViewController()
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        
        cell.message = messages[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

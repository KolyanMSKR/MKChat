//
//  NewMessageController.swift
//  MKChat
//
//  Created by asd dsa on 2/7/20.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class NewMessageController: UITableViewController {
    
    let cellID = "cellID"
    var users = [ChatUser]()
    var messagesController: MessagesController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        fetchUsers()
    }
    
    private func fetchUsers() {
        let ref = Database.database().reference()
        
        ref.child("users").observe(.childAdded, with: { snapshot in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = ChatUser()
                user.id = snapshot.key
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageURL = dictionary["profileImageURL"] as? String
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        },
                                   withCancel: nil
        )
        
    }
    
    @objc
    private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource's methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrlString = user.profileImageURL {
            cell.profileImageView.downloadImage(from: profileImageUrlString)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    // MARK: - UITableViewDataDelegate's methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            print("Dismiss completed")
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerFor(user: user)
        }
    }

}

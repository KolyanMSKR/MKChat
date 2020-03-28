//
//  ChatsController.swift
//  MKChat
//
//  Created by asd dsa on 2/6/20.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ChatsController: UIViewController {
    
    private let cellID = "cellID"
    private let currentUser: MKChatUser
    private let tableView = UITableView()
    
    
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    var chats: [Chat] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    func showChats() {
        let listener = Firestore.firestore().collection("users").document(currentUser.id).collection("chats").addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ diff in
                guard let chat = Chat(document: diff.document) else {
                    return
                }
                
                if diff.type == .added {
                    self.chats.append(chat)
                }
                if diff.type == .modified {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    //MARK: - inits
    
    init(currentUser: MKChatUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        title = currentUser.username
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle's methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        showChats()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        tableView.register(ChatCell.self, forCellReuseIdentifier: cellID)
        
        setConstraints()
    }
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

// MARK: - UITableViewDatasource

extension ChatsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ChatCell
        
        cell.nameLabel.text = chats[indexPath.row].lastMessage
        cell.messageLabel.text = chats[indexPath.row].senderUsername
        //cell.timestampLabel.text = Date(timeIntervalSince1970: postTimestamp.seconds)
        
        let url = URL(string: chats[indexPath.row].senderAvatarStringURL)!
        let data = try? Data(contentsOf: url)
        cell.profileImageView.image = UIImage(data: data!)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ChatsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friendUserID = chats[indexPath.row].senderID
        
        Firestore.firestore().collection("users").document(friendUserID).getDocument { document, error in
            guard let friendUser = MKChatUser(document: document!) else {
                self.showAlert(title: "Error!", message: "Something goes wrong!")
                return
            }
            
            let chatLogController = ChatLogController(friendUser: friendUser)
            self.navigationController?.pushViewController(chatLogController, animated: true)
        }
    }
    
}

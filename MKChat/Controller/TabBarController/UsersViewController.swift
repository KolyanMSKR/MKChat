//
//  UsersViewController.swift
//  MKChat
//
//  Created by Admin on 20.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit
import FirebaseFirestore

class UsersViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    
    private let cellID = "cellID"
    private let db = Firestore.firestore()
    
    private var users = [MKChatUser]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var usersListener: ListenerRegistration?
    
    private let currentUser: MKChatUser
    
    //MARK: - inits
    
    init(currentUser: MKChatUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        title = currentUser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        usersListener?.remove()
    }
    
    // MARK: - Lifecycle's methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        usersListener = ListenerService.shared.usersObserve(users: users, completion: { result in
            switch result {
            case .success(let users):
                self.users = self.users + users
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
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

extension UsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.user = user
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension UsersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friendUser = users[indexPath.row]
        let chatLogController = ChatLogController(friendUser: friendUser)
        
        return (navigationController?.pushViewController(chatLogController, animated: true))!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

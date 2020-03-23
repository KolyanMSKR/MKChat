//
//  UsersViewController.swift
//  MKChat
//
//  Created by Admin on 20.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit
import FirebaseFirestore

class UsersViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let cellID = "cellID"
    private let db = Firestore.firestore()
    
    private var users = [MKChatUser]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var usersListener: ListenerRegistration?
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    // MARK: - UITableViewDatasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = users[indexPath.row].username
        cell.detailTextLabel?.text = users[indexPath.row].description
        
        let url = URL(string: users[indexPath.row].avatarStringURL)
        print("-------------------------------------------------------------------")
        print(url)
        print("-------------------------------------------------------------------")
        let data = try? Data(contentsOf: url!)
        cell.imageView?.image = UIImage(data: data!)
        
        return cell
    }
    
}

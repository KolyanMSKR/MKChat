//
//  TabBarController.swift
//  MKChat
//
//  Created by Admin on 16.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let currentUser: MKChatUser
    
    // MARK: - Inits
    
    init(currentUser: MKChatUser) {
        self.currentUser = currentUser
        
        super.init(nibName: nil, bundle: nil)
        
        title = currentUser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = currentUser.username
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(signOut))

        setTabBar()
    }
    
    private func setTabBar() {
        let chatsViewController = ChatsController(currentUser: currentUser)
        chatsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        
        let usersViewController = UsersViewController()
        usersViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        viewControllers = [chatsViewController, usersViewController]
    }
    
    @objc private func signOut() {
        let alertController = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = LoginViewController()
            } catch {
                fatalError("signOut()")
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
}

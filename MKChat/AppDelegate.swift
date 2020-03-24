//
//  AppDelegate.swift
//  MKChat
//
//  Created by asd dsa on 2/1/20.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = #colorLiteral(red: 0, green: 0.4705658555, blue: 0, alpha: 1)
        
        window?.rootViewController = UIViewController()
        
        if let user = Auth.auth().currentUser {
            FirestoreService.shared.getUserData(user: user) { result in
                switch result {
                case .success(let chatUser):
                    let tabBarController = TabBarController(currentUser: chatUser)
                    let navController = UINavigationController(rootViewController: tabBarController)
                    navController.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController = navController
                case .failure(_):
                    self.window?.rootViewController = LoginViewController()
                }
            }
        } else {
            window?.rootViewController = LoginViewController()
        }
        return true
    }

}


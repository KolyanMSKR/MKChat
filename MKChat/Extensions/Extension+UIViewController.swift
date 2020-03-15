//
//  Extension+UIViewController.swift
//  MKChat
//
//  Created by Admin on 14.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, completion: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

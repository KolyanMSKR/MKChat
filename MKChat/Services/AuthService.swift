//
//  AuthService.swift
//  MKChat
//
//  Created by Admin on 13.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthService {
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    
    private init() { }
    
    func login(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {
        guard let email = email, let password = password else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(result.user))
        }
    }
    
    func register(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {
        guard Validator.isFilled(email: email, password: password) else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        guard Validator.isSimpleEmail(email!) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(result.user))
        }
    }
    
    
    
}

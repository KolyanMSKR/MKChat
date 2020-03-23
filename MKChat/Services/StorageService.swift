//
//  StorageService.swift
//  MKChat
//
//  Created by Admin on 19.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class StorageService {
    
    static let shared = StorageService()
    
    let storageRef = Storage.storage().reference()
    
    private var currentUserID: String {
        return Auth.auth().currentUser!.uid
    }
    
    private var avatarRef: StorageReference {
        return storageRef.child("profile_images")
    }
    
    private init() {}
    
    func upload(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let uploadData = photo.jpegData(compressionQuality: 0.9) else {
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        avatarRef.child(currentUserID).putData(uploadData, metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            
            self.avatarRef.child(self.currentUserID).downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                
                completion(.success(downloadURL))
            }
        }
    }
    
}

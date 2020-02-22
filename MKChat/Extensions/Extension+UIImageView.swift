//
//  Extension+UIImageView.swift
//  MKChat
//
//  Created by asd dsa on 2/9/20.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CacheImageView: UIImageView {
    
    var imageUrlString: String?
    
    func downloadImage(from url: String) {
        imageUrlString = url
        image = nil
        
        if let cachedImeg = imageCache.object(forKey: url as AnyObject) as? UIImage {
            DispatchQueue.main.async {
                self.image = cachedImeg
            }
            return
        }
        
        if let urlS = URL(string: url) {
            let urlRequest = URLRequest (url: urlS)
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                if let data = data, let downloadedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        let imageToCache = UIImage(data: data)
                        if self.imageUrlString == url {
                            self.image = imageToCache
                        }
                        imageCache.setObject(downloadedImage, forKey: url as AnyObject)
                    }
                }
            }
            task.resume()
        }
    }
    
}

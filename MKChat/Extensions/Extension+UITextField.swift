//
//  Extension+UITextField.swift
//  MKChat
//
//  Created by Admin on 13.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit

extension UITextField {
    
    convenience init(borderStyle: UITextField.BorderStyle, placeholder: String? = "") {
        self.init()
        
        self.borderStyle = borderStyle
        self.placeholder = placeholder
    }
    
}

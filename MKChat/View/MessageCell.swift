//
//  MessageCell.swift
//  MKChat
//
//  Created by Admin on 30.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    static var cellID = "MessageCell"
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 14)
        
        return textView
    }()

    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        
        return view
    }()
    
    var bubbleViewWidthAnchor: NSLayoutConstraint!
    var bubbleViewLeadingAnchor: NSLayoutConstraint!
    var bubbleViewTrailingAnchor: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bubbleView)
        self.addSubview(textView)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        bubbleViewWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: self.frame.width * 2/3)
        bubbleViewTrailingAnchor = bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        bubbleViewLeadingAnchor = bubbleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        bubbleViewLeadingAnchor.isActive = false
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: self.topAnchor),
            bubbleViewTrailingAnchor,
            bubbleViewWidthAnchor,
            bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            textView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
}

extension String {
    
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }

}

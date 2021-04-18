//
//  InputTextView.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/17/21.
//

import UIKit

// custom input text view with placeholder
class InputTextView: UITextView {
    
    //MARK: properties
    
    var placeholderText: String? {
        didSet { placeholderLabel.text = placeholderText}
    }
    
    private let placeholderLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        
        
        return label
    }()
    
    //MARK: life cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top:topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 10)
        
        
        // disappear placeholder
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: actions
    @objc func handleTextDidChange(){
        placeholderLabel.isHidden = !text.isEmpty
    }
    
}

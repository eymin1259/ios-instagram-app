//
//  CommentCell.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/18/21.
//

import UIKit

class CommentCell: UICollectionViewCell {
    // MARK: properties
    private let profileImage : UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let commentLabel : UILabel = {
        let lbl = UILabel()
        let attributedString = NSMutableAttributedString(string: "unknown", attributes: [.font:UIFont.boldSystemFont(ofSize: 17)])
        attributedString.append(NSAttributedString(string: " some comment written by unknonw", attributes: [.font : UIFont.systemFont(ofSize: 14)]))
        lbl.attributedText = attributedString
        return lbl
        
    }()
    
    
    // MARK: life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImage)
        profileImage.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 10)
        profileImage.setDimensions(height: 40, width: 40)
        profileImage.layer.cornerRadius = 40/2
        
        addSubview(commentLabel)
        commentLabel.centerY(inView: self, leftAnchor: profileImage.rightAnchor, paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

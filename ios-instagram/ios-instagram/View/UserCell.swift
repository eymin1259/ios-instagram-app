//
//  UserCell.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/13/21.
//

import UIKit

class UserCell: UITableViewCell {
    // MARK: properties
    
    var userViewModel: UserCellViewModel?{
        didSet { configure() }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "username"
        return label
    }()
    
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.text = "full name"
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 50, width: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 10)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: helpers
    func configure(){
    
        guard let userViewModel = self.userViewModel else {return}
        profileImageView.sd_setImage(with: userViewModel.profileImageUrl, completed: nil)
        fullnameLabel.text = userViewModel.fullname
        usernameLabel.text = userViewModel.username
    }
    
}

//
//  ProfileHeader.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/6/21.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: class {
    func header(_ profileHeader: ProfileHeader, didTapActionBtnFor user: User)
}


class ProfileHeader: UICollectionReusableView {
    
    //MARK: properties
    
    var profileHeaderViewModel: ProfileHeaderViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let profileImageView: UIImageView = {
       let iv = UIImageView()
       // iv.image = #imageLiteral(resourceName: "venom-7")
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        //label.text = "yongmin lee"
        label.text  = ""
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var editProfileBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("loading..", for: .normal)
        btn.layer.cornerRadius = 3
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 0.5
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(handleEditProfileBtn), for: .touchUpInside)
        return btn
    }()
    
    private lazy var postsLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStatText(val: 5, label: "posts")
        return label
    }()
    
    private lazy var followerLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStatText(val: 2, label: "followers")
        return label
    }()
    
    private lazy var followingLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStatText(val: 1, label: "following")
        return label
    }()
    
    let gridButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        // btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    
    let listButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    
    let bookmarkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    
    //MARK: life cycle
    override init(frame:CGRect){
        super.init(frame: frame)
        
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top:topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 80/2
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(editProfileBtn)
        editProfileBtn.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15 , paddingLeft: 20, paddingRight: 20)
        
        let statStack = UIStackView(arrangedSubviews: [postsLabel, followerLabel, followingLabel])
        statStack.distribution = .fillEqually
        addSubview(statStack)
        statStack.centerY(inView: profileImageView)
        statStack.anchor(left:profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12, height: 50)
        
        let topDivider = UIView()
        topDivider.backgroundColor = .gray
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .gray
        
        let btnStack = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        btnStack.distribution = .fillEqually
        addSubview(topDivider)
        addSubview(btnStack)
        addSubview(bottomDivider)
        
        btnStack.anchor(left:leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        topDivider.anchor(top: btnStack.topAnchor, left: leftAnchor, right: rightAnchor, height:  0.5)
        bottomDivider.anchor(top: btnStack.bottomAnchor, left: leftAnchor, right: rightAnchor, height:  0.5)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: actions
    @objc func handleEditProfileBtn(){
        print("debug : handleEditProfileBtn")
        guard let viewModel = profileHeaderViewModel else {return}
        self.delegate?.header(self, didTapActionBtnFor: viewModel.user)
    }
    
    //MARK: helpers
    
    func attributedStatText(val: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(val)\n", attributes: [.font:UIFont.boldSystemFont(ofSize: 15)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font:UIFont.systemFont(ofSize: 14), .foregroundColor:UIColor.lightGray] ))
        return attributedText
    }
    
    func configure(){
        guard let viewModel = self.profileHeaderViewModel else {return}
        nameLabel.text = viewModel.fullname
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        editProfileBtn.setTitle(viewModel.followButtonText, for: .normal)
        editProfileBtn.backgroundColor = viewModel.followButtonBackgroundColor
        editProfileBtn.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        
        
    }
   
}

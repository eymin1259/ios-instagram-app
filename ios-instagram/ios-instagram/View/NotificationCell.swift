//
//  NotificationCell.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/19/21.
//

import UIKit

protocol NotificationCelldelegate : class {
    func cell(_ cell :NotificationCell, wantsToFollow uid : String)
    func cell(_ cell :NotificationCell, wantsToUnFollow uid : String)
    func cell(_ cell :NotificationCell, wantsToViewPost postId : String)
}

class NotificationCell : UITableViewCell {
    
    // MARK: properties
    weak var delegate : NotificationCelldelegate?
    
    
    var viewModel : NotificationViewModel? {
        didSet{
            configureCell()
        }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var postImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlTapPostImageView))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private lazy var followBtn : UIButton = {
        let btn = UIButton()
        
        btn.setTitle("loading..", for: .normal)
        btn.layer.cornerRadius = 3
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 0.5
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(handleTapFollwBtn), for: .touchUpInside)
        
        
        
        return btn
        
        
        
 
    }()
    
    
    
    // MARK: life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(profileImageView)
        profileImageView.setDimensions(height: 50, width: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        contentView.addSubview(followBtn)
        followBtn.centerY(inView: self)
        followBtn.anchor(right: rightAnchor , paddingRight: 10, width: 88, height: 30)
        
        
        contentView.addSubview(infoLabel)
        infoLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 10)
        infoLabel.anchor(right:followBtn.leftAnchor, paddingRight: 5)
        
        contentView.addSubview(postImageView)
        postImageView.centerY(inView: self)
        postImageView.anchor(right: rightAnchor , paddingRight: 10, width: 40, height:40)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: actions
    @objc func handleTapFollwBtn() {
        // print("debug : handleTapFollwBtn")
        guard let viewModel = self.viewModel else {
            return
        }
        
        if viewModel.notification.userIsFollowed {
            delegate?.cell(self, wantsToUnFollow: viewModel.notification.uid)
        }else{
            delegate?.cell(self, wantsToFollow: viewModel.notification.uid)
        }
    }
    
    @objc func handlTapPostImageView() {
        guard let postId = self.viewModel?.notification.postId else {
            return
        }
        delegate?.cell(self, wantsToViewPost: postId)
    }
    
    // MARK: helpers
    func configureCell() {
        guard let viewModel = self.viewModel else {return}
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        postImageView.sd_setImage(with: viewModel.postImageUrl, completed: nil)
        infoLabel.attributedText = viewModel.notificationMsg
        postImageView.isHidden = viewModel.shouldHidePostImage
        followBtn.isHidden = viewModel.shouldHideFollowButton
        followBtn.setTitle(viewModel.followBtnText, for: .normal)
        followBtn.backgroundColor = viewModel.followBtnBackgroundColor
        followBtn.setTitleColor(viewModel.followBtnTextColor, for: .normal)
        
    }
}

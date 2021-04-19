import UIKit

// FeedCell의 정보를 FeedController를 거쳐 다른 controller에게 전달하기 위해서 구현
protocol FeedCellDelegate: class {
    func cell(_ cell:FeedCell, wantsToShowCommentsOf post : Post)
    func cell(_ cell: FeedCell, didLike post : Post)
    func cell(_ cell: FeedCell, wantsToShowProfileOf uid : String)
}

class FeedCell: UICollectionViewCell {
    
    // MARK: properties
    
    var delegate : FeedCellDelegate?
    
    var postViewModel : PostViewModel? {
        didSet {configure()}
    }
    
    
    private lazy var profileImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        imgView.backgroundColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tap)
        
        return imgView
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(showUserProfile), for: .touchUpInside)
        return button
    }()
    
    private let postImageView: UIImageView = {
       let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        imgView.backgroundColor = .lightGray
        return imgView
    }()
    
     lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleCommentBtn), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    var likeLabel: UILabel = {
        let label = UILabel()
        label.text = "1 like"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        //label.text = "this is caption text"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        return label
    }()
    
    
    
    // MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left:  leftAnchor, paddingTop: 12, paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40/2
        
        addSubview(usernameButton)
        usernameButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        configureActionButtons()
        
        addSubview(likeLabel)
        likeLabel.anchor(top:likeButton.bottomAnchor, left: leftAnchor, paddingTop: -4, paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top:likeLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top:captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    // MARK: actions
    
    func configure() {
        guard let postViewModel = self.postViewModel else { return}
        
        captionLabel.text = postViewModel.caption
        postImageView.sd_setImage(with: postViewModel.imageUrl)
        profileImageView.sd_setImage(with: postViewModel.userProfileImageUrl)
        usernameButton.setTitle(postViewModel.username, for: .normal)
        likeLabel.text = postViewModel.likesLabelText
        likeButton.setImage(postViewModel.likeBtnImage, for: .normal)
        
        if let timestamp = postViewModel.timestampString {
            postTimeLabel.text = "\(timestamp) ago"
        }
        
        
        if postViewModel.post.didLike {
            likeButton.contentVerticalAlignment = .center
            likeButton.contentHorizontalAlignment = .center
            likeButton.imageEdgeInsets = UIEdgeInsets(top: 11, left: 7, bottom: 15, right: 7)
        }
    }
    
    @objc func didTapLike() {
        guard let post = postViewModel?.post else { return}
        delegate?.cell(self, didLike: post)
    }
    
    @objc func showUserProfile() {
        guard let post = postViewModel?.post else { return}
        delegate?.cell(self, wantsToShowProfileOf: post.ownerId)
    }
    
    @objc func handleCommentBtn() {
        
        guard let postViewModel = postViewModel else { return}
        delegate?.cell(self, wantsToShowCommentsOf: postViewModel.post)
    }
    
    // MARK: helpers
    
    func configureActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        
        addSubview(stackView)
        stackView.anchor(top:postImageView.bottomAnchor, width: 120, height: 50)
    }
    
}

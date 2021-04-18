//
//  ProfileCell.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/6/21.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    //MARK: properties
    var viewModel : PostViewModel? {
        didSet {configure()}
    }
    
    private let postImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    //MARK: life cycle
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        addSubview(postImageView)
        postImageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: helpers
    func configure(){
        guard let viewModel = self.viewModel else {return}
        postImageView.sd_setImage(with: viewModel.imageUrl)
    }
    
}

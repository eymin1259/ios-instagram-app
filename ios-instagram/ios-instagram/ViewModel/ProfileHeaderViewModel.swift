//
//  ProfileHeaderViewModel.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/12/21.
//

import UIKit

struct ProfileHeaderViewModel { // bind user-object(firebase-data) to view
    
    let user : User
    
    var profileImage: String{
        return user.profileImage
    }
    
    var fullname: String{
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImage)
    }
    
    var followButtonText: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        else {
            return user.isFollowed ? "Following" : "Follow"
        }
        
    }
    
    var numberOfFollowers: Int {
        return user.stats.followers
    }
    
    var numberOfFollowing: Int {
        return user.stats.following
    }
    
    var followButtonBackgroundColor: UIColor{
        return user.isCurrentUser ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return user.isCurrentUser ? .black : .white
    }
    
    init(user: User) {
        self.user = user
    }
    
    
    
}

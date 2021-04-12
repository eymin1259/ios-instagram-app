//
//  ProfileHeaderViewModel.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/12/21.
//

import Foundation

struct ProfileHeaderViewModel { // bind user-object(firebase-data) to view
    
    let user : User
    
    var profileImage: String{
        return user.profileImage
    }
    
    var fullnmae: String{
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImage)
    }
    
    init(user: User) {
        self.user = user
    }
    
    
    
}

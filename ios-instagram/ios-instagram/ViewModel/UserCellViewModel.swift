//
//  UserCellViewModel.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/13/21.
//

import Foundation


struct UserCellViewModel {
    private let user:User
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImage)
    }
    
    var username: String {
        return user.username
    }
    
    var fullname: String{
        return user.fullname
    }
    
    init(user:User){
        self.user = user
    }
}

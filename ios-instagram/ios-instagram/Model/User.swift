//
//  User.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/12/21.
//

import Foundation

struct User {
    let email: String
    let fullname: String
    let username: String
    let profileImage: String
    let uid : String
    
    init(dictionary: [String:Any]){
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImage = dictionary["profileImage"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}

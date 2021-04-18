//
//  User.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/12/21.
//

import Foundation
import Firebase

struct User {
    let email: String
    let fullname: String
    let username: String
    let profileImage: String
    let uid : String
    
    var isFollowed = false
    var isCurrentUser: Bool {return Auth.auth().currentUser?.uid == self.uid}
    
    var stats: UserStats!
    
    init(dictionary: [String:Any]){
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImage = dictionary["profileImage"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.stats = UserStats(followers: 0, following: 0, posts: 0)
    }
    
}

struct  UserStats {
    let followers : Int
    let following : Int
    let posts : Int
}

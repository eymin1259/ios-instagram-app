//
//  Notification.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/19/21.
//

import Firebase

enum NotificationType : Int {
    case like
    case follow
    case comment
    
    var notificationMessage : String{
        switch self {
        case .like:
            return " liked your post"
        case .follow:
            return " started follwing you"
        case .comment:
            return " commented on your post"
        }
    }
}


struct Notification {
    let id : String
    let uid : String
    let postImageUrl : String?
    let postId: String?
    let timestamp : Timestamp
    let type: NotificationType
    let userProfileImageUrl : String
    let username : String
    var userIsFollowed = false
    
    init(dictionary:[String:Any]){
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id = dictionary["id"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.userProfileImageUrl = dictionary["userProfileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like // default 0 -> .like
        
    }
}

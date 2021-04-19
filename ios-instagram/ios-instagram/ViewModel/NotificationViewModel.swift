//
//  NotificationViewModel.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/19/21.
//

import UIKit

struct NotificationViewModel {
    
    var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    var postImageUrl: URL? {
        return URL(string: self.notification.postImageUrl ?? "")
    }
    
    var profileImageUrl: URL? {
        return URL(string: self.notification.userProfileImageUrl)
    }
    
    var notificationMsg: NSAttributedString {
        let username = self.notification.username
        let message = self.notification.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: message, attributes: [.font:UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: " 2m", attributes: [.font:UIFont.systemFont(ofSize: 12) , .foregroundColor:UIColor.lightGray])) // timestamp
        
        return attributedText
    }
    
    
    var shouldHidePostImage : Bool {
        return self.notification.type != .like
    }
    
    var shouldHideFollowButton : Bool{
        return self.notification.type != .follow
    }
    
    var followBtnText : String {
        return notification.userIsFollowed ? "following" : "follow"
    }
    
    var followBtnBackgroundColor : UIColor {
        return notification.userIsFollowed ? .white : .systemBlue
    }
    
    var followBtnTextColor : UIColor {
        return notification.userIsFollowed ? .black : .white
    }
    
    
}

//
//  PostViewModel.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/18/21.
//

import UIKit

struct PostViewModel {
     var post : Post
    
    var imageUrl : URL? {
        
        return URL(string: post.imageUrl)
    }
    
    var caption : String {
        return post.caption
    }
    
    var likes : Int {
        return post.likes
    }
    
    var likeBtnImage : UIImage? {
        let imageName = post.didLike ? "red_like_selected" : "like_unselected"
        return UIImage(named: imageName)
    }
    
    var timestampString : String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: post.timestamp.dateValue(), to: Date())
    }
    
    var owenerId: String {
        return post.ownerId
    }
    
    var userProfileImageUrl : URL? {
        return URL(string: post.ownerProfileImage)
    }
    
    var username : String {
        return post.ownerUsername
    }
    
    var likesLabelText : String {
        if post.likes >= 2 {
            return "\(post.likes) likes"
        }
        else {
            return "\(post.likes) like"
        }
    }
    
    
    
    init(post: Post) {
        self.post = post
    }
    
    
}

//
//  Post.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/18/21.
//

import Firebase


struct Post{
    var caption: String
    var likes : Int
    let imageUrl : String
    let ownerId : String
    let timestamp : Timestamp
    let postId: String
    let ownerProfileImage: String
    let ownerUsername : String
    var didLike  = false
    
    init(postId: String, dictionary: [String:Any]){
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerId = dictionary["ownerId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerProfileImage = dictionary["ownerImageUrl"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
        self.postId = postId
        
        
    }
    
}

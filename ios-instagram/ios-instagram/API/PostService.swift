//
//  PostService.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/18/21.
//

import UIKit
import Firebase

typealias FirestoreCompletion = (Error?)->Void

struct PostService {
    
    
    
    static func uploadPost(caption:String, image:UIImage, user:User, completion:@escaping(FirestoreCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        
        // 1. store image to fire store
        ImageUploader.uploadImage(image: image) { (imgUrl) in
            
            // 2. define post data
            let postData = ["caption":caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes" : 0,
                        "imageUrl" : imgUrl,
                        "ownerId": uid,
                        "ownerImageUrl":user.profileImage,
                        "ownerUsername":user.username] as [String:Any]
            
            // 3. upload post data
            COLLECTION_POSTS.addDocument(data: postData, completion: completion) // document id is generated automatically
            
        }
    }
    
    static func fetchPosts(completion: @escaping([Post])->Void){
        
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { (snapshot , error) in
            if let error = error {
                print("debug : fetch posts error -> \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {return}
            let posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) }) // $0 : each element
            completion(posts)
        }
    }
    
    static func fetchPosts(forUser uid : String, completion: @escaping([Post])->Void){
        let query = COLLECTION_POSTS.whereField("ownerId", isEqualTo: uid)
        query.getDocuments { (snapshot, error) in
            
            if let error = error {
                print("debug : error fetchPosts forUser error -> \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {return}
            var posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) }) // $0 : each element
            posts.sort { (post1, post2) -> Bool in
                return post1.timestamp.seconds > post2.timestamp.seconds
            }
            completion(posts)
            
        }
    }
}

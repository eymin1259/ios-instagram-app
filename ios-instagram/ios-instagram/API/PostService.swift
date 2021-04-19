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
    
    static func fetchPost(withPostId postId : String, completion: @escaping(Post)->Void){
        COLLECTION_POSTS.document(postId).getDocument { (snapshot, _) in
            guard let snapshot = snapshot else {return}
            guard let data = snapshot.data() else {return}
            let post = Post(postId: snapshot.documentID, dictionary: data)
            completion(post)
        }
    }
    
    static func likePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        COLLECTION_POSTS.document(post.postId).updateData(["likes" : post.likes + 1 ])
        
        // 해당 post를 어떤 user가 좋아하는지 저장
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).setData([:]) { (error) in
            
            // 해당 user가 어떤 post를 좋아하는지 저장
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).setData([:], completion: completion)
        }
    }
    
    static func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)){
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        guard post.likes > 0 else {
            print("debug : unlike error -> post.likes <= 0")
            return
        }
        
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes - 1 ])
        
        // 해당 post를 어떤 user가 좋아하는지 삭제
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).delete { (error) in
            
            // 해당 user가 어떤 post를 좋아하는지 삭제
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).delete(completion: completion)
        }
    }
    
    static func chekcIfUserLikePost(post: Post, completion: @escaping(Bool)->Void){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // user가 좋아한 post 목록에 있는지 확인
        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).getDocument { (snapshot, error) in
            guard let userDidLike = snapshot?.exists else {return}
            completion(userDidLike)
        }
    }
}

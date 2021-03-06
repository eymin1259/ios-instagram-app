//
//  UserService.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/12/21.
//

import Firebase


struct UserService {
    
    static func fetchUser(withUid uid: String, completion: @escaping (User) -> Void) {
        
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            if let error = error{
                print("debug : COLLECTION_USERS.document(uid).getDocument error -> \(error.localizedDescription)")
                return
            }
            if let dataDictionary = snapshot?.data(){
                let user = User(dictionary: dataDictionary)
                completion(user)
            }
            else {
                print("deubg : there is no uid")
            }
            
        }
    }
    
    static func fetchUser(completion: @escaping (User) -> Void) {

        if let current_uid = Auth.auth().currentUser?.uid{
            COLLECTION_USERS.document(current_uid).getDocument { (snapshot, error) in
                if let error = error{
                    print("debug : COLLECTION_USERS.document(current_uid).getDocument error -> \(error.localizedDescription)")
                    return
                }
                
                if let dataDictionary = snapshot?.data(){
                    let user = User(dictionary: dataDictionary)
                    completion(user)
                }
            }
        }else {
            print("deubg : there is no current_uid")
        }
    }
    
    static func fetchUsers(completion: @escaping([User]) ->Void) {
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            if let error = error {
                print("debug :   COLLECTION_USERS.getDocuments error -> \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {return}
            var users = [User]()
            snapshot.documents.forEach { (document) in
                let user = User(dictionary: document.data())
                users.append(user)
            }
            
//            let users = snapshot.documents.map( {User(dictionary: $0.data())} ) // $0 : each element
            
            
            
            completion(users)
            
            
            
        }
    }
    
    // user A ??? user B ??? follow
    // currentUid = A
    // uid =  B
    static func follow(uid: String, completion: @escaping(Error?)->Void ){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        // A document?????? B??? ???????????? ??????
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) { (error) in
            
            // B document?????? A??? ????????? ????????? ??????
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
        }
        
        
    }
    
    static func unFollow(uid: String, completion: @escaping(Error?)->Void ){
        guard  let currentUid = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).delete { (error) in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
    
    static func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).getDocument { (snapshot, error) in
            
            if let isFollowed = snapshot?.exists {
                completion(isFollowed)
            }
            
        }
        
        
    }
    
    static func fetchUserStats(uid: String, completion: @escaping(UserStats)->Void){
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, _) in
            let followers = snapshot?.documents.count ?? 0
            
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { (snapshot, _) in
                let following = snapshot?.documents.count ?? 0
                
                COLLECTION_POSTS.whereField("ownerId", isEqualTo: uid).getDocuments { (snapshot, error) in
                    
                    
                    let postsNumber = snapshot?.documents.count ?? 0
                    completion(UserStats(followers: followers, following: following, posts: postsNumber))
                }
                
                
            }
        }
    }

}
